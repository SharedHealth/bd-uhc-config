update  global_property  set property_value= '<org.openmrs.layout.web.address.AddressTemplate>
     <nameMappings class="properties">
          <property name="postalCode" value="Location.postalCode"/>
          <property name="longitude" value="Location.longitude"/>
          <property name="address1" value="Address Line"/>
          <property name="address2" value="Rural Ward"/>
          <property name="address3" value="Ward/Union"/>
          <property name="address4" value="Paurasava"/>
          <property name="address5" value="Upazilla"/>
          <property name="countyDistrict" value="District"/>
          <property name="stateProvince" value="Division"/>
          <property name="country" value="Location.country"/>
          <property name="startDate" value="PersonAddress.startDate"/>
          <property name="endDate" value="personAddress.endDate"/>
          <property name="latitude" value="Location.latitude"/>
        </nameMappings>
        <sizeMappings class="properties">
          <property name="postalCode" value="10"/>
          <property name="longitude" value="10"/>
          <property name="address1" value="40"/>
          <property name="address2" value="40"/>
          <property name="address3" value="40"/>
          <property name="address4" value="40"/>
          <property name="address5" value="40"/>
          <property name="stateProvince" value="10"/>
          <property name="country" value="10"/>
          <property name="startDate" value="10"/>
          <property name="endDate" value="10"/>
          <property name="latitude" value="10"/>
        </sizeMappings>
        <lineByLineFormat>
          <string>address1</string>
          <string>address2</string>
          <string>address3</string>
          <string>address4 address5 stateProvince country postalCode</string>
          <string>latitude longitude</string>
          <string>startDate endDate</string>
        </lineByLineFormat>
      </org.openmrs.layout.web.address.AddressTemplate>'
where property='layout.address.format';