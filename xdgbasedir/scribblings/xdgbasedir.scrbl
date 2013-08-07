#lang scribble/manual

@(require planet/scribble)

@title{xdgbasedir}
@author{@(author+email "Lawrence Woodman" "lwoodman@vlifesystems.com")}

This package eases access to the @link["http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html"]{XDG Base Directory Specification}.  The specification describes a simple and clean way to locate an application's data, configuration and miscellaneous files.  It is a response to the inconsistent mess of files spread all across a file system by many applications.

@local-table-of-contents[]

@include-section["exported-functions.scrbl"]
@include-section["development.scrbl"]
@include-section["licence.scrbl"]
