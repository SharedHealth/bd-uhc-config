SELECT DISTINCT cpdv.name as 'Diagnosis Name', 
count(cpdv.person_id) as 'count of patients' 
FROM confirmed_patient_diagnosis_view cpdv  
INNER JOIN person p on p.person_id=cpdv.person_id    
INNER JOIN reporting_age_group rag ON DATE(cpdv.obs_datetime) 
BETWEEN (DATE_ADD(DATE_ADD(birthdate, INTERVAL rag.min_years YEAR), INTERVAL rag. min_days DAY)) AND (DATE_ADD(DATE_ADD(birthdate, INTERVAL rag.max_years YEAR), INTERVAL rag.max_days DAY)) 
AND rag.report_group_name = 'Above 30 years'
WHERE CAST(cpdv.obs_datetime as date) BETWEEN '#startDate#' AND '#endDate#' 
GROUP BY  cpdv.name ORDER BY count(cpdv.person_id) DESC LIMIT 10;