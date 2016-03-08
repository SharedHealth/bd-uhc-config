
select user.username as 'User Name',
  rag.name AS 'Patient Age Group',
  sum(IF(p.gender = 'F', 1, 0)) AS Female,
  sum(IF(p.gender = 'M', 1, 0)) AS Male,
  sum(IF(p.gender = 'O', 1, 0)) AS Other
from users user inner join provider provider on provider.person_id=user.person_id
  inner join encounter_provider ep on ep.provider_id=provider.provider_id
  inner join encounter ec on ec.encounter_id = ep.encounter_id
  inner join obs o on o.encounter_id=ec.encounter_id and o.obs_id in (select obs_id from obs
    inner join concept_view cv on cv.concept_id=obs.concept_id and cv.concept_full_name='Fee Category' and obs.value_coded
                                                                                                           in (select cv.concept_id from concept_view cv where  cv.concept_full_name='Fee Category, General'))
  and o.voided = 0
and cast(o.obs_datetime AS DATE) BETWEEN '#startDate#' AND '#endDate#'
  inner join person p on p.person_id=o.person_id

  INNER JOIN reporting_age_group rag ON DATE(o.obs_datetime) BETWEEN (DATE_ADD(
      DATE_ADD(birthdate, INTERVAL rag.min_years YEAR), INTERVAL rag. min_days DAY)) AND (DATE_ADD(
      DATE_ADD(birthdate, INTERVAL rag.max_years YEAR), INTERVAL rag.max_days DAY))
                                        AND rag.report_group_name = 'Registration'

group by user.user_id,rag.sort_order order by user.username,rag.name;
