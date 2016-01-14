select pt.identifier As Identifier,concat(coalesce(pn.given_name,''),' ',coalesce(pn.middle_name,''),' ',coalesce(pn.family_name,''))as Name,
   p.birthdate as 'DOB',
       concat(coalesce(pa.address1,''),' ',coalesce(pa.address2,''),' ',coalesce(pa.city_village,''),' ',coalesce(pa.state_province,''),' ',coalesce(pa.postal_code,''),' ',coalesce(pa.country,''))as Address,
  cv.concept_full_name as 'Diagnosis',crv.code as ICD10,diagnosis.obs_datetime  as Date
from patient_identifier pt
  inner JOIN
  person p on pt.patient_id=p.person_id
    inner join
  person_name pn on pn.person_id=pt.patient_id
inner  JOIN
  person_address pa on pn.person_id=pa.person_id

  JOIN
  obs AS diagnosis on pt.patient_id=diagnosis.person_id  AND diagnosis.voided = 0
                      and cast(diagnosis.obs_datetime AS DATE) BETWEEN '#startDate#' AND '#endDate#'
  INNER JOIN encounter e ON diagnosis.encounter_id = e.encounter_id
  INNER join location l on l.location_id = e.location_id
  INNER JOIN location_tag_map lm on l.location_id= lm.location_id
  inner JOIN location_tag lt on lt.location_tag_id = lm.location_tag_id and lt.name='Report Location'
  inner JOIN
  visit v on e.visit_id=v.visit_id
  inner JOIN concept_view AS cv
    ON cv.concept_id = diagnosis.value_coded AND cv.concept_class_name = 'Diagnosis'
  inner JOIN
  concept_reference_term_map_view crv on crv.concept_id=cv.concept_id and
                                         crv.concept_reference_source_name='ICD10-BD' AND
                                         crv.concept_map_type_name='SAME-AS'
  inner join concept_set cs on cv.concept_id=cs.concept_id
  INNER join concept_name cn on cn.concept_id=cs.concept_set and cn.name='Physical Assault'
                                and cn.concept_name_type='FULLY_SPECIFIED'
    AND diagnosis.obs_group_id IN (
    SELECT DISTINCT confirmed.obs_id
    FROM (
           SELECT DISTINCT parent.obs_id
           FROM obs AS parent
             JOIN concept_view pcv ON pcv.concept_id = parent.concept_id AND
                                      pcv.concept_full_name = 'Visit Diagnoses'
           WHERE parent.voided IS FALSE) AS confirmed

    WHERE confirmed.obs_id NOT IN
          (SELECT DISTINCT parent.obs_id
           FROM obs AS parent
             JOIN concept_view pcv2
               ON pcv2.concept_id = parent.concept_id AND pcv2.concept_full_name = 'Visit Diagnoses'
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
                           revised.value_coded = (SELECT property_value
                                                  FROM global_property
                                                  WHERE property = 'concept.true') AND
                           revised.voided IS FALSE
                  ) revised_and_ruled_out_diagnosis
               ON revised_and_ruled_out_diagnosis.obs_group_id = parent.obs_id
           WHERE parent.voided IS FALSE)
  );



