-- Shopify Orders Items
SELECT
  DATE(`Created at`) AS date,
  EXTRACT(HOUR FROM `Created at`) AS hour,
  Name AS order_id, 
  Email AS user_id,
  `Financial Status` AS financial_status,
  `Lineitem sku` AS lineitem_sku,
  REGEXP_EXTRACT(`Lineitem name`, r'^(.*?) -') AS lineitem_name,
   REGEXP_EXTRACT(`Lineitem name`, r' - ([A-Z]+)$') AS lineitem_variant,
   REGEXP_EXTRACT(`Lineitem name`, r' - (.+?) - [A-Z]+$') AS color,
   CASE
      WHEN lower(`Lineitem name`) like '%hombre%' THEN 'Hombre'
      WHEN lower(`Lineitem name`) like '%mujer%' THEN 'Mujer'
      ELSE 'Unisex'
    END AS genero,
   REGEXP_EXTRACT(`Lineitem name`, r'^([^\s]+)') AS categoria,
   `Lineitem quantity` AS lineitem_quantity,
   round(`Lineitem price`,2) AS lineitem_price,
   round(`Lineitem quantity`*`Lineitem price`,2) AS lineitem_total,
  `Lineitem compare at price` AS lineitem_compare_at_price,
   COALESCE(round(`Lineitem compare at price`-`Lineitem price`),0) AS lineitem_discount,
   COALESCE(round((`Lineitem compare at price`-`Lineitem price`)/`Lineitem compare at price`*100,2),0) AS lineitem_percent_discount,
  CASE
    WHEN (`Lineitem compare at price`-`Lineitem price`)/`Lineitem compare at price`*100 >69 THEN 'Descuento mayor a 70%'
    WHEN (`Lineitem compare at price`-`Lineitem price`)/`Lineitem compare at price`*100 >59 THEN'Descuento entre 60% y 70%'
    WHEN (`Lineitem compare at price`-`Lineitem price`)/`Lineitem compare at price`*100 >49 THEN'Descuento entre 50% y 60%'
    WHEN (`Lineitem compare at price`-`Lineitem price`)/`Lineitem compare at price`*100 >39 THEN'Descuento entre 40% y 50%'
    WHEN (`Lineitem compare at price`-`Lineitem price`)/`Lineitem compare at price`*100 >29 THEN'Descuento entre 30% y 40%'
    WHEN (`Lineitem compare at price`-`Lineitem price`)/`Lineitem compare at price`*100 >19 THEN 'Descuento entre 20% y 30%'
    WHEN (`Lineitem compare at price`-`Lineitem price`)/`Lineitem compare at price`*100 >9 THEN'Descuento entre 10% y 20%'
    ELSE 'Sin descuento'
  END AS range_discount,

  IF(
    COALESCE(round(`Lineitem compare at price`-`Lineitem price`),0) > 0, 'Con descuento','Sin descuento'
  ) AS discount_filter,
  IF(
    `Lineitem compare at price` IS NOT NULL,`Lineitem quantity`, 0
  ) AS con_descuento_items,
    IF(
    `Lineitem compare at price` IS NULL,`Lineitem quantity`, 0
  ) AS sin_descuento_items

FROM
  `prueba2-433703.dataset_shopify_orders_download.shopify_orders`
