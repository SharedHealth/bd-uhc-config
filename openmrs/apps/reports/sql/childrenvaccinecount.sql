select dg.name AS 'Vaccine Name',
  rag.name as 'Age Group',
  count(dg.drug_id) as 'Count'
from obs o
  inner join concept_view cv on cv.concept_id=o.concept_id and concept_full_name='Immunization Incident Vaccine' and o.voided=0
  and cast(o.date_created as date) BETWEEN '#startDate#' AND '#endDate#'
  inner join drug dg on o.value_drug=dg.drug_id
  inner join person p on p.person_id=o.person_id
  INNER JOIN reporting_age_group rag ON DATE(o.obs_datetime) BETWEEN (DATE_ADD(
      DATE_ADD(birthdate, INTERVAL rag.min_years YEAR), INTERVAL rag. min_days DAY)) AND (DATE_ADD(
      DATE_ADD(birthdate, INTERVAL rag.max_years YEAR), INTERVAL rag.max_days DAY))
                                        AND rag.report_group_name = 'Vaccination'
group by dg.name,rag.name;
