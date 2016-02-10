select dg.name as 'Drug Name',
  rag.name as 'Age Group',
  count(o.value_drug) as 'Drug Count'
from obs o
  inner join concept_view cv on cv.concept_id=o.concept_id and concept_full_name='Immunization Incident Vaccine'  and o.voided=0
                                and cast(o.obs_datetime as DATE) BETWEEN '#startDate#' AND '#endDate#'

  inner join concept_view cv1 on cv1.concept_id=o.value_coded and  cv1.concept_full_name in('Tetanus toxoid')
  inner join drug dg on o.value_drug=dg.drug_id
  inner join person p on p.person_id=o.person_id and p.gender='F'
  INNER JOIN reporting_age_group rag ON DATE(o.obs_datetime) BETWEEN (DATE_ADD(
      DATE_ADD(birthdate, INTERVAL rag.min_years YEAR), INTERVAL rag. min_days DAY)) AND (DATE_ADD(
      DATE_ADD(birthdate, INTERVAL rag.max_years YEAR), INTERVAL rag.max_days DAY))
                                        AND rag.report_group_name = 'women 15-49'
group by dg.name,rag.name;
