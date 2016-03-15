SELECT DISTINCT answer_concept.concept_full_name as 'Cause of Death', 
count(o.value_coded) as 'Patient Count' 
FROM obs o   
INNER JOIN concept_view cv on cv.concept_id=o.concept_id and concept_full_name='Cause of Death' and o.voided=0   and cast(o.date_created as date) BETWEEN '#startDate#' AND '#endDate#' 
INNER join concept_view answer_concept on answer_concept.concept_id=o.value_coded   
INNER join person p on p.person_id=o.person_id   
INNER JOIN reporting_age_group rag ON DATE(o.obs_datetime) 
BETWEEN (DATE_ADD(DATE_ADD(birthdate, INTERVAL rag.min_years YEAR), INTERVAL rag. min_days DAY)) AND (DATE_ADD(DATE_ADD(birthdate, INTERVAL rag.max_years YEAR), INTERVAL rag.max_days DAY))  
AND rag.report_group_name = 'Below 5 years' 
GROUP BY answer_concept.concept_full_name ORDER BY count(o.value_coded) DESC LIMIT 10;