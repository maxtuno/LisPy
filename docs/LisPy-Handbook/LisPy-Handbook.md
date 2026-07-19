# LisPy Handbook — Índice Maestro

> **The Definitive Guide to LisPy: Where Common Lisp and Python Become One**
>
> *"It is not Lisp. It is not Python. It is LisPy."*
>
> Autor: Oscar Riveros — 2026

---

## Estructura General

| Parte | Título | Nivel | Capítulos | Ejemplos |
|-------|--------|-------|-----------|----------|
| 0 | Preludio | — | 4 | 0 |
| I | Fundamentos | ★☆☆☆ Principiante | 8 | 45+ |
| II | El Núcleo Lisp | ★★☆☆ Intermedio | 9 | 80+ |
| III | El Puente Python | ★★☆☆ Intermedio | 9 | 55+ |
| IV | Programación Híbrida | ★★★☆ Avanzado | 11 | 65+ |
| V | Meta-Programación | ★★★★ Experto | 8 | 40+ |
| VI | Matemáticas Aplicadas | ★★★★ Experto | 8 | 50+ |
| VII | Ingeniería de Sistemas | ★★★★ Experto | 7 | 30+ |
| VIII | Estudios de Caso | ★★★★ Experto | 7 | 25+ |
| IX | Apéndices | — | 8 | — |
| X | Librerías `lib/` | ★★★☆ Avanzado | 1 | — |
| XI | Competitive Programming Problems | ★☆☆☆–★★★★ | 1 (120 prob.) | — |
| **Total** | | | **81 secciones** | **390+ ejemplos, 120 problemas** |

---

## Parte 0 — Preludio

### Capítulo 0.1 — Manifiesto de LisPy
- La visión: un solo proceso, dos runtimes, posibilidades ilimitadas
- ¿Por qué Lisp? Expresividad, macros, condiciones, CLOS
- ¿Por qué Python? Ecosistema, librerías, comunidad, rendimiento
- ¿Por qué juntos? El puente bidireccional como ventaja cualitativa
- Filosofía de diseño: single-file C99 portable, CPython 3.14 embebido
- Principio rector: *"Lisp como orquestador y generador, Python como motor de cálculo"*

### Capítulo 0.2 — Cómo Leer Este Libro
- Notación y convenciones tipográficas
- Símbolos de nivel de dificultad: ★ principiante → ★★★★ experto
- Organización por capas: cada parte presupone la anterior
- Ejecución de ejemplos: línea de comandos, REPL interactivo
- Dónde encontrar el código fuente: `lib/`, `problem_*.lp`

### Capítulo 0.3 — Hoja de Ruta del Aprendizaje
- Ruta A: Científico de Datos (Partes I → III → IV → VI → VIII)
- Ruta B: Ingeniero de Software (Partes I → II → V → VII → VIII)
- Ruta C: Matemático (Partes I → III → VI → VIII)
- Ruta D: Hacker de Lenguajes (Partes I → II → V → VII)
- Ruta E: Principiante Absoluto (Parte I completa, luego elegir ruta)

### Capítulo 0.4 — Mapa de Dependencias entre Capítulos
- Grafo de prerrequisitos: qué capítulo requiere cuáles para su comprensión
- Parte I como base universal: sin dependencias, punto de entrada único
- Parte II depende de Parte I (sintaxis, tipos, control de flujo)
- Parte III depende de Partes I y II (funciones, símbolos, macros)
- Parte IV depende de Partes I, II y III (puente Python + CLOS + macros)
- Parte V depende de Partes I–IV (meta-programación sobre todas las capas)
- Parte VI depende de Partes I, III y IV (`numpy-fast`, `sympy-bridge`, `defmath`)
- Parte VII depende de Partes I y II (compilación, CLI, sistema)
- Parte VIII depende de Partes I–VI según el caso de estudio específico
- Matriz de prerrequisitos: tabla con todos los capítulos y sus dependencias directas
- Capítulos autocontenidos: marcados con `(*)` para lectura no lineal
- Recomendación de orden para cada ruta de aprendizaje (ver Capítulo 0.3)

---

## Parte I — Fundamentos ★☆☆☆

### Capítulo 1.1 — Instalación y Primeros Pasos
- Requisitos del sistema: Windows x64, CPython 3.14 opcional
- Descarga e instalación de `lispy.exe`
- Verificación de la instalación: `lispy.exe --version`
- Entornos virtuales Python: `python -m venv` + `--venv`
- Primer comando: `(+ 1 2)` → 3
- El REPL: `LisPy>` y comandos `:help`, `:quit`, `:pip`

**Ejemplos:**
1. Instalación básica y verificación
2. Primer programa: `hello.lp` — `(format t "Hello, LisPy!~%")`
3. Uso de `--venv` con un entorno virtual preexistente
4. Instalación de `numpy` desde el REPL con `:pip install numpy`

### Capítulo 1.2 — Átomos y Tipos de Datos Primitivos
- Números enteros (bigints de precisión arbitraria): `42`, `-7`, `123456789012345678901234567890`
- Números racionales: `1/3`, `22/7`
- Números flotantes: `3.14159`, `1.0e10`, `-0.5`
- Números complejos: `#C(3 4)`, `#C(1.0 -2.5)`
- Caracteres: `#\A`, `#\Space`, `#\Newline`, `#\λ`
- Strings: `"Hello"`, `"Línea 1~%Línea 2"`
- Símbolos: `'foo`, `'|nombre con espacios|`, `:keyword`
- Booleanos: `t` (verdadero) y `nil` (falso, también lista vacía)

**Ejemplos:**
5. Precisión arbitraria con bigints: Fibonacci(100)
6. Aritmética exacta con racionales: `(+ 1/3 1/7 1/11)` → fracción exacta
7. Operaciones con complejos: multiplicación, magnitud, fase
8. Comparación de strings: `string=`, `string<`, `string-equal`
9. Conversión entre tipos: `float`, `coerce`, `numerator`, `denominator`

### Capítulo 1.3 — Listas: La Estructura de Datos Universal
- Cons cells: `(cons 1 2)` → `(1 . 2)`
- Listas propias: `'(1 2 3 4 5)`, `(list 1 2 3)`
- Listas impropias (dotted): `'(1 2 . 3)`
- `car` (first), `cdr` (rest), `cadr`, `caddr`, `cddr`...
- `push`, `pop`, `pushnew`
- `cons`, `append`, `list*`, `make-list`
- `nth`, `nthcdr`, `last`, `butlast`
- `member`, `find`, `position` con `:test` y `:key`
- `assoc`, `rassoc`, `acons` — listas de asociación (alists)
- `sublis`, `subst`, `subst-if`
- `copy-list`, `copy-tree`, `tree-equal`
- `reverse`, `nreverse`
- `adjoin`, `union`, `intersection`, `set-difference`

**Ejemplos:**
10. Construcción incremental con `push`/`pop`
11. Búsqueda en alists: mini-base de datos de productos
12. `copy-tree` vs `copy-list`: mutación independiente
13. Operaciones de conjuntos con listas: `union`, `intersection`
14. Aplanamiento recursivo de listas anidadas (`flatten`)
15. Zip de dos listas en pares
16. Transposición de matriz como lista de listas

### Capítulo 1.4 — Vectores y Secuencias
- Vectores: `#(1 2 3)`, `(vector 1 2 3)`
- `aref`, `(setf aref)` para acceso indexado
- `make-array`: dimensiones, `:initial-element`, `:initial-contents`
- Vectores ajustables con fill-pointer: `vector-push`, `vector-pop`
- `length`, `elt`, `subseq`, `copy-seq`
- `fill`, `replace`, `reverse`
- `concatenate`, `map`, `map-into`
- `reduce` con `:key`, `:from-end`, `:initial-value`
- `remove`, `remove-if`, `remove-if-not`, `delete`
- `count`, `count-if`, `find`, `position`
- `sort`, `stable-sort` con predicado y `:key`
- `every`, `some`, `notevery`, `notany`
- `mismatch`, `search` en secuencias
- `merge` de secuencias ordenadas

**Ejemplos:**
17. Vector con fill-pointer: buffer dinámico
18. `reduce` para producto escalar (dot product)
19. `sort` con `:key` personalizado
20. `remove-if-not` para filtrado funcional
21. Búsqueda binaria sobre vector ordenado
22. Matriz bidimensional con `make-array` y `aref`
23. `map` vectorizado sobre dos secuencias

### Capítulo 1.5 — Hash Tables y Diccionarios
- `make-hash-table` con `:test` (`eq`, `eql`, `equal`, `equalp`)
- `gethash`, `(setf gethash)`, `remhash`, `clrhash`
- `maphash`, `hash-table-count`, `hash-table-p`
- `with-hash-table-iterator` (si disponible)
- Hash como contador de frecuencias
- Hash como caché (memoización)
- Hash como índice invertido
- Hash como representación de conjuntos

**Ejemplos:**
24. Contador de palabras en un texto
25. Two-sum: búsqueda de pares con hash table
26. Memoización de Fibonacci con hash table
27. Índice invertido de documentos
28. Agrupación por clave (GROUP BY)
29. Copia profunda de hash tables
30. Iteración con `maphash`

### Capítulo 1.6 — Control de Flujo Básico
- `if`, `when`, `unless`, `cond`
- `case`, `ecase`, `typecase`
- `and`, `or` (short-circuit)
- `let`, `let*` — ámbitos léxicos
- `progn`, `prog1`, `prog2`
- `setq`, `setf` — asignación y lugares generalizados
- `incf`, `decf`, `rotatef`, `shiftf`
- `psetq`, `psetf` — asignación paralela

**Ejemplos:**
31. Calculadora de tarifas con `cond`
32. Menú interactivo con `case`
33. Validación en cadena con `and` short-circuit
34. Intercambio de variables con `rotatef`
35. Asignación paralela con `psetf`

### Capítulo 1.7 — Iteración y Recursión
- `dotimes`, `dolist`
- `loop`: cláusulas `for`, `while`, `collect`, `sum`, `maximize`, `thereis`
- `do`, `do*` — iteración con múltiples variables
- `tagbody` + `go` — saltos explícitos
- `block` + `return-from` — salida no local
- `catch` + `throw` — escape dinámico
- Recursión simple y recursión de cola
- `labels` para funciones locales recursivas

**Ejemplos:**
36. Tabla de multiplicar con `dotimes` anidado
37. `loop` para Project Euler #1 (suma de múltiplos)
38. `do*` para el algoritmo de Euclides (MCD)
39. `tagbody`/`go` para máquina de estados simple
40. Máximo de una lista con `loop maximize`
41. Factorial con recursión de cola y `labels`
42. `catch`/`throw` para salida temprana en búsqueda profunda

### Capítulo 1.8 — Entrada/Salida Fundamental
- `format`: directivas `~A`, `~S`, `~D`, `~F`, `~%`, `~&`, `~~`
- `format` avanzado: `~R` (números romanos/cardinales), `~C` (caracteres), `~B` (binario)
- `print`, `princ`, `prin1`, `terpri`
- `read`, `read-line`, `read-char`, `read-from-string`
- `write`, `write-line`, `write-string`, `write-to-string`
- `with-open-file`: lectura y escritura de archivos
- `*standard-input*`, `*standard-output*`, `*error-output*`
- Redirección con `with-input-from-string`, `with-output-to-string`
- Streams de broadcast y echo

**Ejemplos:**
43. Formato tabular con `~%`, `~@a`, alineación
44. Números romanos con `~@R`
45. Escritura y lectura de archivo CSV simple
46. Captura de salida con `with-output-to-string`
47. Procesamiento de archivo línea por línea

---

## Parte II — El Núcleo Lisp ★★☆☆

### Capítulo 2.1 — Funciones y Ámbitos
- `defun` — definición de funciones
- Parámetros: `&optional`, `&rest`, `&key`, `&aux`, `&allow-other-keys`
- Parámetros `&key` con valores por defecto y `supplied-p`
- `lambda` — funciones anónimas
- `funcall`, `apply` — invocación funcional
- `function`, `#'` — operador de función
- `flet`, `labels` — funciones locales
- Closures: captura de variables léxicas
- `complement`, `constantly` — funciones derivadas
- `identity`, `values`, `values-list`
- `multiple-value-bind`, `multiple-value-list`, `multiple-value-setq`
- `nth-value`

**Ejemplos:**
48. Parámetros `&key` con valores por defecto
49. `&rest` para funciones variádicas (suma de N argumentos)
50. Closure: contador con estado encapsulado
51. `funcall` vs `apply`: diferencias semánticas
52. Composición funcional: `(complement #'evenp)` aplicado con `remove-if`
53. Retorno de múltiples valores: división entera con cociente y resto
54. `multiple-value-bind` para desempaquetar resultados

### Capítulo 2.2 — Símbolos, Paquetes y Namespaces
- Símbolos internados vs no-internados: `intern`, `make-symbol`, `gensym`
- `symbol-name`, `symbol-package`, `symbol-value`, `symbol-function`
- `boundp`, `fboundp`, `makunbound`, `fmakunbound`
- `get`, `(setf get)`, `remprop`, `symbol-plist`
- `defpackage`, `in-package`, `find-package`
- `:use`, `:export`, `:import-from`, `:shadow`, `:shadowing-import-from`
- `do-symbols`, `do-external-symbols`, `do-all-symbols`
- Nicknames de paquetes
- Conflictos de símbolos y resolución
- El paquete `PYTHON`/`PY` como caso especial de auto-internado

**Ejemplos:**
55. Creación de paquete con `defpackage` y exportación selectiva
56. Símbolos no-internados: `gensym` para higiene en macros
57. Property lists para metadatos en símbolos
58. Resolución de conflictos con `shadowing-import-from`
59. Inspección de paquetes con `do-external-symbols`
60. El paquete `PYTHON`: auto-internado y resolución transparente

### Capítulo 2.3 — Macros: Metaprogramación en Tiempo de Compilación
- `defmacro` — sintaxis y semántica
- Backquote (`` ` ``), comma (`,`), comma-at (`,@`)
- `gensym` para higiene (evitar captura de variables)
- `once-only` — evaluación única de expresiones
- `macroexpand-1`, `macroexpand` — inspección de expansión
- `define-compiler-macro` — optimizaciones en tiempo de compilación
- `define-symbol-macro`, `symbol-macrolet`
- Macros anafóricas (ej. `aif` que bindea `it`)
- Macros de iteración personalizadas
- Macros con `&body` y `&environment`
- Patrones: `with-*` (resource management), `def*` (definición)

**Ejemplos:**
61. `aif` — macro anafórico que bindea `it`
62. `square-once` con `once-only` y `gensym`
63. `with-coords` — macro de destructuring
64. `define-compiler-macro` para optimizar `square`
65. `symbol-macrolet` para alias de variables
66. Quasiquoting: generación de código con `,` y `,@`
67. Macro de bucle `while` personalizada
68. `macroexpand-1` para depuración de macros

### Capítulo 2.4 — CLOS: Common Lisp Object System (Fundamentos)
- `defclass` — slots, `:initarg`, `:initform`, `:accessor`, `:reader`, `:writer`
- `:allocation :instance` vs `:allocation :class`
- `make-instance`, `slot-value`, `slot-boundp`, `slot-exists-p`
- `(setf slot-value)`, `slot-makunbound`
- `with-slots`, `with-accessors` — acceso conciso
- `defgeneric` — definición de función genérica
- `defmethod` — especialización por clase
- `call-next-method` — delegación al método padre
- Especializadores EQL en `defmethod`
- `change-class` — transformación dinámica de clase
- `class-of`, `type-of`, `find-class`
- `print-object` — personalización de impresión
- Jerarquía de clases: herencia simple

**Ejemplos:**
69. Jerarquía de figuras geométricas (`shape` → `circle`, `rectangle`)
70. Método `area` con `defgeneric`/`defmethod`
71. `call-next-method` en cadena de herencia
72. Especializadores EQL para tasas de impuesto por país
73. `change-class` para migración `point-2d` → `point-3d`
74. `print-object` personalizado para vectores 2D
75. Slot de clase (`:allocation :class`) para contador compartido
76. `with-slots` para acceso conciso a múltiples slots

### Capítulo 2.5 — CLOS Avanzado: Combinación de Métodos
- Métodos `:before`, `:after`, `:around`
- Orden de ejecución en combinación estándar
- `call-next-method` en métodos `:around`
- Propagación de argumentos en `call-next-method`
- `no-next-method`, `no-applicable-method`
- Herencia múltiple y orden de precedencia de clases (CPL)
- Re-inicialización: `initialize-instance :after`/`:before`
- `reinitialize-instance`, `shared-initialize`
- `make-instances-obsolete`

**Ejemplos:**
77. Middleware pipeline con `:around`, `:before`, `:after`
78. Orden de combinación estándar: verificación con logs
79. `initialize-instance :after` con `&allow-other-keys`
80. `no-applicable-method` para manejo de errores en dispatch
81. Herencia múltiple: `ta dxa` → `(p , sw)`
82. Delegación con `call-next-method` y argumentos explícitos

### Capítulo 2.6 — Sistema de Condiciones y Re-inicios
- `error`, `cerror`, `warn`, `signal`
- `handler-case` — manejo de errores sin desenrollar
- `handler-bind` — manejo antes del desenrollado
- `ignore-errors` — atrapa cualquier error
- `restart-case` — define puntos de reinicio
- `restart-bind`, `find-restart`, `invoke-restart`
- `with-simple-restart` — reinicio simple
- `unwind-protect` — limpieza garantizada
- `check-type`, `assert` — validación en runtime
- Condiciones personalizadas: `define-condition`

**Ejemplos:**
83. `handler-case` para división segura (división por cero)
84. `restart-case` con opciones `use-default`, `skip-file`
85. `unwind-protect` para liberación de recursos
86. `ignore-errors` para suprimir errores no críticos
87. `check-type` como validación declarativa
88. `handler-bind` para capturar warnings sin desenrollar
89. Condición personalizada: `malformed-input-error`

### Capítulo 2.7 — Iteración Avanzada y LOOP
- `loop` en profundidad: todas las cláusulas
- `for ... in`, `for ... on`, `for ... across`
- `for ... from ... to ... by`, `for ... below`
- `for ... = ... then ...`
- `while`, `until`, `always`, `never`, `thereis`
- `collect`, `append`, `nconc`, `count`, `sum`, `maximize`, `minimize`
- `with`, `initially`, `finally`, `do`, `doing`
- `named` blocks y `return`
- `if`, `when`, `unless` dentro de `loop`
- `loop-finish`

**Ejemplos:**
90. `loop` completo: filtro + transformación + acumulación
91. Múltiples cláusulas `for` en paralelo
92. `for ... = ... then ...` para secuencias recurrentes
93. `loop named` con `return-from` para salida temprana
94. `finally` para cleanup y reporte

### Capítulo 2.8 — Operaciones de Archivos y Streams
- `open`, `close`, `with-open-file`
- Direcciones: `:input`, `:output`, `:io`, `:probe`
- `if-exists`: `:error`, `:supersede`, `:append`, `:new-version`
- `read`, `read-line`, `read-char`, `read-byte`
- `write`, `write-line`, `write-char`, `write-byte`
- `file-position`, `file-length`, `file-write-date`
- `truename`, `probe-file`, `delete-file`, `rename-file`
- Streams de string: `make-string-input-stream`, `make-string-output-stream`
- Streams compuestos: `make-broadcast-stream`, `make-echo-stream`
- `make-two-way-stream`, `make-concatenated-stream`
- `make-synonym-stream`
- `listen`, `read-char-no-hang`, `clear-input`, `finish-output`
- `y-or-n-p`, `yes-or-no-p`

**Ejemplos:**
95. Procesamiento de archivo CSV con `read-line` y `split`
96. Escritura segura con backup usando `rename-file`
97. Stream de string para testing de funciones de salida
98. Broadcast stream para logging dual (pantalla + archivo)
99. `file-position` para acceso aleatorio en archivo binario
100. Diálogo interactivo con `y-or-n-p`

### Capítulo 2.9 — Compilación y Carga
- `compile`, `compile-file` — compilación a FASL
- `load` — carga de archivos fuente y compilados
- `eval`, `eval-when` — evaluación en distintos tiempos
- `*compile-file-pathname*`, `*load-pathname*`
- `provide`, `require` — gestión de módulos
- `disassemble` — inspección de bytecode (si implementado)
- `time` — medición de rendimiento
- Flags de línea de comandos: `-c` (compilar), `--repl`, `-i`

**Ejemplos:**
101. Compilación de función y comparación de rendimiento con `time`
102. `load` de librería externa: `(load "lib/defmath.lp")`
103. `eval-when` para inicialización en tiempo de compilación vs carga
104. Medición de rendimiento: `(time (loop ...))`

---

## Parte III — El Puente Python ★★☆☆

### Capítulo 3.1 — Primeros Pasos con Python desde Lisp
- Verificación de disponibilidad: `(find-package :py)`
- `py:import` — importar módulos Python
- `py:attr` — acceder atributos
- `py:call` — invocar funciones Python
- `(py:print "hola")` — builtins Python como funciones Lisp
- Caché de módulos: importaciones repetidas son instantáneas
- Resolución transparente `py:` para módulos y builtins
- Llamada directa de `VALUE_PYTHON` callable como cabeza de función

**Ejemplos:**
105. Primer programa híbrido: `(py:print "Hello from Python!")`
106. Importar `math` y calcular `(py:sqrt 16)` → 4.0
107. `py:sum '(1 2 3 4 5)` → 15 (builtin Python invocado desde Lisp)
108. `py:sorted '(3 1 4 1 5)` → `(1 1 3 4 5)`
109. Caché de módulos: segunda importación es ~0ms
110. Llamada directa: `(let ((sqrt @math:sqrt)) (sqrt 144))` → 12.0

### Capítulo 3.2 — Conversión de Tipos Lisp ↔ Python
- Tabla completa de conversión Lisp → Python
- Tabla completa de conversión Python → Lisp
- `py:->python` — conversión explícita Lisp → Python
- `py:->lisp` — conversión explícita Python → Lisp
- Semántica de referencias y refcounting
- Conversión recursiva de listas, hash-tables, vectores
- Tipos no convertibles: `VALUE_RATIO`, `VALUE_PATHNAME`
- `set`/`frozenset` como `VALUE_PYTHON` (sin conversión automática)
- Conversión de bigints: límites de precisión

**Ejemplos:**
111. Roundtrip Lisp → Python → Lisp: `'(1 2 3)`
112. Conversión de hash-table Lisp a `dict` Python
113. `py:->python` de lista anidada: `'((1 2) (3 4))`
114. Manejo de `VALUE_RATIO`: conversión explícita a float
115. Conversión de `None`/`True`/`False` de Python a `nil`/`t`
- Véase también: Apéndice C para la tabla completa de conversión de tipos

### Capítulo 3.3 — API Python Completa
- `py:getitem` — indexación `obj[key]`
- `py:%set-attr`, `py:%set-item` — mutación de objetos Python
- `py:%chain` — encadenamiento de atributos (motor de `#_` y `@`)
- `py:run` — ejecución de código Python como string
- `py:iter`, `py:next` — iteración sobre objetos Python
- `py:call-kw` — keyword arguments
- `py:help`, `py:dir`, `py:type`, `py:repr`, `py:str`, `py:len`
- `py:python?`, `py:callable?` — verificación de tipos

**Ejemplos:**
116. `py:getitem` para acceso a arrays/listas Python
117. `py:%set-attr` y `py:%set-item` para mutación
118. `py:run` para definir funciones Python multi-línea
119. `py:iter`/`py:next` para consumir iteradores Python
120. `py:call-kw` con hash-table de kwargs
121. `py:dir` y `py:help` para exploración interactiva
122. `py:python?` y `py:callable?` para verificación defensiva

### Capítulo 3.4 — Las Macros de Lectura `#_` y `@`
- Sintaxis: `#_modulo:attr1:attr2` y `@modulo:attr1:attr2` / `@modulo.attr1.attr2`
- Expansión interna a `py:%chain` (ambas producen exactamente lo mismo)
- Forma moderna recomendada: `@math:pi`, `@os:path:join`, `(@math:sqrt 16)`
- Forma clásica: `#_math:pi`, `(#_math:sqrt 16)`
- Ambas se pueden usar como cabeza de función: `(@math:sqrt 16)` → 4.0
- El separador `.` es soportado por `@` para estilo Python: `@math.sqrt`
- Precauciones con `:` en nombres de paquete

**Ejemplos:**
123. `@math:pi` → 3.14159...
124. `(@math:sqrt 25)` → 5.0
125. Encadenamiento: `@os:path:join` para `os.path.join`
126. Variable local Lisp como primer eslabón
127. Notación con punto: `@math.sqrt` ≡ `@math:sqrt`

### Capítulo 3.5 — Modelo de Memoria y GIL
- Estructura interna de `VALUE_PYTHON`: `obj`, `callable`, `callable_known`
- Ownership de `PyObject*`: una referencia por `VALUE_PYTHON`
- Ciclo de vida: GC de Lisp → `Py_DECREF`
- Caché de callable: `PyCallable_Check` bajo demanda
- Caché de módulos: hash-table con test `equal`
- GIL (Global Interpreter Lock): acquire/release por llamada
- Macros `PY_GIL_ENSURE()` y `PY_GIL_RELEASE()`
- Implicaciones de rendimiento del GIL

**Ejemplos:**
127. Verificación de callable: `(py:callable? @math:sqrt)`
128. Caché de módulos: inspección conceptual
129. Ciclo de vida: `let` binding de `VALUE_PYTHON`

### Capítulo 3.6 — Depuración Cruzada
- `py:last-traceback` — frames del último error Python
- `py:frame-locals` — variables locales de un frame
- `py:frame-globals` — variables globales de un frame
- `py:frame-eval` — evaluación en contexto de frame
- `ignore-errors` para atrapar excepciones Python
- `py_bridge_check_error`: mecanismo interno de captura

**Ejemplos:**
130. Captura de traceback tras división por cero
131. Inspección de `f_locals` en frame de error
132. Evaluación de expresión en contexto de frame (`py:frame-eval`)
133. `ignore-errors` envolviendo `py:import` de módulo inexistente

### Capítulo 3.7 — Callbacks Lisp → Python y Viceversa
- `py:register-callback` — exponer función Lisp como callback Python
- Mecanismo sincrónico: `lispy_callback_c` en C
- Mecanismo cooperativo: almacenamiento en `__main__._lispy_cb`
- Limitaciones: solo funciones de ámbito global
- Callbacks de Python a Lisp a través de `builtins`

**Ejemplos:**
134. Registro de callback: `(py:register-callback 'mi-funcion)`
135. Invocación desde Python: `builtins.mi_funcion_cb(42)`
136. Callback sincrónico vs cooperativo

### Capítulo 3.8 — Rendimiento y Optimización del Puente
- Overhead de `py:call`: GIL + conversión + refcounting
- Umbrales: < 1K llamadas (insignificante), > 10K (delegar a lote)
- Conversión de listas: costo O(n) recursivo
- Caché de módulos y callables
- Bigints: costo O(n²) en conversión para enteros grandes
- Modos de uso: nativo vs delegado vs híbrido vs VALUE_PYTHON directo
- Tabla de decisión: cuándo usar cada modo

**Ejemplos:**
137. Medición de overhead con `time` en loop de 10K iteraciones
138. Uso de `py:run` para bucle intensivo en Python (Modo 2)
139. Modo híbrido: Lisp para lógica, Python para matemáticas
140. VALUE_PYTHON directo: evitar `py:call` para llamadas repetidas

### Capítulo 3.9 — FFI Directa a C con ctypes y cffi
- Cuándo usar FFI en lugar del puente Python: librerías sin bindings, rendimiento extremo
- `ctypes`: carga de DLLs compartidas, definición de tipos C, llamada a funciones
- `cffi`: API out-of-line vs in-line, compilación de bindings
- Mapeo de tipos Lisp ↔ C vía Python: enteros, floats, strings, `POINTER`
- Estructuras y uniones: `ctypes.Structure`, `cffi.FFI().new("struct X")`
- Callbacks C desde Lisp: `ctypes.CFUNCTYPE`, `cffi.callback`
- Paso de arrays NumPy a funciones C sin copia (buffer protocol)
- Comparación de rendimiento: FFI vs `py:call` vs nativo Lisp
- Limitaciones: GIL durante llamadas C, seguridad de memoria, portabilidad

**Ejemplos:**
- Cargar `msvcrt.dll`/`libc.so` y llamar `printf` desde Lisp
- Definir struct `Point` en C, instanciarla y pasarla a función C
- Callback Lisp invocado desde código C vía `CFUNCTYPE`
- Pasar array NumPy a función C sin copia usando buffer protocol
- Benchmark: 1M de llamadas FFI vs `py:call` vs loop nativo Lisp

---

## Parte IV — Programación Híbrida ★★★☆

### Capítulo 4.1 — La Biblioteca `python-template.lp`
- Visión general: generación de código Python desde formas Lisp
- `python-template` y `write-python-template`
- Mapeo de constructos: `def`, `return`, `if`/`else`, `for`, `while`
- `lambda`, `print`, `.` (llamadas a método)
- `aref` (indexación), operadores aritméticos y comparaciones
- `:=` para asignación
- Gestión de indentación: tracking de nivel de anidamiento
- Limitaciones: no soporta clases, decoradores, `with`, `try`

**Ejemplos:**
141. Generar función Python `fib` desde Lisp
142. Bucle `for` con `range`: template de iteración
143. `if`/`else` anidado con indentación correcta
144. Llamadas a método: `(. obj method arg1 arg2)`
145. Operadores binarios: `(+ (* x x) (* y y))` → `x * x + y * y`

### Capítulo 4.2 — El Macro `pythonic`
- Implementación del macro `pythonic` sobre `python-template`
- Escribir Python con paréntesis y ejecutarlo
- Combinación con `py:run` para evaluación inmediata
- Traducción de flujo de control Lisp a Python idiomático
- Limitaciones frente a Python real: `:=` vs `setq`, closures

**Ejemplos:**
146. Función factorial con `pythonic`
147. Bucle `for` anidado con acumulador
148. `pythonic` para código Python de producción desde Lisp

### Capítulo 4.3 — `defpyfun`: Funciones Python con Captura Lisp
- Definición de funciones Python desde Lisp con `defpyfun`
- Captura de variables Lisp como constantes Python (`CAPTURED_*`)
- Generación del código Python con valores serializados vía `py:repr`
- Mecanismo de inyección: default arguments implícitos
- Casos de uso: cerrar sobre configuraciones, parámetros de modelo

**Ejemplos:**
149. `defpyfun 'scale '(x) con CAPTURED_factor` → función que escala
150. Captura de múltiples variables de entorno Lisp
151. Uso combinado con `let` para cierre léxico
152. Aplicación: función de activación con parámetros capturados

### Capítulo 4.4 — `numpy-fast.lp`: Aceleración Numérica Vectorizada
- `numpy-array`, `numpy-arange`, `numpy-linspace`, `numpy-zeros`
- UFuncs: `numpy-sin`, `numpy-cos`, `numpy-exp`, `numpy-log`
- Reducciones: `numpy-sum`, `numpy-mean`
- Operaciones binarias: `numpy-add`, `numpy-sub`, `numpy-mul`, `numpy-div`
- `numpy-sqrt`, `numpy-neg`, `numpy-pow`
- Lazy initialization: `*numpy-init*`
- `_np_vec` y `_np_ufunc`: helpers Python subyacentes

**Ejemplos:**
153. Crear array NumPy desde datos Lisp: `(numpy-array '(1 2 3 4 5))`
154. Vectorizado: `(numpy-sin arr)` para millón de elementos
155. `numpy-linspace` para dominio de evaluación
156. Operaciones elemento a elemento: `(numpy-add a b)`
157. Reducción con eje: `(numpy-sum arr 0)`
158. `numpy-mean` para promedio vectorizado

### Capítulo 4.5 — `defnp`: Despacho Automático Vectorizado/Escalar
- El macro `defnp`: una función, dos modos de ejecución
- Detección de tipos en runtime: ¿todos los args son `VALUE_PYTHON`?
- Modo vectorizado: delega a NumPy
- Modo escalar: usa aritmética Lisp nativa sin overhead
- Eliminación de la fricción de escribir dos versiones

**Ejemplos:**
159. `defnp vec-distance (x y)`: distancia euclidiana con despacho automático
160. Escalar: `(vec-distance 3 4)` → 5.0 (aritmética Lisp)
161. Vectorizado: `(vec-distance arr1 arr2)` → array de distancias (NumPy)
162. Función mixta con condicional: `if` con `py:python?`

### Capítulo 4.6 — `sympy-bridge.lp`: Cálculo Simbólico
- `sympy-init`: inicialización lazy de SymPy
- `sympy-symbol`: crear símbolos SymPy
- `sympy-expr`: convertir formas aritméticas Lisp a expresiones SymPy
- Mapeo de operadores: `+`→`Add`, `-`→`Mul(-1)`, `*`→`Mul`, `expt`→`Pow`
- `sympy-derive`: derivación simbólica
- `sympy-integrate`: integración simbólica
- `sympy-simplify`: simplificación algebraica
- `sympy-evalf`: evaluación numérica de expresiones simbólicas
- `sympy-latex`: exportación a LaTeX

**Ejemplos:**
163. Crear símbolo: `(sympy-symbol "x")`
164. Construir expresión: `(sympy-expr '(+ (expt x 2) (* 3 x) 1))`
165. Derivar: `(sympy-derive expr x)` → `2*x + 3`
166. Integrar: `(sympy-integrate expr x)` → `x**3/3 + 3*x**2/2 + x`
167. Simplificar: `(sympy-simplify expr)`
168. LaTeX: `(sympy-latex expr)` → `x^{2} + 3 x + 1`
169. Evaluación numérica: `(sympy-evalf expr)` → float

### Capítulo 4.7 — `defmath.lp`: Matemáticas Híbridas Simbólico-Numéricas
- El macro `defmath`: una definición, dos implementaciones
- `nombre-sym`: variante SymPy para manipulación simbólica
- `nombre-num`: variante NumPy para evaluación vectorizada
- `defmath-numexpr`: conversor interno Lisp → NumPy
- Flujo de trabajo híbrido completo: definir → derivar → evaluar → graficar
- Mapeo de operadores Lisp → NumPy y SymPy

**Ejemplos:**
170. `(defmath distance (x y) (sqrt (+ (expt x 2) (expt y 2))))`
171. Derivada parcial con `distance-sym`: `∂/∂x`
172. Evaluación numérica con `distance-num`: vectorizada para 1M de puntos
173. Integral con `sympy-integrate` sobre expresión generada por `defmath`
174. Exportación LaTeX de la expresión generada

### Capítulo 4.8 — `persist.lp`: Checkpoint/Restore de Sesión
- `py:save-session`: serializar variables de `__main__`
- `py:load-session`: restaurar estado desde archivo
- Mecanismo: pickle + codificación hexadecimal
- Exclusión de variables `_privadas`
- Objetos no pickleables: omisión silenciosa
- Lazy initialization: `*persist-init*`

**Ejemplos:**
175. Guardar y restaurar arrays NumPy
176. Persistencia de modelos simples (pesos + bias)
177. Checkpoint de sesión interactiva de trabajo
178. Migración de estado entre procesos LisPy

### Capítulo 4.9 — `continuations.lp`: Puente de Corutinas
- `py:gen-next`: consumir generadores Python desde Lisp
- `py:gen-send`: enviar valores a corutinas Python
- `py:gen-close`: cerrar generadores
- `StopIteration` → `nil`
- Patrón productor-consumidor Lisp ↔ Python

**Ejemplos:**
179. Consumir generador de cuadrados: `(py:gen-next g)` en loop
180. Corutina acumuladora con `py:gen-send`
181. Iteración con `loop` sobre generador Python
182. Pipeline de procesamiento con generadores

### Capítulo 4.10 — `import-hooks.lp`: Transformación de AST
- `install-import-hook`: instalar finder en `sys.meta_path`
- `py:register-ast-hook`: callback Lisp para transformación
- `py:remove-ast-hook`: desactivar el hook
- Serialización del AST Python a listas Lisp
- Deserialización para reconstrucción y compilación
- `_LispyFinder` y `_LispyLoader`: clases Python del mecanismo
- Lista negra de módulos del sistema para evitar recursión

**Ejemplos:**
183. Instalación del hook: `(load "lib/import-hooks.lp")`
184. Registro de callback de transformación
185. Interceptar y modificar AST de un módulo importado
186. Desactivar el hook con `py:remove-ast-hook`

### Capítulo 4.11 — `pandas-bridge.lp`: DataFrames desde Lisp
- Visión general: operaciones de datos tabulares con pandas desde Lisp
- `pandas-init`: inicialización lazy de pandas
- `pandas-dataframe`: crear DataFrame desde lista de listas, hash-table, o alist
- `pandas-read-csv`, `pandas-read-json`: carga de archivos
- `pandas-select`: selección de columnas por nombre o índice
- `pandas-filter`: filtrado de filas con predicado Lisp
- `pandas-groupby`: agrupación con funciones de agregación
- `pandas-join`: join de DataFrames (inner, left, right, outer)
- `pandas-sort`: ordenamiento por columna(s)
- `pandas-describe`, `pandas-head`, `pandas-info`: exploración rápida
- `pandas-to-list`: conversión de DataFrame a listas Lisp
- `pandas-plot`: integración rápida con matplotlib para visualización

**Ejemplos:**
- Crear DataFrame desde alist de registros
- Cargar CSV y filtrar filas con predicado Lisp
- GROUP BY con agregación múltiple (sum, mean, count)
- Join de dos DataFrames y exportación a listas Lisp
- Pipeline completo: cargar → filtrar → agrupar → graficar

---

## Parte V — Meta-Programación ★★★★

### Capítulo 5.1 — `defpyclass.lp`: Clases Sincronizadas Lisp ↔ Python
- `defpyclass`: una definición, dos clases (CLOS + Python)
- Slot `py-instance` como enlace entre instancias
- Función factory `make-<nombre>` con `:initarg`s
- `py:instance`: obtener el objeto Python asociado a un objeto Lisp
- Transferencia de initargs a ambos lados
- Sincronización manual vía `py:%set-attr`
- Limitaciones: sin métodos Python, sin herencia cruzada

**Ejemplos:**
187. `(defpyclass point ((x :initarg :x) (y :initarg :y)) :python-class-name "Point")`
188. `(make-point :x 3 :y 4)` → instancia dual Lisp + Python
189. Lectura desde Lisp: `(slot-value p 'x)` → 3
190. Lectura desde Python: `(py:attr (py:instance p) "x")` → 3
191. Mutación en Python reflejada en Lisp

### Capítulo 5.2 — CLOS ↔ Python: Sincronización Profunda
- Arquitectura de la metaclase `python-sync-class`: capítulo de diseño
- Mapeo de slots CLOS a atributos Python
- Sincronización bidireccional automática
- Métodos Python como slots de clase
- Herencia cruzada: CLOS → Python y viceversa
- Gestión de referencias entre instancias pareadas

**Ejemplos:**
192. Mapeo conceptual de `defclass` a `class` de Python
193. Diagrama de sincronización de slots
194. Ejemplo de herencia cruzada: `vec2d` → `vec3d`

### Capítulo 5.3 — Macros de Transformación Lisp → Python
- Arquitectura de `pythonic` extendido
- Traducción de condicionales: `if`, `cond`, `when`, `unless`
- Traducción de bucles: `dotimes`, `dolist`, `loop` → `for`/`while`
- Traducción de funciones: `defun`, `lambda` → `def`, `lambda`
- Traducción de clases: `defclass` → `class`
- Traducción de `setf`, `setq`, `incf`, `decf`
- Traducción de `aref` → `[]`
- Operadores aritméticos y de comparación
- Limitaciones y edge cases

**Ejemplos:**
195. `pythonic` para algoritmo de ordenamiento
196. `defun` Lisp → `def` Python con tipos
197. Bucle `dotimes` → `for i in range(...)`
198. `setf` en array → asignación Python

### Capítulo 5.4 — Quasiquoting para Plantillas de Código
- Combinación de `write-python-template` con quasiquoting
- Interpolación de variables Lisp: `,var` en plantillas
- Splicing: `,@list` para inserción de secuencias
- Generación de código parametrizado
- Plantillas para funciones, clases, módulos completos

**Ejemplos:**
199. Plantilla de función con nombre y exponente interpolados
200. Generación de módulo Python completo desde quasiquoting

### Capítulo 5.5 — Transformación de AST de Python desde Lisp
- Estructura del AST serializado: `[ClassName, [[field, value], ...]]`
- Marcadores especiales: `__EMPTY_LIST__`, `__NONE__`, `__LIST__`
- Recorrido de AST con funciones Lisp (`mapcar`, `remove-if`, patrones)
- Transformación de bucles `for` en comprehensions
- Inyección de logging en todas las funciones
- Reescritura de imports

**Ejemplos:**
201. Callback que imprime todos los nombres de función en un módulo
202. Transformación de `for` loops en list comprehensions
203. Inyección de `print` al inicio de cada función
204. Reescritura de `import X` → `import X as _X`

### Capítulo 5.6 — Macros de Lectura Personalizadas
- Tabla de dispatch de `#`: `#_`, `#'`, `#(`, `#|`
- Extensión con `set-dispatch-macro-character`
- Creación de sintaxis especializada para dominios
- `#_` y `@` como ejemplos canónicos de extensión del lector
- `@` soporta tanto `:` como `.` como separadores (`@math.sqrt` ≡ `@math:sqrt`)
- Interacción con el parser de paréntesis

**Ejemplos:**
205. `@math:pi` → 3.14159... (sintaxis preferida), `#_math:pi` (forma clásica)
206. `(@math:sqrt 16)` → 4.0, `(#_math:sqrt 16)` → 4.0
207. `@os:path:join("a" "b")` → "a/b"

### Capítulo 5.7 — Sistema de Módulos y Dependencias
- `provide`/`require` en LisPy
- `load` con paths relativos y absolutos
- Dependencias circulares entre librerías
- Auto-carga en `defmath.lp` → `sympy-bridge.lp`
- Inicialización lazy con `*module*-init*`
- Orden de carga de librerías

**Ejemplos:**
208. Dependencia en cadena: `defmath` → `sympy-bridge`
209. `provide` y `require` para módulos personalizados

### Capítulo 5.8 — Depuración Avanzada de Meta-Programas
- `macroexpand-1`, `macroexpand` para depurar macros
- `trace`, `untrace` (si implementado)
- `step` (si implementado)
- Estrategias de depuración para código generado
- Inspección de expansiones intermedias
- Logging en tiempo de macro-expansión

**Ejemplos:**
210. `macroexpand-1` de `defmath`
211. Traza de expansión de `defnp`
212. Inspección de código Python generado antes de `py:run`

---

## Parte VI — Matemáticas Aplicadas ★★★★

### Capítulo 6.1 — El Workbench Matemático Híbrido
- Arquitectura del *Hybrid Symbolic-Numeric Mathematics Workbench*
- Flujo de trabajo: Definir → Derivar → Evaluar → Visualizar
- Componentes: `defmath`, `sympy-bridge`, `numpy-fast`
- Integración con `scipy`, `matplotlib`, `numba`
- Principio: Lisp orquesta, Python calcula

**Ejemplos:**
213. Flujo completo: `defmath` → `sympy-derive` → `numpy-eval` → `matplotlib`
214. Diagrama de arquitectura del workbench

### Capítulo 6.2 — Cálculo Simbólico con SymPy desde Lisp
- Álgebra simbólica: polinomios, funciones trascendentes
- Derivadas parciales y gradientes
- Integrales definidas e indefinidas
- Límites y series de Taylor
- Resolución de ecuaciones algebraicas
- Simplificación algebraica: `expand`, `factor`, `simplify`
- Sustitución simbólica: `subs`
- Expansión en fracciones parciales

**Ejemplos:**
215. Derivada de `sin(x) * exp(x^2)`
216. Integral definida: `∫₀¹ x² dx`
217. Resolver `x² + 3x + 2 = 0`
218. Serie de Taylor de `sin(x)` alrededor de 0
219. Jacobiano de sistema de ecuaciones
220. LaTeX de matriz de masa de robot 2-DOF

### Capítulo 6.3 — Álgebra Lineal Numérica con NumPy
- Creación de matrices y vectores
- Multiplicación de matrices, transpuesta, inversa
- Descomposición: LU, QR, SVD, eigenvalores
- Resolución de sistemas lineales: `numpy.linalg.solve`
- Normas y productos internos
- Broadcasting y operaciones vectorizadas
- Álgebra lineal con `defmath` y `defnp`

**Ejemplos:**
221. Multiplicación de matrices con `numpy` desde Lisp
222. Resolver `Ax = b` con `numpy.linalg.solve`
223. Eigenvalores y eigenvectores
224. Descomposición SVD
225. Regresión lineal con la ecuación normal

### Capítulo 6.4 — Optimización Numérica con SciPy
- `scipy.optimize.minimize`: métodos BFGS, Nelder-Mead, etc.
- `scipy.optimize.curve_fit`: ajuste de curvas no lineal
- `scipy.optimize.root`: búsqueda de raíces
- Programación lineal con `scipy.optimize.linprog`
- Conversión de funciones Lisp a callables Python para optimización

**Ejemplos:**
226. Minimizar función de Rosenbrock: `(1-x)² + 100(y-x²)²`
227. Ajuste de curva exponencial a datos experimentales
228. Búsqueda de raíces de `cos(x) - x`
229. Optimización con restricciones

### Capítulo 6.5 — Integración Numérica y Ecuaciones Diferenciales
- `scipy.integrate.solve_ivp`: problemas de valor inicial
- Métodos: RK45, Radau, BDF, LSODA
- Sistemas de ecuaciones diferenciales acopladas
- Ecuaciones de Lotka-Volterra (predador-presa)
- Integración numérica: `scipy.integrate.quad`
- Transformación de expresiones simbólicas a funciones numéricas

**Ejemplos:**
230. Resolver `y' = -2y`, `y(0) = 1` → `y(t) = exp(-2t)`
231. Lotka-Volterra: dinámica de poblaciones
232. Oscilador armónico amortiguado
233. `sp.lambdify` para convertir SymPy → NumPy

### Capítulo 6.6 — Visualización con Matplotlib
- `matplotlib.pyplot`: plot, scatter, contour, surface
- Personalización: títulos, etiquetas, leyendas, colores
- Exportación a PNG, SVG, PDF
- Gráficos interactivos con `plotly` (opcional)
- Animaciones con `matplotlib.animation`
- Integración con `defmath` para visualización automática

**Ejemplos:**
234. Gráfico de `sin(x)` con `py:import "matplotlib.pyplot"`
235. Diagrama de fase de sistema dinámico
236. Superficie 3D con `plot_surface`
237. Animación de péndulo doble
238. Exportación de gráfico a `robot.png`

### Capítulo 6.7 — Procesamiento de Señales y Datos
- FFT con `numpy.fft`
- Filtrado con `scipy.signal`
- Interpolación con `scipy.interpolate`
- Estadísticas con `numpy` (mean, std, percentile, histogram)
- Ajuste de distribuciones con `scipy.stats`
- Procesamiento de archivos CSV/JSON con Python desde Lisp

**Ejemplos:**
239. FFT de señal senoidal: espectro de frecuencias
240. Filtro pasa-bajos y reconstrucción
241. Histograma y estadísticas descriptivas
242. Lectura de CSV con `csv.reader` y agregación en Lisp

### Capítulo 6.8 — Machine Learning con scikit-learn
- `sklearn-init`: inicialización de scikit-learn
- Preprocesamiento: `StandardScaler`, `LabelEncoder`, `train_test_split`
- Clasificación: `LogisticRegression`, `RandomForestClassifier`, `SVC`
- Regresión: `LinearRegression`, `Ridge`, `Lasso`
- Clustering: `KMeans`, `DBSCAN`
- Métricas: `accuracy_score`, `f1_score`, `mean_squared_error`, `r2_score`
- Pipelines: `Pipeline` y `ColumnTransformer` desde Lisp
- Validación cruzada: `cross_val_score`, `GridSearchCV`
- Conversión de datos Lisp (listas, vectores) a arrays NumPy para sklearn
- Integración con `defmath` y `numpy-fast` para feature engineering
- Exportación de modelos con `pickle` desde Lisp

**Ejemplos:**
- Clasificador Random Forest sobre dataset Iris
- Regresión lineal con features generadas desde `defmath`
- Pipeline de preprocesamiento + clasificación + evaluación
- Grid search para optimización de hiperparámetros
- Clustering K-Means y visualización de clusters
- Evaluación con validación cruzada y reporte de métricas

---

## Parte VII — Ingeniería de Sistemas ★★★★

### Capítulo 7.1 — El Compilador FASL
- Formato FASL: bytecode binario
- `compile-file`: de `.lp` a `.fasl`
- `load` de `.fasl`
- `compile`: compilar funciones individuales
- `disassemble`: inspeccionar bytecode generado
- Flags de compilación: `-c`, `--compile`
- Modos de ejecución: script, compilado, REPL

**Ejemplos:**
243. Compilar archivo `.lp` a `.fasl`
244. Comparación de rendimiento: interpretado vs compilado
245. Carga de `.fasl` con `load`

### Capítulo 7.2 — Entorno de Ejecución y CLI
- Argumentos de línea de comandos: `--version`, `--help`, `--repl`, `-i`, `-c`
- `--venv`: entornos virtuales Python
- Configuración de `PYTHONHOME` y `VIRTUAL_ENV`
- Integración con `sys.path` de Python
- `lisPy.bat` y variables de entorno
- Modos de ejecución: batch vs interactivo

**Ejemplos:**
246. `lisPy --version` → información de build
247. `lisPy -i script.lp` → cargar y entrar al REPL
248. `lisPy --venv mi-entorno script.lp` → usar venv aislado

### Capítulo 7.3 — Gestión de Paquetes Python con `:pip`
- `:pip install`, `:pip list`, `:pip show`, `:pip uninstall`
- Mecanismo: invocación de `pip._internal.cli.main.main()`
- Captura de stdout/stderr con `io.StringIO()`
- Sockets bloqueantes para HTTPS en Windows
- Subprocesos: `lispy.exe` actuando como intérprete Python
- Paquetes pre-instalados: pip, setuptools, meson, ninja
- Limitaciones: wheels para Python 3.14, permisos de admin

**Ejemplos:**
249. `:pip install numpy` desde el REPL
250. `:pip list` para ver paquetes instalados
251. `:pip show requests` para información detallada

### Capítulo 7.4 — Embedding y Distribución
- Estructura de directorios de distribución
- Linking estático de CPython 3.14
- Dependencias: OpenSSL, zlib, sin DLLs externas
- Build con CMake + Ninja / GNU Make
- NSIS installer para Windows
- `lispy.rc`: recursos de Windows (icono, versión)
- Single-file deployment

**Ejemplos:**
252. Build con `cmake .. -DLISPY_PYTHON=ON && ninja`
253. Build sin Python: `make python=0`
254. Distribución portable: todo en un directorio

### Capítulo 7.5 — Pruebas y Metodología de Desarrollo
- `quick_test.lp`: smoke test de condiciones y restarts
- Problemas 001-120 como test suite de regresión
- `BUGS.md`: 68 bugs documentados con reproducción y solución
- Categorías de bugs y severidad
- Estrategia de test: un problema, un archivo `.lp`
- Compilación condicional y verificación de Python

**Ejemplos:**
255. `quick_test.lp`: verificación de `restart-case` + `handler-bind`
256. Test de `BUG-001`: EQL specializer (corregido)
257. Ejecutar suite: `for %f in (problem_*.lp) do lispy.exe %f`

### Capítulo 7.6 — Integración Continua y Release
- Workflow de build: CMake → Ninja → Test → NSIS
- Versionado semántico
- CHANGELOG y releases
- Distribución: binario + libs + docs
- Skills de build: `SKILLS.md`

**Ejemplos:**
258. Script de build automatizado
259. Verificación de build con `lispy_test.exe`

### Capítulo 7.7 — Seguridad y Sandboxing
- Modelo de amenazas: ¿qué puede ejecutar `py:run` y `py:call`?
- Riesgos de inyección de código: validación de strings antes de `py:run`
- Aislamiento de proceso: `subprocess` para ejecución externa segura
- Entornos virtuales como mecanismo de aislamiento (`--venv`)
- Restricción de imports: whitelist de módulos en `sys.modules`
- Sandboxing con `RestrictedPython` para código no confiable
- Principio de mínimo privilegio en callbacks Lisp ↔ Python
- Auditoría de operaciones: logging de todas las llamadas al puente
- Límites de recursos: timeout en `py:run`, memory limits
- Advertencia: no ejecutar código no confiable sin sandboxing

**Ejemplos:**
- Validación de input antes de `py:run`
- Sandbox con `--venv` aislado sin acceso a red
- Timeout en ejecución de código Python arbitrario
- Logging de todas las llamadas `py:call` con timestamp
- Whitelist de módulos permitidos en `py:import`

---

## Parte VIII — Estudios de Caso ★★★★

### Capítulo 8.1 — Dinámica de Robot 2-DOF
- Planteamiento del problema: brazo robótico de 2 eslabones
- Derivación simbólica de ecuaciones de Lagrange con SymPy
- Matriz de Masa M(q), Matriz de Coriolis C(q,q̇), Vector de Gravedad G(q)
- Conversión a funciones numéricas con `sp.lambdify`
- Integración numérica con `scipy.integrate.solve_ivp`
- Controlador PD para seguimiento de trayectoria
- Visualización con matplotlib

**Ejemplos:**
260. Derivación completa de M, C, G con SymPy desde LisPy
261. Simulación de 10 segundos con RK45
262. Gráfico de ángulos θ₁(t), θ₂(t)
263. Animación del movimiento del brazo

### Capítulo 8.2 — Motor de Trading Algorítmico
- Modelo de órdenes: compra, venta, límite, mercado
- CLOS para modelar instrumentos financieros
- Estrategias de trading con `defgeneric`/`defmethod`
- Backtesting con datos históricos
- Cálculo de métricas: Sharpe ratio, drawdown, volatilidad
- Integridad con Python para feeds de mercado (si `requests`)

**Ejemplos:**
264. Clase `order` con precio, cantidad, timestamp
265. Método `execute` con EQL specializer por tipo de orden
266. Pipeline de backtesting
267. Cálculo de Sharpe ratio con NumPy desde Lisp

### Capítulo 8.3 — Procesador de Imágenes Interactivo
- Carga de imágenes con `PIL`/`Pillow` desde Python
- Manipulación de píxeles con NumPy
- Filtros: blur, sharpen, edge detection (Sobel, Canny)
- Transformaciones: rotación, escala, recorte
- Visualización con matplotlib
- Pipeline de procesamiento con generadores Python

**Ejemplos:**
268. Cargar imagen: `(let ((img (py:call (py:attr PIL "Image") "open" "foto.jpg"))) ...)`
269. Aplicar filtro Sobel con `scipy.ndimage`
270. Redimensionar y guardar
271. Pipeline generador: `yield` de etapas de procesamiento

### Capítulo 8.4 — Chatbot con Personalidad
- Procesamiento de lenguaje natural con NLTK/spaCy desde Python
- Árboles de decisión para flujo de conversación
- Hash tables para memoria de sesión
- Macros para definir patrones de respuesta
- Integración con APIs externas vía `requests`

**Ejemplos:**
272. Motor de respuestas basado en patrones con alists
273. Análisis de sentimiento con Python desde Lisp
274. Chatbot multi-turno con estado en hash table
275. Integración con API de clima

### Capítulo 8.5 — Motor de Búsqueda y Recomendación
- Índice invertido con hash tables
- TF-IDF con NumPy desde Lisp
- Similitud coseno entre documentos
- Filtrado colaborativo: similitud entre usuarios
- `sort` con `:key` para ranking
- Persistencia del índice con `persist.lp`

**Ejemplos:**
276. Construcción de índice invertido
277. Búsqueda: `(search "machine learning" index)`
278. Recomendación: usuarios similares con similitud coseno
279. Persistencia del índice en checkpoint

### Capítulo 8.6 — DSL para Análisis de Datos
- Lenguaje de dominio específico para consultas de datos
- Macros de lectura para sintaxis SQL-like
- Traducción a `py:run` con pandas/NumPy
- Agregaciones, filtros, joins
- Visualización automática
- Extensibilidad: nuevos comandos como macros

**Ejemplos:**
280. `(query (select :name :age) (from users) (where (> age 18)))`
281. Traducción a `pandas` y ejecución
282. Agregación GROUP BY con `loop` y hash tables
283. Join de dos datasets con hash table

### Capítulo 8.7 — Migración de Proyecto Python Existente a Híbrido
- Estrategia incremental: reemplazar módulo por módulo sin romper funcionalidad
- Identificación de candidatos: ¿qué partes se benefician más de Lisp?
- Fase 1: envolver funciones Python existentes con `defpyfun`
- Fase 2: reescribir lógica de negocio en Lisp puro
- Fase 3: reemplazar generación de código con macros Lisp
- Fase 4: migrar configuración y DSLs a S-expressions
- Coexistencia: tests que validan ambas implementaciones en paralelo
- Medición de beneficios: líneas de código, mantenibilidad, rendimiento
- Estudio de caso real: migración de script de análisis de datos (~200 líneas Python → ~80 líneas Lisp + ~20 líneas Python)
- Lecciones aprendidas y anti-patrones

**Ejemplos:**
- Migración de función de preprocesamiento de datos paso a paso
- Reemplazo de `argparse` por S-expressions de configuración
- Generación de reportes: de `f-strings` a `format` con macros
- Coexistencia: test suite que corre contra ambas implementaciones

---

## Parte IX — Apéndices

### Apéndice A — Referencia Rápida de Common Lisp en LisPy
- Tabla completa de funciones built-in por categoría
- Sintaxis de formas especiales
- Operadores de comparación y aritméticos
- Funciones de secuencia
- Funciones de hash table
- Macros y formas especiales
- Sistema de condiciones
- Cada entrada incluye referencia al capítulo donde se explica en detalle

### Apéndice B — Referencia Rápida de la API Python (`py:`)
- Tabla completa de símbolos `py:` con firma y descripción
- Funciones de conversión de tipos
- Builtins para depuración
- Funciones de iteración y generadores
- Serialización y persistencia
- Registro de callbacks y hooks
- Librerías `lib/`: funciones exportadas por cada módulo

### Apéndice C — Tabla de Conversión de Tipos Lisp ↔ Python
- Lisp → Python: todos los tipos con ejemplos
- Python → Lisp: todos los tipos con ejemplos
- Tipos no convertibles y workarounds
- Notas sobre precisión y redondeo
- Véase también: Capítulo 3.2 para la semántica de conversión en tiempo de ejecución

### Apéndice D — Tabla de Mapeo de Operadores Lisp ↔ SymPy
- `+` → `Add`, `-` → `Add`+`Mul(-1)`, `*` → `Mul`
- `/` → `Pow(arg, -1)`, `expt` → `Pow`
- `sqrt`, `sin`, `cos`, `log`, `exp` → funciones SymPy
- Mapeo inverso: expresiones SymPy → S-expressions Lisp

### Apéndice E — Diagnóstico de Errores Comunes
- 40+ mensajes de error con causa y solución
- Errores de tipo en la frontera Lisp↔Python
- Errores de importación de módulos
- Errores de conversión de tipos no soportados
- Errores del lector y paquetes
- Errores de rendimiento (overhead de `py:call`)

### Apéndice F — Glosario de Términos
- Términos de Common Lisp: cons, car, cdr, atom, s-expression, closure...
- Términos de CLOS: clase, slot, generic function, method combination...
- Términos de Python: PyObject, GIL, pickle, AST, meta_path, coroutine...
- Términos de LisPy: VALUE_PYTHON, `py:`, `#_`, `@`, `defmath`, checkpoint...

### Apéndice G — Índice de Todos los Ejemplos
- Listado completo de los 390+ ejemplos numerados
- Referencia cruzada por capítulo
- Clasificación por nivel de dificultad
- Clasificación por tema (Lisp puro, Python FFI, híbrido, matemáticas...)

### Apéndice H — Bibliografía y Referencias
- ANSI Common Lisp Standard (HyperSpec)
- Common Lisp the Language, 2nd Edition (Steele)
- Python 3.14 Documentation
- NumPy, SciPy, SymPy, Matplotlib Documentation
- Competitive Programmer's Handbook (Antti Laaksonen)
- Libros de la carpeta `docs/`: referencias completas

---

## Parte X — Cómo Escribir Nuevas Librerías `lib/` ★★★☆

### Capítulo 10.1 — Guía para Crear Librerías en `lib/`
- Estructura de un archivo `.lp`: encabezado, dependencias, exports
- Convenciones de nomenclatura: prefijos, extensión `.lp`, snake-case
- Patrón `*<modulo>-init*` para inicialización lazy
- Gestión de dependencias: `(load "lib/dependencia.lp")` al inicio del archivo
- API pública: qué exportar y documentar, qué mantener interno
- Documentación: formato de docstrings y comentarios de cabecera
- Ejemplo guiado: construcción de `lib/mi-libreria.lp` paso a paso
- Integración con el sistema `provide`/`require`
- Testing de librerías: patrón `(when (find-package :py) ...)` para pruebas condicionales
- Registro de la librería en el índice del handbook
- Patrones comunes: `defmath`, `defnp`, `defpyclass`, `pythonic`, `defpyfun`
- Publicación y distribución: empaquetado para compartir con la comunidad

**Ejemplos:**
- Esqueleto mínimo de librería `.lp` con inicialización lazy
- Librería `lib/json-utils.lp`: parseo y generación de JSON vía Python
- Librería `lib/string-metrics.lp`: distancia de Levenshtein, Jaccard
- Inicialización lazy con `*json-utils-init*`
- Test condicional con `(when (find-package :py) ...)`

---

## Parte XI — Competitive Programming Problems

> **Referencia completa:** `docs/problems/PROBLEMS.md` (2679 líneas, documentación detallada con soluciones, bugs y workarounds)
>
> **Archivos fuente:** `docs/problems/problem_*.lp` (120 problemas)

El directorio `docs/problems/` contiene 120 problemas de programación competitiva que funcionan como test suite integral de LisPy. Cada problema ejercita combinaciones específicas de características del lenguaje, desde fundamentos hasta bugs de implementación. Los problemas 001–100 siguen el formato de desafíos de Codeforces; los problemas 101–120 son pruebas sistemáticas del runtime que han descubierto y documentado más de 69 bugs.

### Índice por Categoría

| # | Categoría | Problemas |
|---|-----------|-----------|
| 1 | Arithmetic & Numbers | 001–009 |
| 2 | Lists & Cons Cells | 010–018 |
| 3 | Sequences & Vectors | 019–025 |
| 4 | Strings & Characters | 026–032 |
| 5 | Hash Tables & Sets | 033–038 |
| 6 | Macros & Metaprogramming | 039–047 |
| 7 | CLOS & Object-Oriented | 048–055 |
| 8 | Condition System | 056–062 |
| 9 | Iteration & Control Flow | 063–070 |
| 10 | File I/O & Streams | 071–076 |
| 11 | Python FFI Bridge | 077–085 |
| 12 | Packages & Symbols | 086–090 |
| 13 | Compilation & Performance | 091–095 |
| 14 | Miscellaneous | 096–100 |

### Problemas Avanzados (101–120)

Estos problemas constituyen la suite de integración profunda del runtime. Cada uno prueba constructos específicos de ANSI CL, CLOS, y el puente Python, documentando bugs encontrados y workarounds.

| # | Archivo | Título | Conceptos Clave | Bugs |
|---|---------|--------|-----------------|------|
| 101 | `problem_101.lp` | Disjoint Set Union | CLOS, arrays, path compression, union by rank | — |
| 102 | `problem_102.lp` | Middleware Pipeline | `:around`/`:before`/`:after`, `call-next-method`, `with-slots` | BUG-013 |
| 103 | `problem_103.lp` | Convex Hull (Graham Scan) | `sort`/`reduce` with `:key`, vectores, geometría, `loop` | — |
| 104 | `problem_104.lp` | Weighted Task Scheduler | Greedy, `sort`/`reduce`/`find` with `:key`, `values`/`multiple-value-bind` | — |
| 105 | `problem_105.lp` | BUG-013 Verification | Método `:around`, combinación estándar, CLOS dispatch | BUG-013 |
| 106 | `problem_106.lp` | Instrumented Stack Machine | Ciclo de vida CLOS, `&optional`/`&rest` en `defmethod`, `ecase`, Python `math`, `vector-push-extend` | BUG-015–019 |
| 107 | `problem_107.lp` | Collection Analytics Engine | 11 operaciones vía EQL specializers, `sort`/`find`/`reduce` con `:key` en `defmethod`, `multiple-value-bind`, Python FFI | BUG-020–022 |
| 108 | `problem_108.lp` | Delegating Calculator | `call-next-method` con args, `psetf`/`rotatef`/`shiftf`, `&aux`, `no-next-method`, `no-applicable-method` | BUG-023 |
| 109 | `problem_109.lp` + `_debug.lp` | Cryptographic Audit System | `progv`, `ldb`/`dpb`, `nth-value`, `multiple-value-call`, `row-major-aref`, `slot-makunbound`, `reinitialize-instance`, Python `hashlib` | BUG-025–027 |
| 110 | `problem_110.lp` | Reinitialization Protocol Bridge | `update-instance-for-redefined-class`, Python `struct`, serialización delta, `class-of`, `find-class` | BUG-025/026/027 |
| 111 | `problem_111.lp` | Polymorphic Expression Evaluator | Jerarquía CLOS (`poly`, `exponential`, `trig`), Python `math`, `tagbody`/`go` en `defmethod`, integración trapezoidal adaptativa | BUG-028–033 |
| 112 | `problem_112.lp` + `_diag.lp` | Algorithmic Trading Engine | 36 constructos dentro de `defmethod`, DP con matrices 2D, Python `statistics`, `case`/`do*`/`prog`/`cond`/`restart-case` | BUG-034–045 |
| 113 | `problem_113.lp` | Symbolic Property Graph | Herencia múltiple (diamante), `get`/`remprop`/`symbol-plist`, `char-code`/`code-char`, `make-random-state`, Dijkstra | — |
| 114 | `problem_114.lp` | Metaprogramming & Introspection | `class-of`/`type-of`/`subtypep`/`find-class`, `format` `~:{`/`~<`/`~[`, `call-next-method` en `:before`, `array-rank` | BUG-046–047 |
| 115 | `problem_115.lp` + `_b.lp` | List Ops & Reader/Printer Meta | `acons`/`pairlis`/`rassoc`, `nconc`/`nreconc`, `*print-escape*`, `*read-base*`, `change-class`, `complement`/`constantly` | BUG-048–054 |
| 116 | `problem_116.lp` | Reader Macro DSL | `set-macro-character`, `set-dispatch-macro-character`, `read-delimited-list`, `*read-eval*`, `*read-suppress*` | BUG-055 |
| 117 | `problem_117.lp` | CLOS MOP Deep Probe | `class-slots`/`class-direct-slots`, `generic-function-methods`, `find-method`/`add-method`/`remove-method`, `ensure-generic-function` | BUG-056–063 |
| 118 | `problem_118.lp` + `_a.lp` + `_minimal.lp` | Stream Composition & Restarts | `make-broadcast-stream`/`concatenated`/`echo`/`two-way`/`synonym`, `compute-restarts`, `find-restart`, `invoke-restart`, `make-condition`, `signal` | BUG-064–067 |
| 119 | `problem_119.lp` | Dynamic Method Protocol | `find-method`/`add-method`/`remove-method`, EQL specializers, `:around`/`:before`/`:after`, `fdefinition` vs `symbol-function` | BUG-056 |
| 120 | `problem_120.lp` | Stdlib Audit & Precision Pipeline | `make-sequence`/`fill`/`replace`/`map-into`/`mismatch`/`stable-sort`/`merge`, `defsetf`/`define-setf-expander`, `apropos`, `directory`, Python `decimal` | BUG-068–069 |

### Resumen de Bugs por Componente

| Componente | Bugs | Estado |
|-----------|------|--------|
| CLOS dispatch (`:around`/`:before`/`:after`) | BUG-013, 016 | ✅ Fixed |
| `defmethod`: `&allow-other-keys`, `with-slots` | BUG-015, 017, 028–045 | ✅ Fixed |
| `handler-case`/`handler-bind` en `defmethod` | BUG-018, 019 | ✅ Fixed |
| `multiple-value-bind` en `defmethod` | BUG-020, 022 | ✅ Fixed |
| Puente Python (`rational → float`, `bytes` round-trip) | BUG-021, 026 | ✅ Fixed |
| `call-next-method` con argumentos explícitos | BUG-023 | ✅ Fixed |
| `reinitialize-instance` / `shared-initialize` | BUG-025, 027 | ✅ Fixed |
| Especializadores de tipo built-in | BUG-033 | Workaround |
| `class-of`/`find-class` en tipos built-in | BUG-046, 047 | ⚠️ Limitation |
| Funciones ANSI CL faltantes | BUG-048–054, 057–063 | 📝 Missing |
| `read-delimited-list` con delimitadores no-`)` | BUG-055 | ❌ Open |
| Streams compuestos (`echo`, `synonym`) | BUG-064, 065 | ❌ Open |
| `read-char-no-hang` EOF semantics | BUG-066 | ❌ Open |
| `restart-bind` + `handler-bind` | BUG-067 | ❌ Open |
| `mismatch :from-end` off-by-one | BUG-068 | ❌ Open |
| `directory` en Windows | BUG-069 | ❌ Open |

### Ejecución

```sh
# Problemas básicos (001–100)
lispy.exe problem_001.lp

# Problemas avanzados (101–120)
cd docs/problems
lispy.exe problem_120.lp         # Test individual
lispy.exe problem_112.lp          # Trading engine
lispy.exe problem_112_diag.lp     # Diagnostic pass

# Suite completa (todos los problemas con Python)
for %f in (problem_*.lp) do lispy.exe %f
```

### Documentación Relacionada

| Archivo | Descripción |
|---------|-------------|
| `docs/problems/PROBLEMS.md` | Documentación completa de los 120 problemas con soluciones, bugs y workarounds |
| `docs/problems/BUGS.md` | Catálogo de bugs encontrados (68+ documentados) |
| `docs/problems/problem_NNN.lp` | Código fuente de cada problema |

---

## Resumen Estadístico

| Métrica | Cantidad |
|---------|----------|
| Partes | 11 + Preludio |
| Capítulos | 80 + 1 (Problemas) |
| Ejemplos numerados | 390+ |
| Problemas de programación competitiva | 120 |
| Páginas estimadas | ~900-1300 |
| Niveles de dificultad | 4 (★ a ★★★★) |
| Rutas de aprendizaje | 5 |
| Bugs documentados | 69+ (en PROBLEMS.md) |

---

*"LisPy Handbook — The Definitive Guide" — Índice Maestro v2.0 — Junio 2026*
