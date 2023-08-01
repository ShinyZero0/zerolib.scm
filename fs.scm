(define-module (zerolib fs) #:export (file/write-all-lines))
(use-modules (zerolib)
             (ice-9 textual-ports))

(define-public (file/write-all-lines lst file)
  (write-all-lines lst (open-output-file file)))
(define-public (file/read-all-lines lst file)
  (read-all-lines lst (open-input-file file)))
(define-public
  (read-all-text filepath)
  (get-string-all
    (open-file filepath "r")))
