select user.username as UserName,
  sum(if(drug_inventory_id is not null,1,0)) as Coded Drug Orders,
sum(if(drug_inventory_id is null,1,0)) as Non Coded Drugs Orders
from drug_order dr inner join orders o on o.order_id=dr.order_id and cast(o.date_created as date) BETWEEN '#startDate#' AND '#endDate#'
inner join provider pr on pr.provider_id=o.orderer
  INNER JOIN users  user ON user.person_id = pr.person_id
group by user.username;
