-- Shopify Orders
SELECT
  DATE(`Created at`) AS date,
  EXTRACT(HOUR FROM `Created at`) AS hour,
  Name AS order_id, 
  Email AS user_id,
  `Financial Status` AS financial_status,
  MAX(REGEXP_EXTRACT(`Lineitem name`, r'^([^\s]+)')) AS categoria,
  MAX(
    CASE
        WHEN lower(`Lineitem name`) like '%hombre%' THEN 'Hombre'
        WHEN lower(`Lineitem name`) like '%mujer%' THEN 'Mujer'
        ELSE 'Unisex'
      END 
  ) AS genero,
  `Billing City` AS billing_city,
  `Payment Method` AS payment_method,
   NULLIF(TRIM(`Discount Code`), '') AS discount_code,
   round(AVG(`Discount Amount`)) AS discount_amount,
   round(AVG(subtotal),2) AS subtotal,
   
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
