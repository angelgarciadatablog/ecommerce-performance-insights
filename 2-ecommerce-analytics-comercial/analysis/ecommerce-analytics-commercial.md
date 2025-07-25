# Análisis técnico – Ecommerce Analytics Comercial

Este documento detalla el proceso técnico del análisis, incluyendo las fuentes de datos, lógica aplicada en SQL, construcción de la tabla maestra y hallazgos principales que alimentan el dashboard final.

---

## 1. 🧩 Fuentes de datos utilizadas

| Plataforma | Tipo de fuente     | Granularidad        | Descripción                                                                                                                                                                                                                     | ID de tabla                                                        |
|------------|--------------------|---------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------|
| Shopify   | Ordenes (descarga csv) | orden por cliente  | Descripción | `prueba2-433703.dataset_shopify_orders_download.shopify_orders`     |

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

## 3. 🧮 Consulta SQL principal

La siguiente consulta construye la **tabla maestra** que alimenta el dashboard final:

> 📁 Query Completa: [`queries/consulta_product_performance.sql`](../queries/rendimiento-producto-ga4-big-query.sql)

```sql
-- Shopify Orders
  SELECT
    # fecha
    PARSE_DATE('%Y%m%d', event_date) AS date,

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
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
    UNNEST(items) AS items
  WHERE
      REGEXP_EXTRACT(_TABLE_SUFFIX, r"[0-9]+") BETWEEN 
      FORMAT_DATE("%Y%m%d", "2020-11-01")AND 
      FORMAT_DATE("%Y%m%d", current_date()) 
      AND items.item_id <> '(not set)'

  GROUP BY
  
    #fecha
    PARSE_DATE('%Y%m%d', event_date),

    # item_id
    item_id
```

## 4. 📊 Visualizaciones y gráficos

A continuación, algunos gráficos utilizados para obtener insights clave a partir de la tabla maestra:

| Visualización | Descripción |
|---------------|-------------|
| ![Gráfico 1](../images/insight_1.png) | Entre el 26 de diciembre y el 17 de enero se observó un aumento significativo en las vistas de productos que no estuvo acompañado por un incremento proporcional en las ventas. |
| ![Gráfico 2](../images/insight_2.png) | Las categorías Men's T-Shirts, Mug, Sale, Clearance, Eco-friendly, Small goods y Backpacks están dentro del top 10 de productos más vistos, pero no generan ingresos. |
| ![Gráfico 3](../images/insight_3.png) | La categoría Apparel es la que genera más revenue, sin embargo, no es la que recibe más vistas. |

> 🖼️ Las imágenes se encuentran en la carpeta [`images/`](../images/).

---

## 5. 🧭 Hallazgos clave

- **Desajuste entre visualizaciones y conversión**: Durante la campaña de fin de año (26 de diciembre al 17 de enero), se registró un incremento en vistas de productos que no derivaron en ventas. Se recomienda evaluar cuáles son esos productos con alto tráfico pero baja conversión y ajustar la inversión publicitaria de acuerdo a su potencial real.
- **Tráfico alto en categorías con bajo rendimiento**: Algunas categorías reciben gran cantidad de vistas pero no generan ingresos. Es recomendable revisar si:
  - Están vendiendo a través de otros canales (ej. tienda física).
  - Presentan problemas de inventario o disponibilidad.  
  En caso de baja disponibilidad o falta de conversión, se sugiere reducir su exposición en la web (ej. despriorizarlos en publicidad o incluso ocultarlos si no tienen potencial de conversión).
- **Oportunidad en la categoría más rentable**: La categoría Apparel genera el mayor revenue, pero no es la más vista. Se recomienda reforzar su visibilidad mediante estrategias como:
  - Ubicar sus productos en la página de inicio.
  - Activar pop-ups o banners.
  - Incluirla en correos, stories, y campañas pagadas.

---

## 6. 📈 Enlace al dashboard final

Accede al dashboard interactivo con filtros por categoría, canal publicitario y tipo de conversión:

🔗 [Ver dashboard en línea](https://lookerstudio.google.com/reporting/5e8d97c8-e7c4-4c62-93f5-0d7396d216d7)  
>  🖥️ Compatible con dispositivos móviles (responsive)

---

## 👤 Autor

**Ángel García**  
📍 Lima, Perú  
🔗 [LinkedIn](https://www.linkedin.com/in/angelgarciachanga)  
🎥 [@angelgarciadatablog](https://youtube.com/@angelgarciadatablog)

