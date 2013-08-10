#lang racket/base
; Copyright (C) 2013 Lawrence Woodman
; Licensed under an MIT licence.  Please see LICENCE.md for details.

(require racket/string)
(require racket/contract)

(provide
 xdgbasedir-current-os
 (contract-out
  [xdgbasedir-data-home (->* () (path-string?) path?)]
  [xdgbasedir-config-home (->* () (path-string?) path?)]
  [xdgbasedir-cache-home (->* () (path-string?) path?)]
  [xdgbasedir-data-dirs (->* () (path-string?) (listof path?))]
  [xdgbasedir-config-dirs (->* () (path-string?) (listof path?))]
  [xdgbasedir-runtime-dir (->* () (path-string?) (or/c path? boolean?))]))

; Defined as a parameter so that we can force the os when testing
(define xdgbasedir-current-os (make-parameter (system-type 'os)))

; Ensure will only run body on unix, else raise an exception
(define-syntax-rule (run-on-unix-or-exn body ...)
  (if (equal? (xdgbasedir-current-os) 'unix)
      (begin body ...)
      (error
       (string-append "Unsupported os: "
                      (symbol->string (xdgbasedir-current-os))))))


(define (default var)
  (case var
    [("XDG_DATA_HOME") (build-path (getenv "HOME") ".local" "share")]
    [("XDG_CONFIG_HOME") (build-path (getenv "HOME") ".config")]
    [("XDG_CACHE_HOME") (build-path (getenv "HOME") ".cache")]
    [("XDG_DATA_DIRS") (list (build-path "/usr" "local" "share")
                             (build-path "/usr" "share"))]
    [("XDG_CONFIG_DIRS") (list (build-path "/etc" "xdg"))]))

(define (string-not-empty? str)
  (and str (not (equal? str ""))))

(define (add-subdir path subdir)
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
     (add-subdir main-path subdir))))

(define (dirs var subdir)
  (run-on-unix-or-exn
   (let* ([env-var (getenv var)]
          [main-paths
           (if (string-not-empty? env-var)
               (map (λ (path) (build-path path)) (string-split env-var ":"))
               (default var))])
     (map (λ (path) (add-subdir path subdir)) main-paths))))


;==================================================
;                  Exported Functions
;==================================================
(define (xdgbasedir-data-home [subdir ""]) (dir "XDG_DATA_HOME" subdir))
(define (xdgbasedir-config-home [subdir ""]) (dir "XDG_CONFIG_HOME" subdir))
(define (xdgbasedir-cache-home [subdir ""]) (dir "XDG_CACHE_HOME" subdir))
(define (xdgbasedir-data-dirs [subdir ""]) (dirs "XDG_DATA_DIRS" subdir))
(define (xdgbasedir-config-dirs [subdir ""]) (dirs "XDG_CONFIG_DIRS" subdir))

(define (xdgbasedir-runtime-dir [subdir ""])
  (run-on-unix-or-exn
   (let ([runtime-dir (getenv "XDG_RUNTIME_DIR")])
     (if (string-not-empty? runtime-dir)
         (add-subdir runtime-dir subdir)
         #f))))