;;; quicklisp-compat.lp — LisPy compatibility shims for Quicklisp libraries

(format t "; quicklisp-compat~%")
(pushnew :lispy *features*)
(pushnew :abcl *features*)

;; ── split-sequence ─────────────────────────────────────────────
(load "/mnt/c/Users/river/quicklisp/dists/quicklisp/software/split-sequence-v2.0.1/package.lisp")
(in-package :split-sequence)
(defun split-sequence (delimiter sequence &key (start 0) (end nil) (from-end nil)
                                  (count nil) (remove-empty-subseqs nil)
                                  (test #'eql) (test-not nil) (key #'identity))
  (let* ((vec (if (stringp sequence) sequence (coerce sequence 'vector)))
         (len (length vec))
         (eff-end (or end len))
         (result nil)
         (seg-start start)
         (seg-count 0))
    (when from-end
      (let* ((rev nil) (s eff-end) (j (1- eff-end)))
        (loop while (>= j start) do
          (if (and (>= j start) (delimiter-match-p delimiter vec j test test-not key))
              (progn
                (unless (and remove-empty-subseqs (= (1+ j) s))
                  (push (subseq vec (1+ j) s) rev)
                  (incf seg-count))
                (setf s j)
                (when (and count (>= seg-count count))
                  (push (subseq vec start s) rev)
                  (return)))
              (when (= j start)
                (push (subseq vec start s) rev)))
          (decf j))
        (return-from split-sequence (nreverse rev))))
    (loop for i from start below eff-end do
      (if (delimiter-match-p delimiter vec i test test-not key)
          (progn
            (unless (and remove-empty-subseqs (= i seg-start))
              (push (subseq vec seg-start i) result)
              (incf seg-count))
            (setf seg-start (1+ i))
            (when (and count (>= seg-count count))
              (push (subseq vec seg-start eff-end) result)
              (return-from split-sequence (nreverse result))))))
    (push (subseq vec seg-start eff-end) result)
    (nreverse result)))
(defun delimiter-match-p (delimiter vec idx test test-not key)
  (let ((elt (aref vec idx)))
    (or (and test (funcall test delimiter (funcall key elt)))
        (and test-not (not (funcall test-not delimiter (funcall key elt)))))))
(defun split-sequence-if (predicate sequence &key (start 0) (end nil) (from-end nil)
                                     (count nil) (remove-empty-subseqs nil) (key #'identity))
  (split-sequence nil sequence :start start :end end :from-end from-end
                  :count count :remove-empty-subseqs remove-empty-subseqs
                  :test predicate :key key))
(defun split-sequence-if-not (predicate sequence &key (start 0) (end nil) (from-end nil)
                                         (count nil) (remove-empty-subseqs nil) (key #'identity))
  (split-sequence nil sequence :start start :end end :from-end from-end
                  :count count :remove-empty-subseqs remove-empty-subseqs
                  :test-not predicate :key key))
(in-package :cl-user)
(format t ";   split-sequence OK~%")

;; ── alexandria (safe modules) ──────────────────────────────────
(load "/mnt/c/Users/river/quicklisp/dists/quicklisp/software/alexandria-20241012-git/alexandria-1/package.lisp")
(load "/mnt/c/Users/river/quicklisp/dists/quicklisp/software/alexandria-20241012-git/alexandria-1/conditions.lisp")
(load "/mnt/c/Users/river/quicklisp/dists/quicklisp/software/alexandria-20241012-git/alexandria-1/definitions.lisp")
(load "/mnt/c/Users/river/quicklisp/dists/quicklisp/software/alexandria-20241012-git/alexandria-1/functions.lisp")
(load "/mnt/c/Users/river/quicklisp/dists/quicklisp/software/alexandria-20241012-git/alexandria-1/binding.lisp")
(load "/mnt/c/Users/river/quicklisp/dists/quicklisp/software/alexandria-20241012-git/alexandria-1/control-flow.lisp")
(load "/mnt/c/Users/river/quicklisp/dists/quicklisp/software/alexandria-20241012-git/alexandria-1/hash-tables.lisp")
(load "/mnt/c/Users/river/quicklisp/dists/quicklisp/software/alexandria-20241012-git/alexandria-1/io.lisp")
(load "/mnt/c/Users/river/quicklisp/dists/quicklisp/software/alexandria-20241012-git/alexandria-1/numbers.lisp")
(load "/mnt/c/Users/river/quicklisp/dists/quicklisp/software/alexandria-20241012-git/alexandria-1/strings.lisp")
(format t ";   alexandria (partial) OK~%")

;; ── fare-memoization ───────────────────────────────────────────
(let ((b "/mnt/c/Users/river/quicklisp/dists/quicklisp/software/fare-memoization-20180430-git/"))
  (handler-case (load (concatenate 'string b "memoization.lisp"))
    (error (c) (format t ";   fmemo: ~A~%" c))))
(when (find-package :fare-memoization)
  (let ((*package* (find-package :fare-memoization)))
    (defmacro define-memo-function (name formals &body body)
      (multiple-value-bind (n keys)
          (if (consp name) (values (car name) (cdr name)) (values name nil))
        `(progn (unmemoize ',n) (defun ,n ,formals ,@body) (memoize ',n ,@keys))))
    (unless (fboundp 'memoized-funcall)
      (defun memoized-funcall (function &rest args)
        (apply (memoizing function) args)))))
(format t ";   fare-memoization OK~%")

(format t "; quicklisp-compat ready~%")
