# Contributing Guide

## Tabla de Contenidos

- [Descripción del Proyecto](#descripción-del-proyecto)
- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
- [Ejecución del Proyecto](#ejecución-del-proyecto)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Detalles Técnicos](#detalles-técnicos)
- [Funcionalidades](#funcionalidades)
- [Librerías Utilizadas](#librerías-utilizadas)
- [Formatos de Datos Soportados](#formatos-de-datos-soportados)
- [Contribuir](#contribuir)

---

## Descripción del Proyecto

Aplicación Shiny para resolver problemas de regresión lineal simple y múltiple de manera interactiva. Permite cargar datos desde archivos CSV o ingresarlos manualmente, seleccionar variables, ejecutar modelos estadísticos y visualizar resultados.

---

## Requisitos Previos

### Software Necesario

| Software | Versión Mínima | Descripción |
|----------|----------------|-------------|
| **R** | 4.0.0 o superior | Lenguaje de programación estadístico |
| **RStudio** | 1.4.0 o superior | IDE recomendado (opcional) |

### Verificar instalación de R

```bash
R --version
```

---

## Instalación

### 1. Instalar R

Descarga R desde [CRAN](https://cran.r-project.org/) y sigue el asistente de instalación.

### 2. Instalar librerías necesarias

Abre R o RStudio y ejecuta:

```r
install.packages("shiny")
install.packages("DT")
install.packages("ggplot2")
```

O de forma simultánea:

```r
install.packages(c("shiny", "DT", "ggplot2"))
```

### 3. Verificar instalaciones

```r
library(shiny)
library(DT)
library(ggplot2)
```

Si no hay errores, las librerías están correctamente instaladas.

---

## Ejecución del Proyecto

### Método 1: Desde RStudio

1. Abre RStudio
2. Archivo > Abrir archivo
3. Selecciona `app.R`
4. Haz clic en **Run App** (botón verde en la esquina superior derecha del editor)

### Método 2: Desde línea de comandos

```bash
R -e "shiny::runApp('.')"
```

### Método 3: Con puerto específico

```bash
R -e "shiny::runApp('.', port = 3838)"
```

### Acceso a la aplicación

Por defecto, la aplicación estará disponible en:
- **http://127.0.0.1:3838** (o el puerto configurado)
- **http://localhost:3838**

---

## Estructura del Proyecto

```
ProyectoDE/
├── app.R          # Archivo principal -入口 point
├── ui.R           # Definición de interfaz de usuario
├── server.R       # Lógica del servidor y cálculos
├── README.md      # Documentación general
└── LICENSE        # Licencia del proyecto
```

### Descripción de Archivos

| Archivo | Función |
|---------|---------|
| `app.R` | Punto de entrada. Carga ui.R y server.R, inicia la aplicación Shiny |
| `ui.R` | Define la interfaz de usuario (layout, inputs, outputs, estilos CSS) |
| `server.R` | Contiene toda la lógica: carga de datos, procesamiento, modelado estadístico |

---

## Detalles Técnicos

### Arquitectura de la Aplicación

La aplicación sigue el patrón MVC (Model-View-Controller) de Shiny:

```
┌─────────────────────────────────────────────┐
│                  app.R                       │
│  ┌─────────────┐      ┌─────────────────┐   │
│  │    ui.R     │      │   server.R      │   │
│  │  (Frontend) │ <--> │   (Backend)     │   │
│  └─────────────┘      └─────────────────┘   │
└─────────────────────────────────────────────┘
```

### Flujo de Datos

1. **Entrada**: Usuario carga CSV o ingresa datos manualmente
2. **Almacenamiento**: Datos se guardan en un valor reactivo `datos()`
3. **Selección**: Usuario elige tipo de modelo y variables
4. **Procesamiento**: Se ejecuta `lm()` con las variables seleccionadas
5. **Salida**: Se muestran tabla, resumen del modelo, gráfico e interpretación

### Tipos de Regresión Soportados

#### Regresión Lineal Simple
- Formula: `Y = β₀ + β₁X + ε`
- Una variable dependiente (Y)
- Una variable independiente (X)

#### Regresión Lineal Múltiple
- Formula: `Y = β₀ + β₁X₁ + β₂X₂ + ... + βₙXₙ + ε`
- Una variable dependiente (Y)
- Múltiples variables independientes

### Validaciones Implementadas

| Validación | Descripción |
|------------|-------------|
| X ≠ Y | No permite seleccionar la misma variable para X e Y |
| Y numérica | La variable dependiente debe ser numérica |
| Datos suficientes | Mínimo 2 observaciones para regresión simple |
| NA handling | Elimina automáticamente filas con valores faltantes |

### Manejo de Variables

La función `prepare_variable()` (línea 183-194 en `server.R`) procesa las variables de la siguiente manera:

1. Si es numérica → retorna tal cual
2. Si es factor → retorna tal cual
3. Si es character:
   - Intenta convertir a numérico
   - Si todos los valores son numéricos → convierte
   - Si no → convierte a factor

---

## Funcionalidades

### 1. Carga de Datos

- **Archivo CSV**: Soporta archivos con o sin encabezado
- **Datos manuales**: Modal interactivo para crear tablas

### 2. Tabla Interactiva (DT)

- Paginación (10 filas por página)
- Edición de celdas en tiempo real
- Filtrado de columnas según modelo seleccionado

### 3. Configuración del Modelo

- Selección de tipo de modelo (simple/múltiple)
- Selección dinámica de variables Y y X
- Para regresión múltiple: selección múltiple de predictores

### 4. Resultados Estadísticos

Usando `summary()` de R:
- Coeficientes (intercepto y pendientes)
- Error estándar
- Valor t y p-value
- R² y R² ajustado
- Estadístico F
- Grados de libertad

### 5. Visualización

| Tipo de Modelo | Visualización |
|----------------|---------------|
| Simple | Scatter plot con línea de regresión + IC (95%) |
| Múltiple | 4 gráficos diagnósticos (residuals, Q-Q, scale-location, leverage) |

### 6. Interpretación Automática

Genera automáticamente:
- Ecuación del modelo
- Valor de R²
- R² ajustado (para múltiples)

---

## Librerías Utilizadas

### shiny (>= 1.7.0)
Framework web para R. Permite crear aplicaciones interactivas.
- **Autor**: RStudio
- **License**: GPL-3
- **Fuente**: CRAN

### DT (>= 0.20)
Wrapper de DataTables para R. Proporciona tablas interactivas con JavaScript.
- **Autor**: Yihui Xie
- **License**: GPL-3
- **Fuente**: CRAN

### ggplot2 (>= 3.3.0)
Sistema para crear gráficos declarativamente basado en Grammar of Graphics.
- **Autor**: Hadley Wickham
- **License**: GPL-2
- **Fuente**: CRAN

---

## Formatos de Datos Soportados

### CSV (Recomendado)

```csv
grupo,temperatura,produccion
A,22,100
A,24,105
A,26,112
B,23,98
B,25,110
```

**Nota**: La primera fila se usa como nombres de columnas si "Archivo con encabezado" está activado.

### Requisitos de los Datos

| Requisito | Detalle |
|-----------|---------|
| Variable Y | **Obligatoriamente numérica** |
| Variables X | Numéricas para regresión simple, cualquier tipo para múltiples |
| Valores faltantes | Se eliminan automáticamente con `na.omit()` |
| Encoding | UTF-8 recomendado |

---

## Troubleshooting

### Error: "package 'shiny' is not installed"
```r
install.packages("shiny")
```

### Error: "Error in file()... No such file or directory"
Verifica que el archivo CSV exista y la ruta sea correcta.

### La aplicación no carga
```r
# Reiniciar R y volver a cargar
rm(list=ls())
shiny::runApp('.')
```

### Problemas con caracteres especiales
Guardar archivos CSV con encoding UTF-8.