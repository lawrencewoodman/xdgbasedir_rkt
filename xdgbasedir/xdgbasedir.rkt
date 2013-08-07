#lang racket/base
; Copyright (C) 2013 Lawrence Woodman
; Licensed under an MIT licence.  Please see LICENCE.md for details.

(require racket/string)
(require racket/contract)

(provide
 (contract-out
  [xdgbasedir-data-home (->* () (path-string?) path?)]
  [xdgbasedir-config-home (->* () (path-string?) path?)]
  [xdgbasedir-cache-home (->* () (path-string?) path?)]
  [xdgbasedir-data-dirs (->* () (path-string?) (listof path?))]
  [xdgbasedir-config-dirs (->* () (path-string?) (listof path?))]
  [xdgbasedir-runtime-dir (->* () (path-string?) (or/c path? boolean?))]))


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

(define (dir var subdir)
  (let* ([env-var (getenv var)]
         [main-path
          (if (string-not-empty? env-var)
              env-var
              (default var))])
    (if (equal? subdir "")
        (build-path main-path)
        (build-path main-path subdir))))

(define (dirs var subdir)
  (let* ([env-var (getenv var)]
         [main-paths
          (if (string-not-empty? env-var)
              (map (λ (path) (build-path path)) (string-split env-var ":"))
              (default var))])
    (if (equal? subdir "")
        main-paths
        (map (λ (path) (build-path path subdir)) main-paths))))


;==================================================
;                  Exported Functions
;==================================================
(define (xdgbasedir-data-home [subdir ""]) (dir "XDG_DATA_HOME" subdir))
(define (xdgbasedir-config-home [subdir ""]) (dir "XDG_CONFIG_HOME" subdir))
(define (xdgbasedir-cache-home [subdir ""]) (dir "XDG_CACHE_HOME" subdir))
(define (xdgbasedir-data-dirs [subdir ""]) (dirs "XDG_DATA_DIRS" subdir))
(define (xdgbasedir-config-dirs [subdir ""]) (dirs "XDG_CONFIG_DIRS" subdir))
(define (xdgbasedir-runtime-dir [subdir ""])
  (if (string-not-empty? (getenv "XDG_RUNTIME_DIR"))
      (dir "XDG_RUNTIME_DIR" subdir)
      #f))
