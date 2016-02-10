select dg.name as 'Drug Name',
  count(o.value_drug) as 'Drug Count'
from obs o
  inner join concept_view cv on cv.concept_id=o.concept_id and concept_full_name='Immunization Incident Vaccine'  and o.voided=0
                                and cast(o.obs_datetime as DATE) BETWEEN '#startDate#' AND '#endDate#'
                                and o.obs_group_id in(select o.obs_group_id from obs o inner join concept_view cv on o.concept_id = cv.concept_id and cv.concept_full_name = 'Pregnant'
                                                                                                                     and o.value_coded = 1)
  inner join concept_view cv1 on cv1.concept_id=o.value_coded and  cv1.concept_full_name in('Tetanus toxoid')
  inner join drug dg on o.value_drug=dg.drug_id
group by dg.name;
