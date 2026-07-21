# LisPy <sup>v1.1.0</sup>

<p align="center">
  <img src="icon.png" alt="LisPy Logo" width="200">
</p>

Complete ANSI Common Lisp interpreter implemented as a single portable C file with an embedded **CPython FFI bridge** — call Python from Lisp and Lisp from Python in the same process.

## Features

- **Core ANSI Common Lisp** — defun, defmacro, defclass, defgeneric, defmethod, CLOS, conditions/restarts, pretty printer, packages, structures, reader macros
- **FASL compiler** — compile to bytecode format, load and evaluate `.fasl` files
- **Python FFI** — import modules, call functions, access attributes, transparent `py:` prefix, bidirectional type conversion
- **`@` reader macro** — compact Python chain syntax: `@math:sqrt(16)` → `4.0`, `@numpy:array('(1 2 3))` → NumPy array. Legacy `#_` form also supported.
- **Lisp libraries** (`lib/`) — hybrid symbolic/numeric math, NumPy/SymPy bridges, Python code generation, session persistence, AST import hooks, coroutine bridge, synchronized CLOS↔Python classes
- **REPL** — interactive read-eval-print loop with `:pip` integration, multi-line input, and virtual environment support (`--venv`)
- **Jupyter Kernel** — interactive notebooks with syntax highlighting, persistent state across cells, auto-loaded core libraries
- **VS Code Extension** (`lp-language/`) — syntax highlighting, bracket matching, embedded Python support for `.lp` files
- **Test Suite** — 191 tests across 3 categories: ANSI CL conformance (`cl/`), integration & FFI (`lispy-test/`), QA & regression (`qa/`)
- **Cross-platform** — Windows, Linux, and WSL. Single-file C99, no external dependencies except optional Python
- **Native FFI** — call C shared libraries via Python ctypes (`lib/ffi.lp`), supports `.so` (Linux), `.dll` (Windows)

## Quick Start

```bash
# Build
cmake -B build && cmake --build build --config Release

# REPL
./bin/lispy

# Run a file
./bin/lispy examples/hello.lp

# With Python virtual environment
./bin/lispy --venv ./venv

# Jupyter kernel
cd jupyter && python install.py
jupyter notebook LisPy-Demo.ipynb
```

## What Can It Do

```lisp
;; Python chain with @ reader macro
@math:sqrt(16)           ;; → 4.0
@math:pi                 ;; → 3.14159...
@os:path:join("a" "b")  ;; → "a/b"

;; Call Python functions via py: prefix
(py:import "math")
(py:print (* @math:pi 2))

;; Transparent Python builtins
(py:abs -42)             ;; → 42
(py:sum '(1 2 3 4 5))   ;; → 15

;; Vectorized NumPy from Lisp
(load "lib/numpy-fast.lp")
(let ((arr (numpy-array '(1 2 3 4 5))))
  (py:->lisp (numpy-sin arr)))

;; Symbolic math with SymPy
(load "lib/sympy-bridge.lp")
(let ((x (sympy-symbol "x")))
  (py:str (sympy-derive (sympy-expr '(+ (expt x 2) (* 3 x) 1)) x)))
;; → "2*x + 3"

;; Hybrid symbolic/numeric functions
(load "lib/defmath.lp")
(defmath distance (x y) (sqrt (+ (expt x 2) (expt y 2))))
;; Creates distance-sym (SymPy) and distance-num (NumPy) automatically

;; Generate Python code from Lisp
(load "lib/python-template.lp")
(python-template '(def fib (n) (if (<= n 1) (return n) (return (+ (fib (- n 1)) (fib (- n 2)))))))

;; Coroutine bridge: Python generators ↔ Lisp
(load "lib/continuations.lp")
(py:run "def gen(): yield 1; yield 2; yield 3")
(py:gen-next (py:attr (py:import "__main__") "gen"))  ;; → 1

;; Session persistence
(load "lib/persist.lp")
(py:run "x = 42; import numpy; data = numpy.array([1,2,3])")
(py:save-session "checkpoint.txt")
;; ... restart LisPy ...
(py:load-session "checkpoint.txt")  ;; x and data restored
```

## VS Code Extension

The `lp-language/` directory contains a VS Code extension providing syntax highlighting for `.lp` files.

**Install from local folder:**

1. Open VS Code
2. Press `Ctrl+Shift+P` → **Extensions: Install from VSIX...**
   (or type `Developer: Install Extension from Location...`)
3. Navigate to and select the `lp-language/` folder
4. Reload VS Code when prompted

**Or via command line:**

```bash
cp -r lp-language ~/.vscode/extensions/lp-language
```

Features: Lisp keyword/function coloring, Python embedded code highlighting, bracket matching, block comment support (`#|...|#`), `@` reader macro highlighting.

## Test Suite

The test suite contains **191 tests** across three directories:

```bash
# Run all tests (requires Python 3 with numpy, sympy, pandas, matplotlib, scipy)
python3 test/run_tests.py

# Quick conformance check (pure Lisp, no Python)
for f in test/cl/*.lp; do ./bin/lispy "$f"; done
```

**Test categories:**

| Directory | Count | Description |
|-----------|-------|-------------|
| `test/cl/` | 90 | ANSI Common Lisp examples — arithmetic, lists, functions, macros, CLOS, structures, hash tables, iteration |
| `test/lispy-test/` | 41 | Integration & algorithm tests — NumPy, SymPy, Matplotlib, Pandas, SciPy, FFI, pure Lisp algorithms |
| `test/qa/` | 60 | Quality assurance — hybrid code, edge cases, regression tests, string handling, reader macros |

Tests that depend on Python libraries use `--venv` and require packages listed in `test/requirements.txt`:

```bash
# Set up test environment
python3 -m venv venv
source venv/bin/activate   # or: venv\Scripts\activate on Windows
pip install -r test/requirements.txt

# Run all tests through the runner
python3 test/run_tests.py
```

The runner automatically skips platform-specific tests (e.g., `ffi_linux.lp` on Windows, `ffi_win.lp` on Linux).

## Project Structure

```
LisPy/
├── docs/
│   ├── LisPy-Reference.md    # Python FFI reference, API docs, type conversion
│   └── LisPy-Handbook/       # Comprehensive handbook (LaTeX + Markdown)
├── jupyter/
│   ├── lisPy_kernel/         # IPython kernel implementation
│   ├── lib/                  # Kernel-side Python utilities
│   ├── LisPy-Demo.ipynb      # Interactive demo notebook
│   └── install.py            # Kernel installer
├── lib/                      # Lisp standard library (.lp files)
│   ├── ffi.lp                # Python ctypes FFI bridge (C shared libraries)
│   ├── defmath.lp            # Hybrid symbolic/numeric math
│   ├── defpyfun.lp           # Python function wrappers
│   ├── defpyclass.lp         # Python class wrappers
│   ├── numpy-fast.lp         # NumPy acceleration
│   ├── sympy-bridge.lp       # SymPy symbolic math
│   ├── python-template.lp    # Python code generation
│   ├── continuations.lp      # Coroutine bridge
│   ├── persist.lp            # Session checkpoint/restore
│   └── quicklisp-compat.lp   # Quicklisp compatibility layer
├── lp-language/              # VS Code language extension
│   └── syntaxes/             # TextMate grammars
├── test/
│   ├── run_tests.py          # Automated test runner
│   ├── requirements.txt      # Python dependencies for tests
│   ├── advanced/             # Generated test output (images)
│   ├── cl/                   # 90 ANSI Common Lisp examples
│   ├── lispy-test/           # 41 integration & algorithm tests
│   └── qa/                   # 60 QA & regression tests
├── lispy.c                   # Main interpreter (single-file C99, ~70K LOC)
├── lispy.rc                  # Windows resource file
├── CMakeLists.txt            # Build configuration
├── LICENSE.txt               # Apache License 2.0
├── VERSION                   # Semantic version
└── README.md
```

`build/` and `bin/` directories are generated by CMake during compilation.

## Changelog

### v1.1.0

- **Fix:** `load` now correctly handles files ending with comments (trailing comment after last form no longer causes silent failure)
- **Fix:** REPL no longer hangs on Windows interactive console (removed spurious `GetNumberOfConsoleInputEvents` check in interactive path)
- **Fix:** `@*variable*` reader macro resolves Lisp special variables correctly (string-to-symbol conversion in `py:%chain`)
- **Fix:** `(load ...)` crash on WSL/Linux caused by `realpath()` on cross-mounted filesystem paths
- **Fix:** stdin restored to text mode on Windows alongside stdout (Python init may set binary mode)
- **Test suite:** reorganized into `cl/`, `lispy-test/`, `qa/` with consistent naming (`alg_*`, `py_*`, `ffi_*`)
- **Test runner:** added `test/run_tests.py` with automatic platform detection, `PYTHONHOME` cleanup, and skip lists
- **Test dependencies:** added `test/requirements.txt` (numpy, sympy, pandas, matplotlib, scipy)

## Author

**Oscar Riveros** — 2026

## Documentation

- `docs/LisPy-Reference.md` — Complete Python FFI reference, type conversion tables, API docs, advanced patterns
- `docs/LisPy-Handbook/` — Comprehensive handbook (81 sections, 390+ examples, 120 competitive programming problems)
- `lib/` — Lisp library source code with inline documentation
- `jupyter/LisPy-Demo.ipynb` — Interactive notebook with 16 sections covering all LisPy features

## Jupyter Kernel

LisPy includes a Jupyter kernel for interactive notebooks:

```bash
cd jupyter
python install.py         # --user or --sys-prefix for system-wide
jupyter notebook LisPy-Demo.ipynb
```

The kernel auto-loads core libraries (`ffi`, `continuations`, `defpyfun`, `defpyclass`, `python-template`, `persist`) on startup. Heavy libraries (`numpy-fast`, `sympy-bridge`, `defmath`) are loaded on demand in their respective notebook sections.

## License

Copyright (c) 2026 Oscar Riveros. Licensed under the Apache License, Version 2.0.

LisPy links against CPython at runtime via dynamic FFI (`python3.dll` on Windows, `libpython3.so` on Linux/macOS). Python is **not bundled, distributed, or statically linked** with LisPy — it must be installed separately by the user. Because no Python code or binaries are included in this project, the Python Software Foundation License does not apply to LisPy itself. See `LICENSE.txt` for full terms.
