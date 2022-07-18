(define-module (conses home services ocaml)
  #:use-module (rde features predicates)
  #:use-module (gnu home services)
  #:use-module (gnu home-services-utils)
  #:use-module (gnu packages ocaml)
  #:use-module (gnu services configuration)
  #:use-module (guix gexp)
  #:export (home-ocaml-configuration
            home-ocaml-service-type))

(define-configuration/no-serialization home-ocaml-configuration
  (ocaml
    (file-like ocaml)
    "The @code{ocaml} package to use.")
  (tools
   (list-of-file-likes '())
   "OCaml tools and libraries to install alongside @code{package}.")
  (config
   (list '())
   "List of strings that make up a @file{.ocamlinit} configuration."))

(define (home-ocaml-files-service config)
  (define (filter-fields field)
    (filter-configuration-fields home-ocaml-configuration-fields
                                 (list field)))

  (filter
   (compose not null?)
   (list
    (optional (not (null? ((configuration-field-getter
                            (car (filter-fields 'config))) config)))
              `("ocaml/init.ml"
                ,(mixed-text-file
                  "init-ml"
                  #~(string-append
                     #$@(interpose (home-ocaml-configuration-config config)
                                   "\n" 'suffix))))))))

(define (home-ocaml-profile-service config)
  (cons* (home-ocaml-configuration-ocaml config)
         (home-ocaml-configuration-tools config)))

(define home-ocaml-service-type
  (service-type
   (name 'home-ocaml)
   (extensions
    (list
     (service-extension
      home-profile-service-type
      home-ocaml-profile-service)
     (service-extension
      home-xdg-configuration-files-service-type
      home-ocaml-files-service)))
   (default-value (home-ocaml-configuration))
   (description "Home service for the OCaml programming language.")))