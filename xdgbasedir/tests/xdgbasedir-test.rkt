#lang racket

(require rackunit
         "test-helpers.rkt"
         "../main.rkt")

(define env-vars '())
(define (before-every-test) (set! env-vars (get-all-xdg-vars)))
(define (after-every-test) (restore-all-xdg-vars env-vars))

(test-exn
 "data-home raises an exception if not run on unix"
 exn:fail?
 (λ ()
   (parameterize ([xdgbasedir-current-os 'windows])
     (xdgbasedir-data-home))))

(test-equal?
 "data-home returns the set XDG_DATA_HOME directory"
 (around
  (before-every-test)
  (putenv "XDG_DATA_HOME"
          (path->string (build-path "/tmp" "xdg_data_home")))
  (xdgbasedir-data-home)
  (after-every-test))
 (build-path "/tmp" "xdg_data_home"))

(test-equal?
 "data-home returns the set XDG_DATA_HOME directory with subdir"
 (around
  (before-every-test)
  (putenv "XDG_DATA_HOME"
          (path->string (build-path "/tmp" "xdg_data_home")))
  (xdgbasedir-data-home "some_dir")
  (after-every-test))
 (build-path "/tmp" "xdg_data_home" "some_dir"))

(test-equal?
 "data-home returns default directory if XDG_DATA_HOME not set"
 (around
  (before-every-test)
  (putenv "XDG_DATA_HOME" "")
  (xdgbasedir-data-home)
  (after-every-test))
 (build-path (getenv "HOME") ".local" "share"))

(test-equal?
 "data-home returns default directory with subdir if XDG_DATA_HOME not set"
 (around
  (before-every-test)
  (putenv "XDG_DATA_HOME" "")
  (xdgbasedir-data-home "some_dir")
  (after-every-test))
 (build-path (getenv "HOME") ".local" "share" "some_dir"))


(test-exn
 "config-home raises an exception if not run on unix"
 exn:fail?
 (λ ()
   (parameterize ([xdgbasedir-current-os 'macosx])
     (xdgbasedir-config-home))))

(test-equal?
 "config-home returns the set XDG_CONFIG_HOME directory"
 (around
  (before-every-test)
  (putenv "XDG_CONFIG_HOME"
          (path->string (build-path "/tmp" "xdg_config_home")))
  (xdgbasedir-config-home)
  (after-every-test))
 (build-path "/tmp" "xdg_config_home"))

(test-equal?
 "config-home returns the set XDG_CONFIG_HOME directory with subdir"
 (around
  (before-every-test)
  (putenv "XDG_CONFIG_HOME"
          (path->string (build-path "/tmp" "xdg_config_home")))
  (xdgbasedir-config-home "some_dir")
  (after-every-test))
 (build-path "/tmp" "xdg_config_home" "some_dir"))

(test-equal?
 "config-home returns the default directory if XDG_CONFIG_HOME not set"
 (around
  (before-every-test)
  (putenv "XDG_CONFIG_HOME" "")
  (xdgbasedir-config-home)
  (after-every-test))
 (build-path (getenv "HOME") ".config"))

(test-equal?
 "config-home returns the default directory with subdir if XDG_CONFIG_HOME \
not set"
 (around
  (before-every-test)
  (putenv "XDG_CONFIG_HOME" "")
  (xdgbasedir-config-home "some_dir")
  (after-every-test))
 (build-path (getenv "HOME") ".config" "some_dir"))


(test-exn
 "cache-home raises an exception if not run on unix"
 exn:fail?
 (λ ()
   (parameterize ([xdgbasedir-current-os 'windows])
     (xdgbasedir-cache-home))))

(test-equal?
 "cache-home returns the set XDG_CACHE_HOME directory"
 (around
  (before-every-test)
  (putenv "XDG_CACHE_HOME"
          (path->string (build-path "/tmp" "xdg_cache_home")))
  (xdgbasedir-cache-home)
  (after-every-test))
 (build-path "/tmp" "xdg_cache_home"))

(test-equal?
 "cache-home returns the set XDG_CACHE_HOME directory with subdir"
 (around
  (before-every-test)
  (putenv "XDG_CACHE_HOME"
          (path->string (build-path "/tmp" "xdg_cache_home")))
  (xdgbasedir-cache-home "some_dir")
  (after-every-test))
 (build-path "/tmp" "xdg_cache_home" "some_dir"))

(test-equal?
 "cache-home returns default directory if XDG_CACHE_HOME not set"
 (around
  (before-every-test)
  (putenv "XDG_CACHE_HOME" "")
  (xdgbasedir-cache-home)
  (after-every-test))
 (build-path (getenv "HOME") ".cache"))

(test-equal?
 "cache-home returns the default directory with subdir if XDG_CACHE_HOME \
not set"
 (around
  (before-every-test)
  (putenv "XDG_CACHE_HOME" "")
  (xdgbasedir-cache-home "some_dir")
  (after-every-test))
 (build-path (getenv "HOME") ".cache" "some_dir"))


(test-exn
 "data-dirs raises an exception if not run on unix"
 exn:fail?
 (λ ()
   (parameterize ([xdgbasedir-current-os 'windows])
     (xdgbasedir-data-dirs))))

(test-equal?
 "data-dirs returns the set XDG_DATA_DIRS directories"
 (around
  (before-every-test)
  (putenv "XDG_DATA_DIRS"
          (string-join
           (list (path->string (build-path "/tmp" "xdg_data_dir" "1"))
                 (path->string (build-path "/tmp" "xdg_data_dir" "2")))
           ":"))
  (xdgbasedir-data-dirs)
  (after-every-test))
 (list (build-path "/tmp" "xdg_data_dir" "1")
       (build-path "/tmp" "xdg_data_dir" "2")))

(test-equal?
 "data-dirs returns the set XDG_DATA_DIRS directories with subdir"
 (around
  (before-every-test)
  (putenv "XDG_DATA_DIRS"
          (string-join
           (list (path->string (build-path "/tmp" "xdg_data_dir" "1"))
                 (path->string (build-path "/tmp" "xdg_data_dir" "2")))
           ":"))
  (xdgbasedir-data-dirs "some_dir")
  (after-every-test))
 (list (build-path "/tmp" "xdg_data_dir" "1" "some_dir")
       (build-path "/tmp" "xdg_data_dir" "2" "some_dir")))

(test-equal?
 "data-dirs returns default directories if XDG_DATA_DIRS not set"
 (around
  (before-every-test)
  (putenv "XDG_DATA_DIRS" "")
  (xdgbasedir-data-dirs)
  (after-every-test))
 (list (build-path "/usr" "local" "share")
       (build-path "/usr" "share")))

(test-equal?
 "data-dirs returns the default directories with subdir if XDG_DATA_DIRS \
not set"
 (around
  (before-every-test)
  (putenv "XDG_DATA_DIRS" "")
  (xdgbasedir-data-dirs "some_dir")
  (after-every-test))
 (list (build-path "/usr" "local" "share" "some_dir")
       (build-path "/usr" "share" "some_dir")))


(test-exn
 "config-dirs raises an exception if not run on unix"
 exn:fail?
 (λ ()
   (parameterize ([xdgbasedir-current-os 'windows])
     (xdgbasedir-config-dirs))))

(test-equal?
 "config-dirs returns the set XDG_CONFIG_DIRS directories"
 (around
  (before-every-test)
  (putenv "XDG_CONFIG_DIRS"
          (string-join
           (list (path->string (build-path "/tmp" "xdg_config_dir" "1"))
                 (path->string (build-path "/tmp" "xdg_config_dir" "2")))
           ":"))
  (xdgbasedir-config-dirs)
  (after-every-test))
 (list (build-path "/tmp" "xdg_config_dir" "1")
       (build-path "/tmp" "xdg_config_dir" "2")))

(test-equal?
 "config-dirs returns the set XDG_CONFIG_DIRS directories with subdir"
 (around
  (before-every-test)
  (putenv "XDG_CONFIG_DIRS"
          (string-join
           (list (path->string (build-path "/tmp" "xdg_config_dir" "1"))
                 (path->string (build-path "/tmp" "xdg_config_dir" "2")))
           ":"))
  (xdgbasedir-config-dirs "some_dir")
  (after-every-test))
 (list (build-path "/tmp" "xdg_config_dir" "1" "some_dir")
       (build-path "/tmp" "xdg_config_dir" "2" "some_dir")))

(test-equal?
 "config-dirs returns default directories if XDG_CONFIG_DIRS not set"
 (around
  (before-every-test)
  (putenv "XDG_CONFIG_DIRS" "")
  (xdgbasedir-config-dirs)
  (after-every-test))
 (list (build-path "/etc" "xdg")))

(test-equal?
 "config-dirs returns the default directories with subdir if XDG_CONFIG_DIRS \
not set"
 (around
  (before-every-test)
  (putenv "XDG_CONFIG_DIRS" "")
  (xdgbasedir-config-dirs "some_dir")
  (after-every-test))
 (list (build-path "/etc" "xdg" "some_dir")))

(test-exn
 "runtime-dir raises an exception if not run on unix"
 exn:fail?
 (λ ()
   (parameterize ([xdgbasedir-current-os 'windows])
     (xdgbasedir-runtime-dir))))

(test-equal?
 "runtime-dir returns the set XDG_RUNTIME_DIR directories"
 (around
  (before-every-test)
  (putenv "XDG_RUNTIME_DIR"
          (path->string (build-path "/tmp" "xdg_runtime_dir")))
  (xdgbasedir-runtime-dir)
  (after-every-test))
 (build-path "/tmp" "xdg_runtime_dir"))

(test-equal?
 "runtime-dir returns the set XDG_RUNTIME_DIR directories with subdir"
 (around
  (before-every-test)
  (putenv "XDG_RUNTIME_DIR"
          (path->string (build-path "/tmp" "xdg_runtime_dir")))
  (xdgbasedir-runtime-dir "some_dir")
  (after-every-test))
 (build-path "/tmp" "xdg_runtime_dir" "some_dir"))

(test-equal?
 "runtime-dir returns #f if XDG_RUNTIME_DIR not set"
 (around
  (before-every-test)
  (putenv "XDG_RUNTIME_DIR" "")
  (xdgbasedir-runtime-dir)
  (after-every-test))
 #f)

(test-equal?
 "runtime-dir returns #f if XDG_RUNTIME_DIR not set, even if subdir given"
 (around
  (before-every-test)
  (putenv "XDG_RUNTIME_DIR" "")
  (xdgbasedir-runtime-dir "some_dir")
  (after-every-test))
 #f)