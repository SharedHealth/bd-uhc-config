
SELECT DISTINCT
  pi.identifier as 'Identifier',
  t.given_name   AS 'Given Name',
  t.family_name as 'Family Name',
  Gender,
  DOB,
  visit_type as 'Visit Type',
  t.visit_start as 'Visit Start',
  MAX(CASE WHEN t.concept_full_name = 'Date of death'
    THEN t.value
      ELSE NULL END) AS 'Date of Death',
  MAX(CASE WHEN t.concept_full_name = 'Cause of Death'
    THEN t.value
      ELSE NULL END) AS 'Cause of Death',
  MAX(CASE WHEN t.concept_full_name = 'Cause of Death'
    THEN t.ICD10
      ELSE NULL END) AS 'ICD10',
  MAX(CASE WHEN t.concept_full_name = 'Circumstances of Death'
    THEN t.value
      ELSE NULL END) AS 'Circumstances of Death',
  MAX(CASE WHEN t.concept_full_name = 'Additional details of death'
    THEN t.value
      ELSE NULL END) AS 'Additional Details of Death',
  MAX(CASE WHEN t.concept_full_name = 'Place of death'
    THEN t.value
      ELSE NULL END) AS 'Place of Death'
FROM obs o
  INNER JOIN patient_identifier pi ON pi.patient_id = o.person_id
  INNER JOIN
  (SELECT DISTINCT
     pi.identifier,
     pn.given_name                                    AS given_name,
     pn.family_name                                   AS family_name,
     p.gender                                         as Gender,
     p.birthdate                             as DOB,
     vt.name                                          AS visit_type,
     vt.date_created                                   as visit_start,
     cv.concept_full_name,
     ifnull(o.value_text, ifnull(cv2.concept_full_name, o.value_datetime)) AS value,
     o.obs_group_id,
     o.concept_id,
     cv2.concept_full_name                            AS name,
     crv.code                                         AS ICD10,
     o.obs_datetime
   FROM obs o
     INNER JOIN concept_view cv ON cv.concept_id = o.concept_id and o.concept_id IN (SELECT cs.concept_id
                                                                                     FROM concept_set cs INNER JOIN
                                                                                       concept_view cv ON cv.concept_id = cs.concept_set AND cv.concept_full_name = 'Death Note')
                                   AND o.voided = 0 AND
                                   cast(o.obs_datetime AS DATE) BETWEEN '#startDate#' AND '#endDate#'
     LEFT JOIN concept_view cv2 ON cv2.concept_id = o.value_coded

     LEFT JOIN
     concept_reference_term_map_view crv ON crv.concept_id = cv2.concept_id
                                            AND crv.concept_reference_source_name = 'ICD10-BD' AND
                                            crv.concept_map_type_name = 'SAME-AS'

     INNER JOIN person p ON p.person_id = o.person_id

     INNER JOIN encounter e ON e.encounter_id = o.encounter_id
     INNER JOIN location l ON l.location_id = e.location_id
     INNER JOIN location_tag_map lm ON l.location_id = lm.location_id
     INNER JOIN location_tag lt ON lt.location_tag_id = lm.location_tag_id AND lt.name = 'Report Location'
     INNER JOIN visit v ON v.visit_id = e.visit_id
     INNER JOIN visit_type vt ON vt.visit_type_id = v.visit_type_id
     INNER JOIN person_name pn ON pn.person_id = o.person_id
     INNER JOIN patient_identifier pi ON pi.patient_id = o.person_id
  ) AS t ON t.identifier = pi.identifier

GROUP BY t.given_name, t.family_name;
