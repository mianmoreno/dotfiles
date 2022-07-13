(define-module (quasar home services xorg)
  #:use-module (conses home services glib)
  #:use-module (conses home services emacs)
  #:use-module (conses home services xorg)
  #:use-module (gnu services)
  #:use-module (gnu home services)
  #:use-module (gnu home-services base)
  #:use-module (gnu home-services xorg)
  #:use-module (gnu packages xorg)
  #:use-module (gnu services xorg)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services base)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu home-services base)
  #:use-module (guix gexp)
  #:export (cursor-service
            xorg-service))

(define (cursor-service)
  (list
   (service home-unclutter-service-type
            (home-unclutter-configuration
             (seconds 2)))
   (elisp-configuration-service
    `((with-eval-after-load 'mwheel
        (custom-set-variables
         '(mouse-wheel-scroll-amount '(1 ((shift) . 1)))
         '(mouse-wheel-progressive-speed nil)
         '(mouse-wheel-follow-mouse t)
         '(scroll-conservatively 100))
        (custom-set-variables
         '(mouse-autoselect-window nil)
         '(what-cursor-show-names t)
         '(focus-follows-mouse t)))))))

(define (xorg-service)
  (list
   (home-generic-service 'home-xorg-packages
                         #:packages (list xinit
                                          xev
                                          xprop
                                          xset
                                          xsetroot
                                          xorg-server
                                          xss-lock
                                          xsecurelock
                                          xf86-input-libinput))
   (simple-service 'xorg-init-service
                   home-shepherd-service-type
                   (list
                    (shepherd-service
                     (provision '(home-screensaver))
                     (requirement '(home-dbus))
                     (one-shot? #t)
                     (start #~(make-system-constructor "xset -dpms s off")))
                    (shepherd-service
                     (provision '(home-xsetroot))
                     (requirement '(home-dbus))
                     (one-shot? #t)
                     (start #~(make-forkexec-constructor (list "xsetroot" "-cursor_name" "left_ptr"))))))
   (service home-xresources-service-type
            (home-xresources-configuration
             (config
              '((Xcursor.theme . "Bibata Classic")
                (Emacs.font . "IBM Plex Sans")
                (Xcursor.size . 16)
                (Xft.autohint . #t)
                (Xft.antialias . #t)
                (Xft.hinting . #t)
                (Xft.hintstyle . hintfull)
                (Xft.rgba . none)
                (Xft.lcdfilter . lcddefault)
                (Xft.dpi . 110)))))))
