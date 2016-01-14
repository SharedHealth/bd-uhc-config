SELECT data.name as 'Location Names',
  MAX(CASE WHEN data.Fee_Category = 'Fee Category, Vaccination'
    THEN data.count END) AS 'Vaccination',
  MAX(CASE WHEN data.Fee_Category = 'Fee Category, Revisit Patient'
    THEN data.count END) AS 'Revisit Patient',
  MAX(CASE WHEN data.Fee_Category = 'Fee Category, Freedom fighter'
    THEN data.count END) AS 'Freedom Fighter',
  MAX(CASE WHEN data.Fee_Category = 'Fee Category, Ultra poor'
    THEN data.count END) AS 'Ultra Poor',
  MAX(CASE WHEN data.Fee_Category = 'Fee Category, Handicapped'
    THEN data.count END) AS 'Handicapped',
  MAX(CASE WHEN data.Fee_Category = 'Fee Category, Orphan'
    THEN data.count END) AS 'Orphan'
from
(SELECT
  l.name,
  cv2.concept_full_name as 'Fee_Category',
  count(DISTINCT (e.patient_id)) as count
FROM obs o
  INNER JOIN encounter e ON o.encounter_id = e.encounter_id
                            AND cast(o.obs_datetime AS DATE) BETWEEN '#startDate#' AND '#endDate#' AND o.voided = 0
                            AND o.obs_id IN (SELECT obs_id
                                             FROM obs
                                               INNER JOIN concept_view cv ON cv.concept_id = obs.concept_id AND
                                                                             cv.concept_full_name = 'Fee Category'
                                                                             AND
                                                                             obs.value_coded IN (SELECT cv.concept_id
                                                                                                 FROM concept_view cv
                                                                                                 WHERE
                                                                                                   cv.concept_full_name
                                                                                                   NOT LIKE
                                                                                                   'Fee Category, General'))
  INNER JOIN concept_view cv2 ON cv2.concept_id = o.value_coded AND o.value_coded
                                                                    IN (SELECT cv.concept_id
                                                                        FROM concept_view cv
                                                                        WHERE cv.concept_full_name NOT LIKE
                                                                              'Fee Category, General')
  INNER JOIN location l ON e.location_id = l.location_id
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
                           AND l.retired = FALSE AND l.name IN ('OPD', 'IPD', 'Emergency','Vaccination')
GROUP BY l.name, cv2.concept_full_name
ORDER BY l.name, cv2.concept_full_name) as data
GROUP BY data.name ORDER BY data.name;