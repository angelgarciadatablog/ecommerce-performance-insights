WITH product_performance AS

(SELECT
    # fecha
    PARSE_DATE('%Y%m%d', event_date) AS date,

    #Hora
    EXTRACT( HOUR FROM TIMESTAMP_MICROS(event_timestamp) AT TIME ZONE "America/Lima") AS hour,

    # item_id
    items.item_id AS item_id,

    # view_item
    SUM(CASE WHEN event_name = 'view_item' THEN IFNULL(items.quantity, 1) ELSE 0 END) AS view_item,

    # add_to_cart  
    SUM(CASE WHEN event_name = 'add_to_cart' THEN IFNULL(items.quantity, 1) ELSE 0 END) AS add_to_cart,

    # begin_checkout
    SUM(CASE WHEN event_name = 'begin_checkout' THEN IFNULL(items.quantity, 1) ELSE 0 END) AS begin_checkout,

    # purchase_item
    SUM(CASE WHEN event_name = 'purchase' THEN IFNULL(items.quantity, 1) ELSE 0 END) AS purchase_item,

    # revenue_item
    SUM(CASE WHEN event_name = 'purchase' THEN items.item_revenue ELSE 0 END) AS revenue_item,

  
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,  #cambiar por tabla intraday_*
    UNNEST(items) AS items
  WHERE
      REGEXP_EXTRACT(_TABLE_SUFFIX, r"[0-9]+") BETWEEN 
      FORMAT_DATE("%Y%m%d", "2020-12-15")AND #cambiar por current_date()
      FORMAT_DATE("%Y%m%d", '2020-12-15')    #cambiar por current_date()
      AND items.item_id <> '(not set)'

  GROUP BY
  
    #fecha
    PARSE_DATE('%Y%m%d', event_date),

    #Hora
    EXTRACT( HOUR FROM TIMESTAMP_MICROS(event_timestamp) AT TIME ZONE "America/Lima"),

    # item_id
    item_id

),

item_name AS

(SELECT
    item_id, 
    ANY_VALUE(item_name) AS item_name
  FROM
    (SELECT
      items.item_id,
      IF(items.item_name = '(not set)','no_name', items.item_name) AS item_name
    FROM
      `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,   #cambiar por tabla intraday_*
        UNNEST(items) AS items
    WHERE
        REGEXP_EXTRACT(_TABLE_SUFFIX, r"[0-9]+") BETWEEN 
        FORMAT_DATE("%Y%m%d", "2020-12-15")AND #cambiar por current_date()
        FORMAT_DATE("%Y%m%d", '2020-12-15')    #cambiar por current_date()
        AND items.item_id <> '(not set)'
  )
  GROUP BY
    item_id
),

item_brand AS 

(SELECT
    item_id,
    ANY_VALUE(item_brand) AS item_brand
  FROM
    (SELECT
        item_id,
      CASE
        WHEN items.item_brand = '' THEN 'No Brand' 
        WHEN items.item_brand = '(not set)' THEN 'No Brand'
        WHEN items.item_brand LIKE '%#%' THEN 'Remarkable'
        ELSE items.item_brand END AS item_brand
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,   #cambiar por tabla intraday_*
    UNNEST(items) AS items
  WHERE
    REGEXP_EXTRACT(_TABLE_SUFFIX, r"[0-9]+") BETWEEN 
    FORMAT_DATE("%Y%m%d", "2020-12-15")AND  #cambiar por current_date()
    FORMAT_DATE("%Y%m%d", '2020-12-15')     #cambiar por current_date()
    AND items.item_id <> '(not set)'
  )
GROUP BY
item_id
),

item_category AS

(SELECT
  item_id,
  ANY_VALUE(item_category) AS item_category,
  ANY_VALUE(item_category_2) AS item_category_2

FROM
  (SELECT
    items.item_id,
    IF(
        SPLIT(items.item_category, "/")[SAFE_OFFSET(0)] IN ('', '(not set)'),
        'No Category',
        SPLIT(items.item_category, "/")[SAFE_OFFSET(0)]
      ) AS item_category,
    IF(
        SPLIT(items.item_category, "/")[SAFE_OFFSET(1)] IS NULL OR
        SPLIT(items.item_category, "/")[SAFE_OFFSET(1)] IN ('', '(not set)'),
        'No Category',
        SPLIT(items.item_category, "/")[SAFE_OFFSET(1)]
      ) AS item_category_2,
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,    #cambiar por tabla intraday_*
    UNNEST(items) AS items
  WHERE
      REGEXP_EXTRACT(_TABLE_SUFFIX, r"[0-9]+") BETWEEN 
      FORMAT_DATE("%Y%m%d", "2020-12-15")AND   #cambiar por current_date()
      FORMAT_DATE("%Y%m%d", '2020-12-15')      #cambiar por current_date()
      AND items.item_id <> '(not set)'
)
GROUP BY 
  item_id
),

item_link AS 

(
  SELECT
  items.item_id AS item_id,
  ANY_VALUE((SELECT value.string_value FROM UNNEST(event_params) WHERE KEY = 'page_location'))AS link
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,   #cambiar por tabla intraday_*
    UNNEST(items) AS items
WHERE
    REGEXP_EXTRACT(_TABLE_SUFFIX, r"[0-9]+") BETWEEN 
      FORMAT_DATE("%Y%m%d", "2020-12-15")AND  #cambiar por current_date()
      FORMAT_DATE("%Y%m%d", '2020-12-15')     #cambiar por current_date()
    AND items.item_id <> '(not set)'
GROUP BY
  items.item_id
)




SELECT
  t1.date,
  t1.hour,
  t1.item_id,
  t2.item_name,
  t3.item_brand,
  t4.item_category,
  t4.item_category_2,
  t1.view_item,
  t1.add_to_cart,
  t1.begin_checkout,
  t1.purchase_item,
  t1.revenue_item,
  t5.link

FROM
  product_performance t1
LEFT JOIN item_name t2 
ON t1.item_id = t2.item_id
LEFT JOIN item_brand t3
ON t1.item_id = t3.item_id
LEFT JOIN item_category t4
ON t1.item_id = t4.item_id
LEFT JOIN item_link t5
ON t1.item_id = t5.item_id
