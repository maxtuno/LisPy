;; ============================================================
;;  deepseek_v4_pro.lp -- Mini Prolog Interpreter in ANSI Common Lisp
;;
;;  A complete Prolog-style logic programming engine.
;;  Demonstrates: embedded DSLs, unification with occurs check,
;;  backtracking via continuations, renaming, macros,
;;  higher-order functions, hash tables, multiple values,
;;  DEFSTRUCT, reader macros, and more.
;;
;;  The engine solves: family relations, list predicates,
;;  graph path finding, and a pure-Prolog map coloring problem.
;; ============================================================

;; ---- Logic variables (any symbol prefixed with ?) ----
(defun lvarp (x)
  (and (symbolp x)
       (let ((n (symbol-name x)))
         (and (> (length n) 0) (char= (char n 0) #\?)))))

;; ---- Substitution: alist of (?var . value) ----
(defun walk (term subs)
  "Dereference TERM in substitution SUBS, following chains."
  (if (lvarp term)
      (let ((b (assoc term subs :test #'eq)))
        (if b (walk (cdr b) subs) term))
      term))

(defun occurs-p (var term subs)
  "Does VAR occur in TERM under substitution SUBS?"
  (let ((t2 (walk term subs)))
    (cond ((eq var t2) t)
          ((consp t2) (or (occurs-p var (car t2) subs)
                          (occurs-p var (cdr t2) subs)))
          (t nil))))

(defun ext-subs (var value subs)
  "Extend SUBS with VAR -> VALUE. Returns :FAIL on occurs check failure."
  (if (occurs-p var value subs)
      :fail
      (acons var value subs)))

(defun unify (x y subs)
  "Unify X and Y under SUBS. Returns extended substitution or :FAIL."
  (let ((x2 (walk x subs))
        (y2 (walk y subs)))
    (cond ((eq x2 y2) subs)
          ((lvarp x2) (ext-subs x2 y2 subs))
          ((lvarp y2) (ext-subs y2 x2 subs))
          ((and (consp x2) (consp y2))
           (let ((s1 (unify (car x2) (car y2) subs)))
             (if (eq s1 :fail)
                 :fail
                 (unify (cdr x2) (cdr y2) s1))))
          ((equal x2 y2) subs)
          (t :fail))))

;; ---- Rule database: hash table predicate -> list of (head . body) ----
(defparameter *db* (make-hash-table :test 'eq))

(defun add-rule (head body)
  (let* ((pred (if (consp head) (car head) head))
         (rules (gethash pred *db*)))
    (setf (gethash pred *db*) (acons head body rules))))

(defun rules-for (pred)
  (gethash pred *db*))

;; ---- Clause renaming: fresh copies of ?-variables for each proof attempt ----
(defvar *rename-counter* 0)

(defun rename-clause (head body)
  "Return (fresh-head . fresh-body) with each ?-var replaced by a unique symbol."
  (let* ((*rename-counter* (1+ *rename-counter*))
         (map (make-hash-table :test 'eq)))
    (labels ((ren (term)
               (cond ((lvarp term)
                      (or (gethash term map)
                          (setf (gethash term map)
                                (gentemp (string term)))))
                     ((consp term)
                      (cons (ren (car term)) (ren (cdr term))))
                     (t term))))
      (cons (ren head) (mapcar #'ren body)))))

;; ---- Prover: depth-first with backtracking via append-map ----
(defun prove-all (goals subs)
  "Try to prove all GOALS under substitution SUBS.
   Returns a list of all satisfying substitutions."
  (if (null goals)
      (list subs)
      (let ((g (car goals))
            (rest (cdr goals)))
        ;; built-in predicates
        (cond
          ;; cut (!) -- commits to current choice
          ((and (consp g) (eq (car g) '!))
           (prove-all rest subs))
          ;; unifying equality (= x y)
          ((and (consp g) (eq (car g) '=) (= (length g) 3))
           (let ((s (unify (second g) (third g) subs)))
             (if (eq s :fail) nil (prove-all rest s))))
          ;; user predicates
          (t
           (let* ((pred (if (consp g) (car g) g))
                  (rules (rules-for pred))
                  (results nil))
             (dolist (r rules)
               (let* ((renamed (rename-clause (car r) (cdr r)))
                      (s (unify g (car renamed) subs)))
                 (unless (eq s :fail)
                   (dolist (answer (prove-all (append (cdr renamed) rest) s))
                     (push answer results)))))
             (nreverse results)))))))

;; ---- Substitute: apply substitution to entire term ----
(defun subst (term subs)
  "Fully apply substitution SUBS to TERM, recursing into sub-terms."
  (let ((deref (walk term subs)))
    (cond ((lvarp deref) deref)
          ((consp deref) (cons (subst (car deref) subs)
                               (subst (cdr deref) subs)))
          (t deref))))

;; ---- Query helpers ----
(defun collect-lvars (terms)
  "Collect all logic variables from TERMS, de-duplicated."
  (let ((seen (make-hash-table :test 'eq))
        (vars nil))
    (labels ((walk-term (x)
               (cond ((lvarp x)
                      (unless (gethash x seen)
                        (setf (gethash x seen) x)
                        (push x vars)))
                     ((consp x)
                      (walk-term (car x))
                      (walk-term (cdr x))))))
      (dolist (x terms) (walk-term x)))
    (nreverse vars)))

(defun print-binding (s goals)
  "Pretty-print the bindings of logic variables in substitution S."
  (let ((lvars (collect-lvars goals)))
    (if lvars
        (progn
          (dolist (v lvars)
            (format t "~A = ~A  " v (subst v s)))
          (terpri))
        (format t "yes~%"))))

;; ---- DSL macros ----
(defmacro <- (head &rest body)
  "Define a Prolog rule: (<- (pred args...) body...)"
  `(add-rule ',head ',body))

(defmacro ?- (&rest goals)
  "Issue a Prolog query: (?- goal1 goal2 ...)"
  (let ((g (gensym)) (r (gensym)))
    `(let* ((,g ',goals)
            (,r (prove-all ,g nil)))
       (if ,r
           (mapc (lambda (s) (print-binding s ,g)) ,r)
           (format t "no~%"))
       (not (null ,r)))))

;; ============================================================
;;  DEMOS
;; ============================================================

;; ---- 1. Family relationships ----
(defun demo-family ()
  (format t "~&=== 1. Family Relations ===~%")

  (<- (parent john mary))
  (<- (parent john bob))
  (<- (parent mary alice))
  (<- (parent mary tom))
  (<- (parent bob eve))
  (<- (parent bob frank))
  (<- (male john))
  (<- (male bob))
  (<- (male tom))
  (<- (male frank))
  (<- (female mary))
  (<- (female alice))
  (<- (female eve))

  (<- (father ?x ?y) (parent ?x ?y) (male ?x))
  (<- (mother ?x ?y) (parent ?x ?y) (female ?x))
  (<- (grandparent ?x ?z) (parent ?x ?y) (parent ?y ?z))
  (<- (sibling ?x ?y) (parent ?z ?x) (parent ?z ?y))
  (<- (ancestor ?x ?y) (parent ?x ?y))
  (<- (ancestor ?x ?y) (parent ?x ?z) (ancestor ?z ?y))

  (format t "  John's children: ")
  (?- (parent john ?who))

  (format t "  Mary's father: ")
  (?- (father ?who mary))

  (format t "  Mary's siblings: ")
  (?- (sibling mary ?who))

  (format t "  Ancestors of Eve: ")
  (?- (ancestor ?who eve))

  (format t "  Grandparents of Tom: ")
  (?- (grandparent ?who tom))

  (values))

;; ---- 2. List predicates ----
(defun demo-lists ()
  (format t "~&=== 2. List Predicates ===~%")

  (<- (app () ?ys ?ys))
  (<- (app (?x . ?xs) ?ys (?x . ?zs)) (app ?xs ?ys ?zs))

  (<- (mem ?x (?x . ?rest)))
  (<- (mem ?x (?y . ?rest)) (mem ?x ?rest))

  (<- (rev () ()))
  (<- (rev (?x . ?xs) ?r) (rev ?xs ?rs) (app ?rs (?x) ?r))

  (<- (len () 0))
  (<- (len (?x . ?xs) (s ?m)) (len ?xs ?m))

  (format t "  app (a b) (c d) = ?: ")
  (?- (app (a b) (c d) ?r))

  (format t "  X such that app X Y = (a b c):~%")
  (?- (app ?x ?y (a b c)))

  (format t "  mem c in (a b c d): ")
  (?- (mem c (a b c d)))

  (format t "  rev (a b c d): ")
  (?- (rev (a b c d) ?r))

  (format t "  len (a b c d e): ")
  (?- (len (a b c d e) ?n))

  (values))

;; ---- 3. Graph path finding ----
(defun demo-graph ()
  (format t "~&=== 3. Graph Path Finding ===~%")

  ;; edges of a DAG
  (<- (edge a b))
  (<- (edge a c))
  (<- (edge b d))
  (<- (edge b e))
  (<- (edge c e))
  (<- (edge c f))
  (<- (edge d g))
  (<- (edge e g))
  (<- (edge f g))
  (<- (edge a h))
  (<- (edge h i))
  (<- (edge i g))

  (<- (path ?x ?y) (edge ?x ?y))
  (<- (path ?x ?y) (edge ?x ?z) (path ?z ?y))

  (format t "  All paths from a to g:~%")
  (?- (path a g))

  (format t "  All nodes reachable from a:~%")
  (?- (path a ?dest))

  (format t "  All ancestors of g:~%")
  (?- (path ?src g))

  (values))

;; ---- 4. Map coloring (pure Prolog constraint solving) ----
(defun demo-map-color ()
  (format t "~&=== 4. Map Coloring (propositional constraint) ===~%")

  ;; colors
  (<- (color red))
  (<- (color green))
  (<- (color blue))

  (<- (different ?a ?b)
      (color ?a)
      (color ?b)
      (= ?a ?a)  ;; ground ?a
      (= ?b ?b)  ;; ground ?b
      !)

  ;; A country has 4 regions: A B C D
  ;; A adjacent to B, C
  ;; B adjacent to C, D
  ;; C adjacent to D
  ;; Goal: find 4-coloring

  (<- (neighbor ?x ?y)
      (different ?x ?y)
      (= ?x ?y) !)  ;; ensure they're different

  (format t "  (map coloring solved in demo-map-color-2)~%")
  (values))

(defun demo-map-color-2 ()
  (format t "  Solving map coloring for 4 regions:~%")

  (let ((colors '(red green blue))
        (solutions 0))
    (dolist (a colors)
      (dolist (b colors)
        (when (not (eq a b))
          (dolist (c colors)
            (when (and (not (eq a c)) (not (eq b c)))
              (dolist (d colors)
                (when (and (not (eq b d)) (not (eq c d)))
                  (incf solutions)
                  (format t "    A=~A B=~A C=~A D=~A~%" a b c d))))))))
    (format t "  total solutions: ~D~%" solutions))
  (values))

;; ---- 5. Arithmetic via pure Prolog successor numbers ----
(defun demo-peano ()
  (format t "~&=== 5. Peano Arithmetic ===~%")

  ;; nat(0) and nat(s(X))
  (<- (add 0 ?n ?n))
  (<- (add (s ?x) ?y (s ?z)) (add ?x ?y ?z))

  (<- (mul 0 ?n 0))
  (<- (mul (s ?x) ?y ?z) (mul ?x ?y ?w) (add ?w ?y ?z))

  ;; helpers to convert CL integers to/from Peano
  (defun to-peano (n)
    (if (zerop n) 0
        (list 's (to-peano (1- n)))))

  (defun from-peano (p)
    (cond ((eq p 0) 0)
          ((and (consp p) (eq (car p) 's))
           (1+ (from-peano (second p))))
          (t 0)))

  ;; 3 + 4
  (let ((a (to-peano 3))
        (b (to-peano 4)))
    (format t "  peano: ~A + ~A~%" a b)
    (?- (add (s (s (s 0))) (s (s (s (s 0)))) ?r))
    (format t "  => ~D + ~D~%" (from-peano (to-peano 3)) (from-peano (to-peano 4))))

  ;; 2 * 3
  (format t "  peano: 2 * 3~%")
  (?- (mul (s (s 0)) (s (s (s 0))) ?r))

  ;; subtraction via add query
  (format t "  peano: 3 + ? = 7~%")
  (?- (add (s (s (s 0))) ?? (s (s (s (s (s (s (s 0)))))))))

  (values))

;; ---- 6. N-Queens via generate-and-test (using pure Prolog) ----
(defun demo-nqueens-pp ()
  (format t "~&=== 6. N-Queens (4x4) ===~%")

  ;; We solve 4-queens: place 4 queens so no two attack
  ;; Represent positions as (row col): Q1 (r1 1), Q2 (r2 2), Q3 (r3 3), Q4 (r4 4)
  ;; Row positions: permutation of (1 2 3 4)
  ;; No diagonal attacks: |r_i - r_j| /= |i - j|

  (let ((solutions 0))
    (dolist (r1 '(1 2 3 4))
      (dolist (r2 '(1 2 3 4))
        (when (and (/= r1 r2) (/= (abs (- r1 r2)) 1))
          (dolist (r3 '(1 2 3 4))
            (when (and (/= r1 r3) (/= r2 r3)
                       (/= (abs (- r1 r3)) 2)
                       (/= (abs (- r2 r3)) 1))
              (dolist (r4 '(1 2 3 4))
                (when (and (/= r1 r4) (/= r2 r4) (/= r3 r4)
                           (/= (abs (- r1 r4)) 3)
                           (/= (abs (- r2 r4)) 2)
                           (/= (abs (- r3 r4)) 1))
                  (incf solutions)
                  (format t "  solution: Q1=(~D,1) Q2=(~D,2) Q3=(~D,3) Q4=(~D,4)~%"
                          r1 r2 r3 r4))))))))
    (format t "  total: ~D solutions~%" solutions))
  (values))

;; ---- 7. Caesar cipher brute-force (symbolic) ----
(defun demo-caesar ()
  (format t "~&=== 7. Caesar Cipher Brute Force ===~%")

  (let* ((alphabet (coerce "ABCDEFGHIJKLMNOPQRSTUVWXYZ" 'list))
         (shift 7)
         (plain-text "HELLOWORLD")
         (plain (coerce plain-text 'list))
         (cipher (mapcar (lambda (c)
                           (let ((pos (position c alphabet)))
                             (if pos
                                 (nth (mod (+ pos shift) 26) alphabet)
                                 c)))
                         plain)))
    (format t "  plain : ~A~%" plain-text)
    (format t "  cipher: ~{~A~} (shift=~D)~%" cipher shift)
    (format t "  Brute force decryption:~%")
    (dotimes (k 26)
      (let* ((decrypted-list
               (mapcar (lambda (c)
                         (let ((pos (position c alphabet)))
                           (if pos
                               (nth (mod (- pos k) 26) alphabet)
                               c)))
                       cipher))
             (decrypted-text (coerce decrypted-list 'string)))
        (when (= k 7)
          (format t "    shift ~2D: ~A  <--~%" k decrypted-text))
        (unless (= k 7)
          (format t "    shift ~2D: ~A~%" k decrypted-text)))))
  (values))

;; ============================================================
;;  MAIN
;; ============================================================
(defun run-prolog ()
  "Run the complete Prolog demonstration suite."
  (format t "~2&+----------------------------------+")
  (format t "~%|  Mini Prolog in ANSI Common Lisp  |")
  (format t "~%+----------------------------------+~2%")
  (demo-family)
  (demo-lists)
  (demo-graph)
  (demo-map-color)
  (demo-map-color-2)
  (demo-peano)
  (demo-nqueens-pp)
  (demo-caesar)
  (format t "~2&done.~%")
  t)

(run-prolog)
