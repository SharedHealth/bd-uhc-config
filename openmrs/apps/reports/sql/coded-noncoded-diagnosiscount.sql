select user.username as UserName,sum(if(cv.concept_full_name='Non-coded Diagnosis',1,0)) as 'Non-coded Diagnosis',
sum(if(cv.concept_full_name='Coded Diagnosis',1,0)) as 'Coded Diagnosis'
from
  obs o inner join encounter e on o.encounter_id=e.encounter_id
    inner join encounter_provider ep on e.encounter_id = ep.encounter_id
    inner join provider p  on ep.provider_id=p.provider_id
inner join users user on p.person_id=user.person_id
inner join concept_view cv on cv.concept_id=o.concept_id and (cv.concept_full_name='Non-coded Diagnosis' or
cv.concept_full_name='Coded Diagnosis') and cast(o.obs_datetime as DATE) BETWEEN '#startDate#' AND '#endDate#'
AND o.obs_group_id IN (
  SELECT confirmed.obs_id
             FROM (
                                SELECT parent.obs_id
               FROM obs AS parent
                 JOIN concept_view pcv ON pcv.concept_id = parent.concept_id AND
                                                           pcv.concept_full_name = 'Visit Diagnoses'
                                  LEFT JOIN obs AS child
                                    ON child.obs_group_id = parent.obs_id
                                       AND child.voided IS FALSE
                                  JOIN concept_name AS confirmed
                                    ON confirmed.concept_id = child.value_coded AND confirmed.name = 'Confirmed' AND
                                       confirmed.concept_name_type = 'FULLY_SPECIFIED'
                                WHERE parent.voided IS FALSE ) AS confirmed
       WHERE confirmed.obs_id NOT IN (SELECT parent.obs_id
                                                                                  FROM obs AS parent
                                                    JOIN concept_view pcv2 ON pcv2.concept_id = parent.concept_id AND pcv2.concept_full_name = 'Visit Diagnoses'
                                     JOIN (
                                            SELECT obs_group_id
                                            FROM obs AS status
                                              JOIN concept_name ON concept_name.concept_id = status.value_coded AND
                                                                   concept_name.name = 'Ruled Out Diagnosis' AND
                                                                   concept_name.concept_name_type = 'FULLY_SPECIFIED' AND
                                                                   status.voided IS FALSE
                                            UNION
                                            SELECT obs_group_id
                                            FROM obs AS revised
                                              JOIN concept_name revised_concept
                                                ON revised_concept.concept_id = revised.concept_id AND
                                                   revised_concept.name = 'Bahmni Diagnosis Revised' AND
                                                   revised_concept.concept_name_type = 'FULLY_SPECIFIED' AND
                                                   revised.value_coded = (SELECT property_value FROM global_property WHERE property = 'concept.true') AND
                                                   revised.voided IS FALSE
                                          ) revised_and_ruled_out_diagnosis
                                       ON revised_and_ruled_out_diagnosis.obs_group_id = parent.obs_id
                                   WHERE parent.voided IS FALSE)) group by user.username;