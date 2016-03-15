SELECT u.username as 'User Name', count(DISTINCT e.encounter_id) as 'Patient Count' 
FROM encounter e INNER JOIN encounter_provider ep  on ep.encounter_id = e.encounter_id 
INNER JOIN provider  p on p.provider_id = ep.provider_id 
INNER JOIN users u on u.person_id = p.person_id 
WHERE e.encounter_type in (select encounter_type_id from encounter_type where name in ("EME", "Consultation", "OPD", "IPD")) 
and cast(e.encounter_datetime as date) BETWEEN '#startDate#' AND '#endDate#' 
group by u.username;