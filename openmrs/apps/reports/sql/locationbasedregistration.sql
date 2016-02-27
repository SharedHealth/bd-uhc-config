
select
  l.name as 'Location Name',
       rag.name AS 'Patient Age Group',
       sum(IF(p.gender = 'F', 1, 0)) AS Female,
       sum(IF(p.gender = 'M', 1, 0)) AS Male,
       sum(IF(p.gender = 'O', 1, 0)) AS Other
from
  users user inner join provider provider on provider.person_id=user.person_id
  inner join encounter_provider ep on ep.provider_id=provider.provider_id
  inner join encounter ec on ec.encounter_id = ep.encounter_id

  inner join obs o on o.encounter_id=ec.encounter_id and o.obs_id in (select obs_id from obs
    inner join concept_view cv on cv.concept_id=obs.concept_id and cv.concept_full_name='Fee Category')
                      and o.voided = 0
                      and cast(o.obs_datetime AS DATE) BETWEEN '#startDate#' AND '#endDate#'

  inner JOIN location l ON ec.location_id = l.location_id
                           AND l.location_id IN (SELECT l.location_id
                                                 FROM location l INNER JOIN location_tag_map lt
                                                     ON l.location_id = lt.location_id AND lt.location_tag_id
                                                                                           IN (SELECT lm.location_tag_id
                                                                                               FROM
                                                                                                 location_tag_map lm INNER JOIN
                                                                                                 location_tag lt ON
                                                                                                                   lt.location_tag_id
                                                                                                                   =
                                                                                                                   lm.location_tag_id
                                                                                                                   AND
                                                                                                                   lt.name
                                                                                                                   =
                                                                                                                   'Login Location'))
                           AND l.retired = FALSE
  inner join person p on p.person_id=o.person_id

  INNER JOIN reporting_age_group rag ON DATE(o.obs_datetime) BETWEEN (DATE_ADD(
      DATE_ADD(birthdate, INTERVAL rag.min_years YEAR), INTERVAL rag. min_days DAY)) AND (DATE_ADD(
      DATE_ADD(birthdate, INTERVAL rag.max_years YEAR), INTERVAL rag.max_days DAY))
                                        AND rag.report_group_name = 'Registration'
group by l.name,rag.name order by l.name,rag.name;
