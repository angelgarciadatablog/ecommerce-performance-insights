# Análisis técnico – Ecommerce Analytics Comercial

Este documento detalla el proceso técnico del análisis, incluyendo las fuentes de datos, lógica aplicada en SQL, construcción de la tabla maestra y hallazgos principales que alimentan el dashboard final.

---

## 1. 🧩 Fuentes de datos utilizadas

| Plataforma | Tipo de fuente     | Granularidad        | Descripción                                                                                                                                                                                                                     | ID de tabla                                                        |
|------------|--------------------|---------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------|
| Shopify   | Ordenes (descarga csv) | orden por cliente  | tabla que contiene todas las órdenes generadas en una tienda de shopify | `prueba2-433703.dataset_shopify_orders_download.shopify_orders`     |

> 🔜 En una siguiente etapa, se conectará directamente con la API REST de Shopify para automatizar la recolección de datos y eliminar la dependencia de las exportaciones manuales.

---

## 2. 🧠 Transformación de la tabla GA4 en BigQuery

![limpieza de datos](../images/image_2.1.png)
| Elemento | Descripción |
|----------|-------------|
| **Izquierda** – *Tabla original (`descarga de órdenes Shopify CSV`)* | Archivo CSV exportado manualmente desde Shopify que contiene todas las órdenes generadas por la tienda. Representa la fuente de datos en bruto antes de cualquier transformación o limpieza. |
| **Derecha** – *Tabla `Shopify_Orders` (nivel de orden)* | Tabla procesada en BigQuery donde cada fila representa una orden individual. Incluye información general como el ID de orden, cliente, fecha, total pagado, estado de pago, uso de cupones y ciudad de destino. Ideal para análisis a nivel de compra. |
| **Derecha** – *Tabla `Shopify_Orders_Items` (nivel de producto)* | Tabla procesada en BigQuery donde cada fila representa un producto específico vendido dentro de una orden. Contiene detalles como nombre del producto, SKU, cantidad, precio, talla, categoría, y si tuvo descuento. Esta estructura permite análisis detallados a nivel de artículo. |



---

## 3.🔄 Flujo de trabajo

1. Se descargó manualmente un archivo `.csv` con las órdenes desde la plataforma de Shopify.
2. Este archivo fue cargado como una tabla física en BigQuery, ubicada en la ruta:  
   `prueba2-433703.dataset_shopify_orders_download.shopify_orders`
3. A partir de esta tabla base se construyeron dos tablas procesadas (guardadas como vistas) mediante consultas SQL:
   - `Shopify_Orders`: tabla (vista) con un registro por orden.
   - `Shopify_Orders_Items`: tabla (vista) con un registro por producto vendido.
4. Estas dos vistas son las que alimentan el dashboard final en Looker Studio.

   

## 3. 🧮 Consultas SQL

Las siguientes consultas construyen las tablas que alimentan el dashboard final:

> 📁 Archivo `.csv` original (órdenes de Shopify) y resultados en formato `.csv` de ambas consultas
>  (para práctica o visualización rápida): [`2-ecommerce-analytics-comercial/files_csv`](../files_csv/)

```sql
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
```

```sql
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
```


## 4. 📊 Visualizaciones y gráficos

A continuación, algunos gráficos utilizados para obtener insights clave a partir de la tabla maestra:

### 4.1 Ventas con cupones

<div style="display: flex; align-items: center; gap: 40px; margin-bottom: 50px;">

  <img src="../images/ecommerce-performance-cupones.png" width="650"/>

  <div style="max-width: 420px;">
    <p>
      Se observa que los cupones son utilizados mayormente por el género femenino y lo utilizan sobre todo el de BIENVENIDA, con una mayor concentración en los distritos de Santiago de Surco y Chorrillos.
    </p>
  </div>

</div>

---

### 4.2 Caída de ventas

<div style="display: flex; align-items: center; gap: 40px; margin-bottom: 50px;">

  <img src="../images/ecommerce-performance-caida-de-ventas.png" width="650"/>

  <div style="max-width: 420px;">
    <p>
      A partir de julio de 2024 se detecta una caída sostenida en las ventas de artículos con descuento. Este comportamiento podría estar asociado a un cambio en la estrategia comercial, ajustes en las campañas promocionales o variaciones en la demanda durante ese periodo.
    </p>
  </div>

</div>

---

### 4.3 Distribución por tallas

<div style="display: flex; align-items: center; gap: 40px; margin-bottom: 50px;">

  <img src="../images/ecommerce-performance-tallas.png" width="650"/>

  <div style="max-width: 420px;">
    <p>
      Se identifica que la talla M concentra el mayor volumen de ventas de manera transversal en todos los géneros, consolidándose como la principal talla generadora de ingresos. Esto sugiere la necesidad de una gestión prioritaria de inventario y abastecimiento en esta talla.
  </div>

</div>

---

### 4.4 Segmentación por categoría

<div style="display: flex; align-items: center; gap: 40px; margin-bottom: 50px;">

  <img src="../images/ecommerce-performance-mujer.png" width="650"/>

  <div style="max-width: 420px;">
    <p>
      Finalmente, las categorías con mayor volumen de ventas son Short y Vestido. No obstante, el género con mayor peso dentro de estas categorías es Unisex, no femenino. Además, se observa una mayor participación de ventas en productos sin descuento.
    </p>
  </div>

</div>

> 🖼️ Las imágenes se encuentran en la carpeta [`images/`](../images/).

---

## 5. 🧭 Hallazgos clave

-Las campañas con cupón tienen mejor desempeño cuando están segmentadas por género y zona, lo que abre oportunidades de optimización en targeting.  

-La talla M concentra el mayor volumen de ventas en todos los géneros, posicionándose como la talla dominante en términos de demanda.  

-El negocio no depende exclusivamente de promociones para generar ingresos, lo que sugiere:Buena percepción de valor del producto, fortaleza en demanda orgánica, posibilidad de optimizar márgenes reduciendo dependencia promocional.

---

## 6. 📈 Enlace al dashboard final

Accede al dashboard interactivo con filtros por categoría, canal publicitario y tipo de conversión:

🔗 [Ver dashboard en línea](https://lookerstudio.google.com/reporting/feceecaa-0ba9-4750-8b55-0ab20da5a5b8)

>  🖥️ Compatible con dispositivos móviles (responsive)

---

## 👤 Autor

**Ángel García**  
📍 Lima, Perú  
🔗 [LinkedIn](https://www.linkedin.com/in/angelgarciachanga)  
🎥 [@angelgarciadatablog](https://youtube.com/@angelgarciadatablog)

