;;; slippery-chicken-lispy.lp — LisPy port of slippery-chicken

(format t "; sc-lispy: porting...~%")
(defparameter +slippery-chicken-version+ "1.1.0-lispy")
(defparameter +slippery-chicken-config-data+ nil)
(defparameter *sc-ok* 0)
(defparameter *sc-fail* 0)

;; Stubs
(defpackage :cl-ppcre (:use :cl) (:nicknames :ppcre) (:export :create-scanner :scan-to-strings :scan :register-groups-bind :split))
(in-package :cl-ppcre) (defun create-scanner (p) p) (defun scan-to-strings (s st) (declare (ignore s st)) "") (in-package :cl-user)
(defpackage :uiop (:use :cl) (:export :split-string))
(in-package :uiop) (defun split-string (p &key sep) (declare (ignore sep)) (list p)) (in-package :cl-user)
(defpackage :cm (:use :cl) (:export :*scale* :*tempo* :keynum :tuning :find-object :list-named-objects :output-midi-note :process-voices :parse-midi-file :midi-file-high-low :midi-file-one-note :object-time :midi-keynum))
(in-package :cm) (defparameter *scale* nil) (defparameter *tempo* 60) (defun keynum (n &key in) (declare (ignore n in)) 60) (defun find-object (x) (declare (ignore x)) nil) (defun list-named-objects (x) (declare (ignore x)) nil) (defun output-midi-note (a b c &key d e) (declare (ignore a b c d e)) nil) (defun process-voices (x) (declare (ignore x)) nil) (defun parse-midi-file (x) (declare (ignore x)) nil) (defun midi-file-high-low (x) (declare (ignore x)) nil) (defun midi-file-one-note (a b c) (declare (ignore a b c)) nil) (defmacro new (class &rest args) (declare (ignore class args)) nil) (in-package :cl-user)
(defpackage :cmn (:use :cl)) (in-package :cmn) (defparameter *cmn-units* nil) (in-package :cl-user)
(defpackage :slippery-chicken (:use :cl) (:nicknames :sc :slimy-poultry) (:import-from :cl-user +slippery-chicken-version+ +slippery-chicken-config-data+))
(format t ";   stubs ready~%")

;; ── Load helpers ──────────────────────────────────────────────
;; sc-load-file: read forms sequentially and eval them.
;; Uses a simple tagbody/go loop (avoids extended loop scoping bugs).
(defun sc-load-file (path result-ok result-fail)
  (let ((f nil) (form nil) (n 0))
    (handler-case
        (progn
          (setf f (open path :direction :input))
          (tagbody
           next
             (setf form (read f nil :eof))
             (when (eq form :eof) (go done))
             (incf n)
             (eval form)
             (go next)
           done)
          (close f)
          (setf (symbol-value result-ok) (+ (symbol-value result-ok) 1))
          (format t ";   [OK] ~A (~D forms)~%" (file-namestring path) n)
          t)
      (error (c)
        (when f (close f :abort t))
        (setf (symbol-value result-fail) (+ (symbol-value result-fail) 1))
        (format t ";   [SKIP] ~A: ~A~%" (file-namestring path) c)
        nil))))

(defun sc-load-module (name)
  (sc-load-file (concatenate 'string "/tmp/slippery-chicken/src/" name)
                '*sc-ok* '*sc-fail*))

;; ── Load modules ──────────────────────────────────────────────
(sc-load-module "utilities.lsp")
(sc-load-module "named-object.lsp")

(format t "; sc-lispy: ~D ok, ~D fail~%" *sc-ok* *sc-fail*)
