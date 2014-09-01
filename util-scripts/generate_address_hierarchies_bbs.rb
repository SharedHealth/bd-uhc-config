require 'csv'

# deleting location_hierarchies is a painfull thing, because of parental reference id restrictions imposed.
# hence before you run "bdlocationhierarchies.sql, make sure you note down the max location_id"
# select max(location_id) from location; 
# if you want to delete the location codes first delete the location attribute for these codes 
# delete from location_attribute where value_reference like "BDLC:%";
# update location set parent_location = null where location_id > <max_location_id_you_noted_down>;
# delete from location where location_id > <max_location_id_you_noted_down>;

class GeoLocation
  attr_reader :code, :level, :name, :geocode, :children
  def initialize(code, level, name, geocode) 
    @code = code
    @level = level
    @parentLevel = level - 1
    @name = name.gsub("'","").strip
    @geocode = geocode
    @children = []
  end
  
  def export_address_entries(parentInfo)
     # puts "#{parentInfo}"
     if @children.length > 0
         nodeInfo = parentInfo.empty? ? "#{@name}^#{@geocode}" : "#{parentInfo}|#{@name}^#{@geocode}"
         @children.each{|child| child.export_address_entries(nodeInfo)}
     else
       # puts "#{parentInfo}|#{@name}^#{@geocode}" if @level==4;
       $bd_address_heirarchies_file.puts("#{parentInfo}|#{@name}^#{@geocode}") if @level==5;
       # return "geocode: #{@geocode}, code : #{@code}, level: #{@level} , name:#{@name}" if @level==4;
     end 
  end

  def export_location_hierarchies
     # return if @level ==1 && @geocode != "60"; 
     if @level == 1
        $bd_location_heirarchies_file.puts "INSERT INTO location (parent_location, name, description, creator, date_created, uuid) VALUES (@rootGeocode, '#{@name}', '#{@name}', 1, curdate(), uuid());"
        $bd_location_heirarchies_file.puts "SET @locationIdLevel#{@level} = last_insert_id();"
     else
        $bd_location_heirarchies_file.puts "INSERT INTO location (parent_location, name, description, creator, date_created, uuid) VALUES (@locationIdLevel#{@parentLevel}, '#{@name}', '#{@name}', 1, curdate(), uuid());"
        $bd_location_heirarchies_file.puts "SET @locationIdLevel#{@level} = last_insert_id();"   
     end
     $bd_location_heirarchies_file.puts "INSERT INTO location_attribute (location_id, attribute_type_id, value_reference, uuid, creator, date_created) " +
     " (SELECT  @locationIdLevel#{@level}, location_attribute_type_id, 'BDLC:#{@geocode}', uuid(), 1, curdate() FROM location_attribute_type WHERE name = 'LocationCode'); "
     if @children.length > 0
        @children.each{|child| child.export_location_hierarchies }
     end
  end 
end

@divisions = []

def find_or_create_division(division_code, division_name) 
  division = @divisions.detect{|div| div.code == division_code}
  if division.nil?
    division = GeoLocation.new division_code, 1, division_name, division_code
    @divisions.push division
  end
  division
end

def find_or_create_child_for(parent, code, name) 
  return nil if code.nil? or code.empty? or parent.nil?
  child = parent.children.detect{|c| c.code == code}
  if child.nil?
    child_level = parent.level + 1
    child_geocode = parent.geocode + code.rjust(2, '0')
    child = GeoLocation.new code, child_level, name, child_geocode
    parent.children.push child
  end
  child
end


CSV.foreach "sample/bbs_geocodes.csv", :headers => true do |row|
  division_code = row["Division"]
  district_code = row["Zila"]
  upazilla_code = row["Upazila/Thana"]
  corp_code     = row["CityCorp/Paurasava"]
  union_code    = row["Union/Ward"]
  administrative_name  = row["Name"]

  division    = find_or_create_division(division_code, administrative_name)
  district    = find_or_create_child_for(division, district_code, administrative_name)
  upazilla    = find_or_create_child_for(district, upazilla_code, administrative_name)
  corporation = find_or_create_child_for(upazilla, corp_code, administrative_name)
  union       = find_or_create_child_for(corporation, union_code, administrative_name)
end

$bd_address_heirarchies_file = File.open("data/bbs_address_hierarchies.csv", "w+")
@divisions.each{|div| div.export_address_entries("")}
$bd_address_heirarchies_file.close

# $bd_location_heirarchies_file = File.open("data/bdlocationhierarchies.sql", "w+")
# $bd_location_heirarchies_file.puts "INSERT INTO location_attribute_type (name, description, datatype, min_occurs, max_occurs, creator, date_created, uuid)  select 'LocationCode', 'BD Location code', 'org.openmrs.customdatatype.datatype.FreeTextDatatype', 0, 1, 1, curdate(), uuid() from dual where NOT EXISTS(select * from location_attribute_type where name ='LocationCode');"
# $bd_location_heirarchies_file.puts "set @rootGeocode = 0;"
# $bd_location_heirarchies_file.puts "select location_id into @rootGeocode from location where name = \"BDLocationCodes\";"
# @divisions.each{|div| div.export_location_hierarchies}
# $bd_location_heirarchies_file.close

