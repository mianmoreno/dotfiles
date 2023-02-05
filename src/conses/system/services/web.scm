(define-module (conses system services web)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages python-web)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services configuration)
  #:export (whoogle-service-type
            whoogle-configuration))

(define-configuration/no-serialization whoogle-configuration
  (whoogle
    (package whoogle-search)
    "The @code{whoogle-search} package to use."))

(define (whoogle-shepherd-service config)
  (list
   (shepherd-service
    (provision '(whoogle-search))
    (start #~(make-forkexec-constructor
              (list (string-append #$(whoogle-configuration-whoogle config)
                                   "/bin/whoogle-search"))
              #:environment-variables
              (append (list "CONFIG_VOLUME=/var/cache/whoogle-search")
                      (default-environment-variables))))
    (stop #~(make-kill-destructor))
    (documentation "Run a @code{whoogle-search} instance."))))

(define (whoogle-profile-service config)
  (list
   (whoogle-configuration-whoogle config)))

(define whoogle-service-type
  (service-type
   (name 'whoogle-search)
   (extensions
    (list
     (service-extension
      shepherd-root-service-type
      whoogle-shepherd-service)
     (service-extension
      profile-service-type
      whoogle-profile-service)))
   (default-value (whoogle-configuration))
   (description "Whoogle search system service.")))