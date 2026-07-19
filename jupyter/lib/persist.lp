;;; persist.lp — Session save/restore for Python objects

(defvar *persist-init* nil)

(defun persist-init ()
  (unless *persist-init*
    (setf *persist-init* t)
    (py:run
     "import pickle, sys
def _lispy_save(filepath):
    f = open(filepath, 'w')
    m = sys.modules.get('__main__')
    ct = 0
    if m:
        for k, v in list(m.__dict__.items()):
            if k.startswith('_'): continue
            try:
                d = pickle.dumps(v).hex()
                f.write(k + '|' + d + chr(10))
                ct += 1
            except: pass
    f.close()
    return ct

def _lispy_load(filepath):
    ct = 0
    try:
        f = open(filepath, 'r')
        m = sys.modules.get('__main__')
        for line in f:
            parts = line.strip().split('|', 1)
            if len(parts) == 2:
                try:
                    obj = pickle.loads(bytes.fromhex(parts[1]))
                    m.__dict__[parts[0]] = obj
                    ct += 1
                except: pass
        f.close()
    except: pass
    return ct
")))

(defun py:save-session (filename)
  (persist-init)
  (let* ((main (py:import "__main__"))
         (fn (py:attr main "_lispy_save"))
         (ct (py:call fn filename)))
    t))

(defun py:load-session (filename)
  (persist-init)
  (let* ((main (py:import "__main__"))
         (fn (py:attr main "_lispy_load"))
         (ct (py:call fn filename)))
    t))
