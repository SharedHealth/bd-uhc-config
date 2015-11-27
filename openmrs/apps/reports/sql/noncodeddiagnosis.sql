select o.value_text as 'Non coded Diagnosis', pn.given_name as 'Diagnosed By', o.obs_datetime as 'Observation date' from obs o left outer  join users u on o.creator = u.user_id left outer join person_name pn on u.person_id=pn.person_id where o.concept_id = 14 and o.date_created >= '#startDate#' and o.date_created < '#endDate#' order by o.value_text;

