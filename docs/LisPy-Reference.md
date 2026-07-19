# LisPy + Python: Documentación de Interoperabilidad

## Tabla de Contenidos

1. [Visión General](#1-visión-general)
2. [El Paquete `PY`](#2-el-paquete-py)
3. [Conversión de Tipos](#3-conversión-de-tipos)
4. [API de Referencia](#4-api-de-referencia)
5. [Resolución Transparente `py:`](#5-resolución-transparente-py)
6. [Macros de Lectura `#_` y `@`](#6-macros-de-lectura-_y-)
7. [Modos de Uso: Lisp Nativo vs Python Delegado](#7-modos-de-uso-lisp-nativo-vs-python-delegado)
8. [Modelo de Memoria y Referencias](#8-modelo-de-memoria-y-referencias)
9. [Manejo de Errores](#9-manejo-de-errores)
10. [Consideraciones de Rendimiento](#10-consideraciones-de-rendimiento)
11. [Limitaciones](#11-limitaciones)
12. [Ejemplos Completos](#12-ejemplos-completos)
13. [Apéndice: Tabla de Tipos](#13-apéndice-tabla-de-tipos)
14. [Apéndice: Diagnóstico de Errores Comunes](#14-apéndice-diagnóstico-de-errores-comunes)
15. [Apéndice: Arquitectura Interna](#15-apéndice-arquitectura-interna)
16. [Apéndice: Depuración](#16-apéndice-depuración)
17. [Apéndice: Librerías Lisp (`lib/`)](#17-apéndice-librerías-lisp-lib)
18. [REPL Interactivo](#18-repl-interactivo)
19. [Gestión de Paquetes Python con `:pip`](#19-gestión-de-paquetes-python-con-pip)
20. [Patrones Avanzados: Código Python desde Lisp](#20-patrones-avanzados-código-python-desde-lisp)
21. [Matemáticas Híbridas: Simbólico + Numérico](#21-matemáticas-híbridas-simbólico--numérico)
22. [Puente de Corutinas: Lisp ↔ Python](#22-puente-de-corutinas-lisp--python)
23. [Transformación de AST en Importaciones](#23-transformación-de-ast-en-importaciones)
24. [Persistencia de Sesión: Checkpoint/Restore](#24-persistencia-de-sesión-checkpointrestore)
25. [Clases Sincronizadas Lisp ↔ Python](#25-clases-sincronizadas-lisp--python)

---

## 1. Visión General

LisPy integra **CPython 3.14** como runtime embebido, permitiendo llamar funciones
Python, importar módulos y manipular objetos Python directamente desde Common
Lisp con sintaxis Lisp nativa.

La integración se basa en tres pilares:

| Pilar | Mecanismo |
|-------|-----------|
| **Paquete `PY`** | Namespace Lisp que mapea al runtime Python |
| **`VALUE_PYTHON`** | Tipo de valor Lisp que envuelve un `PyObject*` |
| **Conversión automática** | Traducción bidireccional Lisp ↔ Python bajo demanda |

La implementación es **condicional**: si CPython 3 no está disponible al compilar,
todo el soporte Python se omite mediante la guarda `#ifdef LISPY_HAVE_PYTHON`.

```lisp
;; Ejemplo canónico de uso
(let ((math (py:import "math")))
  (py:call (py:attr math "sqrt") 16))   ;; => 4

;; Acceso transparente a builtins Python
(py:print "Hola desde Python")           ;; => "Hola desde Python"
(py:abs -42)                              ;; => 42
```

---

## 2. El Paquete `PY`

### 2.1 Creación y Registro

El paquete `PYTHON` (nickname `PY`) se crea automáticamente en `interp_init()`
al iniciar LisPy si la compilación incluye Python. Es un paquete Common Lisp
estándar registrado en la lista de paquetes del intérprete:

```lisp
(find-package :py)     ;; => #<PACKAGE PYTHON>
(find-package :python) ;; => #<PACKAGE PYTHON>
```
```c
// Código de creación (lispy.c:65891-65895)
it->python_package = make_package_value("PYTHON");
interp_register_package(it, it->python_package, tmp_err, sizeof(tmp_err));
strvec_push_copy(&it->python_package->as.package.nicknames, "PY");
it->python_module_cache = make_hash_table_value(HASH_TEST_EQUAL, 32, 1.5, 1.0);
```

El paquete se registra junto con `COMMON-LISP`, `KEYWORD`, `CL-USER` y
`LISPY-TEMP`. La caché de módulos Python es una hash-table Lisp estándar con
test `equal` (comparación de strings), capacidad inicial 32, factor de
crecimiento 1.5 y umbral de rehash 1.0.

### 2.2 Resolución de Símbolos

Cuando el lector encuentra `py:xxx`, resuelve la referencia de la siguiente manera:

1. Busca `xxx` en la tabla de símbolos del paquete `PYTHON` (búsqueda case-insensitive)
2. Si no existe, **auto-interna** el símbolo (no requiere pre-registro)
3. Si existe pero no es externo, lo trata como accesible (el paquete `PYTHON` es especial)

```
py:print    → símbolo "PRINT" en PYTHON (auto-internado)
py:import   → símbolo "IMPORT" en PYTHON (pre-registrado como builtin)
py:anything → símbolo "ANYTHING" en PYTHON (cualquier nombre es válido)
```

Esta es la diferencia fundamental con otros paquetes Lisp: `PYTHON` nunca rechaza un
símbolo por no ser externo.

### 2.3 Símbolos Pre-registrados

Los siguientes símbolos tienen implementaciones built-in en C y están siempre disponibles:

| Símbolo | Función | Descripción |
|---------|---------|-------------|
| `py:import` | `importar módulo` | Importa un módulo Python por nombre |
| `py:call` | `llamar función` | Invoca un callable Python con argumentos |
| `py:attr` | `acceder atributo` | Obtiene un atributo de objeto Python |
| `py:getitem` | `indexar objeto` | `obj[key]` en Python |
| `py:%set-attr` | `asignar atributo` | `setattr(obj, name, value)` en Python |
| `py:%set-item` | `asignar índice` | `obj[key] = value` en Python |
| `py:%chain` | `encadenar atributos` | Destino interno de las macros `#_` y `@` |
| `py:help` | `ayuda` | `help(obj)` de Python |
| `py:dir` | `listar atributos` | `dir(obj)` de Python |
| `py:type` | `tipo` | `type(obj)` de Python |
| `py:repr` | `representación` | `repr(obj)` de Python |
| `py:str` | `string` | `str(obj)` de Python |
| `py:len` | `longitud` | `len(obj)` de Python |
| `py:iter` | `iterador` | `iter(obj)` de Python |
| `py:next` | `siguiente` | `next(obj)` de Python |
| `py:run` | `ejecutar código` | Ejecuta string como código Python |
| `py:->lisp` | `a Lisp` | Convierte objeto Python a Lisp puro |
| `py:->python` | `a Python` | Convierte valor Lisp a objeto Python |
| `py:callable?` | `es callable` | Verifica si es invocable |
| `py:python?` | `es Python` | Verifica si es VALUE_PYTHON |
| `py:call-kw` | `llamar con kwargs` | Invoca callable Python con argumentos keyword |
| `py:last-traceback` | `último traceback` | Lista de frames del último error Python |
| `py:frame-locals` | `locales de frame` | Hash-table con variables locales de un frame |
| `py:frame-globals` | `globales de frame` | Hash-table con variables globales de un frame |
| `py:frame-eval` | `evaluar en frame` | Evalúa expresión Python en contexto de un frame |
| `py:register-callback` | `registrar callback` | Expone función Lisp como callback Python |
| `py:load-hybrid` | `cargar híbrido` | Carga archivo .lp con sintaxis híbrida Lisp/Python |
| `py:pickle-dumps` | `serializar pickle` | Serializa objeto Python a hex string vía pickle |
| `py:pickle-loads` | `deserializar pickle` | Reconstruye objeto Python desde hex string pickle |

**Nota sobre generadores:** `py:gen-next`, `py:gen-send` y `py:gen-close` no son
builtins en C. Son funciones Lisp proporcionadas por la librería
`lib/continuations.lp` (ver [Puente de Corutinas](#416-puente-de-corutinas-lisp--python-py-gen-next-y-py-gen-send)).

**Nota:** Los símbolos con prefijo `%` (como `%SET-ATTR`, `%SET-ITEM`, `%CHAIN`)
están registrados como builtins pero **no** se resuelven de forma transparente
vía `py:xxx`. Son funciones internas usadas por el lector (macro `#_` y `@`) o
disponibles para uso explícito cuando se conoce su nombre completo.

### 2.4 Auto-internado y el Lector Especial

El lector de LisPy tiene lógica especial para el paquete PYTHON en dos puntos:

**Auto-internado** (lispy.c:4639-4656): Cuando el lector busca un símbolo en
PYTHON que no existe, lo crea automáticamente (interna) en lugar de señalar
error:

```c
if (internalp || pkg == it->python_package) {
    Value *interned = NULL;
    if (!package_intern_name(it, pkg, name, &interned, NULL, err, errsz)) return -1;
    if (out_symbol != NULL) *out_symbol = interned;
    return 1;
}
```

**Acceso a no-externos** (mismo bloque): Cuando un símbolo existe pero no es
externo, los demás paquetes lo rechazan. PYTHUN lo permite:

```c
if (!internalp && !entry->externalp) {
    if (pkg == it->python_package) {
        if (out_symbol != NULL) *out_symbol = entry->symbol;
        return 1;
    }
}
```

Esto significa que `py:cualquier_cosa` siempre es una expresión Lisp válida (como
símbolo). La validez semántica se determina en tiempo de evaluación, no de lectura.

---

## 3. Conversión de Tipos

La conversión entre tipos Lisp y Python ocurre en tres momentos:

1. **Argumentos a `py:call`**: Los argumentos Lisp se convierten a Python automáticamente
2. **Resultado de `py:call`/`py:attr`**: Se convierte de Python a Lisp según la tabla
3. **Conversión explícita**: `py:->lisp` y `py:->python` para control manual

### 3.1 Tabla de Conversión: Lisp → Python

| Tipo Lisp | Tipo Python | Notas |
|-----------|-------------|-------|
| `nil` | `None` | El Lisp `nil` mapea a Python `None` |
| `t` (booleano) | `True` | Cualquier valor no-nil se convierte a `True` |
| `nil` (booleano) | `False` | `nil` en contexto booleano es `False` |
| Entero (bigint) | `int` | Precisión arbitraria, vía `PyLong_FromString` |
| Flotante | `float` | `double` de C → `float` de Python |
| String | `str` | UTF-8 |
| Carácter | `str` (longitud 1) | |
| Símbolo | `str` | Nombre del símbolo (case-sensitive) |
| Lista (cons) | `list` | `proper_list_to_array` + conversión recursiva |
| Lista (array) | `list` | Conversión recursiva de elementos |
| Vector | `list` | Cada elemento se convierte recursivamente |
| Hash-table | `dict` | Claves y valores convertidos recursivamente |
| Complejo | `complex` | `PyComplex_FromDoubles(real, imag)` |
| `VALUE_PYTHON` | `PyObject*` original | Sin conversión (se incrementa refcount) |

**Tipos NO convertibles**: `VALUE_RATIO` (fracciones), `VALUE_PATHNAME` → error
en tiempo de ejecución.

### 3.2 Tabla de Conversión: Python → Lisp

| Tipo Python | Tipo Lisp | Notas |
|-------------|-----------|-------|
| `None` | `nil` | |
| `True` | `t` | |
| `False` | `nil` | En Common Lisp, `nil` y `falso` son lo mismo |
| `int` | Entero (bigint) | Precisión arbitraria preservada vía `PyObject_Str` → `bigint_from_decimal` |
| `float` | Flotante | |
| `complex` | Complejo | `PyComplex_AsCComplex` → partes real/imag |
| `str` | String | UTF-8 |
| `bytes` | Vector de enteros | Cada byte → entero 0-255 |
| `list` | Lista Lisp | `VALUE_LIST` (array-backed), conversión recursiva |
| `tuple` | Lista Lisp | Mismo tratamiento que `list` |
| `dict` | Hash-table | Test de igualdad `equal`; conversión recursiva k/v |
| `callable` | `VALUE_PYTHON` | Se mantiene como objeto Python |
| `type` (clase) | `VALUE_PYTHON` | Ídem |
| `module` | `VALUE_PYTHON` | Ídem |
| `set` / `frozenset` | `VALUE_PYTHON` | Sin conversión automática a lista |
| Otros objetos | `VALUE_PYTHON` | Ídem |

**Nota sobre `set`/`frozenset`:** No existe un caso explícito `PySet_Check` en
`python_to_lisp`. Estos tipos caen en el caso genérico y permanecen como
`VALUE_PYTHON`. Para convertirlos a lista Lisp, usa `(py:->lisp (py:call
(py:attr (py:import "builtins") "list") py_set))`.

### 3.3 Regla de Oro de la Conversión

> **La conversión es lazy y parcial.** Solo los tipos con equivalente directo se
> convierten automáticamente. Los objetos Python sin equivalente Lisp (funciones,
> clases, módulos) permanecen como `VALUE_PYTHON` y se manipulan a través de la API
> `py:`. Para convertir explícitamente, usa `py:->lisp` y `py:->python`.

```lisp
;; Retorno de py:call: conversión automática parcial
(py:call (py:attr (py:import "math") "sqrt") 16)
;; => 4.0  (float de Python → VALUE_FLOAT de Lisp)

;; Objeto Python que no tiene equivalente Lisp
(py:import "math")
;; => #<PYTHON-OBJECT 0x...>  (VALUE_PYTHON)

;; Convertir explícitamente
(py:->lisp (py:->python '(1 2 3)))
;; => (1 2 3)  (lista Lisp pura)
```

### 3.4 Nota sobre Listas

Las listas creadas por `python_to_lisp` (conversión automática) son de tipo
`VALUE_LIST` (array-backed). Esto significa que ciertas operaciones que esperan
`VALUE_CONS` (como `car`/`cdr` en algunos contextos) pueden fallar. Se recomienda
usar `nth`, `first`, `second` y `length` para acceder a listas provenientes de Python.

```lisp
;; Correcto: usar nth con listas convertidas de Python
(let ((py-list (py:attr (py:import "__main__") "some_list")))
  (nth 0 py-list))  ;; ✓

;; Puede fallar con listas VALUE_LIST
;; (car py-list)     ;; ✗ "car expects a list" en algunos casos
```

### 3.5 Semántica de Referencias durante la Conversión

Cada conversión cruzando la frontera Lisp↔Python gestiona correctamente los
refcounts de `PyObject*`:

- **Lisp → Python**: Objetos Python creados desde Lisp (`PyLong_FromString`,
  `PyFloat_FromDouble`, `PyUnicode_FromString`, `PyList_New`, etc.) se retornan
  como **new references** — el llamador es responsable de `Py_DECREF`.
- **`VALUE_PYTHON` → Python**: Se llama `Py_INCREF` porque el Lisp retiene su
  propia referencia. El Python callable recibe una referencia propia.
- **Python → Lisp**: Cuando un `PyObject*` se envuelve como `VALUE_PYTHON`,
  se llama `Py_INCREF` en el catch-all final de `python_to_lisp`.
- **Recursión con limpieza**: En `lisp_to_python` para listas/dicts, si un
  elemento falla la conversión, los elementos ya convertidos se liberan con
  `Py_DECREF` para evitar fugas.

### 3.6 Conversión de Números: Bigints, Ratios y Complejos

**Bigints (VALUE_INT → PyLong):**
La conversión usa una representación intermedia en string:
```c
char *str = bigint_to_string(v->as.bigint);
PyObject *py_int = PyLong_FromString(str, NULL, 10);
free(str);
```
Esto tiene complejidad O(n²) en el número de dígitos para enteros muy grandes
(>100 dígitos). Para la mayoría de los casos prácticos es imperceptible.

**Python → Bigint:**
Se usa `PyObject_Str()` para obtener el string decimal, luego `bigint_from_decimal`:
```c
PyObject *str_obj = PyObject_Str(obj);
const char *s = PyUnicode_AsUTF8(str_obj);
BigInt *bi = bigint_from_decimal(s, &ok);
```
Si la conversión falla (p. ej., el entero es demasiado grande para la
implementación de BigInt), se retorna como `VALUE_PYTHON`.

**Ratios (VALUE_RATIO):**
No hay conversión automática. `lisp_to_python` no tiene un caso `VALUE_RATIO`,
por lo que cae en `default` y produce error:
```
cannot convert Lisp type 4 to Python
```
**Workaround:** Convertir manualmente: `(py:->python (float ratio))` o
`(py:->python (numerator ratio))` y `(py:->python (denominator ratio))`.

**Complejos:**
Ambas direcciones convierten correctamente la parte real e imaginaria como
doubles:
```c
// Lisp → Python
PyComplex_FromDoubles(real, imag)
// Python → Lisp
Py_complex c = PyComplex_AsCComplex(obj);
```

---

## 4. API de Referencia

### 4.1 `py:import`

```lisp
(py:import nombre &optional simbolo) → objeto-python
```

Importa un módulo Python. El nombre se convierte a minúsculas automáticamente.

```lisp
(py:import "math")           ;; → #<PYTHON-OBJECT: module 'math'>
(py:import "numpy" 'np)      ;; importa y bindea np como variable local
```

**Implementación** (lispy.c:64693-64741):
1. Convierte el nombre a minúsculas
2. Adquiere el GIL (`PY_GIL_ENSURE`)
3. Crea `PyUnicode` y llama `PyImport_Import`
4. Libera el GIL (`PY_GIL_RELEASE`)
5. Cachea el resultado en `python_module_cache`
6. Si hay 2º argumento (símbolo), lo bindea en el entorno local con `env_define_value_symbol`

El módulo se cachea en `python_module_cache` (hash-table con test `equal`):
múltiples llamadas con el mismo nombre retornan la misma instancia.

### 4.2 `py:call`

```lisp
(py:call callable &rest args) → resultado
```

Invoca un callable Python con los argumentos convertidos automáticamente.

```lisp
(py:call (py:attr (py:import "math") "sqrt") 16)     ;; → 4.0
(py:call (py:attr (py:import "builtins") "sum") '(1 2 3 4))  ;; → 10
(py:call (py:import "math") nil)  ;; error: module no es callable
```

**Optimizaciones por número de argumentos** (lispy.c:64743-64790):

| Args | Ruta C | Descripción |
|------|--------|-------------|
| 0 | `PyObject_CallNoArgs` | Sin argumentos, máxima eficiencia |
| 1 | `PyObject_CallOneArg` | Argumento único, sin tupla intermedia |
| 2+ | `PyTuple_New` + `PyObject_Call` | Tupla construida dinámicamente |

**Validaciones:**
- El primer argumento debe ser `VALUE_PYTHON` y no NULL
- El objeto debe ser `PyCallable_Check` (callable)
- Los argumentos se convierten con `lisp_to_python` (con manejo de errores)
- El resultado se convierte con `python_to_lisp` y se hace `Py_DECREF`

### 4.3 `py:attr`

```lisp
(py:attr objeto nombre-atributo) → valor
```

Accede a un atributo de un objeto Python. El nombre puede ser símbolo, string o keyword.

```lisp
(let ((math (py:import "math")))
  (py:attr math "pi")       ;; → 3.141592653589793
  (py:attr math 'sqrt)      ;; → #<PYTHON-OBJECT: builtin_function_or_method>
  (py:attr math :pi))       ;; → 3.141592653589793
```

**Implementación** (lispy.c:64792-64827):
```c
PY_GIL_ENSURE();
PyObject *py_attr = PyObject_GetAttrString((PyObject*)obj->as.python.obj, name);
PY_GIL_RELEASE();
*out = python_to_lisp(it, py_attr, err, errsz);
Py_DECREF(py_attr);
```

### 4.4 `py:getitem`

```lisp
(py:getitem objeto clave) → valor
```

Equivalente a `objeto[clave]` en Python. Útil para listas, dicts, arrays numpy.

```lisp
(let ((arr (py:call (py:attr (py:import "builtins") "list") '(10 20 30))))
  (py:getitem arr 1))       ;; → 20
```

**Implementación** (lispy.c:64829-64855):
La clave se convierte con `lisp_to_python`, luego se llama `PyObject_GetItem`.

### 4.5 `py:%set-attr` y `py:%set-item`

```lisp
(py:%set-attr objeto nombre-atributo valor) → valor
(py:%set-item objeto clave valor) → valor
```

Funciones built-in para mutación de objetos Python. No tienen integración con
`setf` de Common Lisp.

**`py:%set-attr`** (lispy.c:64857-64885): Equivalente a `setattr(obj, name, value)`.
- El nombre puede ser símbolo, string o keyword
- El valor se convierte con `lisp_to_python`
- Retorna el valor (no el objeto modificado)
- Usa `PyObject_SetAttrString`

**`py:%set-item`** (lispy.c:64887-64912): Equivalente a `obj[key] = value`.
- Clave y valor se convierten con `lisp_to_python`
- Retorna el valor
- Usa `PyObject_SetItem`

```lisp
(let ((lst (py:call (py:attr (py:import "builtins") "list") '(1 2 3))))
  (py:%set-item lst 1 99)  ;; lst → [1, 99, 3]
  (py:%set-attr (py:import "__main__") "x" 42))  ;; __main__.x = 42
```

### 4.6 `py:run`

```lisp
(py:run código-python) → resultado
```

Ejecuta una cadena de código Python en el contexto del módulo `__main__`.
Usa `Py_file_input` para soportar código multi-línea (definiciones de funciones,
clases, bucles, etc.).

```lisp
(py:run "x = sum(range(1, 101))")
(let ((x (py:attr (py:import "__main__") "x")))
  x)  ;; → 5050
```

**Implementación** (lispy.c:65072-65097):
```c
PyObject *main_module = PyImport_AddModule("__main__");
PyObject *globals = PyModule_GetDict(main_module);
PyObject *py_result = PyRun_String(src, Py_file_input, globals, globals);
```

Las variables definidas en `py:run` persisten en `__main__.__dict__` y son
accesibles posteriormente vía `py:attr` o `PyImport_AddModule("__main__")`.

### 4.7 `py:->lisp` y `py:->python`

```lisp
(py:->lisp objeto-python)  → valor-lisp
(py:->python valor-lisp)    → objeto-python
```

Conversión explícita y recursiva entre tipos.

```lisp
;; Lisp → Python → Lisp (roundtrip)
(py:->lisp (py:->python '(1 2 3)))  ;; → (1 2 3)

;; Forzar conversión completa de un objeto Python
(let ((py-dict (py:call (py:attr (py:import "builtins") "dict")
                        (py:->python '((a . 1) (b . 2))))))
  (py:->lisp py-dict))  ;; → hash-table con :a → 1, :b → 2
```

**`py:->lisp`** (lispy.c:65099-65112): Requiere que el argumento sea `VALUE_PYTHON`.
Adquiere el GIL, llama `python_to_lisp` (que aplica la tabla de conversión completa),
libera el GIL. El objeto original (`VALUE_PYTHON`) no se modifica.

**`py:->python`** (lispy.c:65114-65123): Acepta cualquier valor Lisp. Adquiere el
GIL, llama `lisp_to_python`, envuelve el resultado como `VALUE_PYTHON`.

### 4.8 `py:%chain` (Macros de Lectura `#_` y `@`)

```lisp
(py:%chain nombre &rest atributos) → valor
```

Función built-in interna que implementa las macros de lectura `#_` y `@`. Resuelve el
primer componente y luego encadena accesos a atributos.

**Algoritmo de resolución del primer argumento** (lispy.c:67472):
1. Si es símbolo o string, intenta `eval_python_symbol` (módulo Python o builtin)
2. Si eso falla, busca una variable Lisp en el entorno con `symbol_value_lookup_symbol`
3. **Fallback `*name*`**: si el nombre no contiene `*` y los pasos 1-2 fallan, busca `*nombre*` como variable Lisp dinámica
4. Si es `VALUE_PYTHON`, lo usa directamente
5. **Auto-conversión de escalares**: si el resultado final es `VALUE_PYTHON` envolviendo un escalar Python (int, float, str), se convierte automáticamente a Lisp. Callables y módulos se mantienen como `VALUE_PYTHON`.

**Para cada atributo subsiguiente:**
```c
PY_GIL_ENSURE();
PyObject *py_attr = PyObject_GetAttrString((PyObject*)current->as.python.obj, attr_name);
PY_GIL_RELEASE();
current = python_to_lisp(it, py_attr, err, errsz);
Py_DECREF(py_attr);
```

### 4.9 Funciones de Inspección

```lisp
(py:python? obj)     ;; → t si obj es VALUE_PYTHON
(py:callable? obj)   ;; → t si obj es VALUE_PYTHON y callable (caché interna)
(py:type obj)        ;; → tipo Python del objeto
(py:dir obj)         ;; → lista de atributos del objeto
(py:repr obj)        ;; → representación Python del objeto
(py:str obj)         ;; → string Python del objeto
(py:len obj)         ;; → longitud Python del objeto
(py:help obj)        ;; → imprime help(obj) de Python
```

```lisp
(let ((math (py:import "math")))
  (py:python? math)         ;; → t
  (py:callable? math)       ;; → nil (módulo no es callable)
  (py:callable? (py:attr math "sqrt"))  ;; → t
  (py:len (py:->python '(1 2 3 4 5)))   ;; → 5
  (member "sqrt" (py:dir math) :test #'equal))  ;; busca sqrt en atributos
```

**Implementaciones:**
- `py:python?`: Comprueba `type == VALUE_PYTHON` — O(1), no requiere GIL
- `py:callable?`: Llama `python_value_is_callable` que cachea `PyCallable_Check`
- `py:help`: Importa `builtins`, obtiene `help`, llama con el objeto como argumento
- `py:dir`: `PyObject_Dir` → `python_to_lisp`
- `py:type`: `PyObject_Type` → `python_to_lisp`
- `py:repr`: `PyObject_Repr` → `python_to_lisp`
- `py:str`: `PyObject_Str` → `python_to_lisp`
- `py:len`: `PyObject_Length` → `make_int_value`

### 4.10 Iteración

```lisp
(py:iter objeto-python)   ;; → iterador Python
(py:next iterador)         ;; → siguiente elemento o nil (StopIteration)
```

```lisp
(let ((it (py:iter (py:->python '(10 20 30)))))
  (py:next it)  ;; → 10
  (py:next it)  ;; → 20
  (py:next it)  ;; → 30
  (py:next it)) ;; → nil
```

**`py:next`** (lispy.c:65045-65070): Usa `PyIter_Next`. Si retorna NULL:
- Si `PyErr_Occurred()` está activo (excepción real, no StopIteration):
  llama `py_bridge_check_error` y retorna error
- Si no hay error (StopIteration normal): retorna `nil`

**`py:iter`** (lispy.c:65028-65043): Usa `PyObject_GetIter`. Retorna el iterador
como `VALUE_PYTHON`.

---

### 4.11 `py:call-kw` — Keyword Arguments

```lisp
(py:call-kw callable kwargs-hash-table &rest args) → resultado
```

Invoca un callable Python con argumentos posicionales y keyword. El segundo
argumento es una hash-table Lisp cuyas claves (strings o símbolos) se convierten
en nombres de parámetro keyword y los valores en sus argumentos.

```lisp
;; Sin numpy: (setf (gethash "axis" kwargs) 0)
(let* ((np (py:import "numpy"))
       (arr (py:call (py:attr np "array") (py:->python '((1 2) (3 4)))))
       (kwargs (make-hash-table :test 'equal)))
  (setf (gethash "axis" kwargs) 0)
  (py:call-kw (py:attr np "sum") kwargs arr))
;; → array([4, 6])  (suma por columnas)
```

**Implementación** (lispy.c: ~64870): Convierte la hash-table a `PyDict` con
`lisp_to_python`, luego llama `PyObject_Call(callable, args, kwargs)`.

### 4.12 Depuración de Python

**`py:last-traceback`** — Obtiene la lista de frames del último error Python.

```lisp
(py:last-traceback) → lista-de-frames | nil
```

`py_bridge_check_error` guarda automáticamente el traceback en
`__main__._lispy_last_tb` cuando ocurre una excepción Python. `py:last-traceback`
recorre la cadena `tb_next` y retorna una lista Lisp de objetos frame
(`VALUE_PYTHON`).

```lisp
(ignore-errors (py:run "1/0"))
(let ((frames (py:last-traceback)))
  (length frames))  ;; → 2 (dos frames en el stack)
```

**`py:frame-locals`** — Obtiene variables locales de un frame Python.

```lisp
(py:frame-locals frame) → hash-table
```

Llama `PyObject_GetAttrString(frame, "f_locals")` y convierte el diccionario
Python resultante a hash-table Lisp.

```lisp
(let* ((frames (py:last-traceback))
       (frame (elt frames 0)))
  (hash-table-count (py:frame-locals frame)))  ;; → número de variables locales
```

**`py:frame-globals`** — Obtiene variables globales de un frame Python.

```lisp
(py:frame-globals frame) → hash-table
```

Similar a `py:frame-locals` pero accede a `f_globals` en lugar de `f_locals`.

**`py:frame-eval`** — Evalúa una expresión Python en el contexto de un frame.

```lisp
(py:frame-eval "expresión" frame) → resultado
```

Usa `PyRun_String(expr, Py_eval_input, globals, locals)` con los diccionarios
del frame. Permite inspeccionar y evaluar expresiones en medio de un stack
trace.

```lisp
(let* ((frames (py:last-traceback))
       (frame (elt frames 0)))
  (py:frame-eval "x + y" frame))  ;; → evalúa en contexto del frame
```

**Implementación** (lispy.c: ~65298-65404): Cada builtin adquiere el GIL,
accede a los atributos del frame vía `PyObject_GetAttrString`, y convierte los
resultados con `python_to_lisp`.

### 4.14 `py:register-callback` — Callback Lisp→Python

```lisp
(py:register-callback simbolo-lisp) → t
```

Registra una función Lisp para ser invocada desde Python. Internamente:

1. Crea una función Python `simbolo_cb` en `builtins` que almacena los argumentos
   en `__main__._lispy_cb`
2. Registra `lispy_callback_c` (C) en `builtins` como callable sincrónico
3. La función Python wrapper intenta el callback sincrónico primero; si falla,
   almacena en `_lispy_cb` para procesamiento cooperativo

```lisp
(defun mi-fn (val)
  (* val 2))

(py:register-callback 'mi-fn)
;; Python puede ahora llamar builtins.mi_fn_cb(21)
;; → almacena en __main__._lispy_cb
```

**Callback sincrónico** (`lispy_py_callback_impl`, lispy.c:66934): La función C
recibe `(fn_name, *args)`, busca el nombre en el entorno global (primero como
función con `env_lookup_function_symbol`, luego como valor con
`symbol_value_lookup_symbol`). Si no es callable (variable numérica, string),
retorna el valor directamente. Soporta **fallback `*name*`**: si el nombre no
contiene asteriscos y la búsqueda directa falla, intenta con `*nombre*`
automáticamente (permite `builtins.lispy_callback_c('pi')` resolver a `*pi*`).

### 4.15 `py:load-hybrid` — Carga de archivos con sintaxis híbrida

```lisp
(py:load-hybrid pathname) → t
```

Carga un archivo `.lp` que mezcla sintaxis Lisp y Python sin boilerplate.
El pre-procesador está **incrustado nativamente** en `lispy.c` (cadena Python
`LP_PREPROCESS_PY`, ~250 líneas), sin dependencia de archivos externos.

**Transformación automática:**

1. Detecta bloques Python (líneas sin `(` inicial, respetando strings Lisp multi-línea)
2. Reemplaza `fn(args)` → `builtins.fn_cb(args)` para funciones Lisp definidas con `defun`
3. Genera `(py:register-callback 'fn)` automáticamente antes del primer uso
4. Reemplaza `@variable` → `builtins.lispy_callback_c('variable')` en bloques Python
5. Envuelve el bloque en `(py:run "...")` con flushing de stdout

**Modos de uso (detección automática):**

```bash
# --load (explícito)
bin/lispy.exe --load examples/103.lp

# Archivo directo (implícito)
bin/lispy.exe examples/103.lp

# Modo interactivo
bin/lispy.exe -i examples/103.lp
```

```lisp
;; Desde Lisp/Jupyter/REPL (load también detecta híbridos):
(load "examples/103.lp")

;; En Jupyter notebooks, el kernel preprocesa automáticamente
;; cada celda. No es necesario py:load-hybrid — simplemente
;; escribe código híbrido directamente en las celdas.
```

**Ejemplo de archivo híbrido:**

```lisp
(defun add (a b) (+ a b))

m = 0
for i in range(10):
    m = add(m, i)

(print @m)   ;; @m lee m de Python __main__, convierte a Lisp
```

**Semántica de `@variable`:**

| Contexto | Resolución | Comportamiento |
|---|---|---|
| `@m` en Lisp | `py:%chain "m"` → Python `__main__.m` → conversión a Lisp | Si es escalar (int, float, str), se convierte automáticamente. Si es módulo/función, se mantiene como `VALUE_PYTHON`. |
| `@pi` en Python | `builtins.lispy_callback_c('pi')` → busca variable Lisp `PI` → fallback `*PI*` | Permite `{@pi}` en f-strings. El fallback `*name*` existe tanto en `lispy_callback_c` como en `py:%chain`. |

**Salida estándar:** `builtin_py_run` fuerza `\n` entre bloques Lisp y Python
para separar líneas (Lisp `print` termina con espacio, no con `\n`). La primera
llamada a `py:run` no añade `\n` para evitar línea en blanco inicial.

### 4.16 `py:pickle-dumps` y `py:pickle-loads` — Serialización

```lisp
(py:pickle-dumps objeto-python) → hex-string
(py:pickle-loads hex-string) → objeto-python
```

Serializan/deserializan objetos Python usando el módulo `pickle` de Python,
con codificación hexadecimal para almacenamiento seguro en strings Lisp.

**`py:pickle-dumps`**: Llama `pickle.dumps(obj)`, convierte los bytes a hex
vía `binascii.hexlify`, decodifica a string ASCII. Retorna un string Lisp.

**`py:pickle-loads`**: Convierte el string hex a bytes vía
`binascii.unhexlify`, llama `pickle.loads(bytes)`, retorna el objeto Python
reconstruido como `VALUE_PYTHON`.

```lisp
(let* ((arr (py:->python '(1 2 3 4 5)))
       (data (py:pickle-dumps arr))
       (restored (py:pickle-loads data)))
  (py:repr restored))  ;; → [1, 2, 3, 4, 5]
```

**Uso típico** — checkpoint/restore de sesión (ver `lib/persist.lp`):

```lisp
(load "lib/persist.lp")
(py:run "x = 42; import numpy; z = numpy.array([1,2,3])")
(py:save-session "session.txt")   ;; guarda todas las variables de __main__
;; ... reiniciar LisPy ...
(py:load-session "session.txt")   ;; restaura x, z, etc.
```

### 4.17 Puente de Corutinas: Lisp ↔ Python — `py:gen-next` y `py:gen-send`

> **Nota:** Estas funciones no son builtins C, sino funciones Lisp definidas en
> la librería `lib/continuations.lp`. Deben cargarse explícitamente:
> `(load "lib/continuations.lp")`. La librería también provee `py:gen-close`.

```lisp
(load "lib/continuations.lp")   ;; necesario para usar gen-next/gen-send

(py:gen-next generador) → valor | nil
(py:gen-send generador valor) → valor
```

**`py:gen-next`**: Equivalente a `next(gen, None)`. Retorna el siguiente valor
del generador o `nil` cuando se agota (StopIteration).

**`py:gen-send`**: Equivalente a `gen.send(value)`. Envía un valor al generador
(útil para corutinas) y retorna el valor producido por `yield`.

```lisp
;; Crear corutina en Python
(py:run "def coro():
    x = yield 'ready'
    yield x * 2

g = coro()
g.send(None)  ;; iniciar
")

;; Interactuar desde Lisp
(let* ((main (py:import "__main__"))
       (g (py:attr main "g")))
  (py:gen-send g 10))  ;; → 20
```

**Implementación** (en `lib/continuations.lp`):
```lisp
(defun py:gen-next (gen)
  (let ((blt (py:import "builtins")))
    (py:call (py:attr blt "next") gen nil)))

(defun py:gen-send (gen value)
  (py:call (py:attr gen "send") (py:->python value)))
```

---

La evaluación de símbolos del paquete `PY` sigue un algoritmo de dos niveles:
como valor y como cabeza de función.

### 5.1 Como Valor

Cuando se evalúa `py:xxx` como **valor** (no como función), el evaluador
(lispy.c:57142-57150) aplica el siguiente algoritmo:

```
py:xxx evaluado como valor en eval():
  └─ ¿Símbolo no ligado en el entorno Lisp?
     └─ ¿Símbolo pertenece al paquete PYTHON?
        └─ eval_python_symbol():
           ├─ 1. Buscar en caché de módulos
           │     (hash-table con test equal, clave = nombre original)
           ├─ 2. Intentar import como módulo (nombre en minúsculas)
           │     → éxito: cachear y retornar
           ├─ 3. builtins.nombre_original
           │     → éxito: cachear y retornar
           ├─ 4. builtins.nombre_minúsculas
           │     → éxito: cachear y retornar
           └─ 5. Error: "Python: could not find 'X' as module or builtin"
```

Este mecanismo es el que permite escribir directamente:

```lisp
py:math   ;; → import math   (módulo)
py:print  ;; → builtins.print (builtin encontrado en paso 3 o 4)
```

**Nota sobre el nombre en caché:** La clave de caché usa el nombre original del
símbolo (en mayúsculas, como lo entrega el lector Lisp). Esto significa que
`py:MATH` y `py:math` son **el mismo símbolo** (el lector Lisp convierte a
mayúsculas), por lo que no hay duplicados.

### 5.2 Como Cabeza de Función

Cuando `py:xxx` aparece como **cabeza de función** (lispy.c:57627-57643):

```
(py:xxx args...) en eval():
  └─ env_lookup_function_symbol(env, head_symbol) → no encontrado
     └─ ¿Símbolo pertenece al paquete PYTHON?
        ├─ eval_python_symbol() para resolver py:xxx como valor
        ├─ Construir call_args = (valor_resuelto . args)
        └─ Llamar builtin_py_call(call_args)
```

Esto significa que **cualquier función built-in de Python** puede invocarse
directamente con `py:` sin necesidad de `py:import` ni `py:call`:

```lisp
(py:print "hola")       ;; → Python's print()
(py:abs -42)            ;; → Python's abs()
(py:len "hello")        ;; → Python's len()
(py:sum '(1 2 3 4 5))   ;; → Python's sum()
(py:pow 2 10)           ;; → Python's pow()
(py:int 3.14)           ;; → Python's int()
(py:float 42)           ;; → Python's float()
(py:sorted '(3 1 4 1 5));; → Python's sorted()
(py:range 5)            ;; → Python's range(0, 5)
(py:max 1 2 3 4 5)      ;; → Python's max()
(py:min 1 2 3 4 5)      ;; → Python's min()
```

**Nota sobre el case:** El lector Lisp convierte `py:abs` al símbolo `ABS` (en
mayúsculas). Internamente, `eval_python_symbol` primero intenta `ABS` como
builtin (falla, porque Python tiene `abs` en minúsculas) y luego `abs` (tiene
éxito). Este fallback a minúsculas está implementado en
lispy.c:64664-64671.

### 5.3 Algoritmo Interno: `eval_python_symbol`

La función `eval_python_symbol` (lispy.c:64619-64689) es el núcleo de la
resolución transparente. Su implementación completa:

```c
static int eval_python_symbol(Interp *it, Value *symbol, Value **out, char *err, size_t errsz) {
    const char *name = symbol->as.str;
    // 1. Cache lookup (clave = nombre original, ej. "MATH")
    Value *key = make_string_value(name);
    int idx = hash_table_find_entry(it->python_module_cache, key);
    if (idx >= 0) { *out = valor_cacheado; return 1; }
    
    PY_GIL_ENSURE();
    // 2. Try module import (lowercased, ej. "math")
    char lower_name[...]; // tolower() conversion
    module = PyImport_Import(py_name); Py_DECREF(py_name);
    if (module) { PY_GIL_RELEASE(); cachear y retornar; }
    PyErr_Clear();  // ← Limpia el error del import fallido
    
    // 3. Try builtins.nombre_original (ej. "ABS")
    attr = PyObject_GetAttrString(builtins, name); // ej. "ABS"
    if (!attr) {
        PyErr_Clear();
        // 4. Try builtins.nombre_minúsculas (ej. "abs")
        attr = PyObject_GetAttrString(builtins, lower_name);
    }
    Py_DECREF(builtins);
    if (attr) { PY_GIL_RELEASE(); cachear y retornar; }
    PyErr_Clear();
    
    PY_GIL_RELEASE();
    // 5. Error
    snprintf(err, errsz, "Python: could not find '%s' as module or builtin", name);
    return 0;
}
```

**Detalles importantes:**
- El GIL se adquiere **una vez** y se libera al encontrar el resultado o al
  terminar sin éxito
- `PyErr_Clear()` se llama después de cada intento fallido para evitar que
  errores residuales contaminen intentos posteriores
- La caché almacena tanto módulos como builtins resueltos
- La comparación de módulos usa el nombre en minúsculas (tolower)
- La comparación de builtins prueba primero el nombre original (mayúsculas) y
  luego minúsculas como fallback

### 5.4 Llamada Directa de `VALUE_PYTHON` como Función

Además de la resolución transparente de símbolos `py:`, el evaluador también
soporta la **llamada directa** de cualquier `VALUE_PYTHON` que sea callable
como cabeza de función (lispy.c:57666-57699):

```lisp
(let ((f (py:attr (py:import "math") "sqrt")))  ;; f es VALUE_PYTHON callable
  (f 16))  ;; → 4.0  ¡Llamada directa!
```

Esto funciona porque en la rama de evaluación de funciones (tras evaluar la
cabeza), el evaluador comprueba:

```c
if (fn->type == VALUE_PYTHON && python_value_is_callable(fn)) {
    // Llama directamente con la misma optimización de args:
    // 0 args → PyObject_CallNoArgs
    // 1 arg  → PyObject_CallOneArg
    // 2+ args → PyTuple_New + PyObject_Call
}
```

Esta es una vía más rápida que pasar por `py:call`, ya que elimina la
indirección del builtin y la validación del primer argumento.

---

## 6. Macros de Lectura `#_` y `@`

LisPy proporciona dos macros de lectura para acceso compacto a objetos Python:
`#_` (dispatch macro) y `@` (reader macro estándar). Ambos producen internamente
llamadas a `(py:%chain ...)` con argumentos de tipo **string**, no símbolos.

### 6.1 Macro `#_` (Dispatch)

#### 6.1.1 Sintaxis

El dispatch macro `#_` permite una sintaxis compacta para cadenas de atributos Python:

```
#_nombre:attr1:attr2:attrN
```

Se implementa como un dispatch macro en la tabla de lectura de `#`
(lispy.c:12408-12480), activo solo cuando `LISPY_HAVE_PYTHON` está definido.

#### 6.1.2 Expansión

**Siempre** se expande a `(py:%chain "comp1" "comp2" ...)` con argumentos de tipo
string, independientemente de si hay uno o múltiples componentes:

```lisp
#_math         → (py:%chain "math")
#_math:sqrt    → (py:%chain "math" "sqrt")
```

```lisp
;; Equivalente a: (py:attr (py:attr (py:import "math") "sqrt") "...")
#_math:sqrt       ;; → #<PYTHON-OBJECT: builtin_function_or_method>

;; Como cabeza de función:
(#_math:sqrt 16)  ;; → 4.0

;; Con variables locales Lisp:
(let ((math (py:import "math")))
  (list (#_math:sqrt 25)   ;; → 5.0
        #_math:pi))         ;; → 3.14159...
```

> **Nota sobre `#_` vs `@`:** Ambos producen la misma expansión
> `(py:%chain ...)` con strings. La macro `@` es generalmente más usada en
> archivos híbridos y código moderno por su sintaxis más limpia.

### 6.2 Macro `@` (Reader Macro Estándar)

#### 6.2.1 Sintaxis

El reader macro `@` permite una sintaxis compacta tipo Python para cadenas
de atributos:

```
@nombre:attr1:attr2:attrN
@nombre.attr1.attr2.attrN
```

Admite tanto `:` como `.` como separadores de atributos,
lo que permite escribir código con estilo Python:

```lisp
@math:sqrt             ;; → #<PYTHON-OBJECT: builtin_function_or_method>
@math:pi               ;; → 3.14159...
@os:path:join("/a" "b") ;; → "a/b"
```

También soporta la notación con punto (`.`) para mayor familiaridad Python:

```lisp
@math.sqrt             ;; ≡ @math:sqrt
@os.path.join          ;; ≡ @os:path:join
```

#### 6.2.2 Expansión

Al igual que `#_`, siempre se expande a `(py:%chain "comp1" "comp2" ...)`:

```lisp
@math         → (py:%chain "math")
@math:sqrt    → (py:%chain "math" "sqrt")
@math.sqrt    → (py:%chain "math" "sqrt")
```

Esto permite usar cualquiera de las dos notaciones indistintamente.

#### 6.2.3 Uso como Cabeza de Función

El resultado de `@` es un valor Lisp normal, por lo que puede usarse como
cabeza de función directamente:

```lisp
(@math:sqrt 16)   ;; → 4.0
(@math:pow 2 10)  ;; → 1024
```

Cuando se usa en archivos híbridos, `@variable` en bloques Python se traduce
a `builtins.lispy_callback_c('variable')` (ver §4.15).

### 6.3 Implementación Interna de `py:%chain`

`py:%chain` (lispy.c:65165-65215) es la función builtin que ejecuta la cadena
de atributos:

```c
static int builtin_py_chain(Interp *it, Env *env, const ValueArray *args,
                            Value **out, char *err, size_t errsz) {
    // args[0]: primer eslabón (símbolo, string, o VALUE_PYTHON)
    // args[1..n]: nombres de atributos (símbolos o strings)
    
    // Paso 1: Resolver primer eslabón
    if (args[0] es símbolo o string) {
        nombre = args[0]->as.str;
        if (eval_python_symbol(it, args[0], &pv)) {
            current = pv;  // Módulo Python o builtin
        } else {
            buscar variable Lisp en entorno;
            current = bound_value;  // Variable Lisp local
        }
    } else if (args[0] es VALUE_PYTHON) {
        current = args[0];  // Objeto Python directo
    }
    
    // Paso 2: Encadenar getattr para cada atributo
    for (i = 1; i < args->count; i++) {
        PY_GIL_ENSURE();
        py_attr = PyObject_GetAttrString(current, attr_name);
        PY_GIL_RELEASE();
        current = python_to_lisp(it, py_attr);
        Py_DECREF(py_attr);
    }
    
    *out = current;
}
```

Este diseño permite una flexibilidad total: el primer eslabón puede ser un
módulo Python (`#_math:pi`), un builtin (`#_print:"hola"`), o una variable
Lisp local que contenga un objeto Python.

---

## 7. Modos de Uso: Lisp Nativo vs Python Delegado

LisPy ofrece un espectro de integración, desde Lisp puro con ayuda puntual de Python
hasta delegación completa de cómputo a Python. La elección depende del equilibrio
entre **expresividad Lisp** y **rendimiento**.

### 7.1 Modo 1: Lisp Nativo + Python Puntual

El control de flujo está en Lisp. Python se usa solo para operaciones específicas
(funciones matemáticas, E/S de archivos, librerías especializadas).

```lisp
;; ✅ BUENO: Lisp controla el loop, Python calcula logaritmos
(let ((math (py:import "math"))
      (max-log -1.0)
      (max-line 0)
      (line-num 0))
  (dolist (line lineas)
    (incf line-num)
    (let ((log-val (* exponente (py:call (py:attr math "log") base))))
      (when (> log-val max-log)
        (setf max-log log-val max-line line-num))))
  max-line)
```

**Ventajas**: Código idiomático Lisp, legible, mantenible.
**Desventajas**: Lento para operaciones en loops ajustados (>10K iteraciones con `py:call`).

### 7.2 Modo 2: Python Delegado por Lotes

Se usa `py:run` para ejecutar bloques de Python que realizan cómputo intensivo,
y luego se recuperan los resultados a Lisp.

```lisp
;; ✅ BUENO: Python hace el trabajo pesado, Lisp orquesta
(py:run "
def is_bouncy(n):
    s = str(n)
    inc = dec = True
    for i in range(1, len(s)):
        if s[i] > s[i-1]: dec = False
        if s[i] < s[i-1]: inc = False
    return not (inc or dec)

n, bouncy = 100, 0
while bouncy * 100 != 99 * n:
    n += 1
    if is_bouncy(n): bouncy += 1
result = n
")
(let ((result (py:attr (py:import "__main__") "result")))
  (format t "Answer: ~A" result))
```

**Ventajas**: Rendimiento de Python nativo para bucles intensivos.
**Desventajas**: El código Python está en strings, menos integrado visualmente.

### 7.3 Modo 3: Híbrido Balanceado (Recomendado)

Python se usa para operaciones de librería y Lisp para la lógica de negocio.

```lisp
;; ✅ MEJOR PRÁCTICA: Python para E/S y matemáticas, Lisp para lógica
(let* ((math (py:import "math"))               ;; Python
       (fact (py:attr math "factorial"))       ;; Python
       (c70-20 (/ (py:call fact 70)            ;; Python
                  (* (py:call fact 20) (py:call fact 50))))
       (c60-20 (/ (py:call fact 60)            ;; Python
                  (* (py:call fact 20) (py:call fact 40))))
       (expected (* 7 (- 1 (/ (float c60-20) (float c70-20))))))  ;; Lisp
  (format t "Answer: ~A" expected))             ;; Lisp
```

### 7.4 Modo 4: Llamada Directa VALUE_PYTHON

Cuando se tiene un `VALUE_PYTHON` callable, se puede invocar directamente como
cabeza de función sin pasar por `py:call`:

```lisp
(let ((sqrt (py:attr (py:import "math") "sqrt")))
  (sqrt 16))            ;; → 4.0 (llamada directa, sin py:call)
  (sqrt 25)             ;; → 5.0
```

Este modo es más rápido que `py:call` porque:
1. No hay validación del tipo del primer argumento (ya se validó al crear)
2. No hay indirección del builtin Lisp
3. La optimización de args (0/1/N) se aplica igual

### 7.5 Cuándo Usar Cada Modo

| Situación | Modo Recomendado |
|-----------|-----------------|
| < 1000 llamadas a Python | Modo 1 (Lisp Nativo) |
| Loop de > 10K iteraciones con `py:call` | Modo 2 (Python Delegado) |
| Algoritmo mixto con librerías Python | Modo 3 (Híbrido) |
| Múltiples llamadas al mismo callable | Modo 4 (VALUE_PYTHON directo) |
| Procesamiento de archivos | Python para I/O, Lisp para lógica |
| Cálculo matemático puro | Lisp (si es factible) o Python para bigint |
| Machine Learning / NumPy | Modo 2 (todo en Python) |

---

## 8. Modelo de Memoria y Referencias

### 8.1 Estructura de `VALUE_PYTHON`

Cada `VALUE_PYTHON` se define como (lispy.c:762-814):

```c
struct Value {
    ValueType type;  // VALUE_PYTHON = 33
    // ... campos comunes (hash, next, etc.) ...
    union {
        struct {
            void *obj;            // PyObject* (almacenado como void*)
            int callable;         // Cache: ¿es callable? (0/1)
            int callable_known;   // Cache: ¿ya se verificó?
        } python;
        // ... otros tipos ...
    } as;
};
```

**Tres campos de estado:**
- `obj`: Puntero al `PyObject*` subyacente. Puede ser NULL (tratado como `None`).
- `callable_known`: Flag que indica si la propiedad de callable ya fue evaluada.
- `callable`: Resultado cacheado de `PyCallable_Check`.

### 8.2 Ownership de PyObject*

Cada `VALUE_PYTHON` posee **exactamente una referencia** a su `PyObject*` interno:

- **Al crear** desde una C API que retorna _new reference_ (p. ej., `PyImport_Import`,
  `PyObject_GetAttrString`): no se incrementa (ya viene con referencia)
- **Al crear** desde una _borrowed reference_ (p. ej., `Py_None`, `Py_True`):
  se llama `Py_INCREF`
- **Al convertir** `VALUE_PYTHON` a Python (`lisp_to_python` cae en caso
  `VALUE_PYTHON`): se llama `Py_INCREF` porque el Lisp retiene su referencia
- **Al destruir** un `VALUE_PYTHON` (GC, salida de ámbito): se llama `Py_DECREF`
- **Al copiar** (asignación, paso de argumentos): no se copia el `PyObject*`;
  solo se copia el `Value` (shallow copy). El refcount del `PyObject*` no cambia

```lisp
;; Cada let binding mantiene una referencia
(let ((math (py:import "math")))      ;; refcount++ en módulo math
  (let ((tambien-math math))          ;; shallow copy del Value, misma referencia
    (py:attr math "pi")))             ;; nuevo VALUE_PYTHON con refcount propio
;; Al salir del let, refcount-- para math, posible GC de Python
```

### 8.3 Ciclo de Vida

Los objetos `VALUE_PYTHON` son manejados por el sistema de memoria de LisPy
(garbage collection, ámbitos léxicos, `let`, etc.). Cuando un `VALUE_PYTHON`
es liberado, su `PyObject*` recibe `Py_DECREF`.

**Caso especial:** La función `make_python_value` (lispy.c:64425-64431) crea un
nuevo `VALUE_PYTHON` con `callable = 0` y `callable_known = 0`. La propiedad
de callable se verifica bajo demanda.

### 8.4 Caché de Callable

La función `python_value_is_callable` (lispy.c:64433-64440) cachea el resultado
de `PyCallable_Check`:

```c
static int python_value_is_callable(Value *v) {
    if (v->type != VALUE_PYTHON || v->as.python.obj == NULL) return 0;
    if (!v->as.python.callable_known) {
        v->as.python.callable = PyCallable_Check((PyObject*)v->as.python.obj);
        v->as.python.callable_known = 1;
    }
    return v->as.python.callable;
}
```

Esto evita llamadas repetidas a `PyCallable_Check` (que es una llamada a la API
de Python y requiere el GIL). Un objeto verificado como callable mantiene ese
estado hasta que el `VALUE_PYTHON` es destruido.

**Limitación:** Si el objeto Python subyacente muta su naturaleza (p. ej., se le
elimina `__call__`), la caché no se invalida. En la práctica esto es poco común.

### 8.5 Caché de Módulos

La caché `python_module_cache` es una hash-table Lisp con test `equal`
(comparación de strings), inicializada en `interp_init`:

```c
it->python_module_cache = make_hash_table_value(HASH_TEST_EQUAL, 32, 1.5, 1.0);
```

**Claves:** Strings con el nombre del símbolo en el caso original del lector
(p. ej., `"MATH"` para `py:math`).

**Valores:** `VALUE_PYTHON` con el módulo o builtin resuelto.

**Población:**
- `builtin_py_import` cachea después de cada import exitoso
- `eval_python_symbol` cachea después de cada resolución exitosa de builtin o módulo

**La caché nunca se limpia explícitamente** — persiste durante toda la vida del
intérprete. Esto es seguro porque los módulos Python no se descargan
normalmente. Para forzar una recarga, se necesitaría acceso interno a la caché.

### 8.6 GIL (Global Interpreter Lock)

CPython requiere el GIL para operaciones sobre objetos Python. LisPy lo gestiona
automáticamente mediante macros (lispy.c:64420-64423):

```c
#define PY_GIL_ENSURE()  PyGILState_STATE _py_gil = PyGILState_Ensure()
#define PY_GIL_RELEASE() PyGILState_Release(_py_gil)
```

**Ámbito del GIL:** El GIL se adquiere al entrar a una función Python y se
libera al salir. Es un patrón **por llamada**, no por ámbito léxico:

```
py:call → PY_GIL_ENSURE → PyObject_Call* → PY_GIL_RELEASE → conversión resultado
py:attr → PY_GIL_ENSURE → PyObject_GetAttrString → PY_GIL_RELEASE → conversión resultado
py:run  → PY_GIL_ENSURE → PyRun_String → conversión → PY_GIL_RELEASE
```

**Durante operaciones Lisp puras**, el GIL está liberado. Esto permite
concurrencia con otros hilos Python (aunque LisPy es actualmente monohilo).

**Casos con GIL retenido entre operaciones:**
- `eval_python_symbol` adquiere el GIL al inicio y lo libera al encontrar el
  resultado, abarcando múltiples operaciones (módulo import + builtin attrs)
- `builtin_py_call` libera el GIL entre la conversión de args y la llamada real

---

## 9. Manejo de Errores

### 9.1 Errores de Python (`py_bridge_check_error`)

Los errores de Python se capturan mediante `py_bridge_check_error`
(lispy.c:64442-64457) después de cada llamada a la API Python que puede fallar:

```c
static int py_bridge_check_error(char *err, size_t errsz) {
    if (PyErr_Occurred()) {
        // 1. Obtener la excepción
        PyObject *ptype = NULL, *pvalue = NULL, *ptraceback = NULL;
        PyErr_Fetch(&ptype, &pvalue, &ptraceback);
        // 2. Normalizar (asignar clase canónica a type, etc.)
        PyErr_NormalizeException(&ptype, &pvalue, &ptraceback);
        // 3. Convertir a string
        PyObject *pstr = pvalue ? PyObject_Str(pvalue)
                                : PyUnicode_FromString("<unknown error>");
        const char *msg = pstr ? PyUnicode_AsUTF8(pstr) : "Python error (no message)";
        // 4. Formatear error Lisp
        snprintf(err, errsz, "Python: %s", msg ? msg : "???");
        // 5. Limpiar referencias Python
        Py_XDECREF(pstr);
        Py_XDECREF(ptype); Py_XDECREF(pvalue); Py_XDECREF(ptraceback);
        return 1;  // Error ocurrió
    }
    return 0;  // Sin error
}
```

Los errores de Python se convierten en **strings de error** que el evaluador
Lisp muestra como condiciones de error. **No** se convierten en condiciones
Common Lisp manejables con `handler-case`/`ignore-errors`:

```lisp
(py:import "modulo_que_no_existe")
;; → ERROR: Python: No module named 'modulo_que_no_existe'

(py:call (py:import "math") 42)
;; → ERROR: Python: 'module' object is not callable

(py:attr (py:import "math") "atributo_falso")
;; → ERROR: Python: module 'math' has no attribute 'atributo_falso'
```

### 9.2 Errores de Tipo en la Frontera

```lisp
;; Pasar no-Python a funciones que esperan Python
(py:len '(1 2 3))
;; → ERROR: py:len: not a Python object
;; CORRECTO: (py:len (py:->python '(1 2 3))) o (length '(1 2 3))

(py:->lisp "soy string lisp")
;; → ERROR: py:->lisp: not a Python object

(py:attr '(1 2 3) "x")
;; → ERROR: py:attr: object is not a Python object
```

### 9.3 Errores del Lector

```lisp
python:len
;; → ERROR: reader could not find package 'PYTHON'
;; (falta importar el paquete; no ocurre si Python está inicializado)

py:simbolo_que_no_existe
;; Se auto-interna sin error (el paquete PY es especial)
```

### 9.4 Errores Silenciosos (`PyErr_Clear`)

En `eval_python_symbol`, después de cada intento fallido se llama
`PyErr_Clear()` para limpiar el estado de error de Python:

```c
// Intento de import
module = PyImport_Import(py_name);
if (module) { ... éxito ... }
PyErr_Clear();  // ← Limpia ImportError

// Intento de builtin (mayúscula)
attr = PyObject_GetAttrString(builtins, name);
if (attr) { ... éxito ... }
PyErr_Clear();  // ← Limpia AttributeError
```

Esto es necesario porque los pasos de resolución son especulativos y los errores
de pasos intermedios no deben propagarse al usuario.

---

## 10. Consideraciones de Rendimiento

### 10.1 Overhead de `py:call`

Cada `py:call` cruza la frontera Lisp↔Python con el siguiente costo:

1. Adquirir/liberar GIL (~microsegundos)
2. Convertir argumentos Lisp→Python (recursivo para listas/hash-tables)
3. Convertir resultado Python→Lisp
4. Gestión de referencias (INCREF/DECREF)

**Regla práctica**: Para menos de ~1,000 llamadas, el overhead es insignificante.
Para más de ~10,000, considera `py:run` con código Python en lote.

### 10.2 Conversión de Listas

La conversión de listas Lisp a Python (y viceversa) es **recursiva y O(n)**:

```lisp
;; Esto convierte CADA elemento de la lista recursivamente
(py:->python '((1 2) (3 4) (5 6)))  ;; 6 conversiones individuales
```

Para listas grandes (>1000 elementos), la conversión puede dominar el tiempo de ejecución.

### 10.3 Caché de Módulos

Los módulos importados se cachean en `python_module_cache`. Importaciones repetidas
del mismo módulo retornan la instancia cacheada sin llamar a `PyImport_Import`:

```lisp
(py:import "math")  ;; Primera vez: PyImport_Import("math") + cacheo
(py:import "math")  ;; Segunda vez: retorna instancia cacheada (instantáneo)
```

### 10.4 Bigints y Precisión

La conversión de bigints de Lisp a Python se hace vía string (`bigint → char* →
PyLong_FromString`). Para enteros muy grandes (>100 dígitos), esta conversión
tiene costo O(n²) en el número de dígitos.

La conversión inversa (Python → Lisp) también usa string (`PyObject_Str` →
`bigint_from_decimal`), con el mismo perfil de costo.

### 10.5 Caché de Callable y Atributos

- `py:callable?` cachea el resultado de `PyCallable_Check` en el `VALUE_PYTHON`,
  evitando rondas repetidas al GIL
- Los builtins pre-registrados (como `py:call`) ya están resueltos en la tabla de
  funciones Lisp, sin necesidad de `eval_python_symbol`
- Las macros `#_` y `@` solo expanden la cadena una vez, en tiempo de lectura; la
  evaluación repite el recorrido cada vez

---

## 11. Limitaciones

### 11.1 Sin Keyword Arguments

Actualmente `py:call` solo soporta argumentos posicionales. No hay equivalente
directo para `func(a=1, b=2)` de Python.

**Workaround**: Usar `py:run` para llamadas con kwargs:

```lisp
(py:run "result = some_func(a=1, b=2)")
(py:attr (py:import "__main__") "result")
```

### 11.2 Sin Soporte para `setf` en Atributos/Items (Parcial)

Aunque `py:%set-attr` y `py:%set-item` están implementados como builtins internos,
no hay integración con el macro `setf` de Common Lisp:

```lisp
;; NO funciona actualmente:
(setf (py:attr obj 'x) 10)  ;; Error de setf expansion

;; Workaround:
(py:%set-attr obj 'x 10)    ;; Usar el builtin directamente
```

### 11.3 Sin `car`/`cdr` Garantizado en Listas Convertidas

Las listas creadas por `python_to_lisp` son `VALUE_LIST` (array-backed), no
`VALUE_CONS`. Usa `nth` y `length` en lugar de `car`/`cdr` para acceso portátil:

```lisp
(let* ((main (py:import "__main__"))
       (py-list (py:attr main "algo")))  ;; ← VALUE_LIST
  (nth 0 py-list)    ;; ✓ funciona
  ;; (car py-list)   ;; ✗ puede fallar
  )
```

### 11.4 Sin Acceso Directo a Sintaxis Python

No hay forma de escribir `obj.method()` o `obj[key]` con sintaxis Lisp directa.
Debe usarse `(py:call (py:attr obj "method") args...)` y `(py:getitem obj key)`.

### 11.5 Sin Async/Await

No hay soporte para corutinas de Python (`async def`, `await`). Todo el código
Python se ejecuta sincrónicamente.

### 11.6 Build Condicional

Si Python 3 no está disponible al compilar, LisPy se compila sin soporte Python.
Las funciones `py:*` no existirán y el paquete `PYTHON` no se creará:

```lisp
(find-package :py)  ;; → nil (si Python no está disponible)
```

### 11.7 Sin Conversión para `VALUE_RATIO` ni `VALUE_PATHNAME`

`lisp_to_python` no maneja `VALUE_RATIO` ni `VALUE_PATHNAME`. Pasar estos tipos
a `py:->python` o como argumento a `py:call` produce:

```
cannot convert Lisp type 4 to Python  ;; para ratio (ValueType=4)
cannot convert Lisp type 8 to Python  ;; para pathname (ValueType=8)
```

### 11.8 Sin Conversión Automática para `set`/`frozenset`

Los conjuntos Python (`set`, `frozenset`) no tienen entrada en `python_to_lisp`.
Quedan como `VALUE_PYTHON`. Para convertirlos a lista:

```lisp
(py:->lisp (py:call (py:attr (py:import "builtins") "list") py_set))
```

### 11.9 Sin Condiciones de Error Lisp para Excepciones Python

Los errores Python se convierten en strings de error, no en condiciones Common
Lisp. `ignore-errors` puede atraparlos a nivel del evaluador, pero no hay
`handler-case` específico para tipos de excepción Python:

```lisp
(ignore-errors (py:import "no_existe"))  ;; → nil (atrapa el error)
```

### 11.10 GIL de Ámbito por Llamada

El GIL se adquiere y libera en cada operación Python individual. Esto es seguro
pero introduce overhead. En un futuro hilo múltiple, este patrón podría causar
contención.

### 11.11 `VALUE_PYTHON` Dangling después de `Py_Finalize`

Si se llama a `Py_Finalize()` (al cerrar LisPy), todos los `VALUE_PYTHON`
existentes quedan con punteros `PyObject*` colgantes. No hay un mecanismo para
invalidar valores Lisp que referencian objetos Python finalizados.

### 11.12 Sin Soporte para Argumentos Posicionales Dinámicos en `py:call`

`py:call` usa `&rest args` en C pero los argumentos deben pasarse individualmente.
No se puede hacer splat de una lista Lisp como argumentos a `py:call`. Para
funciones Python que esperan `*args`, usar `py:run` con una función helper:

```lisp
(py:run "def _helper(fn, arglist):
    return fn(*arglist)")
```

### 11.13 PyCFunction Vectorcall en CPython 3.14

El callback sincrónico `lispy_callback_c` usa `PyCFunction_New` con
`METH_VARARGS`. En CPython 3.14, esto puede fallar con el error
`'builtin_function_or_method' does not support vectorcall`. El wrapper Python
`lispy_callback` captura esta excepción y delega al modo cooperativo
(`__main__._lispy_cb`).

### 11.14 `#_` / `@` Chain: Solo Atributos, Sin Invocación ni Índices

Las macros `#_` y `@` soportan encadenamiento de atributos (`#_math:sqrt`, `@math:sqrt`) pero **no**
invocación con argumentos inline (`@math:sqrt(16)`) ni indexación (`@arr[0]`).
La invocación debe hacerse aplicando la forma resultante como función:

```lisp
(py:call (#_math:sqrt) 16)  ;; en lugar de #_math:sqrt(16)
```

### 11.15 Inicialización de Callbacks: Solo Símbolos

`py:register-callback` espera un símbolo Lisp. El nombre se sanitiza
(guiones → guiones bajos, lowercase) para generar un identificador Python
válido. La función Python se registra como `<nombre>_cb` en `builtins`.

### 11.16 Límites de Serialización Pickle

`py:pickle-dumps` / `py:pickle-loads` usan codificación hexadecimal que
duplica el tamaño de los datos (~2x overhead). Para objetos muy grandes
(>10 MB), considerar serialización directa a archivo binario vía `py:run`.
Objetos no pickleables (generadores, sockets, file handles) se omiten
silenciosamente en `py:save-session`.

### 11.17 `sys.meta_path` y Reentrada

El finder de `import-hooks.lp` incluye lista negra de módulos del sistema
(`builtins`, `sys`, `ast`, `importlib`, `types`, `io`, `os`) para evitar
recursión infinita. Módulos con dependencias circulares o importaciones
complejas pueden requerir ajustes en la lista negra.

### 11.18 Scope del Callback en `lispy_callback_impl`

La función C de callback busca símbolos en `g_lispy_interp->global_env`.
Funciones definidas en ámbitos léxicos anidados (closures) no son accesibles.
Usar `defun` a nivel superior o `defvar` para exponer callbacks.

### 11.19 Sin `dolist`/`labels` en Versiones Anteriores

Algunas construcciones Common Lisp (`dolist`, `labels`, `loop`) no están
completamente soportadas en LisPy. Las librerías usan recursión explícita,
`dotimes`, y `let` como alternativas portables.

---

## 12. Ejemplos Completos

### 12.1 NumPy: Operaciones con Arrays

```lisp
(let* ((np (py:import "numpy"))
       (arr (py:call (py:attr np "array") (py:->python '((1 2 3) (4 5 6))))))
  (format t "Array: ~A~%" arr)
  (format t "Shape: ~A~%" (py:attr arr "shape"))
  (format t "Mean:  ~A~%" (py:call (py:attr arr "mean")))
  (format t "Sum axis=0: ~A~%" (py:call (py:attr arr "sum") :axis 0)))
```

### 12.2 SymPy: Cálculo Simbólico

```lisp
(let* ((sp (py:import "sympy"))
       (x (py:call (py:attr sp "Symbol") "x"))
       (sin (py:attr sp "sin"))
       (diff (py:attr sp "diff"))
       (integrate (py:attr sp "integrate"))
       (expr (py:call sin x)))
  (format t "d/dx sin(x) = ~A~%" (py:str (py:call diff expr x)))
  (format t "∫cos(x)dx = ~A~%" (py:str (py:call integrate (py:call diff expr x) x))))
```

### 12.3 Requests: HTTP GET

```lisp
(let* ((requests (py:import "requests"))
       (resp (py:call (py:attr requests "get") "https://api.github.com")))
  (format t "Status: ~A~%" (py:attr resp "status_code"))
  (format t "Content-Type: ~A~%" (py:attr (py:attr resp "headers") "get"))
  (let ((data (py:call (py:attr resp "json"))))
    (format t "Keys: ~A~%" (py:->lisp (py:call (py:attr data "keys"))))))
```

### 12.4 Project Euler con Lisp + Python

```lisp
;; Problema #99: Largest Exponential
;; Lisp controla el loop, Python calcula logaritmos
(let* ((math (py:import "math"))
       (log (py:attr math "log"))
       (io (py:import "builtins"))
       (file (py:call (py:attr io "open") "base_exp.txt"))
       (lines (py:call (py:attr file "readlines")))
       (max-log -1.0)
       (max-line 0)
       (num 0))
  (py:call (py:attr file "close"))
  (dolist (line lines)
    (incf num)
    (let* ((comma (position #\, line))
           (base (read-from-string (subseq line 0 comma)))
           (exp  (read-from-string (subseq line (1+ comma))))
           (val (* exp (py:call log base))))
      (when (> val max-log)
        (setf max-log val max-line num))))
  (format t "Answer: ~A~%" max-line))
```

### 12.5 Procesamiento de Datos con Python, Agregación en Lisp

```lisp
;; Leer CSV con Python, procesar en Lisp
(py:run "
import csv
data = []
with open('datos.csv') as f:
    for row in csv.reader(f):
        data.append([float(x) for x in row])
")

(let* ((main (py:import "__main__"))
       (data (py:attr main "data"))  ;; lista de listas de floats
       (total 0.0)
       (count 0))
  (dolist (row data)
    (dolist (val row)
      (incf total val)
      (incf count)))
  (format t "Total: ~F, Average: ~F~%" total (/ total count)))
```

### 12.6 Matplotlib: Graficar desde Lisp

```lisp
(let* ((plt (py:import "matplotlib.pyplot"))
       (np (py:import "numpy"))
       (x (py:call (py:attr np "linspace") 0 10 100))
       (y (py:call (py:attr np "sin") x)))
  (py:call (py:attr plt "plot") x y)
  (py:call (py:attr plt "title") "sin(x) from LisPy")
  (py:call (py:attr plt "show")))
```

### 12.7 VALUE_PYTHON Directo y Llamada Directa

```lisp
(let* ((math (py:import "math"))
       (sqrt (py:attr math "sqrt"))     ;; sqrt es VALUE_PYTHON callable
       (pi (py:attr math "pi")))        ;; pi es VALUE_PYTHON (float envuelto)
  ;; Llamada directa — sin py:call
  (sqrt 144)     ;; → 12.0
  ;; También funciona como cabeza de función en apply
  (apply sqrt '(169))  ;; → 13.0
  ;; Inspección
  (py:callable? sqrt)  ;; → t
  (py:python? pi)      ;; → t
  (py:type sqrt))      ;; → <class 'builtin_function_or_method'>
```

### 12.8 Errores y Manejo con ignore-errors

```lisp
;; Las excepciones Python se atrapan como errores Lisp
(let ((result (ignore-errors (py:import "modulo_inexistente"))))
  (if result
      (format t "Módulo: ~A" result)
    (format t "Error atrapado por ignore-errors")))

;; También funciona con operaciones inválidas
(ignore-errors (py:call (py:import "math") "no es callable"))
;; → nil (el módulo math no es callable)
```

### 12.9 Robot 2-DOF: Dinámica Híbrida Simbólico-Numérica

El ejemplo canónico que demuestra la integración completa:
SymPy → derivación simbólica → NumPy → scipy.integrate → matplotlib.

```lisp
(load "lib/sympy-bridge.lp")
(load "lib/numpy-fast.lp")

;; 1. Derivar ecuaciones de movimiento con SymPy
(py:run "
import sympy as sp
m1, m2, l1, l2, g = sp.symbols('m1 m2 l1 l2 g')
th1, th2 = sp.symbols('th1 th2')
th1d, th2d = sp.symbols('th1d th2d')

# Energía cinética y potencial
T = 0.5*m1*l1**2*th1d**2 + 0.5*m2*(l1**2*th1d**2 + l2**2*(th1d+th2d)**2
     + 2*l1*l2*th1d*(th1d+th2d)*sp.cos(th2))
V = -m1*g*l1*sp.cos(th1) - m2*g*(l1*sp.cos(th1) + l2*sp.cos(th1+th2))

# Matriz de masa M
M11 = sp.diff(sp.diff(T, th1d), th1d)
M12 = sp.diff(sp.diff(T, th1d), th2d)
M22 = sp.diff(sp.diff(T, th2d), th2d)
__M = sp.simplify(sp.Matrix([[M11, M12], [M12, M22]]))
G1 = sp.diff(V, th1); G2 = sp.diff(V, th2)
__G = sp.simplify(sp.Matrix([G1, G2]))
")

;; 2. Generar funciones numéricas
(py:run "
params = {m1:1.0, m2:1.0, l1:1.0, l2:1.0, g:9.81}
_M = sp.lambdify((th1, th2), __M.subs(params), 'numpy')
_G = sp.lambdify((th1, th2), __G.subs(params), 'numpy')

def robot_dyn(t, s):
    M = np.array(_M(s[0], s[1]), dtype=float)
    G = np.array(_G(s[0], s[1]), dtype=float).flatten()
    qdd = np.linalg.solve(M, -G)
    return [s[2], s[3], qdd[0], qdd[1]]
")

;; 3. Simular y graficar
(py:run "
from scipy.integrate import solve_ivp
sol = solve_ivp(robot_dyn, (0,10), [np.pi/2,0,0,0],
                t_eval=np.linspace(0,10,200), method='RK45')
import matplotlib.pyplot as plt
plt.plot(sol.t, sol.y[0], label='th1')
plt.plot(sol.t, sol.y[1], label='th2')
plt.legend(); plt.savefig('robot.png')
")
```

### 12.10 Checkpoint/Restore de Sesión

```lisp
(load "lib/persist.lp")
(py:run "x = 42; import numpy; data = numpy.array([1,2,3])")
(py:save-session "session.txt")   ;; guarda estado Python
;; --- reiniciar LisPy ---
(py:load-session "session.txt")   ;; restaura x, data
```

### 12.11 AST Hooks: Transformación al Importar

```lisp
(load "lib/import-hooks.lp")
(defun my-xform (modname ast) ast)  ;; modificar AST aquí
(py:register-ast-hook 'my-xform)
(py:run "import mi_modulo")  ;; AST interceptado
(py:remove-ast-hook)
```

---

## 13. Apéndice: Tabla de Tipos

### 13.1 `ValueType` en LisPy

| Tipo | Valor | Equivalente Python | Conversión |
|------|-------|-------------------|------------|
| `VALUE_NIL` | 0 | `None` | Automática |
| `VALUE_BOOL` | 1 | `bool` | Automática |
| `VALUE_INT` | 2 | `int` | Automática (vía string) |
| `VALUE_FLOAT` | 3 | `float` | Automática |
| `VALUE_RATIO` | 4 | — | **No convertible** |
| `VALUE_COMPLEX` | 5 | `complex` | Automática |
| `VALUE_CHAR` | 6 | `str` (len 1) | Automática |
| `VALUE_STRING` | 7 | `str` | Automática |
| `VALUE_PATHNAME` | 8 | — | **No convertible** |
| `VALUE_SYMBOL` | 9 | `str` | Automática |
| `VALUE_CONS` | 10 | `list` | Automática (proper list) |
| `VALUE_LIST` | 11 | `list` | Automática |
| `VALUE_VECTOR` | 12 | `list` | Automática |
| `VALUE_HASH_TABLE` | 16 | `dict` | Automática |
| `VALUE_PYTHON` | 33 | `PyObject*` | Sin conversión (refcount inc) |

### 13.2 Funciones de Conversión por Tipo

```lisp
;; De Lisp a Python:
(lisp-to-python nil)         ;; → None
(lisp-to-python t)           ;; → True
(lisp-to-python 42)          ;; → int(42)
(lisp-to-python 3.14)        ;; → float(3.14)
(lisp-to-python "hola")      ;; → str("hola")
(lisp-to-python '(1 2 3))    ;; → list([1, 2, 3])

;; De Python a Lisp:
(python-to-lisp None)        ;; → nil
(python-to-lisp True)        ;; → t
(python-to-lisp 42)          ;; → 42 (bigint)
(python-to-lisp 3.14)        ;; → 3.14 (float)
(python-to-lisp "hola")      ;; → "hola" (string)
(python-to-lisp [1, 2, 3])   ;; → (1 2 3) (list)
(python-to-lisp {"a": 1})    ;; → hash-table
(python-to-lisp some_object) ;; → #<PYTHON-OBJECT ...>
```

---

## 14. Apéndice: Diagnóstico de Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `reader could not find external symbol 'X' in package PYTHON` | Versión antigua sin auto-intern; símbolo no registrado | Actualizar LisPy |
| `py:len: not a Python object` | Pasaste lista Lisp donde se espera objeto Python | `(py:->python lista)` o usa `(length lista)` |
| `py:->lisp: not a Python object` | El valor ya es Lisp (fue auto-convertido) | No llames `py:->lisp`; el valor ya está convertido |
| `py:attr: object is not a Python object` | El objeto base no es `VALUE_PYTHON` | Asegúrate de que el objeto venga de `py:import`, `py:attr`, o `py:->python` |
| `py:call: first argument must be a Python object` | El primer argumento no es callable Python | Usa `(py:attr modulo "funcion")` para obtener la función |
| `Python: No module named 'X'` | `py:X` intentó `import X` como módulo (en mayúscula) | Usa `(py:import "x")` con string en minúscula |
| `car expects a list` en valor de Python | Lista convertida es `VALUE_LIST`, no `VALUE_CONS` | Usa `nth` en lugar de `car` |
| `subseq bounds out of range` en string de Python | String Python contiene caracteres especiales | Usa `py:str` para convertir a string Lisp limpio |
| `undefined function 'X'` para `(py:X args)` | `X` no es función built-in ni builtin Python reconocible | Usa `(py:call (py:attr modulo "X") args)` |
| Tiempo de ejecución excesivo en loop | `py:call` por iteración con overhead acumulado | Mueve el loop a `py:run` |
| `cannot convert Lisp type 4 to Python` | Se pasó un ratio (fracción) a Python | Convierte a float: `(py:->python (float ratio))` |
| `cannot convert Lisp type 8 to Python` | Se pasó un pathname a Python | Convierte a string: `(py:->python (namestring path))` |
| `py:%set-attr: object is not a Python object` | El objeto destino no es `VALUE_PYTHON` | El objeto debe venir de py:import, py:attr o py:->python |

---

## 15. Apéndice: Arquitectura Interna

### 15.1 Estructura del Código

Todo el soporte Python reside en un único archivo: **`lispy.c`** (~66K líneas).
El código Python está condicionalmente compilado con `#ifdef LISPY_HAVE_PYTHON`.

| Sección | Líneas | Descripción |
|---------|--------|-------------|
| `#include <Python.h>` | 40-42 | Header de CPython |
| `VALUE_PYTHON = 33` | 222 | Tipo enum |
| `python` en union Value | 762-814 | Campos obj/callable/callable_known |
| `python_package` en Interp | 833-919 | Referencia al paquete PYTHON |
| `#_` dispatch reader | 12266-12303 | Macro de lectura `#_` |
| `@` reader macro | 12097-12172 | Macro de lectura `@` |
| Forward declarations | 57059-57068 | Prototipos y macros GIL |
| Resolución py: valor | 57143-57150 | eval_python_symbol en evaluación de símbolos |
| Resolución py: función | 57627-57643 | py:xxx como cabeza de función |
| Llamada directa VALUE_PYTHON | 57666-57699 | fn callable como cabeza |
| Implementación FFI | 64418-65217 | Funciones de puente Python |
| Registro de builtins | 65812-65875 | 20 símbolos PYTHON registrados |
| Creación del paquete | 65891-65896 | interp_init: creación PYTHON + cache |
| Inicialización runtime | 66001-66005 | Py_Initialize en main() |
| Finalización runtime | 66308-66310 | Py_Finalize al salir |

### 15.2 Flujo de Inicialización

```
main()
  └─ python_runtime_init()
       ├─ Py_IsInitialized()? → No
       ├─ Py_Initialize()
       ├─ PyRun_SimpleString("import sys; sys.path.insert(0, '.')")
       └─ PyRun_SimpleString("import __main__")
  └─ interp_init()
       ├─ make_package_value("PYTHON") → python_package
       ├─ interp_register_package(python_package)
       ├─ strvec_push_copy("PY") → nicknames
       └─ make_hash_table_value() → python_module_cache
  └─ install_builtins()
       └─ Registrar 20 símbolos en PYTHON + bindear funciones C
```

### 15.3 Macros GIL

```c
#define PY_GIL_ENSURE()  PyGILState_STATE _py_gil = PyGILState_Ensure()
#define PY_GIL_RELEASE() PyGILState_Release(_py_gil)
```

Usan `PyGILState_Ensure`/`Release` que funcionan incluso si el GIL ya estaba
tomado (anidamiento seguro). La variable `_py_gil` se declara con ámbito de
bloque, por lo que cada par `ENSURE`/`RELEASE` debe estar en el mismo bloque C.

### 15.4 Funciones Clave del Puente

| Función | Línea | Rol |
|---------|-------|-----|
| `make_python_value` | 64425 | Crea VALUE_PYTHON desde void* |
| `python_value_is_callable` | 64433 | PyCallable_Check con caché |
| `py_bridge_check_error` | 64442 | Convierte excepción Python → string error |
| `lisp_to_python` | 64459 | Lisp Value → PyObject* |
| `python_to_lisp` | 64547 | PyObject* → Lisp Value |
| `eval_python_symbol` | 64619 | Resuelve py:xxx → módulo/builtin |
| `builtin_py_*` | 64693+ | Implementaciones de builtins py: |
| `python_runtime_init` | 65146 | Py_Initialize() |
| `python_runtime_finalize` | 65159 | Py_Finalize() |

### 15.5 Compilación Condicional

**Makefile:**
```makefile
python ?= 1
ifeq ($(python),1)
    PYTHON3_CONFIG ?= python3-config
    CFLAGS += -DLISPY_HAVE_PYTHON=1 $(shell $(PYTHON3_CONFIG) --includes)
    LDFLAGS += $(shell $(PYTHON3_CONFIG) --ldflags --embed)
endif
```

**CMakeLists.txt:**
```cmake
option(LISPY_PYTHON "Enable Python FFI support" ON)
if(LISPY_PYTHON)
    find_package(Python3 COMPONENTS Interpreter Development QUIET)
    if(Python3_FOUND)
        add_compile_definitions(LISPY_HAVE_PYTHON=1)
    endif()
endif()
```

**Compilar sin Python:** `make python=0` o `cmake .. -DLISPY_PYTHON=OFF`

---

## 16. Apéndice: Depuración

### 16.1 Descubrimiento de API Python

Usa `py:dir` y `py:help` para explorar objetos Python desde Lisp:

```lisp
;; Listar atributos de un módulo
(py:dir (py:import "math"))

;; Obtener ayuda sobre una función
(py:help (py:attr (py:import "math") "sqrt"))

;; Ver el tipo Python de un objeto
(py:type (py:import "math"))

;; Representación oficial (repr)
(py:repr (py:attr (py:import "math") "sqrt"))
```

### 16.2 Verificación de Tipos

```lisp
;; ¿Es objeto Python?
(py:python? (py:import "math"))    ;; → t
(py:python? '(1 2 3))              ;; → nil

;; ¿Es callable?
(py:callable? (py:attr (py:import "math") "sqrt"))  ;; → t
(py:callable? (py:import "math"))                    ;; → nil

;; ¿Qué tipo Lisp tiene?
(type-of (py:import "math"))       ;; → VALUE_PYTHON
(type-of (py:call (py:attr (py:import "math") "sqrt") 16))  ;; → VALUE_FLOAT
```

### 16.3 Conversión Forzada para Inspección

```lisp
;; Convertir un dict Python a hash-table Lisp para inspeccionar
(let* ((main (py:import "__main__"))
       (some_dict (py:attr main "data_dict")))
  (py:hash-table-keys (py:->lisp some_dict)))  ;; si existe

;; Convertir listas Python a listas Lisp
(let* ((py_list (py:call (py:attr (py:import "builtins") "range") 10)))
  (py:->lisp py_list))  ;; → (0 1 2 3 4 5 6 7 8 9)
```

### 16.4 Caché de Módulos

La caché `python_module_cache` es una hash-table Lisp ordinaria. Aunque no hay
API pública para inspeccionarla, puedes verificar que un módulo está cacheado
porque la segunda importación es instantánea:

```lisp
(time (py:import "math"))   ;; Primera: ~10-50ms (PyImport_Import)
(time (py:import "math"))   ;; Segunda: ~0ms (cache hit)
```

### 16.5 Errores Comunes al Depurar

1. **"not a Python object"**: El valor no está envuelto como `VALUE_PYTHON`.
   Usa `py:python?` para verificar. Si es falso, envuelve con `py:->python`.

2. **Valor numérico inesperado**: Python puede retornar `float32` de numpy que
   se convierte a `VALUE_FLOAT` correctamente, pero `int64` de numpy también es
   `PyLong` y se convierte a `VALUE_INT`. Usa `py:type` para ver el tipo Python real.

3. **Error de import**: Si `py:import "mod"` falla, verifica que el módulo esté
   instalado: `(py:run "import mod")` dará el mensaje de error Python completo.

4. **Referencias colgantes**: No almacenes `VALUE_PYTHON` en variables globales
   si podrías llamar a `py:run` con código que reinicialice el submódulo. La
   caché de módulos protege contra esto para módulos.

---

## 17. Apéndice: Librerías Lisp (`lib/`)

El directorio `lib/` contiene librerías Lisp que extienden la funcionalidad
Python desde Lisp. Se cargan con `(load "lib/nombre.lp")`.

### 17.1 `python-template.lp` — Generación de Código Python

```lisp
(load "lib/python-template.lp")
(python-template '(def square (x) (return (* x x))))
;; → "def square(x):\n    return x * x\n"
```

Convierte formas Lisp a strings de código Python con indentación correcta.
Soporta `def`, `return`, `if`/`else`, `for`/`in`, `while`, `lambda`, `:=`,
operadores aritméticos (`+`, `-`, `*`, `/`, `**`) y comparaciones (`<`, `>`,
`==`).

```lisp
(python-template '(def factorial (n)
                    (if (<= n 1)
                        (return 1)
                      (return (* n (factorial (- n 1)))))))
;; Genera código Python válido con indentación anidada
```

**Funciones exportadas:**
- `python-template form &key (indent 0)` → string
- `write-python-template form` — macro wrapper

### 17.2 `defpyfun.lp` — Funciones Python con Captura Lisp

```lisp
(load "lib/defpyfun.lp")
(let ((factor 2.5) (offset 10))
  (defpyfun 'compute '(x)
            "return (x + CAPTURED_offset) * CAPTURED_factor"
            :capture `(("factor" . ,factor) ("offset" . ,offset))))
;; → función Python compute(x) con CAPTURED_factor=2.5, CAPTURED_offset=10
```

Define funciones Python desde Lisp inyectando valores Lisp como constantes
Python vía `py:repr` y `py:->python`. Las variables capturadas se nombran
`CAPTURED_<nombre>` en el cuerpo Python.

**Funciones exportadas:**
- `defpyfun name arglist body &key capture` → callable Python

### 17.3 `sympy-bridge.lp` — Cálculo Simbólico con SymPy

```lisp
(load "lib/sympy-bridge.lp")
(let ((x (sympy-symbol "x")))
  (let ((expr (sympy-expr '(+ (expt x 2) (* 3 x) 1))))
    (py:str (sympy-derive expr x))))  ;; → "2*x + 3"
```

Convierte expresiones aritméticas Lisp a objetos SymPy, permitiendo derivación,
integración, simplificación y exportación LaTeX.

**Mapeo de operadores Lisp→SymPy:**
`+`→`Add`, `-`→`Add`+`Mul(-1)`, `*`→`Mul`, `/`→`Mul`+`Pow(-1)`,
`expt`→`Pow`, `sqrt`→`sqrt`, `sin`→`sin`, `cos`→`cos`, `log`→`log`,
`exp`→`exp`

**Funciones exportadas:**
- `sympy-symbol name` → símbolo SymPy
- `sympy-expr form` → expresión SymPy
- `sympy-derive expr var &optional n` → derivada
- `sympy-integrate expr var` → integral
- `sympy-simplify expr` → simplificación
- `sympy-latex expr` → string LaTeX
- `sympy-evalf expr` → evaluación numérica

### 17.4 `numpy-fast.lp` — Aceleración Numérica con NumPy

```lisp
(load "lib/numpy-fast.lp")
(let ((arr (numpy-array '(1 2 3 4 5))))
  (py:->lisp (numpy-sin arr)))  ;; → vectorizado: sin de cada elemento
```

Wrappers Lisp para operaciones NumPy con evaluación vectorizada.

**Funciones exportadas:**
- `numpy-array data` → array NumPy
- `numpy-arange n` → array 0..n-1
- `numpy-linspace start stop num` → array lineal
- `numpy-zeros shape` → array de ceros
- `numpy-sin arr`, `numpy-cos arr`, `numpy-exp arr`, `numpy-log arr` → ufuncs
- `numpy-sum arr &optional axis`, `numpy-mean arr` → reducciones
- `numpy-add &rest args`, `numpy-mul &rest args` → operaciones elemento a elemento
- `numpy-sub a b`, `numpy-div a b`, `numpy-pow a b` → binarias
- `numpy-sqrt a`, `numpy-neg a` → unarias

**Macro `defnp`** — Funciones con despacho automático vectorizado/escalar:

```lisp
(load "lib/numpy-fast.lp")
(defnp vec-sin (x)
  (numpy-sin x))

;; Con array NumPy → vectorizado
(vec-sin (numpy-linspace 0 3.14 5))  ;; → array([0., 0.78, 1., 0.78, 0.])

;; Con escalar → Lisp nativo (sin overhead NumPy)
(vec-sin 1.5)  ;; → sin(1.5) como float Lisp
```

`defnp` detecta en tiempo de ejecución si todos los argumentos son `VALUE_PYTHON`
(arrays NumPy) y aplica la versión vectorizada; de lo contrario usa aritmética
Lisp nativa. Esto elimina la fricción de escribir dos versiones de cada función.

### 17.5 `defmath.lp` — Macro Híbrido Simbólico/Numérico

```lisp
(load "lib/defmath.lp")
(defmath distance (x y) (sqrt (+ (expt x 2) (expt y 2))))
;; Genera: distance-sym (SymPy) y distance-num (NumPy)
```

Define una función matemática y genera automáticamente dos versiones:
- `nombre-sym`: versión simbólica (SymPy) para derivación e integración
- `nombre-num`: versión numérica (NumPy) para evaluación vectorizada rápida

```lisp
;; Uso simbólico
(let ((x (sympy-symbol "x")) (y (sympy-symbol "y")))
  (py:str (distance-sym x y)))         ;; → sqrt(x**2 + y**2)
  (py:str (sympy-derive (distance-sym x y) x)))  ;; → x/sqrt(x**2 + y**2)

;; Uso numérico
(let ((a (numpy-array '(3 4))))
  (py:->lisp (distance-num a a)))      ;; → array([4.24, 5.66])
```

**Funciones exportadas:**
- `defmath name args &rest body` — macro de definición
- `defmath-numexpr form` — conversor Lisp→NumPy (uso interno)

### 17.6 `persist.lp` — Checkpoint/Restore de Sesión

```lisp
(load "lib/persist.lp")
(py:run "x = 42; import numpy; z = numpy.array([1,2,3])")
(py:save-session "session.txt")
;; ... reiniciar LisPy ...
(py:load-session "session.txt")
;; x, z restaurados en __main__
```

Guarda y restaura el estado de variables Python en `__main__` usando pickle
con codificación hexadecimal. Las variables que comienzan con `_` se excluyen.

**Implementación:** Usa funciones helper Python `_lispy_save` y `_lispy_load`
definidas vía `py:run`. La codificación hex asegura que los blobs binarios
de pickle se almacenen como texto seguro en archivos.

**Funciones exportadas:**
- `py:save-session filename` → t
- `py:load-session filename` → t

### 17.7 `import-hooks.lp` — Transformación de AST en Importaciones

```lisp
(load "lib/import-hooks.lp")
(defun my-transform (modname ast)
  (format t "Transform: ~A~%" modname)
  ast)  ;; retornar AST modificado

(py:register-ast-hook 'my-transform)
;; Ahora todo import de .py pasa por my-transform
(py:run "import mi_modulo")  ;; AST interceptado y transformado
```

Instala un finder/loader en `sys.meta_path` que intercepta importaciones de
módulos Python, parsea el código fuente a AST, serializa el AST a una
estructura de listas Lisp, invoca la función Lisp registrada, deserializa
el AST modificado, y compila el código resultante.

**Serialización AST:** Usa encoding especial para preservar listas vacías
(`__EMPTY_LIST__`) y `None` (`__NONE__`) a través del roundtrip Lisp. Las
listas no vacías se envuelven en `__LIST__`. Los nodos AST se representan
como `[ClassName, field_pairs]`.

**Funciones exportadas:**
- `install-import-hook` → instala finder en `sys.meta_path`
- `py:register-ast-hook lisp-fn-symbol` → registra callback de transformación
- `py:remove-ast-hook` → desactiva el hook

### 17.8 `continuations.lp` — Puente de Generadores/Corutinas

```lisp
(load "lib/continuations.lp")
;; Python: g = (x * 2 for x in range(5))
(py:run "def gen(): yield 1; yield 2; yield 3; g = gen()")
(let* ((main (py:import "__main__"))
       (g (py:attr main "g")))
  (py:gen-next g))  ;; → 1
```

Funciones para interactuar con generadores y corutinas Python desde Lisp.

**Funciones exportadas:**
- `py:gen-next gen` → siguiente valor o nil
- `py:gen-send gen value` → envía valor y recibe respuesta
- `py:gen-close gen` → cierra el generador

### 17.9 `defpyclass.lp` — Clases Sincronizadas Lisp↔Python

```lisp
(load "lib/defpyclass.lp")
(defpyclass vec2d ((x :initarg :x) (y :initarg :y))
            :python-class-name "Vec2D")

(let ((v (make-vec2d :x 3 :y 4)))
  (slot-value v 'x)             ;; → 3 (Lisp)
  (py:attr (py:instance v) "x")) ;; → 3 (Python)
```

Define una clase CLOS y simultáneamente crea una clase Python equivalente.
La función factory `make-<nombre>` crea instancias pareadas: un objeto Lisp
y un objeto Python vinculados.

**Sincronización de slots:** Los initargs se transfieren a ambos lados.
La mutación manual requiere `py:%set-attr` explícito.

**Funciones exportadas:**
- `defpyclass name slots &key python-class-name python-methods` — macro
- `py:instance lisp-obj` → objeto Python asociado

---

## 18. REPL Interactivo

LisPy incluye un REPL (Read-Eval-Print Loop) interactivo con soporte
multi-línea, historial de variables REPL, manejo de señales, y comandos
integrados. El REPL se activa por defecto cuando LisPy se ejecuta sin
argumentos.

### 18.1 Iniciar el REPL

```bash
# Sin argumentos — entra al REPL automáticamente
lisPy

# Explícitamente
lisPy --repl

# Cargar archivo y luego entrar al REPL
lisPy -i script.lp
lisPy --interactive script.lp
```

| Flag | Comportamiento |
|---|---|
| `lisPy` (sin args) | Entra al REPL interactivo |
| `lisPy --repl` | Entra al REPL explícitamente |
| `lisPy -i [archivo]` | Carga el archivo y luego entra al REPL |
| `lisPy --interactive [archivo]` | Ídem |
| `lisPy archivo.lp` | Modo batch (evalúa y sale) |
| `lisPy --venv <ruta> [args]` | Usa un entorno virtual Python |
| `lisPy --help` / `-h` | Muestra ayuda de CLI |

### 18.2 Comandos del REPL

El REPL reconoce comandos especiales con el prefijo `:`:

| Comando | Descripción |
|---|---|
| `:help` | Muestra los comandos disponibles |
| `:quit` | Sale del REPL |
| `:pip <args>` | Ejecuta pip (instalar/listar paquetes Python) |

```lisp
LisPy> :help
LisPy REPL commands:
  :help        Show this help
  :quit        Exit the REPL
  :pip <args>  Run pip (e.g. :pip install numpy)

LisPy> :quit
```

### 18.3 Entrada Multi-línea

El REPL detecta automáticamente expresiones incompletas mediante balance de
paréntesis, corchetes, strings y comentarios de bloque (`#|...|#`). Cuando una
expresión no está completa, muestra un prompt de continuación `.....`:

```lisp
LisPy> (defun factorial (n)
.....   (if (<= n 1)
.....       1
.....       (* n (factorial (- n 1)))))
factorial
LisPy> (factorial 5)
120
```

### 18.4 Variables del REPL

Después de cada evaluación exitosa, el REPL actualiza las variables estándar
de Common Lisp:

| Variable | Contenido |
|---|---|
| `*` | Último resultado evaluado |
| `**` | Resultado anterior a `*` |
| `***` | Resultado anterior a `**` |
| `+` | Última forma evaluada |
| `++` | Forma anterior a `+` |
| `+++` | Forma anterior a `++` |
| `-` | Forma siendo evaluada actualmente |
| `/` | Lista de todos los valores retornados |
| `//` | Valor anterior de `/` |
| `///` | Valor anterior a `//` |

```lisp
LisPy> (+ 1 2)
3
LisPy> *
3
LisPy> (+ * 10)
13
```

### 18.5 Manejo de Errores

Los errores de evaluación no detienen el REPL — se imprime el mensaje de error
y se retorna al prompt:

```lisp
LisPy> (1 2 3)
LisPy: attempted to call non-function of type int
LisPy> (+ 1 2)
3
```

**Ctrl+C** durante una evaluación aborta la operación y retorna al prompt:

```lisp
LisPy> (loop)       ;; loop infinito
^C
Evaluation interrupted
LisPy>
```

### 18.6 Salir del REPL

El REPL soporta múltiples mecanismos de salida:

| Método | Descripción |
|---|---|
| `:quit` | Comando de REPL |
| `(quit)` | Función built-in |
| `(exit)` | Alias de `(quit)` |
| `Ctrl+D` / `Ctrl+Z` | EOF en línea vacía |
| `Ctrl+C` (doble en prompt) | Segunda interrupción sale |

### 18.7 Entornos Virtuales Python (`--venv`)

LisPy soporta entornos virtuales Python creados con `python -m venv`.
El flag `--venv` configura el runtime Python embebido para usar los
`site-packages` aislados del venv, evitando conflictos con el Python del sistema.

```bash
# Crear un venv e instalar librerías
python -m venv mi-entorno
mi-entorno\Scripts\pip install requests numpy

# Usar LisPy con ese venv
LisPy --venv mi-entorno script.lp

# En modo REPL
LisPy --venv mi-entorno --repl
```

**Cómo funciona:**
1. Lee `pyvenv.cfg` del venv para localizar el Python base (stdlib)
2. Configura `PYTHONHOME` al Python base para encontrar la stdlib
3. Configura `VIRTUAL_ENV` a la ruta absoluta del venv
4. Tras inicializar Python, ajusta `sys.prefix` y `sys.exec_prefix` al venv
5. Agrega `Lib/site-packages/` del venv a `sys.path` vía `site.addsitedir()`

Los paquetes instalados con `pip` en el venv están disponibles automáticamente:

```lisp
LisPy> (load "lib/numpy-fast.lp")
LisPy> (let ((arr (numpy-array '(1 2 3 4 5))))
         (py:->lisp (numpy-sin arr)))
;; → (0.8414 0.9092 0.1411 -0.7568 -0.9589)
```

### 18.8 Prompt y Personalización

El prompt principal es `LisPy> ` y el de continuación es `..... `. El REPL
usa `fgets` para la entrada en la versión actual (se planea integración con
line-editing para la siguiente fase: historial, flechas, tab-completion).

---

## 19. Gestión de Paquetes Python con `:pip`

LisPy incluye `pip` integrado en el runtime Python embebido. El comando `:pip`
del REPL permite instalar, listar, y gestionar paquetes Python directamente
desde el REPL, sin necesidad de línea de comandos externa.

### 19.1 Uso Básico

```lisp
;; Listar paquetes instalados
LisPy> :pip list

;; Instalar un paquete
LisPy> :pip install numpy

;; Mostrar info de un paquete
LisPy> :pip show requests

;; Desinstalar un paquete
LisPy> :pip uninstall numpy

;; Actualizar pip
LisPy> :pip install --upgrade pip
```

### 19.2 Cómo Funciona

`:pip` invoca `pip` directamente en el runtime Python embebido de LisPy:

1. **Configura** variables de entorno (`NO_COLOR=1`, `PIP_DISABLE_PIP_VERSION_CHECK=1`,
   `PIP_CACHE_DIR=%TEMP%\LisPy\pip-cache`).
2. **Captura** `sys.stdout`/`sys.stderr` con `io.StringIO()` para asegurar que la
   salida de `pip` (que usa `rich` para logging) sea visible; al finalizar, escribe
   el contenido capturado a los streams reales.
3. **Fuerza** sockets bloqueantes (subclase `_BlockingSocket`) para evitar
   `WinError 10035` en conexiones HTTPS.
4. **Construye** `sys.argv` con los argumentos del usuario.
5. **Ejecuta** `pip._internal.cli.main.main()` en el mismo proceso.

Cuando pip necesita ejecutar subprocesos (build isolation, PEP 517), invoca
`sys.executable` (`lispy.exe`) con flags de Python (`-c`, `-m`, `-I`). LisPy
detecta estos flags al inicio de `main()` y delega a `Py_BytesMain(argc, argv)`,
actuando como un intérprete Python estándar. El flag `-I` se filtra del argv
porque el build estático (`PREFIX=NULL`) necesita `PYTHONHOME` para encontrar
la librería estándar.

### 19.3 Ubicación de Paquetes

Los paquetes se instalan por defecto en el `site-packages` del sistema
(`$INSTDIR\Lib\site-packages\`). Si no hay permisos de administrador, pip
usa automáticamente el `site-packages` del usuario
(`%APPDATA%\Python\Python314\site-packages`).

```lisp
;; Verificar la ubicación desde LisPy
LisPy> (py:run "import site; print(site.getsitepackages())")
```

### 19.4 Paquetes Pre-instalados

La distribución de LisPy incluye pre-instalados:

| Paquete | Versión | Propósito |
|---|---|---|
| `pip` | 26.1.2 | Gestor de paquetes |
| `setuptools` | 82.0.1 | Build backend |
| `meson` | 1.11.1 | Build system (para paquetes Meson) |
| `meson-python` | 0.19.0 | PEP 517 backend para Meson |
| `ninja` | 1.13.0 | Build tool (wrapper Python) |
| `packaging` | 26.2 | Dependencia de meson-python |
| `pyproject-metadata` | 0.11.0 | Dependencia de meson-python |

Además, se incluye el binario `ninja.exe` en `$INSTDIR\` y se agrega al `PATH`
vía `lisPy.bat`.

### 19.5 Limitaciones Conocidas

- **Ruedas pre-compiladas:** Python 3.14 es muy reciente. Paquetes como
  `matplotlib`, `pandas`, y `scipy` no tienen wheels pre-compilados para
  `cp314-win32` aún. Intentar instalarlos descargará el fuente y requerirá
  compilación con Meson + Ninja + compilador C. `numpy` y `sympy` sí tienen
  wheels y se instalan sin compilación.
- **Salida interactiva:** El prompt de confirmación de `pip uninstall`
  (`Proceed (Y/n)?`) se captura en el buffer de `StringIO`; la respuesta del
  usuario se lee de `stdin` real. El texto del prompt aparece en la salida
  capturada después de que pip termina.
- **Red:** `pip install` requiere conexión a Internet para descargar paquetes
  desde PyPI.
- **Permisos:** Escribir en `$INSTDIR\Lib\site-packages\` requiere permisos de
  administrador en Windows. Sin admin, pip instala en el `site-packages` del
  usuario.

---

---

## 20. Patrones Avanzados: Código Python desde Lisp

### 20.1 Generación de Código con `python-template`

La librería `python-template.lp` permite escribir código Python usando sintaxis
Lisp y convertirlo a strings ejecutables. Combinado con `py:run`, se obtiene un
equivalente al macro `pythonic` propuesto en la visión del proyecto:

```lisp
(load "lib/python-template.lp")

;; Escribir Python con paréntesis
(let ((code (python-template
             '(def fib (n)
                (if (<= n 1)
                    (return n)
                  (return (+ (fib (- n 1)) (fib (- n 2)))))))))
  (py:run code)                     ;; ejecuta la definición
  (let ((fib-fn (py:attr (py:import "__main__") "fib")))
    (py:call fib-fn 10)))           ;; → 55
```

**Patrón `pythonic` wrapper:**

```lisp
(defmacro pythonic (&rest forms)
  `(py:run (python-template ',@forms)))

(pythonic
 (def square (x)
   (return (* x x))))

(py:call (py:attr (py:import "__main__") "square") 5)  ;; → 25
```

### 20.2 Plantillas con Interpolación (Quasiquoting)

Combinando `python-template` con `defpyfun`, se pueden generar funciones Python
con valores Lisp interpolados en tiempo de definición:

```lisp
(let ((factor 3.1416)
      (offset 10))
  (defpyfun 'scale '(x)
            "return x * CAPTURED_factor + CAPTURED_offset"
            :capture `(("factor" . ,factor) ("offset" . ,offset))))

(py:call (py:attr (py:import "__main__") "scale") 5)  ;; → 25.708
```

Esto es equivalente a la idea `defpyfun` del documento de ideas — la función
Python captura variables del entorno Lisp como constantes.

### 20.3 Generación de Código Numérico con Numba

Para bucles intensivos, `python-template` puede generar funciones decoradas con
`@numba.jit`:

```lisp
(pythonic
 (def heavy-loop (n)
   (let ((total 0))
     (for i (range n)
       (for j (range n)
         (:= total (+ total (* i j)))))
     (return total))))

;; Envolver con numba:
(py:run "import numba
@numba.jit(nopython=True)
" + (python-template '...))
```

---

## 21. Matemáticas Híbridas: Simbólico + Numérico

Este patrón, inspirado en el proyecto *Hybrid Symbolic-Numeric Mathematics
Workbench* de `docs/ideas.md`, está implementado en las librerías `defmath.lp`,
`sympy-bridge.lp`, y `numpy-fast.lp`.

### 21.1 El Macro `defmath`

`defmath` genera automáticamente dos variantes de una función matemática:

```lisp
(load "lib/defmath.lp")
(defmath distancia (x y) (sqrt (+ (expt x 2) (expt y 2))))
;; Crea: distancia-sym + distancia-num
```

| Variante | Motor | Uso |
|----------|-------|-----|
| `nombre-sym` | SymPy (simbólico) | Derivar, integrar, simplificar, LaTeX |
| `nombre-num` | NumPy (numérico) | Evaluación vectorizada, millones de puntos |

### 21.2 Derivación Simbólica

```lisp
(let ((x (sympy-symbol "x"))
      (y (sympy-symbol "y")))
  ;; Expresión original
  (py:str (distancia-sym x y))              ;; → sqrt(x**2 + y**2)
  ;; Derivada parcial ∂/∂x
  (py:str (sympy-derive (distancia-sym x y) x))) ;; → x/sqrt(x**2 + y**2)
  ;; LaTeX
  (sympy-latex (distancia-sym x y)))        ;; → \sqrt{x^{2} + y^{2}}
```

### 21.3 Evaluación Numérica Vectorizada

```lisp
;; Crear arrays de 1 millón de puntos
(let* ((xs (numpy-linspace 0 3.14 1000000))
       (ys (numpy-linspace 0 3.14 1000000)))
  (py:->lisp (numpy-sum (distancia-num xs ys))))
;; → Evaluado en milisegundos (vectorizado)
```

### 21.4 Flujo de Trabajo Híbrido

1. **Definir** la función una sola vez con `defmath`
2. **Derivar** simbólicamente con la variante `-sym`
3. **Evaluar** numéricamente con la variante `-num`
4. **Visualizar** con matplotlib desde Python

```lisp
;; Ejemplo: dinámica de robot 2-DOF
(load "lib/defmath.lp")
(load "lib/sympy-bridge.lp")

;; 1. Derivar ecuaciones de movimiento con SymPy
(py:run "
import sympy as sp
th1, th2 = sp.symbols('th1 th2')
th1d, th2d = sp.symbols('th1d th2d')
m1=m2=l1=l2=1; g=9.81

T = 0.5*m1*l1**2*th1d**2 + 0.5*m2*(l1**2*th1d**2 + l2**2*(th1d+th2d)**2
     + 2*l1*l2*th1d*(th1d+th2d)*sp.cos(th2))
V = -m1*g*l1*sp.cos(th1) - m2*g*(l1*sp.cos(th1) + l2*sp.cos(th1+th2))

M = sp.simplify(sp.Matrix([[sp.diff(sp.diff(T, th1d), th1d),
                             sp.diff(sp.diff(T, th1d), th2d)],
                            [sp.diff(sp.diff(T, th2d), th1d),
                             sp.diff(sp.diff(T, th2d), th2d)]]))
G = sp.simplify(sp.Matrix([sp.diff(V, th1), sp.diff(V, th2)]))

_M = sp.lambdify((th1,th2), M, 'numpy')
_G = sp.lambdify((th1,th2), G, 'numpy')

def robot_dyn(t, s):
    qdd = np.linalg.solve(_M(s[0],s[1]), -_G(s[0],s[1]).flatten())
    return [s[2], s[3], qdd[0], qdd[1]]
")

;; 2. Simular con scipy
(py:run "
from scipy.integrate import solve_ivp
sol = solve_ivp(robot_dyn, (0,10), [np.pi/2,0,0,0],
                t_eval=np.linspace(0,10,200))
")

;; 3. Graficar con matplotlib
(py:run "
import matplotlib.pyplot as plt
plt.plot(sol.t, sol.y[0]); plt.savefig('robot.png')
")
```

### 21.5 `defnp` para Despacho Automático

El macro `defnp` de `numpy-fast.lp` permite escribir funciones que funcionan
tanto con escalares como con arrays:

```lisp
(load "lib/numpy-fast.lp")
(defnp mi-funcion (x y)
  (numpy-sqrt (numpy-add (numpy-mul x x) (numpy-mul y y))))

;; Escalar → aritmética Lisp
(mi-funcion 3 4)   ;; → 5.0

;; Arrays → vectorizado NumPy
(mi-funcion (numpy-array '(1 2 3)) (numpy-array '(4 5 6)))
;; → array([4.123, 5.385, 6.708])
```

---

## 22. Puente de Corutinas: Lisp ↔ Python

La librería `continuations.lp` + los builtins `py:gen-next`/`py:gen-send`
permiten entrecruzar flujos de ejecución entre Lisp y Python:

### 22.1 Consumir Generadores Python desde Lisp

```lisp
(load "lib/continuations.lp")
(py:run "def squares(n):
    for i in range(n):
        yield i * i

g = squares(5)")

(let* ((main (py:import "__main__"))
       (g (py:attr main "g")))
  (loop for val = (py:gen-next g)
        while val
        collect (py:->lisp val)))
;; → (0 1 4 9 16)
```

### 22.2 Corutinas con `send`

```lisp
;; Una corutina Python que recibe valores de Lisp
(py:run "def accumulator():
    total = 0
    while True:
        x = yield total
        if x is None: break
        total += x

acc = accumulator()
acc.send(None)  # iniciar
")

(let* ((main (py:import "__main__"))
       (acc (py:attr main "acc")))
  (py:gen-send acc 10)   ;; → 10
  (py:gen-send acc 25)   ;; → 35
  (py:gen-send acc 5))   ;; → 40
```

### 22.3 Callbacks Lisp desde Python

```lisp
(defun mi-transform (x)
  (* x 2))

(py:register-callback 'mi-transform)

;; Python puede llamar a Lisp:
(py:run "result = builtins.mi_transform_cb(21)")
(py:attr (py:import "__main__") "result")  ;; → 42
```

---

## 23. Transformación de AST en Importaciones

El sistema de hooks de `import-hooks.lp` permite interceptar y modificar el
AST de cualquier módulo Python al ser importado:

```lisp
(load "lib/import-hooks.lp")

;; Callback que convierte bucles for en comprehensions
(defun loop-to-comprehension (modname ast)
  (format t "Transformando: ~A~%" modname)
  ;; ast es una lista Lisp que representa el AST de Python
  ;; (modificar y retornar)
  ast)

(py:register-ast-hook 'loop-to-comprehension)
(py:run "import mi_modulo")  ;; pasa por el callback
(py:remove-ast-hook)
```

**Serialización del AST:** Cada nodo `ast.AST` se convierte a `[ClassName,
[[field, value], ...]]`. Listas vacías → `__EMPTY_LIST__`, `None` → `__NONE__`,
listas no vacías → `["__LIST__", [...]]`. Esto permite manipular el árbol
completo con funciones Lisp (`mapcar`, `remove-if`, pattern matching).

---

## 24. Persistencia de Sesión: Checkpoint/Restore

`persist.lp` serializa todas las variables de `__main__` (incluyendo objetos
Python como arrays NumPy o modelos entrenados) a disco usando pickle:

```lisp
(load "lib/persist.lp")

;; Entrenar un modelo
(py:run "
import numpy as np
model = {'weights': np.random.randn(100, 50), 'bias': np.zeros(50)}
data = np.arange(1000)
")

(py:save-session "checkpoint.txt")  ;; guarda model + data

;; --- reiniciar LisPy ---

(py:load-session "checkpoint.txt")  ;; restaura model + data
(py:attr (py:import "__main__") "model")  ;; recuperado
```

Las variables que empiezan con `_` se excluyen. Objetos no pickleables
(generadores, sockets, file handles) se omiten silenciosamente.

---

## 25. Clases Sincronizadas Lisp ↔ Python

`defpyclass.lp` crea simultáneamente una clase CLOS y una clase Python vinculadas:

```lisp
(load "lib/defpyclass.lp")

(defpyclass point ((x :initarg :x) (y :initarg :y))
          :python-class-name "Point")

;; Crear instancia dual
(let ((p (make-point :x 3 :y 4)))
  ;; Lado Lisp
  (slot-value p 'x)              ;; → 3
  ;; Lado Python
  (py:attr (py:instance p) "x")) ;; → 3

;; Mutación en Python se refleja en Lisp
(py:%set-attr (py:instance p) "x" 99)
(py:attr (py:instance p) "x")    ;; → 99
```

La función factory `make-<nombre>` acepta `:initarg`s y los transfiere a ambos
lados. El slot `py-instance` almacena la referencia al objeto Python.

---

*Documentación de interoperabilidad LisPy + Python — Junio 2026*
