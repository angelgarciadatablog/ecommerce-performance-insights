SELECT
  DATE(`Created at`) AS date,
  EXTRACT(HOUR FROM `Created at`) AS hour,
  Name AS order_id, 
  Email AS user_id,
  `Financial Status` AS financial_status,
  `Billing City` AS billing_city,
  `Payment Method` AS payment_method,
   NULLIF(TRIM(`Discount Code`), '') AS discount_code
FROM
  `prueba2-433703.dataset_shopify_orders_download.shopify_orders`
GROUP BY
  DATE(`Created at`),
  EXTRACT(HOUR FROM `Created at`),
  Name, 
  Email,
  `Financial Status`,
  `Billing City`,
  `Payment Method`,
  `Discount Code`
