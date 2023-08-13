(define-module
  (zerolib)
  #:export (
            let1
            write-line
            write-all-lines
            read-all-lines))

(use-modules
  (scheme base)
  (srfi srfi-26)
  (ice-9 textual-ports))

(define-syntax-rule
  (let1 (name value) expr expr* ...)
  (let ((name value)) expr expr* ...))

(define*
  (write-line text #:optional (port (current-output-port)))
  (display text port)
  (newline port))

(define*
  (write-all-lines lst #:optional (port (current-output-port)))
  (display (string-join lst "\n") port)
  (newline port))

(define*
  (read-all-lines #:optional (port (current-input-port)))
  "read input port and split to list"
  (split-lines (get-string-all port)))

(define-public
  (split-lines lst)
  (string-split lst #\newline))

(define-public
  (last lst)
  (car (reverse lst)))
(define-public
  (string-product start ends)
  (map (cut string-append start <>) ends))

