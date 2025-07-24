# Ecommerce Analytics Comercial- Análisis de rendimiento comercial de un ecommerce

# 🎯 Objetivo del proyecto

Este proyecto tiene como objetivo analizar el rendimiento comercial de un ecommerce creado con Shopify, a partir de datos de pedidos, con el fin de identificar patrones de compra, anomalías y eventos recurrentes que permitan brindar información útil para la toma de decisiones estratégicas.

## 📈 Descripción del análisis

Se realiza una exploración detallada sobre:

- Comparación de ventas respecto al año anterior
- Artículos vendidos con y sin descuento
- Comportamiento por categorías de productos
- Uso de cupones promocionales (BIENVENIDA, SUERTE, CYBER)
- Preferencias de tallas y género
- Distribución geográfica de los pedidos

# 🗂 Fuente de datos

Los datos utilizados son simulados y provienen de una tienda ficticia creada en Shopify, con el objetivo de representar un caso realista. Este enfoque permite que el análisis realizado pueda aplicarse o adaptarse a cualquier tienda en esa misma plataforma.

Los datos se obtienen con campos estándar mediante una exportación manual de pedidos desde la plataforma de Shopify.


> 🔜 En una siguiente etapa, se conectará directamente con la API REST de Shopify para automatizar la recolección de datos y eliminar la dependencia de las exportaciones manuales.

## 🛠️ Herramientas y tecnologías

- **Shopify** – Extracción de datos
- **BigQuery** – Almacenamiento y limpieza de datos
- **Looker Studio** – Visualización de reporte


## 🗂️ Estructura del proyecto
```plaintext
ecommerce-performance-insight/       # Descripción general del proyecto integral
├── README.md                         
├── 2-ecommerce-analysis-comercial/    
│   ├── README.md                     # Descripción general del módulo
│   ├── analysis/                     # Desarrollo, lógica y hallazgos
│   ├── queries/                      # Consultas SQL
│   ├── images/                       # Soporte visual
│   └── dashboard/                    # Archivos relacionados a visualización interactiva
```

## 📈 Resultados esperados

- Tendencias de crecimiento o caída en las ventas respecto al mismo periodo del año anterior.
- Qué porcentaje de ventas proviene de productos con descuento y cómo estos influyen en el negocio
- Las categorías de productos con mejor desempeño para priorizar stock y promociones.
- El cupón más efectivo en términos de cantidad de pedidos generados.
- Las tallas más vendidas según género, ayudando a optimizar inventario y segmentación.
- Las regiones o ciudades con mayor concentración de pedidos, lo cual puede guiar estrategias logísticas o campañas localizadas.


## 📓 Análisis detallado 

El análisis completo se encuentra en el archivo [`ecommerce-analytics-comercial-analysis.md`](analysis/ecommerce-analytics-comercial-analysis.md) donde se describen paso a paso las exploraciones realizadas, los hallazgos obtenidos y las interpretaciones clave del rendimiento comercial del ecommerce.


## 📈 Dashboard Interactivo

Consulta el dashboard interactivo desarrollado en Looker Studio:  
🔗 [Ver en línea]([https://lookerstudio.google.com/reporting/5e8d97c8-e7c4-4c62-93f5-0d7396d216d7](https://lookerstudio.google.com/reporting/feceecaa-0ba9-4750-8b55-0ab20da5a5b8))


## 👤 Autor

**Angel García**  
Analista de Datos | Lima, Perú  
👤 Perfil profesional: 🔗 [LinkedIn](https://www.linkedin.com/in/angelgarciachanga)  
🎥 Canal educativo: [@angelgarciadatablog](https://youtube.com/@angelgarciadatablog)  
💼 Especializado en Power BI, SQL y análisis de campañas de marketing.  



