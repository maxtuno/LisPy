# Proyectos LisPy en Jupyter Notebook

Ejemplos grandes y proyectos completos que demuestran el stack completo de LisPy (Common Lisp + Python FFI) en Jupyter Notebook.

Cada proyecto es autocontenido y ejecutable secuencialmente. La sesión mantiene estado entre celdas: variables Lisp, funciones, macros, módulos Python importados y el namespace `__main__` de Python.

## Requisitos

```bash
python jupyter/install.py
jupyter notebook jupyter/projects/
```

Las librerías base (`ffi`, `continuations`, `defpyfun`, `defpyclass`, `python-template`, `persist`) se cargan automáticamente al iniciar el kernel. Las librerías pesadas (`numpy-fast`, `sympy-bridge`, `defmath`) se cargan bajo demanda en cada proyecto.

## Índice de Proyectos

| # | Proyecto | Nivel | Features |
|---|----------|-------|----------|
| 01 | [Análisis de Datos](01-analisis-datos/Analisis-Datos.ipynb) | ★★☆☆ Intermedio | pandas, matplotlib, GROUP BY, filtros Lisp→Python, persistencia de sesión |
| 02 | [Machine Learning](02-machine-learning/Machine-Learning.ipynb) | ★★★☆ Avanzado | scikit-learn, clasificación/regresión, pipelines, `defpyfun`, grid search desde Lisp |
| 03 | [Matemáticas Híbridas](03-matematicas-hibridas/Matematicas-Hibridas.ipynb) | ★★★★ Experto | `defmath`, `sympy-bridge`, `defnp`, gradiente/Hessiano, optimización, LaTeX |
| 04 | [Trading Engine](04-trading-engine/Trading-Engine.ipynb) | ★★★★ Experto | CLOS, `defgeneric`/`defmethod`, backtesting, Sharpe ratio, drawdown |
| 05 | [Procesamiento de Señales](05-procesamiento-senal/Procesamiento-Senal.ipynb) | ★★★☆ Avanzado | FFT, scipy.signal, filtros digitales, streaming con generadores, Welch PSD |
| 06 | [Robot 2-DOF](06-robot-dinamica/Robot-Dinamica.ipynb) | ★★★★ Experto | Lagrange simbólico, `solve_ivp`, control PD, espacio de trabajo, animación |

## Librerías Demostradas

| Librería | Proyectos | Propósito |
|----------|-----------|-----------|
| `numpy-fast.lp` | 01, 02, 03, 05, 06 | Operaciones vectorizadas NumPy desde Lisp |
| `sympy-bridge.lp` | 03, 06 | Cálculo simbólico (derivadas, integrales, LaTeX) |
| `defmath.lp` | 03, 06 | Funciones híbridas simbólico-numéricas |
| `continuations.lp` | 05 | Corutinas y generadores Python desde Lisp |
| `defpyfun.lp` | 02 | Funciones Python con captura de variables Lisp |
| `persist.lp` | 01, 02 | Checkpoint/restore de sesión Python |
| `ffi.lp` | — | FFI nativa a C vía ctypes |
| `defpyclass.lp` | — | Clases sincronizadas Lisp ↔ Python |
| `python-template.lp` | — | Generación de código Python desde S-expressions |
| `import-hooks.lp` | — | Transformación de AST Python desde Lisp |
