select vt.name as 'Visit Type',count(DISTINCT v.patient_id) as 'Patient Count' from visit v
inner join encounter e on e.visit_id=v.visit_id
  INNER join location l on l.location_id = e.location_id
  INNER JOIN location_tag_map lm on l.location_id= lm.location_id
  inner JOIN location_tag lt on lt.location_tag_id = lm.location_tag_id and lt.name='Report Location'
  inner join visit_type vt on vt.visit_type_id=v.visit_type_id

                              and cast(v.date_stopped as DATE) between '#startDate#' AND '#endDate#'
GROUP BY vt.name;