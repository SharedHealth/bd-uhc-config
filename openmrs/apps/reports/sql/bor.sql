Select
        (select count(*) from bed where bed_type_id=1) as 'No. of beds',

        (datediff('#endDate#','#startDate#')) as 'No. of days',

        (select sum(datediff(e2.date_created,e1.date_created))
        from patient p JOIN visit v on p.patient_id=v.patient_id
          join encounter e1 on v.visit_id = e1.visit_id
          join encounter_type et on et.encounter_type_id = e1.encounter_type
          JOIN encounter e2 on v.visit_id = e2.visit_id
          join encounter_type et2  on et2.encounter_type_id = e2.encounter_type
        where et.name='ADMISSION' and et2.name='DISCHARGE'
              and date(e2.date_created) between '#startDate#' and '#endDate#' ) as 'Total LOS',

       (select count(p.patient_id)
        from patient p JOIN visit v on p.patient_id=v.patient_id
          join encounter e1 on v.visit_id = e1.visit_id
          join encounter_type et on et.encounter_type_id = e1.encounter_type
          JOIN encounter e2 on v.visit_id = e2.visit_id
          join encounter_type et2  on et2.encounter_type_id = e2.encounter_type
        where et.name='ADMISSION' and et2.name='DISCHARGE'
              and date(e2.date_created) between '#startDate#' and '#endDate#') as 'No. of patients discharged',
       ROUND((select sum(datediff(e2.date_created,e1.date_created))
        from patient p JOIN visit v on p.patient_id=v.patient_id
          join encounter e1 on v.visit_id = e1.visit_id
          join encounter_type et on et.encounter_type_id = e1.encounter_type
          JOIN encounter e2 on v.visit_id = e2.visit_id
          join encounter_type et2  on et2.encounter_type_id = e2.encounter_type
        where et.name='ADMISSION' and et2.name='DISCHARGE'
              and date(e2.date_created) between '#startDate#' and '#endDate#')/
       (select count(p.patient_id)
        from patient p JOIN visit v on p.patient_id=v.patient_id
          join encounter e1 on v.visit_id = e1.visit_id
          join encounter_type et on et.encounter_type_id = e1.encounter_type
          JOIN encounter e2 on v.visit_id = e2.visit_id
          join encounter_type et2  on et2.encounter_type_id = e2.encounter_type
        where et.name='ADMISSION' and et2.name='DISCHARGE'
              and date(e2.date_created) between '#startDate#' and '#endDate#'),2) as ALOS,
        ROUND((
         ((select sum(datediff(e2.date_created,e1.date_created))
           from patient p JOIN visit v on p.patient_id=v.patient_id
             join encounter e1 on v.visit_id = e1.visit_id
             join encounter_type et on et.encounter_type_id = e1.encounter_type
             JOIN encounter e2 on v.visit_id = e2.visit_id
             join encounter_type et2  on et2.encounter_type_id = e2.encounter_type
           where et.name='ADMISSION' and et2.name='DISCHARGE'and
                 date(e1.date_created) between '#startDate#'and '#endDate#')/
          (select count(p.patient_id)
           from patient p JOIN visit v on p.patient_id=v.patient_id
             join encounter e1 on v.visit_id = e1.visit_id
             join encounter_type et on et.encounter_type_id = e1.encounter_type
             JOIN encounter e2 on v.visit_id = e2.visit_id
             join encounter_type et2  on et2.encounter_type_id = e2.encounter_type
           where et.name='ADMISSION' and et2.name='DISCHARGE'and
                 date(e1.date_created) between '#startDate#'and '#endDate#')*100)/
         ((Select (select count(*) from bed where bed_type_id=1 )*(datediff('#endDate#','#startDate#'))))
       ),2)as BOR;
