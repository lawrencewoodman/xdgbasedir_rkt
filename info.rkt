#lang setup/infotab

(define name "xdgbasedir")
(define blurb
  (list "Functions to work with the XDG Base Directory Specification"))
(define homepage "https://github.com/LawrenceWoodman/xdgbasedir_rkt/")
(define version "0.1")
(define primary-file "main.rkt")
(define scribblings '(("scribblings/xdgbasedir.scrbl" (multi-page))))
(define categories '(io))
(define repositories '("4.x"))
(define required-core-version "5.3")
(define release-notes
  (list
   '(ul (li "Initial release"))))
