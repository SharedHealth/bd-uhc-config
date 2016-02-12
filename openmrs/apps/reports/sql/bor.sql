select(((select ((SELECT sum( datediff(date_stopped,date_started)) as ALS from visit where visit_id in
      (select e.visit_id
      from encounter e join encounter_type et
     ON et.encounter_type_id = e.encounter_type where date(e.date_created) between '#startDate#' and '#endDate#'
      ) and date_stopped is not NULL )
      /
      (select count(patient_id ) from visit where visit_id in
      (select e.visit_id
       from encounter e join encounter_type et
       ON et.encounter_type_id = e.encounter_type where date(e.date_created) between '#startDate#' and '#endDate#'
       ) and date_stopped is not NULL)))*(select count(patient_id ) from visit where visit_id in
       (select e.visit_id
        from encounter e join encounter_type et
         ON et.encounter_type_id = e.encounter_type where date(e.date_created) between '#startDate#' and '#endDate#'
         ) and date_stopped is not NULL)*100)/
(Select (select count(*) from bed )*(datediff('#endDate#','#startDate#')) as days)) as BOR,
  (select count(*) from bed ) as NumofBeds,
  (select count(patient_id ) from visit where visit_id in
      (select e.visit_id
       from encounter e join encounter_type et
       ON et.encounter_type_id = e.encounter_type where date(e.date_created) between '#startDate#' and '#endDate#'
       ) and date_stopped is not NULL) as NumofpatientDiscahged,
  (select ((SELECT sum( datediff(date_stopped,date_started)) as ALS from visit where visit_id in
         (select e.visit_id
         from encounter e join encounter_type et
         ON et.encounter_type_id = e.encounter_type where date(e.date_created) between '#startDate#' and '#endDate#'
         ) and date_stopped is not NULL )
    /
  (select count(patient_id ) from visit where visit_id in
         (select e.visit_id
          from encounter e join encounter_type et
           ON et.encounter_type_id = e.encounter_type where date(e.date_created) between '#startDate#' and '#endDate#'
           ) and date_stopped is not NULL))) as ALS,
  (SELECT sum( datediff(date_stopped,date_started)) as ALS from visit where visit_id in
       (select e.visit_id
        from encounter e join encounter_type et
        ON et.encounter_type_id = e.encounter_type where date(e.date_created) between '#startDate#' and '#endDate#'
        ) and date_stopped is not NULL ) as LOS,
        (datediff('#endDate#','#startDate#')) as days;