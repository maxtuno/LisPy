;;; ffi.lp — Native FFI via Python ctypes
;;; Carga DLLs/.so/.dylib sin recompilar LisPy.
;;;
;;; Uso (todas las funciones en una sola forma):
;;;
;;;   (load "lib/ffi.lp")
;;;
;;;   (ffi:with-ffi "msvcrt.dll"
;;;     (c-sqrt :double (:double) "sqrt")
;;;     (c-sin  :double (:double) "sin")
;;;     (c-cos  :double (:double) "cos")
;;;     (c-pow  :double (:double :double) "pow")
;;;     (c-abs  :int (:int) "abs"))
;;;
;;;   (print (c-sqrt 64.0))
;;;   (print (c-pow 2.0 10.0))
;;;
;;; Para llamadas unicas sin definir funcion:
;;;   (ffi:call "sqrt" :double '(:double) 64.0)
;;;
;;; Tipos soportados:
;;;   :void :bool :char :byte :short :ushort :int :uint
;;;   :long :ulong :longlong :ulonglong :float :double
;;;   :pointer :string :wstring

(defpackage :ffi
  (:use :common-lisp)
  (:export :with-ffi :call
           :void :bool :char :byte :short :ushort
           :int :uint :long :ulong :longlong :ulonglong
           :float :double :pointer :string :wstring))

(in-package :ffi)

(defun %init ()
  (unless (boundp '*ctypes*)
    (defvar *ctypes* (py:import "ctypes"))
    (py:run
     "import ctypes as _ct

_ct_type_map = {
    'void': None,
    'bool': _ct.c_bool,
    'char': _ct.c_char,
    'byte': _ct.c_byte,
    'short': _ct.c_short,
    'ushort': _ct.c_ushort,
    'int': _ct.c_int,
    'uint': _ct.c_uint,
    'long': _ct.c_long,
    'ulong': _ct.c_ulong,
    'longlong': _ct.c_longlong,
    'ulonglong': _ct.c_ulonglong,
    'float': _ct.c_float,
    'double': _ct.c_double,
    'pointer': _ct.c_void_p,
    'string': _ct.c_char_p,
    'wstring': _ct.c_wchar_p,
}

def _ffi_get_type(kw):
    if isinstance(kw, list):
        base = _ffi_get_type(kw[0])
        return _ct.POINTER(base) if base is not None else _ct.c_void_p
    return _ct_type_map.get(kw, _ct.c_void_p)

def _ffi_setup_func(lib_handle, func_name, restype_str, argtypes_list):
    func = getattr(lib_handle, func_name)
    func.restype = _ffi_get_type(restype_str)
    func.argtypes = [_ffi_get_type(a) for a in argtypes_list] if argtypes_list else None
    return func
")))

(defun %kw->str (kw)
  (string-downcase (symbol-name kw)))

(defun %call-func (func-sym args)
  (let ((f (symbol-value func-sym)))
    (case (length args)
      (0 (py:call f))
      (1 (py:call f (py:->python (first args))))
      (2 (py:call f (py:->python (first args)) (py:->python (second args))))
      (3 (py:call f (py:->python (first args)) (py:->python (second args)) (py:->python (third args))))
      (4 (py:call f (py:->python (first args)) (py:->python (second args)) (py:->python (third args)) (py:->python (fourth args))))
      (5 (py:call f (py:->python (first args)) (py:->python (second args)) (py:->python (third args)) (py:->python (fourth args)) (py:->python (fifth args))))
      (t (error "ffi: max 5 args")))))

(defmacro with-ffi (lib-path &rest func-specs)
  "Carga una DLL y define funciones Lisp wrappers.
   Cada func-spec: (nombre-lisp tipo-retorno (tipos-arg...) [nombre-nativo])
   Ejemplo:
     (ffi:with-ffi \"msvcrt.dll\"
       (c-sqrt :double (:double) \"sqrt\")
       (c-sin  :double (:double) \"sin\"))"
  (let ((var-defs nil)
        (setup-forms nil)
        (fun-defs nil))
    (dolist (spec func-specs)
      (let* ((lisp-name (first spec))
             (native (let ((r (if (>= (length spec) 4) (fourth spec) nil)))
                       (if (stringp r) r (string-downcase (symbol-name lisp-name)))))
             (restype (second spec))
             (argtypes (third spec))
             (var-sym (intern (format nil "FFI-FUNC-~a" native) :ffi))
             (restype-str (%kw->str restype))
             (argtype-strs (mapcar #'%kw->str argtypes)))
        (push `(defvar ,var-sym nil) var-defs)
        (push `(setf ,var-sym
                     (py:call (py:attr _main "_ffi_setup_func")
                              _lib ,native
                              ,restype-str
                              (py:->python (list ,@argtype-strs))))
              setup-forms)
        (push `(defun ,lisp-name (&rest args)
                 (ffi::%call-func ',var-sym args))
              fun-defs)))
    `(progn
       (ffi::%init)
       ,@(nreverse var-defs)
       (let ((_lib (py:call (py:attr ffi::*ctypes* "CDLL") ,lib-path))
             (_main (py:import "__main__")))
         ,@(nreverse setup-forms))
       ,@(nreverse fun-defs)
       (values))))

(defun call (lib-path func-name restype argtypes &rest args)
  "Llama una funcion nativa directamente, sin definir un wrapper.
   (ffi:call \"msvcrt.dll\" \"sqrt\" :double '(:double) 64.0)"
  (%init)
  (let* ((ctypes (py:import "ctypes"))
         (lib (py:call (py:attr ctypes "CDLL") lib-path))
         (main (py:import "__main__"))
         (restype-str (%kw->str restype))
         (argtype-strs (mapcar #'%kw->str argtypes))
         (func (py:call (py:attr main "_ffi_setup_func")
                        lib func-name
                        restype-str
                        (py:->python argtype-strs))))
    (case (length args)
      (0 (py:call func))
      (1 (py:call func (py:->python (first args))))
      (2 (py:call func (py:->python (first args)) (py:->python (second args))))
      (3 (py:call func (py:->python (first args)) (py:->python (second args)) (py:->python (third args))))
      (4 (py:call func (py:->python (first args)) (py:->python (second args)) (py:->python (third args)) (py:->python (fourth args))))
      (5 (py:call func (py:->python (first args)) (py:->python (second args)) (py:->python (third args)) (py:->python (fourth args)) (py:->python (fifth args))))
      (t (error "ffi: call: max 5 args")))))

(provide :ffi)
