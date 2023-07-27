(define-module
  (zerolib))
(use-modules
  (scheme base)
  (ice-9 popen)
  (ice-9 textual-ports))
(define-public
  (call-command cmd args)
  (let-values ((
                (stdin stdout pid)
                (get-command-pipes cmd args)))

    (waitpid pid)
    (close-port (cdr stdout))
    (string-trim-both
      (get-string-all (car stdout))
      (char-set-adjoin char-set:whitespace #\newline))))

(define-public
  (call-command-with-input cmd args input)
  (let-values ((
                (stdin stdout pid)
                (get-command-pipes cmd args)))

    (display input (cdr stdin))
    (close-port (cdr stdin))
    (waitpid pid)
    (close-port (cdr stdout))
    (string-trim-both
      (get-string-all (car stdout))
      (char-set-adjoin char-set:whitespace #\newline))))

(define-public
  (get-command-pipes cmd args)
  (let* (
         (stdout
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
