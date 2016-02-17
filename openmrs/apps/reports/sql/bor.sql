Select (select sum(datediff(e2.date_created,e1.date_created))
        from patient p JOIN visit v on p.patient_id=v.patient_id
          join encounter e1 on v.visit_id = e1.visit_id
          join encounter_type et on et.encounter_type_id = e1.encounter_type
          JOIN encounter e2 on v.visit_id = e2.visit_id
          join encounter_type et2  on et2.encounter_type_id = e2.encounter_type
        where et.name='ADMISSION' and et2.name='DISCHARGE'and
              date(e1.date_created) between '#startDate#'and '#endDate#'
              and date(e2.date_created) between '#startDate#' and '#endDate#' ) as sumofdatediff,
       (select count(p.patient_id)
        from patient p JOIN visit v on p.patient_id=v.patient_id
          join encounter e1 on v.visit_id = e1.visit_id
          join encounter_type et on et.encounter_type_id = e1.encounter_type
          JOIN encounter e2 on v.visit_id = e2.visit_id
          join encounter_type et2  on et2.encounter_type_id = e2.encounter_type
        where et.name='ADMISSION' and et2.name='DISCHARGE'and
              date(e1.date_created) between '#startDate#'and '#endDate#'
              and date(e2.date_created) between '#startDate#' and '#endDate#') noofpatient,
       (select sum(datediff(e2.date_created,e1.date_created))
        from patient p JOIN visit v on p.patient_id=v.patient_id
          join encounter e1 on v.visit_id = e1.visit_id
          join encounter_type et on et.encounter_type_id = e1.encounter_type
          JOIN encounter e2 on v.visit_id = e2.visit_id
          join encounter_type et2  on et2.encounter_type_id = e2.encounter_type
        where et.name='ADMISSION' and et2.name='DISCHARGE'and
              date(e1.date_created) between '#startDate#'and '#endDate#'
              and date(e2.date_created) between '#startDate#' and '#endDate#')/
       (select count(p.patient_id)
        from patient p JOIN visit v on p.patient_id=v.patient_id
          join encounter e1 on v.visit_id = e1.visit_id
          join encounter_type et on et.encounter_type_id = e1.encounter_type
          JOIN encounter e2 on v.visit_id = e2.visit_id
          join encounter_type et2  on et2.encounter_type_id = e2.encounter_type
        where et.name='ADMISSION' and et2.name='DISCHARGE'and
              date(e1.date_created) between '#startDate#'and '#endDate#'
              and date(e2.date_created) between '#startDate#' and '#endDate#') as ALS,
  (
         ((select sum(datediff(e2.date_created,e1.date_created))
           from patient p JOIN visit v on p.patient_id=v.patient_id
             join encounter e1 on v.visit_id = e1.visit_id
             join encounter_type et on et.encounter_type_id = e1.encounter_type
             JOIN encounter e2 on v.visit_id = e2.visit_id
             join encounter_type et2  on et2.encounter_type_id = e2.encounter_type
           where et.name='ADMISSION' and et2.name='DISCHARGE'and
                 date(e1.date_created) between '#startDate#'and '#endDate#'
                 and date(e2.date_created) between '#startDate#' and '#endDate#')/
          (select count(p.patient_id)
           from patient p JOIN visit v on p.patient_id=v.patient_id
             join encounter e1 on v.visit_id = e1.visit_id
             join encounter_type et on et.encounter_type_id = e1.encounter_type
             JOIN encounter e2 on v.visit_id = e2.visit_id
             join encounter_type et2  on et2.encounter_type_id = e2.encounter_type
           where et.name='ADMISSION' and et2.name='DISCHARGE'and
                 date(e1.date_created) between '#startDate#'and '#endDate#'
                 and date(e2.date_created) between '#startDate#' and '#endDate#')*100)/
         (
           (Select (select count(*) from bed )*(datediff('#endDate#','#startDate#'))
           )
         )
       )as BOR,
  (select count(*) from bed) as Numofbeds,
  (datediff('#endDate#','#startDate#')) as datediff


;
