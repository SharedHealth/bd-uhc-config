select o.value_text as 'Non coded Diagnosis', u.username as 'Diagnosed By', o.obs_datetime as 'Observation date' 
from obs o inner join users u on o.creator = u.user_id
  inner join encounter e on o.encounter_id = e.encounter_id
        INNER join location l on l.location_id = e.location_id
        INNER JOIN location_tag_map lm on l.location_id= lm.location_id
        inner JOIN location_tag lt on lt.location_tag_id = lm.location_tag_id and lt.name='Report Location'
 inner join person_name pn on u.person_id=pn.person_id
 where o.concept_id = 14 
	and date(o.date_created) >= '#startDate#' and date(o.date_created) <= '#endDate#'
	order by o.value_text;
