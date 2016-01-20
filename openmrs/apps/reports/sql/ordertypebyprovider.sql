


SELECT
  users.username      AS Provider,
  ot.name             AS Order_type,
  count(ord.order_id) AS No_of_order
FROM orders ord INNER JOIN order_type ot
    ON ot.order_type_id = ord.order_type_id and cast(ord.date_created as DATE) between '#startDate#' and '#endDate#'
  INNER JOIN provider p ON ord.orderer = p.provider_id
  INNER JOIN users ON users.person_id = p.person_id
GROUP BY  Provider,Order_type
ORDER BY Provider;