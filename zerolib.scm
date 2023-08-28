(define-module
  (zerolib)
  #:export (
            let1
            write-line
            write-all-lines
            read-all-lines))

(use-modules
  (scheme base)
  (srfi srfi-26))

(define-syntax-rule
  (let1 (name value) expr expr* ...)
  (let ((name value)) expr expr* ...))

(define*
  (write-line text #:optional (port (current-output-port)))
  (display text port)
  (newline port))

(define*
  (write-all-lines lst #:optional (port (current-output-port)))
  (for-each
    (lambda (line)
      (write-line line port))
    lst))

(define*
  (read-all-lines #:optional (port (current-input-port)))
  "read input port to list of strings"
  (let1 (line (read-line port))
        (if (eof-object?  line)
          '()
          (cons line (read-all-lines port)))))

(define-public
  (swap func)
  (lambda (foo bar) (func bar foo)))

(define-public
  (split-lines lst)
  (string-split lst #\newline))

(define-public
  (last lst)
  (car (reverse lst)))
(define-public s+ string-append)
