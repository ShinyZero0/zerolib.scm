(define-module (zerolib fs) #:export (file/write-all-lines))
(use-modules (zerolib)
             (srfi srfi-26)
             (ice-9 textual-ports))

(define-public
  (file/write-all-lines lst file)
  (write-all-lines lst (open-output-file file)))
(define-public
  (file/read-all-lines file)
  (read-all-lines (open-input-file file)))
(define-public
  (file/read-all-text filepath)
  (get-string-all
    (open-input-file filepath)))
(define-public (merge-files files output)
  (file/write-all-lines
    (map (cute file/read-all-text <>)
         files)
    output))
