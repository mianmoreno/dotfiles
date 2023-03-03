(define-module (conses hosts base)
  #:use-module (conses utils)
  #:use-module (gnu system)
  #:use-module (gnu system keyboard)
  #:use-module (gnu system file-systems)
  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader grub)
  #:use-module (guix gexp)
  #:use-module (nongnu packages linux)
  #:use-module (ice-9 pretty-print))

(define-public %nonguix-signing-key
  (project-file "conses/keys/nonguix.pub"))

(define-public %default-ssh-key
  (plain-file
   "conses.pub"
   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgHrggw/+ZcncBvWeRmSf/PfaiGVmU2xnuh9C3mfbLN (none)\n"))

(define-public %default-ssh-keygrip "D6B4894600BB392AB2AEDE499CBBCF3E0620B7F6")

(define-public %default-kernel linux)

(define-public %default-timezone (getenv "TIMEZONE"))

(define-public %default-email (getenv "MAIL_PERSONAL_EMAIL"))

(define-public %default-fullname (getenv "MAIL_PERSONAL_FULLNAME"))

(define-public %default-username (getenv "USERNAME"))

(define-public %default-domain (getenv "DOMAIN"))

(define-public %tubo-host (getenv "TUBO_HOST"))

(define-public %default-kernel-arguments
  (list "quiet" "net.ifnames=0"))

(define-public %default-keyboard-layout
  (keyboard-layout
   "us,es"
   #:options '("grp:shifts_toggle"
               "caps:ctrl_modifier"
               "altwin:prtsc_rwin")))

(define-public %default-mpv-tab-bar-modules
  '((make-rde-tab-bar-module
     :id 'mpv-string
     :label 'mpv-mode-line-string)
    (make-rde-tab-bar-module
     :id 'mpv-prev
     :label 'mpv-prev-button
     :help "Previous playlist entry"
     :action 'mpv-playlist-prev)
    (make-rde-tab-bar-module
     :id 'mpv-toggle
     :label 'mpv-toggle-button
     :help "Toggle playback"
     :action 'mpv-pause)
    (make-rde-tab-bar-module
     :id 'mpv-next
     :label 'mpv-next-button
     :help "Next playlist entry"
     :action 'mpv-playlist-next)
    (make-rde-tab-bar-module
     :id 'mpv-playing-time
     :label 'mpv-playing-time-string)))

(define-public %initial-os
  (operating-system
    (host-name "conses")
    (locale "en_US.utf8")
    (timezone %default-timezone)
    (bootloader (bootloader-configuration
                 (bootloader grub-efi-bootloader)
                 (targets '("/boot/efi"))))
    (kernel-arguments %default-kernel-arguments)
    (keyboard-layout %default-keyboard-layout)
    (file-systems %base-file-systems)
    (issue "This is the GNU system. Welcome.\n")
    (sudoers-file #f)))
