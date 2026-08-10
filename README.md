# Ecommerce Performance Insights — Auditoría de medición en GA4

> ¿Puede esta tienda saber qué productos convierten mejor, con la medición que tiene hoy?

Un análisis sobre el export de GA4 de la Google Merchandise Store en BigQuery. No es un informe de ventas: es **una auditoría de la tabla de eventos** para averiguar qué preguntas de negocio se pueden responder con la medición existente y cuáles no.

La respuesta corta es que dos de las tres no se pueden, y el caso demuestra por qué.

📄 **Caso completo:** [angelgarciadatablog.com/portafolio/ecommerce-performance-insights](https://www.angelgarciadatablog.com/portafolio/ecommerce-performance-insights)

---

## Fuente de datos

| | |
|---|---|
| Origen | `bigquery-public-data.ga4_obfuscated_sample_ecommerce` |
| Qué es | Export crudo de GA4 de la Google Merchandise Store, publicado por Google como dataset de demostración |
| Periodo | 1 nov 2020 → 31 ene 2021 |
| Volumen | 4,295,584 eventos · 17 tipos de evento · 270,154 usuarios |
| Estructura | 92 tablas diarias (`events_20201101` … `events_20210131`) |
| Documentación | [Dataset de demostración de ecommerce](https://developers.google.com/analytics/bigquery/web-ecommerce-demo-dataset?hl=es-419) |

Es un dataset público. Todo el análisis es reproducible sin acceso a ningún dato privado.

---

## Qué encontró la auditoría

Once comprobaciones sobre la tabla de eventos. Las que cambiaron el resultado:

| Hallazgo | Consecuencia |
|---|---|
| **`view_item` no mide vistas de producto.** Un evento trae doce productos o ninguno; solo el 2% trae uno | Bloquea cualquier conversión por producto |
| **`item_id` no identifica productos.** 416 de 429 tienen varios identificadores, uno llega a catorce | La clave del análisis pasa a ser `item_name` |
| **`item_category` guarda dos cosas distintas** con el mismo nombre: la ruta de navegación en `view_item`, la categoría del catálogo en `purchase` | La categoría solo se toma de la mitad baja del embudo |
| **El evento de compra se duplica.** 5,692 eventos para 4,466 transacciones | Todo ingreso hay que deduplicar por `transaction_id` |
| 8 productos aparecen comprados sin haberse visto nunca | 645 compras sin producto atribuible |
| 31 productos no tienen categoría en ningún evento | El análisis por categoría cubre 390 de 421 |

---

## Qué se puede responder y qué no

| Pregunta de negocio | ¿Se responde? |
|---|---|
| ¿Cuál es la conversión del negocio? | Sí — 1.35% de las sesiones |
| ¿Qué productos facturan más? | Sí |
| ¿Qué categorías facturan más? | Sí, sobre 390 de 421 productos |
| ¿Qué productos convierten mejor? | **No** — falta el denominador |
| ¿Qué categoría convierte mejor? | **No** — mismo motivo |

---

## Qué habría que arreglar en la medición

1. Disparar `view_item` en la ficha de producto, con ese producto en `items`
2. Mandar las parrillas de categoría como `view_item_list`
3. Usar el mismo identificador de producto en las cuatro etapas del embudo
4. Separar la categoría del catálogo de la ruta de navegación en dos campos

Con los dos primeros, las cinco preguntas de arriba tendrían respuesta.

---

## Sobre este repositorio

**Las consultas SQL están en la página del caso**, no aquí. Son cortas y se leen mejor junto al razonamiento que las justifica; duplicarlas en el repo solo crearía dos versiones que se desincronizan.

Este repositorio guarda lo que no cabe en la página: scripts largos, datos de origen y material de apoyo.

---

## Autor

**Angel García** — Analista de Datos, Lima, Perú
[LinkedIn](https://www.linkedin.com/in/angelgarciachanga) · [@angelgarciadatablog](https://youtube.com/@angelgarciadatablog)
