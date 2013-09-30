#lang racket/base
; Copyright (C) 2013 Lawrence Woodman
; Licensed under an MIT licence.
; Please see scribblings/licence.scrbl for details.

(require racket/contract)

(provide
 xdgbasedir-current-os
 (contract-out
  [data-home (->* () (path-string?) path?)]
  [config-home (->* () (path-string?) path?)]
  [cache-home (->* () (path-string?) path?)]
  [data-dirs (->* () (path-string?) (listof path?))]
  [config-dirs (->* () (path-string?) (listof path?))]
  [runtime-dir (->* () (path-string?) (or/c path? boolean?))]))

(require racket/string)

;=====================================
;              Exported
;=====================================

; Defined as a parameter so that we can force the os when testing
(define xdgbasedir-current-os (make-parameter (system-type 'os)))

(define (data-home [subdir ""]) (dir "XDG_DATA_HOME" subdir))
(define (config-home [subdir ""]) (dir "XDG_CONFIG_HOME" subdir))
(define (cache-home [subdir ""]) (dir "XDG_CACHE_HOME" subdir))
(define (data-dirs [subdir ""]) (dirs "XDG_DATA_DIRS" subdir))
(define (config-dirs [subdir ""]) (dirs "XDG_CONFIG_DIRS" subdir))

(define (runtime-dir [subdir ""])
  (run-on-unix-or-exn
   (let ([runtime-dir (getenv "XDG_RUNTIME_DIR")])
     (if (string-not-empty? runtime-dir)
         (build-full-path runtime-dir subdir)
         #f))))


;=====================================
;              Internal
;=====================================

(define (default var)
  (case var
    [("XDG_DATA_HOME") (build-path (getenv "HOME") ".local" "share")]
    [("XDG_CONFIG_HOME") (build-path (getenv "HOME") ".config")]
    [("XDG_CACHE_HOME") (build-path (getenv "HOME") ".cache")]
    [("XDG_DATA_DIRS") (list (build-path "/usr" "local" "share")
                             (build-path "/usr" "share"))]
    [("XDG_CONFIG_DIRS") (list (build-path "/etc" "xdg"))]))

; Ensure will only run body on unix, else raise an exception
(define-syntax-rule (run-on-unix-or-exn body ...)
  (if (equal? (xdgbasedir-current-os) 'unix)
      (begin body ...)
      (error
       (string-append "Unsupported os: "
                      (symbol->string (xdgbasedir-current-os))))))

(define (string-not-empty? str)
  (and str (not (equal? str ""))))

(define (build-full-path path subdir)
  (if (equal? subdir "")
      (build-path path)
      (build-path path subdir)))

(define (dir var subdir)
  (run-on-unix-or-exn
   (let* ([env-var (getenv var)]
          [main-path
           (if (string-not-empty? env-var)
               env-var
               (default var))])
     (build-full-path main-path subdir))))

(define (dirs var subdir)
  (run-on-unix-or-exn
   (let* ([env-var (getenv var)]
          [main-paths
           (if (string-not-empty? env-var)
               (string-split env-var ":")
               (default var))])
     (map (λ (path) (build-full-path path subdir)) main-paths))))