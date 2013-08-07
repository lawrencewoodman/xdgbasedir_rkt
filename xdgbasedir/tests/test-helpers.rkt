#lang racket

(provide get-all-xdg-vars restore-all-xdg-vars)

(define (get-all-xdg-vars)
  (define xdg-vars '("XDG_DATA_HME" "XDG_CONFIG_HOME" "XDG_CACHE_HOME"
                     "XDG_DATA_DIRS" "XDG_CONFIG_DIRS" "XDG_RUNTIME_DIR"))
  (for/hash ([var xdg-vars])
    (values var (getenv var))))

(define (restore-all-xdg-vars vars)
  (hash-for-each vars
                 (λ (key var)
                   (if var (putenv key var) (putenv key "")))))
