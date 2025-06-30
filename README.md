# Product Performance Insights: Análisis Histórico de Vistas, Inversión y Conversión

Este proyecto analiza el rendimiento de productos de un ecommerce a través de la integración de múltiples fuentes de datos. 

Se combinan métricas de comportamiento del usuario (vistas de producto, agregados al carrito y compras) obtenidas desde Google Analytics 4 a través de BigQuery, 
con la inversión publicitaria registrada en Facebook Ads y Google Ads, ambas a nivel de producto.

Gracias a esta integración, se construye una vista unificada que permite obtener insights tanto a nivel de producto como por categoría, 
con el objetivo de optimizar decisiones comerciales y de inversión publicitaria.

## 📍 Pregunta principal del Negocio
¿La inversión publicitaria en Facebook Ads y Google Ads está siendo asignada a los productos correctos?


## 🎯 Objetivo del proyecto
1. **Evaluar el ciclo completo del producto**: desde las vistas,  agregados al carrito y compras (Google Analytics), 
la inversión publicitaria (Facebook Ads y Google Ads) hasta el inventario disponible, los descuentos aplicados y su categorización.

2. **Medir la eficiencia publicitaria**: identificando productos con alta inversión y baja conversión para detectar ineficiencias y oportunidades de optimización en las campañas.

3. **Generar insights accionables**: por producto y por categoría, que permitan mejorar decisiones comerciales, ajustar estrategias de marketing y priorizar productos según su rentabilidad y comportamiento real.


## 🛠️ Herramientas y tecnologías

- **BigQuery** – Almacenamiento y análisis de grandes volúmenes de datos.
- **SQL** – Extracción y manipulación de datos.
- **Google Analytics 4** – Métricas de comportamiento de usuarios.
- **Facebook Ads y Google Ads** – Datos de inversión por producto.
- **Jupyter Notebook** – Documentación del análisis, consultas y visualizaciones.
- **GitHub** – Control de versiones y publicación del proyecto.


## 🗂️ Estructura del repositorio
```plaintext
product-performance-insights-sql/
├── README.md               # Descripción general del proyecto
├── notebook.ipynb          # Análisis completo con consultas y visualizaciones
├── sql/                    # Consultas SQL reutilizables
│   └── consultas.sql
├── img/                    # Gráficos y visuales del análisis
│   └── grafico1.png
└── data/                   # Archivos de muestra o datasets reducidos
    └── muestras.csv
```


## 📈 Resultados esperados

- Obtener una visión 360° del rendimiento de cada producto, combinando datos de comportamiento, inversión publicitaria y atributos internos como inventario y descuentos.
- Detectar ineficiencias en campañas publicitarias, como productos con alta inversión y baja conversión; y proponer acciones correctivas basadas en datos.
- Identificar oportunidades comerciales por categoría o tipo de producto, priorizando aquellos con alto potencial de conversión y rentabilidad.


## 📓 Notebook interactivo

El análisis completo se encuentra en el archivo `notebook.ipynb`, donde se explican paso a paso las consultas realizadas, los datos integrados y las conclusiones extraídas.



## 👤 Autor

**Ángel García**  
Analista de Datos | Lima, Perú  
👤 Perfil profesional: 🔗 [LinkedIn](https://www.linkedin.com/in/angelgarciachanga)  
🎥 Canal educativo: [@angelgarciadatablog](https://youtube.com/@angelgarciadatablog)  
💼 Especializado en Power BI, SQL y análisis de campañas de marketing.  


