(define-module (quasar home vega)
  #:use-module (quasar home services android)
  #:use-module (quasar home services audio)
  #:use-module (quasar home services bittorrent)
  #:use-module (quasar home services chat)
  #:use-module (quasar home services clojure)
  #:use-module (quasar home services desktop)
  #:use-module (quasar home services documentation)
  #:use-module (quasar home services emacs)
  #:use-module (quasar home services fonts)
  #:use-module (quasar home services golang)
  #:use-module (quasar home services gtk)
  #:use-module (quasar home services keyboard)
  #:use-module (quasar home services tex)
  #:use-module (quasar home services lisp)
  #:use-module (quasar home services mail)
  #:use-module (quasar home services ocaml)
  #:use-module (quasar home services scheme)
  #:use-module (quasar home services security)
  #:use-module (quasar home services shells)
  #:use-module (quasar home services version-control)
  #:use-module (quasar home services video)
  #:use-module (quasar home services virtualization)
  #:use-module (quasar home services web)
  #:use-module (quasar home services xdg)
  #:use-module (quasar home services xorg)
  #:use-module (gnu home)
  #:use-module (gnu services)
  #:export (%home/vega))

(define %home/vega
  (home-environment
   (services
    (append
     (xdg-service)
     (fdroid-service)
     (android-service)
     (audio-service)
     (transmission-service)
     (matrix-service)
     (irc-service)
     (telegram-service)
     (slack-service)
     (pulseaudio-service)
     (exwm-service)
     (desktop-service)
     (documentation-service)
     (emacs-service)
     (fonts-service)
     (go-service)
     (gtk-service)
     (qmk-service)
     (keyboard-service)
     (tex-service)
     (clojure-service)
     (ocaml-service)
     (lisp-service)
     (mail-service)
     (guile-service)
     (guix-service)
     (ssh-service)
     (gnupg-service)
     (password-service)
     (shell-service)
     (git-service)
     (mpv-service)
     (youtube-dl-service)
     (virtualization-service)
     (web-service #:alt-browser-p #t)
     (nyxt-service)
     (cursor-service)
     (xorg-service)))))

%home/vega