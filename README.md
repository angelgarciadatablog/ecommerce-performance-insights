# Ecommerce Performance Insights

Proyecto integral de análisis de datos sobre el desempeño de un ecommerce creado en Shopify. Se estructura en dos módulos independientes que abordan el rendimiento desde perspectivas complementarias: el comportamiento del producto (basado en GA4) y el análisis comercial (basado en datos de pedidos).

---

## Módulos

### [Módulo 1 · Product Performance Insight](1-product-performance-insight)

**¿Los productos más vistos son los que generan mayores ingresos?**

Analiza el ciclo completo de conversión por producto — vistas, agregados al carrito, inicios de checkout y compras — a partir de eventos de GA4 procesados en BigQuery. Permite identificar productos con alta exposición pero baja conversión y detectar oportunidades por categoría.

🔗 [Ver dashboard en Looker Studio](https://lookerstudio.google.com/reporting/5e8d97c8-e7c4-4c62-93f5-0d7396d216d7)

**Herramientas:** Google Analytics 4 · BigQuery · SQL · Looker Studio

---

### [Módulo 2 · Ecommerce Analytics Comercial](2-ecommerce-analytics-comercial)

**¿Qué patrones de compra, anomalías y tendencias se pueden extraer de los pedidos del ecommerce?**

Analiza el rendimiento comercial a partir de exportaciones de Shopify, explorando ventas por categoría, uso de cupones, preferencias de tallas y género, distribución geográfica y comparativa interanual.

🔗 [Ver dashboard en Looker Studio](https://lookerstudio.google.com/reporting/feceecaa-0ba9-4750-8b55-0ab20da5a5b8)

**Herramientas:** Shopify · BigQuery · SQL · Looker Studio

---

## Presentación

Existe una presentación interactiva que resume los hallazgos de ambos módulos:
🔗 [Ver presentación](https://www.angelgarciadatablog.com/ecommerce-performance-insights/)

---

## Estructura del repositorio

```plaintext
ecommerce-performance-insights/
├── README.md
├── index.html                                   # Presentación interactiva
├── 1-product-performance-insight/
│   ├── README.md
│   ├── analysis/                                # Desarrollo, lógica y hallazgos
│   ├── queries/                                 # Consultas SQL (GA4 + BigQuery)
│   ├── images/
│   └── dashboard/
└── 2-ecommerce-analytics-comercial/
    ├── README.md
    ├── analysis/                                # Desarrollo, lógica y hallazgos
    ├── queries/                                 # Consultas SQL (Shopify Orders)
    ├── files_csv/                               # Datos exportados desde Shopify
    ├── images/
    └── dashboard/
```

---

## Autor

**Angel García**
Analista de Datos · Lima, Perú
[LinkedIn](https://www.linkedin.com/in/angelgarciachanga) · [YouTube @angelgarciadatablog](https://youtube.com/@angelgarciadatablog)
