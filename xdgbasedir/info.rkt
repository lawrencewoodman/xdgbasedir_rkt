#lang setup/infotab

(define name "xdgbasedir")
(define blurb
  (list "Functions to work with the XDG Base Directory Specification"))
(define homepage "http://lawrencewoodman.github.io/xdgbasedir_rkt/")
(define primary-file "main.rkt")
(define scribblings '(("scribblings/xdgbasedir.scrbl" (multi-page))))
(define categories '(io))
(define repositories '("4.x"))
(define required-core-version "5.3")
(define compile-omit-paths '("private"))
(define release-notes
  (list
   '(ul (li "Various internal structural changes"))))
