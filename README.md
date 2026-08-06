# Ecommerce Performance Insights — Rendimiento de producto con GA4

> ¿Los productos más vistos son los que generan mayores ingresos?

En una tienda con más de mil productos, la atención y el dinero no se reparten igual. Marketing decide dónde invertir mirando el tráfico, pero el tráfico no paga: paga la conversión.

Este proyecto reconstruye el **ciclo completo de conversión por producto** —vistas, agregados al carrito, inicios de checkout y compras— a partir de los eventos de Google Analytics 4 procesados en BigQuery, para detectar productos con alta exposición y baja conversión, y oportunidades por categoría.

📄 **Caso completo:** [angelgarciadatablog.com/portafolio/ecommerce-performance-insights](https://www.angelgarciadatablog.com/portafolio/ecommerce-performance-insights)
📈 **Dashboard:** [Ver en Looker Studio](https://lookerstudio.google.com/reporting/5e8d97c8-e7c4-4c62-93f5-0d7396d216d7)

---

## 🗂 Fuente de datos

| | |
|---|---|
| Origen | `bigquery-public-data.ga4_obfuscated_sample_ecommerce` |
| Qué es | Export crudo de GA4 de la Google Merchandise Store. **Datos reales ofuscados**, publicados por Google como dataset de demostración |
| Periodo | 1 nov 2020 → 31 ene 2021 |
| Volumen | 4,295,584 eventos · 17 tipos de evento · 270,154 usuarios |
| Estructura | 92 tablas diarias (`events_20201101` … `events_20210131`) |
| Grano | Un evento por fila, con los productos anidados en un `ARRAY` |

Es un **dataset público de demostración, no un cliente**. Los hallazgos son reales sobre esa tienda, pero el proyecto demuestra método, no una consultoría entregada.

📚 [Documentación oficial del dataset](https://developers.google.com/analytics/bigquery/web-ecommerce-demo-dataset?hl=es-419)

Al ser público, **cualquiera puede reproducir el análisis completo** ejecutando las consultas de [`queries/`](queries/). No hace falta acceso a ningún dato privado.

---

## 🛠️ Herramientas

- **Google Analytics 4** — métricas de comportamiento de usuarios
- **BigQuery** — almacenamiento y transformación
- **SQL** — extracción y modelado
- **Looker Studio** — visualización

---

## 🧠 Lo interesante: el export de GA4 no se puede analizar tal como viene

Cada fila es un evento y los productos viven anidados dentro. Un solo evento de compra puede contener cinco productos distintos.

1. **Desanidar** el array `items` con `UNNEST`, para pasar de "un evento" a "un producto dentro de un evento".
2. **Convertir eventos en métricas** con `CASE WHEN event_name = …` + `SUM`. Ahí aparece el embudo: cada etapa es un nombre de evento distinto sobre la misma fila.
3. **Recorrer las 92 tablas diarias** con `_TABLE_SUFFIX` en vez de apuntar a una tabla fija.
4. **Materializar el resultado** en una tabla maestra de 51,030 filas con grano producto × día.

El paso 4 es la decisión de arquitectura más importante: sin ella, cada filtro del dashboard vuelve a escanear millones de eventos, con el coste y la latencia que eso implica.

---

## 🧭 Hallazgos clave

1. **Vistas que no convierten durante la campaña.** Entre el 26 de diciembre y el 17 de enero las vistas de producto subieron con fuerza, sin subida proporcional en ventas.
2. **Categorías con mucho tráfico y cero ingresos.** Men's T-Shirts, Mug, Sale, Clearance, Eco-friendly, Small goods y Backpacks están en el top 10 de más vistos y no generan ingresos.
3. **La categoría más rentable no es la más vista.** Apparel lidera en ingresos pero no en vistas: genera el dinero desde una posición de baja exposición.

El análisis paso a paso está en [`analysis/product-performance-insight-analysis.md`](analysis/product-performance-insight-analysis.md).

---

## 🗂️ Estructura

```plaintext
ecommerce-performance-insights/
├── README.md
├── analysis/     # desarrollo, lógica y hallazgos
├── queries/      # consultas SQL (GA4 + BigQuery)
├── images/       # soporte visual
└── dashboard/    # documentación de la visualización
```

---

## 📜 Historia

Hasta agosto de 2026 este repo alojaba dos módulos: este análisis de GA4 y un análisis comercial sobre datos ficticios de Shopify. Se separaron porque **no comparten fuente, periodo ni negocio** —uno usa datos reales ofuscados de Google entre 2020 y 2021, el otro datos simulados entre 2023 y 2024— y tenerlos juntos bajo este nombre sugería que analizaban el mismo ecommerce.

El módulo de Shopify vive ahora en [angelgarciadatablog/shopify-orders-analysis](https://github.com/angelgarciadatablog/shopify-orders-analysis), con su historial de commits intacto.

---

## 👤 Autor

**Angel García**
Analista de Datos | Lima, Perú
🔗 [LinkedIn](https://www.linkedin.com/in/angelgarciachanga) · 🎥 [@angelgarciadatablog](https://youtube.com/@angelgarciadatablog)
