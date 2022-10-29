(define-module (conses packages mail)
  #:use-module (conses packages python-xyz)
  #:use-module (gnu packages mail)
  #:use-module (gnu packages gnupg)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system trivial)
  #:use-module ((guix licenses) #:prefix license:))

(define-public go-gitlab.com-shackra-goimapnotify-next
  (package
    (inherit go-gitlab.com-shackra-goimapnotify)
    (version "2.4-rc3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://gitlab.com/shackra/goimapnotify")
             (commit version)))
       (file-name (git-file-name (package-name go-gitlab.com-shackra-goimapnotify)
                                 version))
       (sha256
        (base32 "0dk12x0x5zan86fdi5wi5zv545vmccs15cdrc2ica9afy189zvdn"))))))

(define-public oauth2ms
  (let ((commit "a1ef0cabfdea57e9309095954b90134604e21c08")
        (revision "0"))
    (package
      (name "oauth2ms")
      (version (git-version "0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri
          (git-reference
           (url "https://github.com/harishkrupo/oauth2ms")
           (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "09fhhr6yhnrdp2jx14dryk8g9krn1dn13y1ycylc5qvvvrvfd5la"))))
      (propagated-inputs
       (list isync python-pyxdg python-gnupg python-msal))
      (build-system trivial-build-system)
      (synopsis "XOauth2 compatible O365 token fetcher.")
      (description "This tool can be used to fetch oauth2 tokens from the Microsoft
identity endpoint. Additionally, it can encode the token in the XOAUTH2 format to be
used as authentication in IMAP mail servers.")
      (license license:asl2.0)
      (home-page "https://github.com/harishkrupo/oauth2ms"))))
