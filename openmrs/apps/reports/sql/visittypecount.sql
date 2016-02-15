select vt.name as 'Visit Type',count(DISTINCT v.patient_id) as 'Patient Count' from visit v
  inner join visit_type vt on vt.visit_type_id=v.visit_type_id

                              and cast(v.date_stopped as DATE) between '#startDate#' AND '#endDate#'
GROUP BY vt.name;