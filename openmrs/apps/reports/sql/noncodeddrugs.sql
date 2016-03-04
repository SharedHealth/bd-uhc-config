select distinct do.drug_non_coded as 'Non coded drugs ordered' 
	from drug_order do join orders o on do.order_id = o.order_id
	inner join encounter e on o.encounter_id = e.encounter_id
	INNER join location l on l.location_id = e.location_id
  	INNER JOIN location_tag_map lm on l.location_id= lm.location_id
  	inner JOIN location_tag lt on lt.location_tag_id = lm.location_tag_id and lt.name='Report Location'
	where do.drug_non_coded is not null and date(o.date_created) >= '#startDate#' and date(o.date_created) <= '#endDate#'
 order by do.drug_non_coded;
