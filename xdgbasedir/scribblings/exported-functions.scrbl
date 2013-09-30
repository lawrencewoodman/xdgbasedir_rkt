#lang scribble/manual

@(require (for-label racket
                     xdgbasedir))

@title{Exported functions}

@defmodule[xdgbasedir]

In all the functions below @scheme[subdir] indicates the name of the application that the files relate to.

An @code{exn:fail} exception is raised if any of the functions are run on a non-unix system,
because the defaults make little sense on these operating systems.

@defproc[(data-home [subdir path-string?])
         path?]{
 Returns the location of user-specific data files.
}

@defproc[(config-home [subdir path-string?])
         path?]{
 Returns the location of user-specific configuration files.
}

@defproc[(cache-home [subdir path-string?])
         path?]{
 Returns the location of user-specific non-essential data files.
}

@defproc[(runtime-dir [subdir path-string?])
         (or/c path? boolean?)]{
 Returns the location of user-specific runtime files.  If no directory specified then returns @code{#f}.
}

@defproc[(data-dirs [subdir path-string?])
         (listof path?)]{
 Returns a list of directories, in order of preference, which should be searched for data files.
}

@defproc[(config-dirs [subdir path-string?])
         (listof path?)]{
 Returns a list of directories, in order of preference, which should be searched for configuration files.
}

