(define-module
  (zerolib shell))
(use-modules (ice-9 receive)
             (ice-9 textual-ports)
             (zerolib))

(define-public
  (call-command cmd . args)
  "Execute a program arg0 with args arg1-"
  (receive
    (stdin stdout pid)
    (get-command-pipes cmd args)
    (waitpid pid)
    (close-port (cdr stdout))
    (string-trim-right
      (get-string-all (car stdout))
      (char-set-adjoin char-set:whitespace #\newline))))

(define-public
  (call-command-with-input cmd args input)
  "Same as call-command but args is a list and the third argument
  is a list that would be passed as stdin lines"
  (receive
    (stdin stdout pid)
    (get-command-pipes cmd args)
    (write-all-lines input (cdr stdin))
    (close-port (cdr stdin))
    (waitpid pid)
    (close-port (cdr stdout))
    (string-trim-both
      (get-string-all (car stdout))
      (char-set-adjoin char-set:whitespace #\newline))))

(define-public
  (get-command-pipes cmd args)
  "spawn a process `cmd` with args and return stdin and stdout pipes and pid"
  (let* ((stdout
           (pipe))
         (stdin
           (pipe))
         (pid
           (spawn
             cmd
             (cons cmd args)
             #:output (cdr stdout)
             #:input (car stdin))))
    (values stdin stdout pid)))
