# Product Performance Insights – Análisis de productos impulsados por campañas de publicidad digital

Este proyecto analiza el rendimiento de productos de un ecommerce a través de eventos de conversión.

Se analizan las métricas de comportamiento del usuario a nivel de producto (vistas de producto, agregados al carrito y compras) obtenidas desde Google Analytics 4 a través de BigQuery.

Gracias a esta integración, se construye una vista unificada que permite obtener insights tanto a nivel de producto como por categoría, 
con el objetivo de optimizar decisiones comerciales y de inversión publicitaria.

## 📍 Pregunta principal del Negocio
¿Los productos más vistos son los que generan mayores ingresos?


## 🎯 Objetivo del proyecto
1. **Evaluar el ciclo completo del producto**: desde las vistas,  agregados al carrito y compras (Google Analytics), 
la inversión publicitaria (Facebook Ads y Google Ads) hasta el inventario disponible, los descuentos aplicados y su categorización.

2. **Medir la eficiencia de productos**: identificando productos con alta y baja visuzalición y comparandolos con sus ventas para detectar ineficiencias y oportunidades de optimización en las campañas.

3. **Generar insights accionables**: por producto y por categoría, que permitan mejorar decisiones comerciales, ajustar estrategias de marketing y priorizar productos según su rentabilidad y comportamiento real.


## 🛠️ Herramientas y tecnologías

- **BigQuery** – Almacenamiento y análisis de grandes volúmenes de datos.
- **SQL** – Extracción y manipulación de datos.
- **Google Analytics 4** – Métricas de comportamiento de usuarios.
- **Looker Studio** – Visualización de reporte

## 🗂️ Estructura del proyecto
```plaintext
ecommerce-performance-insights/
├── README.md                         # Descripción general del proyecto integral
├── 1-product-performance-insight/    # Análisis de productos y campañas
│   ├── README.md                      
│   ├── analysis/
│   ├── queries/
│   ├── images/
│   └── dashboard/
```


## 📈 Resultados esperados

- Obtener una visión 360° del rendimiento de cada producto evaluando los eventos de conversión.
- Detectar ineficiencias en campañas publicitarias, como productos con alta visualización y baja conversión; y proponer acciones correctivas basadas en datos.
- Identificar oportunidades comerciales por categoría o tipo de producto, priorizando aquellos con alto potencial de conversión y rentabilidad.


## 📓 Análisis detallado 

El análisis completo se encuentra en el archivo [`product-performance-insights.md`](product-performance-insights/analisis), donde se explican paso a paso las consultas realizadas, los datos integrados y las conclusiones extraídas.



## 👤 Autor

**Angel García**  
Analista de Datos | Lima, Perú  
👤 Perfil profesional: 🔗 [LinkedIn](https://www.linkedin.com/in/angelgarciachanga)  
🎥 Canal educativo: [@angelgarciadatablog](https://youtube.com/@angelgarciadatablog)  
💼 Especializado en Power BI, SQL y análisis de campañas de marketing.  


