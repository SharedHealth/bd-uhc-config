select user.username as 'User Name', count(p.person_id)
from users user inner join provider provider on provider.person_id=user.person_id
  inner join encounter_provider ep on ep.provider_id=provider.provider_id
  inner join encounter ec on ec.encounter_id = ep.encounter_id
  inner join obs o on o.encounter_id=ec.encounter_id and o.obs_id in (select obs_id from obs
    inner join concept_view cv on cv.concept_id=obs.concept_id and cv.concept_full_name='Fee Category')
                      and o.voided = 0
                      and cast(o.obs_datetime AS DATE) BETWEEN '#startDate#' AND '#endDate#'
  inner join person p on p.person_id=o.person_id
group by user.user_id order by user.username
;