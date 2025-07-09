# Análisis técnico – Product Performance Insights

Este documento detalla el proceso técnico del análisis, incluyendo las fuentes de datos, lógica aplicada en SQL, construcción de la tabla maestra y hallazgos principales que alimentan el dashboard final.

---

## 1. 🧩 Fuentes de datos utilizadas

| Fuente | Descripción | Procedencia |
|--------|-------------|-------------|
| Google Analytics 4 | Eventos de comportamiento del usuario: `view_item`, `add_to_cart`, `purchase` | BigQuery export |
| Facebook Ads | Inversión publicitaria por producto | Archivo .csv o conexión directa |
| Google Ads | Inversión publicitaria por producto | Archivo .csv o conexión directa |
| Datos internos | Inventario, descuentos, categorías | Fuente interna (ej. hoja de cálculo o base de datos)

---

## 2. 🧠 Estructura del análisis

### 2.1 Preparación de datos

- Limpieza de eventos en GA4
- Estándar de IDs entre fuentes
- Conversión de métricas de inversión a formato unificado

### 2.2 Integración de fuentes

- Unión de GA4 + Ads usando `item_id`
- Agregación de métricas por producto y categoría
- Inclusión de variables adicionales (descuentos, inventario)

---

## 3. 🧮 Consulta SQL principal

La siguiente consulta construye la **tabla maestra** que alimenta el dashboard final:

> 📁 Archivo fuente: [`queries/consulta_product_performance.sql`](../queries/consulta_product_performance.sql)

```sql
-- Fragmento ilustrativo
SELECT
  item_id,
  item_name,
  category,
  SUM(views) AS total_views,
  SUM(add_to_cart) AS total_adds,
  SUM(purchases) AS total_purchases,
  SUM(facebook_spend + google_spend) AS total_ad_spend
FROM
  `proyecto.dataset.tabla_maestra`
GROUP BY
  item_id, item_name, category
```

## 4. 📊 Visualizaciones y gráficos

A continuación, algunos gráficos utilizados para obtener insights clave a partir de la tabla maestra:

| Visualización | Descripción |
|---------------|-------------|
| ![Gráfico 1](../images/grafico1.png) | Relación entre inversión publicitaria y compras por producto. Permite detectar productos con alto gasto y baja conversión. |
| ![Gráfico 2](../images/grafico2.png) | Funnel de conversión: vistas de producto → agregados al carrito → compras. Ayuda a identificar cuellos de botella en el proceso. |

> 🖼️ Las imágenes se encuentran en la carpeta [`images/`](../images/).

---

## 5. 🧭 Hallazgos clave

- **Desajuste entre inversión y conversión**: Se identificaron productos con alta inversión pero baja tasa de conversión (ej. *Zapatilla X*).
- **Categorías con mayor eficiencia**: Algunos segmentos, como *Accesorios*, lograron mejores resultados con menor inversión.
- **Productos con alto rendimiento orgánico**: Detectados productos con bajo gasto publicitario y alta conversión, lo que sugiere potencial para ampliar presupuesto.

---

## 6. 📈 Enlace al dashboard final

Accede al dashboard interactivo con filtros por categoría, canal publicitario y tipo de conversión:

🔗 [Ver dashboard en línea](https://tu-url-aqui.com)  
> *(Reemplazar con el enlace real al dashboard en Looker Studio, Power BI, etc.)*

---

## 👤 Autor

**Ángel García**  
📍 Lima, Perú  
🔗 [LinkedIn](https://www.linkedin.com/in/angelgarciachanga)  
🎥 [@angelgarciadatablog](https://youtube.com/@angelgarciadatablog)

