(define-module
  (zerolib)
  #:export (let1 write-line write-all-lines))

(use-modules
  (scheme base)
  (ice-9 popen)
  (ice-9 receive)
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

(define-public
  (read-stdin)
  "read stdin and split to list"
  (split-lines (get-string-all (open-input-file "/dev/stdin"))))

(define-public
  (split-lines lst)
  (string-split lst #\newline))

(define-public
  (last lst)
  (car (reverse lst)))

(define-public
  (call-command cmd . args)
  "Execute a program arg0 with args arg1-"
  (receive
    (stdin stdout pid)
    (get-command-pipes cmd args)
    (waitpid pid)
    (close-port (cdr stdout))
    (string-trim-both
      (get-string-all (car stdout))
      (char-set-adjoin char-set:whitespace #\newline))))

(define-public
  (read-all-text filepath)
  (get-string-all
    (open-file filepath "r")))

(define-public
  (call-command-with-input cmd args input)
  "Same as call-command but args is a list and the third argument
  is a list that would be converted to lines"
  (receive
    (stdin stdout pid)
    (get-command-pipes cmd args)
    (display (string-join input "\n") (cdr stdin))
    (close-port (cdr stdin))
    (waitpid pid)
    (close-port (cdr stdout))
    (string-trim-both
      (get-string-all (car stdout))
      (char-set-adjoin char-set:whitespace #\newline))))

(define-public
  (get-command-pipes cmd args)
  "spawn a process cmd with args and return stdin and stdout pipes and pid"
  (let* ((stdout
           (pipe))
         (stdin
           (pipe))
         (pid
           (spawn
             cmd
             (cons cmd args)
             #:output (cdr stdout)
             #:input (car stdin)
             ))
         )
    (values stdin stdout pid)
    )
  )
