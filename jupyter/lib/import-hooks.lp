;;; import-hooks.lp — Python AST import hooks

(defun install-import-hook ()
  "Install sys.meta_path finder/loader that passes AST to Lisp callbacks."
  (py:run
   "import sys, builtins, importlib.util, ast

class _LispyLoader:
    def __init__(self, origin, fullname):
        self.origin = origin
        self.fullname = fullname
    def create_module(self, spec):
        return None
    def exec_module(self, module):
        f = open(self.origin, 'r')
        source = f.read()
        f.close()
        tree = ast.parse(source)
        cb = builtins.__dict__.get('_lispy_ast_callback')
        if cb:
            s = _serialize(tree)
            builtins._lispy_ast_hook_active = False
            m = cb(self.fullname, s)
            builtins._lispy_ast_hook_active = True
            if m is not None:
                tree = _deserialize(m)
                ast.fix_missing_locations(tree)
        code = compile(tree, self.origin, 'exec')
        exec(code, module.__dict__)
    def get_filename(self, f):
        return self.origin

def _serialize(node):
    if isinstance(node, ast.AST):
        return [node.__class__.__name__,
                _serialize([(f, _serialize(getattr(node, f, None))) for f in node._fields])]
    elif isinstance(node, list):
        if not node:
            return '__EMPTY_LIST__'
        return ['__LIST__', [_serialize(x) for x in node]]
    elif node is None:
        return '__NONE__'
    else:
        return node

def _deserialize(data):
    if data == '__EMPTY_LIST__':
        return []
    if data == '__NONE__':
        return None
    if isinstance(data, list) and len(data) >= 1 and isinstance(data[0], str):
        if data[0] == '__LIST__':
            if len(data) >= 2:
                return [_deserialize(x) for x in data[1]]
            return []
        if len(data) == 2:
            cls = getattr(ast, data[0], None)
            if cls and issubclass(cls, ast.AST):
                field_pairs = _deserialize(data[1])
                field_vals = {}
                if isinstance(field_pairs, list):
                    for pair in field_pairs:
                        if isinstance(pair, list) and len(pair) == 2:
                            field_vals[pair[0]] = _deserialize(pair[1])
                args = []
                for f in cls._fields:
                    if f in field_vals:
                        args.append(field_vals[f])
                    elif f in ('type_ignores','type_params','body','args','keywords',
                               'defaults','decorator_list','bases','handlers','names',
                               'targets','orelse','finalbody','values','elts','generators','items'):
                        args.append([])
                    elif f in ('type_comment','returns','kind','ctx'):
                        args.append(None)
                    else:
                        args.append(None)
                if issubclass(cls, ast.stmt):
                    pass  # Python 3.14: no lineno/col_offset in constructors
                try:
                    return cls(*args)
                except TypeError:
                    return None
    if isinstance(data, list):
        return [_deserialize(x) for x in data]
    return data

class _LispyFinder:
    def find_spec(self, fullname, path, target=None):
        if not builtins.__dict__.get('_lispy_ast_hook_active', False):
            return None
        if fullname in sys.modules:
            return None
        import importlib.util as _u
        try:
            spec = _u.find_spec(fullname, path)
        except Exception:
            return None
        if spec is None or spec.origin is None or not spec.origin.endswith('.py'):
            return None
        spec.loader = _LispyLoader(spec.origin, fullname)
        return spec

sys.meta_path.insert(0, _LispyFinder())
builtins._lispy_ast_hook_active = False
builtins._lispy_ast_finder_installed = True
")
  t)

(defun py:register-ast-hook (lisp-fn-symbol)
  "Register a Lisp function as an AST transform callback."
  (py:register-callback lisp-fn-symbol)
  (let* ((fn-name (write-to-string lisp-fn-symbol))
         (py-name ""))
    (dotimes (i (length fn-name))
      (let ((ch (char fn-name i)))
        (if (char= ch #\-)
            (setf py-name (concatenate 'string py-name "_"))
          (setf py-name (concatenate 'string py-name (string ch))))))
    (py:run (concatenate 'string
                         "import builtins; builtins._lispy_ast_callback = builtins."
                         py-name "_cb; builtins._lispy_ast_hook_active = True"))
    t))

(defun py:remove-ast-hook ()
  "Disable the AST import hook."
  (py:run "import builtins; builtins._lispy_ast_hook_active = False")
  t)

(install-import-hook)
