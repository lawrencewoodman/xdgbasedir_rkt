#lang scribble/manual

@(require planet/scribble
          (for-label racket
                     (this-package-in main)))

@title{Exported functions}

@defmodule/this-package[main]

In all the functions below @scheme[subdir] indicates the name of the application that the files relate to.

@defproc[(xdgbasedir-data-home [subdir path-string?])
         path?]{
 Returns the location of user-specific data files.
}

@defproc[(xdgbasedir-config-home [subdir path-string?])
         path?]{
 Returns the location of user-specific configuration files.
}

@defproc[(xdgbasedir-cache-home [subdir path-string?])
         path?]{
 Returns the location of user-specific non-essential data files.
}

@defproc[(xdgbasedir-runtime-dir [subdir path-string?])
         (or/c path? boolean?)]{
 Returns the location of user-specific runtime files.  If no directory specified then returns @code{#f}.
}

@defproc[(xdgbasedir-data-dirs [subdir path-string?])
         (listof path?)]{
 Returns a list of directories, in order of preference, which should be searched for data files.
}

@defproc[(xdgbasedir-config-dirs [subdir path-string?])
         (listof path?)]{
 Returns a list of directories, in order of preference, which should be searched for configuration files.
}

