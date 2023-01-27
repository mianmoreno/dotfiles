(define-module (conses feature-list)
  #:use-module (conses features bittorrent)
  #:use-module (conses features bluetooth)
  #:use-module (conses features clojure)
  #:use-module (conses features emacs-xyz)
  #:use-module (conses features fontutils)
  #:use-module (conses features golang)
  #:use-module (conses features lisp)
  #:use-module (conses features mail)
  #:use-module (conses features matrix)
  #:use-module (conses features messaging)
  #:use-module (conses features nyxt-xyz)
  #:use-module (conses features ocaml)
  #:use-module (conses features scheme)
  #:use-module (conses features security)
  #:use-module (conses features shellutils)
  #:use-module (conses features tex)
  #:use-module (conses features version-control)
  #:use-module (conses features video)
  #:use-module (conses features wm)
  #:use-module (conses features xorg)
  #:use-module (contrib features javascript)
  #:use-module (guix gexp)
  #:use-module (rde features)
  #:use-module (rde features shells)
  #:use-module ((rde features emacs-xyz) #:select (feature-emacs-eglot
                                                   feature-emacs-keycast
                                                   feature-emacs-spelling
                                                   feature-emacs-time))
  #:use-module (rde features irc)
  #:use-module ((rde features mail) #:select (feature-mail-settings
                                              feature-isync))
  #:use-module (rde features terminals)
  #:use-module (rde features xdg)
  #:use-module (rde packages))

(define-public %multimedia-base-features
  (list
   (feature-transmission)
   (feature-youtube-dl
    #:emacs-ytdl (@ (conses packages emacs-xyz) emacs-ytdl-next)
    #:music-dl-args '("-q" "-x"  "-f" "bestaudio" "--audio-format" "mp3" "--add-metadata"
                      "--compat-options" "all")
    #:video-dl-args '("-q" "-f" "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"
                      "--add-metadata" "--compat-options" "all"))
   (feature-emacs-emms)
   (feature-mpv
    #:mpv (@ (conses packages video) mpv-34)
    #:emacs-mpv (@ (conses packages emacs-xyz) emacs-mpv-next)
    #:extra-mpv-conf
    `((border . no)
      (volume . 100)
      (screenshot-directory . ,(string-append (or (getenv "XDG_DATA_HOME") "~/.local/share") "/mpv/screenshots"))
      (autofit . 800x800)
      (osd-border-size . 2)
      (osd-bar . yes)
      (osd-level . 0)
      (slang . en)
      (ytdl-raw-options . "ignore-config=,sub-lang=en,write-auto-sub=")
      (script-opts-add=osc-visibility . never)
      (script-opts-add=osc-windowcontrols . no))
    #:extra-bindings
    `(("F" . "cycle fullscreen")
      ("M" . "cycle mute")
      ("+" . "add volume 2")
      ("-" . "add volume -2")
      (":" . "script-binding console/enable")
      ("s" . "screenshot video")
      ("Q" . "quit-watch-later")
      ("O" . "no-osd cycle-values osd-level 3 0")
      ("o" . "osd-bar show-progress")
      ("v" . "cycle sub-visibility")
      ("b" . "cycle sub")
      ("n" . "script-message osc-visibility always")
      ("N" . "script-message osc-visibility never")
      ("L" . "cycle-values loop-file \"inf\" \"no\"")))))

(define-public %emacs-completion-base-features
  (list
   (feature-emacs-all-the-icons)
   (feature-emacs-completion #:consult-initial-narrowing? #t)
   (feature-emacs-vertico)
   (feature-emacs-corfu #:corfu-doc? #t)
   (feature-emacs-wgrep)))

(define-public %emacs-base-features
  (list
   (feature-emacs-modus-themes
    #:dark? #t)
   (feature-emacs-pdf-tools)
   (feature-emacs-tempel)
   (feature-emacs-files)
   (feature-emacs-ibuffer)
   (feature-emacs-graphviz)
   (feature-emacs-calendar #:week-numbers? #t)
   (feature-emacs-bookmark #:bookmarks-file "~/documents/bookmarks")
   (feature-emacs-spelling
    #:flyspell-hooks '(org-mode-hook bibtex-mode-hook)
    #:ispell-standard-dictionary "en_US")
   (feature-emacs-info)
   (feature-emacs-which-key)
   (feature-emacs-helpful
    #:emacs-helpful (@ (conses packages emacs-xyz) emacs-helpful-next))
   (feature-emacs-time
    #:display-time? #t
    #:display-time-24hr? #t
    #:display-time-date? #t
    #:world-clock-time-format "%R %Z"
    #:world-clock-timezones
    '(("Europe/London" "London")
      ("Europe/Madrid" "Madrid")
      ("Europe/Moscow" "Moscow")
      ("America/New_York" "New York")
      ("Australia/Sydney" "Sydney")
      ("Asia/Tokyo" "Tokyo")))
   (feature-emacs-dired)
   (feature-emacs-calc)
   (feature-emacs-tramp)
   (feature-emacs-rainbow-delimiters)
   (feature-emacs-re-builder)
   (feature-emacs-image)
   (feature-emacs-window)
   (feature-emacs-whitespace
    #:global-modes
    '(not org-mode org-agenda-mode org-agenda-follow-mode
          org-capture-mode dired-mode eshell-mode magit-status-mode
          diary-mode magit-diff-mode text-mode pass-view-mode erc-mode))
   (feature-emacs-project)
   (feature-emacs-keycast)
   (feature-emacs-cursor)))

(define-public %markup-base-features
  (list
   (feature-emacs-org
    #:org-priority-faces
    '((?A . (:foreground "#FF665C" :weight bold))
      (?B . (:foreground "#51AFEF"))
      (?C . (:foreground "#4CA171")))
    #:org-todo-keywords
    '((sequence "TODO(t)" "NEXT(n)" "HOLD(h)" "|" "DONE(d!)"))
    #:org-todo-keyword-faces
    '(("TODO" . "#ff665c")
      ("NEXT" . "#FCCE7B")
      ("HOLD" . "#a991f1")
      ("DONE" . "#7bc275"))
    #:org-tag-alist
    '((:startgroup)
      (:endgroup)
      ("work" . ?w)
      ("emacs" . ?e)
      ("project" . ?p)
      ("linux" . ?l)
      ("education" . ?d)
      ("finance" . ?f)
      ("guix" . ?g)
      ("chore" . ?c)))
   (feature-emacs-org-recur)
   (feature-emacs-org-roam
    #:org-roam-directory "~/documents/notes"
    #:org-roam-dailies-directory "journal/"
    #:org-roam-capture-templates
    `(("d" "default" plain "%?"
       :if-new (file+head
                "%<%Y%m%d%H%M%S>-${slug}.org"
                "#+title: ${title}\n#+filetags: :${Topic}:\n")
       :unnarrowed t)
      ("e" "Programming Concept" plain
       ,(string-append
         "#+begin_src %^{Language|elisp|lisp|scheme"
         "|clojure|ocaml|js}\n%?\n#+end_src\n")
       :if-new (file+head
                "%<%Y%m%d%H%M%S>-${slug}.org"
                ,(string-append
                  ":PROPERTIES:\n:DATA_TYPE: "
                  "%^{Data Type|Function|Method|Variable|Macro|Procedure}"
                  "\n:END:\n#+title: ${title}\n#+filetags: :${Topic}:"))
       :unnarrowed t)
      ("r" "Reference" plain "%?"
       :if-new (file+head
                "%<%Y%m%d%H%M%S>-${slug}.org"
                ,(string-append
                  ":PROPERTIES:\n:ROAM_REFS: ${ref}\n:END:\n"
                  "#+title: ${title}\n#+filetags: :${Topic}:"))
       :unnarrowed t)
      ("m" "Recipe" plain "* Ingredients\n- %?\n* Directions"
       :if-new (file+head
                "%<%Y%m%d%H%M%S>-${title}.org"
                ,(string-append
                  ":PROPERTIES:\n:ROAM_REFS: %l\n"
                  ":MEAL_TYPE: %^{Meal Type|Lunch\|Breakfast|Appetizer|Dessert}"
                  "\n:END:\n#+title: ${title}\n#+filetags: :cooking:"))
       :unnarrowed t)
      ("b" "Book" plain
       "* Chapters\n%?"
       :if-new (file+head
                "%<%Y%M%d%H%M%S>-${slug}.org"
                ,(string-append
                  ":PROPERTIES:\n:AUTHOR: ${Author}\n:DATE: ${Date}\n"
                  ":PUBLISHER: ${Publisher}\n:EDITION: ${Edition}\n:END:\n"
                  "#+title: ${title}\n#+filetags: :${Topic}:"))
       :unnarrowed t))
    #:org-roam-dailies-capture-templates
    '(("d" "default" entry
       "* %?"
       :if-new (file+head "%<%Y-%m-%d>.org"
                          "#+title: %<%Y-%m-d>\n"))))
   (feature-emacs-org-agenda)
   (feature-emacs-markdown)
   (feature-tex
    #:listings-options
    '(("basicstyle" "\\ttfamily")
      ("stringstyle" "\\color{blue}\\ttfamily")
      ("numbers" "left")
      ("numberstyle" "\\tiny")
      ("breaklines" "true")
      ("showstringspaces" "false")
      ("showtabs" "false")
      ("keywordstyle" "\\color{violet}")
      ("commentstyle" "\\color{gray}")
      ("label" "{Figure}"))
    #:extra-packages
    (strings->packages
     "texlive-wrapfig" "texlive-capt-of"
     "texlive-hyperref" "texlive-fonts-ec"
     "texlive-latex-geometry" "texlive-listings"
     "texlive-xcolor" "texlive-ulem" "texlive-latex-preview"
     "texlive-amsfonts" "texlive-grfext" "texlive-latex-natbib"
     "texlive-titling" "texlive-latex-titlesec" "texlive-enumitem"))
   (feature-emacs-citar)))

(define-public %communication-base-features
  (list
   (feature-matrix-settings
    #:homeserver (string-append "https://pantalaimon." (getenv "DOMAIN"))
    #:matrix-accounts
    (list
     (matrix-account
      (id (getenv "MATRIX_USER"))
      (homeserver (string-append "matrix." (getenv "DOMAIN"))))))
   (feature-emacs-ement)
   (feature-irc-settings
    #:irc-accounts
    (list
     (irc-account
      (id 'srht)
      (network "chat.sr.ht")
      (bouncer? #t)
      (nick (getenv "IRC_BOUNCER_NICK")))
     (irc-account
      (id 'libera)
      (network "irc.libera.chat")
      (nick (getenv "IRC_LIBERA_NICK")))
     (irc-account
      (id 'oftc)
      (network "irc.oftc.net")
      (nick (getenv "IRC_OFTC_NICK")))))
   (feature-emacs-erc
    #:erc-auto-query 'bury
    #:erc-query-display 'buffer
    #:erc-join-buffer 'bury
    #:erc-images? #t
    #:erc-log? #f
    #:erc-autojoin-channels-alist
    '((Libera.Chat
       "#nyxt" "#emacs" "#org-mode" "#guix" "#nonguix" "#ocaml"
       "#clojure" "#commonlisp" "#scheme" "#tropin")
      (OFTC "#postmarketos" "#mobian")))
   (feature-slack-settings
    #:slack-accounts
    (list
     (slack-account
      (workspace (getenv "SLACK_WORKSPACE"))
      (token (getenv "SLACK_TOKEN"))
      (cookie (getenv "SLACK_COOKIE")))))
   (feature-emacs-slack)
   (feature-emacs-telega)))

(define-public %shell-base-features
  (list
   (feature-direnv)
   (feature-emacs-comint)
   (feature-emacs-shell)
   (feature-emacs-eshell)
   (feature-compile)
   (feature-bash)
   (feature-vterm)))

(define %gnus-topic-alist
  '(("personal"
     "nnmaildir+personal:inbox"
     "nnmaildir+personal:drafts"
     "nnmaildir+personal:sent"
     "nnmaildir+personal:spam"
     "nnmaildir+personal:trash")
    ("clojure"
     "nntp+gwene:gwene.clojure.planet"
     "nntp+gwene:gwene.com.google.groups.clojure")
    ("lisp"
     "nntp+gwene:gwene.org.lisp.planet"
     "nntp+gwene:gwene.engineer.atlas.nyxt"
     "nntp+gwene:gwene.org.wingolog")
    ("technology"
     "nntp+gwene:gwene.org.fsf.news"
     "nntp+gwene:gwene.rs.lobste"
     "nntp+gwene:gwene.org.hnrss.newest.points"
     "nntp+gwene:gwene.com.unixsheikh"
     "nntp+gwene:gwene.com.drewdevault.blog"
     "nntp+gwene:gwene.net.lwn.headlines.newrss"
     "nntp+gwene:gwene.com.usesthis"
     "nntp+gwene:gwene.org.sourcehut.blog"
     "nntp+gwene:gwene.cc.tante"
     "nntp+gwene:gwene.org.matrix.blog")
    ("emacs"
     "nntp+gwene:gmane.emacs.devel"
     "nntp+gwene:gmane.emacs.erc.general"
     "nntp+gwene:gwene.com.oremacs"
     "nntp+gwene:gwene.org.emacslife.planet"
     "nntp+gwene:gwene.group.discourse.org-roam.latest")
    ("guix"
     "nntp+gwene:gmane.comp.gnu.guix.bugs"
     "nntp+gwene:gmane.comp.gnu.guix.patches"
     "nntp+gwene:gwene.org.gnu.guix.feeds.blog")
    ("Gnus")))

(define-public %mail-base-features
  (list
   (feature-mail-settings
    #:mail-accounts
    (list
     (mail-acc 'personal (getenv "MAIL_PERSONAL_EMAIL") 'gandi))
    #:mail-directory-fn mail-directory-fn
    #:mailing-lists
    (list
     (mail-lst 'guix-devel "guix-devel@gnu.org"
               '("https://yhetil.org/guix-devel/0"))
     (mail-lst 'guix-devel "guix-bugs@gnu.org"
               '("https://yhetil.org/guix-bugs/0"))
     (mail-lst 'guix-devel "guix-patches@gnu.org"
               '("https://yhetil.org/guix-patches/1"))))
   (feature-isync)
   (feature-goimapnotify
    #:goimapnotify (@ (conses packages mail) go-gitlab.com-shackra-goimapnotify-next))
   (feature-emacs-ebdb
    #:ebdb-popup-size 0.2)
   (feature-emacs-gnus
    #:topic-alist %gnus-topic-alist
    #:topic-topology
    '(("Gnus" visible)
      (("personal" visible nil))
      (("clojure" visible nil))
      (("lisp" visible nil))
      (("technology" visible nil))
      (("emacs" visible nil))
      (("guix" visible nil)))
    #:message-archive-method '(nnmaildir "personal")
    #:message-archive-group '((".*" "sent"))
    #:group-parameters
    '(("^nnmaildir"
       (display . 100)
       (gcc-self . "nnmaildir+personal:sent"))
      ("^nntp"
       (display . 1000)))
    #:posting-styles
    `(("^nnmaildir"
       (signature ,(string-append "Best regards,\n" (getenv "MAIL_PERSONAL_FULLNAME"))))
      ((header "to" ".*@lists.sr.ht")
       (To rde-gnus-get-article-participants)
       (name ,(getenv "USERNAME"))
       (cc ,(getenv "MAIL_PERSONAL_EMAIL"))
       (signature ,(string-append "Best regards,\n" (getenv "USERNAME"))))
      ("^nntp.+:"
       (To rde-gnus-get-article-participants)
       (name ,(getenv "USERNAME"))
       (cc ,(getenv "MAIL_PERSONAL_EMAIL"))
       (signature ,(string-append "Best regards,\n" (getenv "USERNAME"))))))
   (feature-emacs-message
    #:message-signature (string-append "Best regards,\n" (getenv "USERNAME")))
   (feature-emacs-org-mime)
   (feature-emacs-smtpmail
    #:smtp-user (getenv "MAIL_PERSONAL_EMAIL")
    #:smtp-server (getenv "MAIL_PERSONAL_HOST"))))

(define-public %programming-base-features
  (list
   (feature-emacs-flymake)
   (feature-emacs-eglot)
   (feature-emacs-xref)
   (feature-emacs-smartparens
    #:paredit-bindings? #t
    #:smartparens-hooks '(prog-mode-hook
                          lisp-data-mode-hook
                          minibuffer-inactive-mode-hook
                          comint-mode-hook))
   (feature-emacs-elisp)
   (feature-clojure)
   (feature-javascript
    #:node (@ (gnu packages node) node-lts))
   (feature-lisp
    #:custom-sly-prompt? #t
    #:extra-lisp-packages
    (strings->packages "sbcl-prove" "sbcl-cl-cffi-gtk" "sbcl-lisp-unit2")
    #:extra-source-registry-entries
    `(("common-lisp/source-registry.conf.d/10-home.conf"
       ,(plain-file "10-home.conf"
                    (format #f "(:tree \"~a/src\")" (getenv "HOME")))))
    #:extra-lisp-templates
    '((do "(do (" p ")" n> r> ")")))
   (feature-ocaml)
   (feature-guile)
   (feature-go)
   (feature-emacs-yaml)
   (feature-emacs-lang-web)))

(define-public %emacs-desktop-base-features
  (list
   (feature-emacs-ednc
    #:notifications-icon "")
   (feature-emacs-exwm
    #:window-configurations
    '(((string= exwm-class-name "Nyxt")
       char-mode t
       workspace 1
       simulation-keys nil
       (exwm-layout-hide-mode-line))
      ((string= exwm-instance-name "emacs")
       char-mode t)
      ((string-match "Android Emulator" exwm-title)
       floating t)))
   (feature-emacs-exwm-run-on-tty
    #:emacs-exwm-tty-number 1
    #:launch-arguments '("-mm" "--debug-init")
    #:extra-xorg-config
    (list
     "Section \"Monitor\"
  Identifier \"DP-3\"
  Option \"DPMS\" \"false\"
EndSection
Section \"ServerFlags\"
  Option \"BlankTime\" \"0\"
EndSection"))
   (feature-xorg)
   (feature-emacs-pulseaudio-control
    #:emacs-pulseaudio-control (@ (conses packages emacs-xyz) emacs-pulseaudio-control-next))
   (feature-emacs-tab-bar
    #:modules-left
    `((make-rde-tab-bar-module
       :id 'menu-bar
       :label (format " %s "
                      (all-the-icons-fileicon
                       "emacs" :v-adjust -0.1 :height 1))
       :help "Menu"
       :action 'tab-bar-menu-bar)
      ,@%rde-mpv-tab-bar-modules
      (make-rde-tab-bar-module
       :id 'notifications
       :label '(:eval (rde-ednc--notify))))
    #:modules-center
    '((make-rde-tab-bar-module
       :id 'time
       :label 'display-time-string))
    #:modules-right
    '((make-rde-tab-bar-module
       :id 'org-timer
       :label 'org-timer-mode-line-string)
      (make-rde-tab-bar-module
       :id 'appointments
       :label 'appt-mode-string)
      (make-rde-tab-bar-module
       :id 'weather
       :label 'display-wttr-string)
      (make-rde-tab-bar-module
       :id 'volume-sink
       :label 'pulseaudio-control-display-volume-string)
      (make-rde-tab-bar-module
       :id 'battery
       :label 'battery-mode-line-string)))
   (feature-emacs-battery)
   (feature-emacs-display-wttr
    #:emacs-display-wttr (@ (conses packages emacs-xyz) emacs-display-wttr-next))))

(define-public %desktop-base-features
  (list
   (feature-bluetooth)
   (feature-xdg
    #:xdg-user-directories-configuration
    (home-xdg-user-directories-configuration
     (desktop "$HOME")
     (documents "$HOME/documents")
     (download "$HOME/downloads")
     (music "$HOME/music")
     (pictures "$HOME/pictures")
     (publicshare "$HOME")
     (videos "$HOME/videos")
     (templates "$HOME")))))

(define-public %ui-base-features
  (list
   (feature-emacs-appearance
    #:auto-theme? #f)
   (feature-fonts)))

(define (nyxt-extra-routes config)
  `((make-instance 'router:web-route
                   :trigger (match-regex ".*/watch\\?.*v=.*" ".*/playlist\\?list=.*")
                   :redirect-url (quri:uri "https://www.youtube.com")
                   :resource (lambda (url)
                               (play-video-mpv url :formats nil :audio t :repeat t)))
    (make-instance 'router:web-route
                   :trigger (match-regex "^https://(m.)?soundcloud.com/.*/.*")
                   :resource (lambda (url)
                               (play-video-mpv url :formats nil :audio t :repeat t)))
    (make-instance 'router:opener
                   :trigger (match-regex "https://gfycat.com/.*" "https://streamable.com/.*"
                                         "https://.*/videos/watch/.*" ".*cloudfront.*master.m3u8")
                   :resource (lambda (url)
                               (play-video-mpv url :formats nil)))
    (make-instance 'router:opener
                   :trigger (match-scheme "mailto")
                   :resource "xdg-open ~a")
    (make-instance 'router:opener
                   :trigger (match-scheme "magnet" "torrent")
                   :resource (lambda (url)
                               (eval-with-emacs `(transmission-add ,url))))
    (make-instance 'router:blocker
                   :trigger (match-domain "lemmy.ml")
                   :blocklist '(:path (:contains (not "/u/" "/post/"))))
    (make-instance 'router:blocker
                   :trigger (match-regex ,(string-append (get-value 'reddit-frontend config) "/.*"))
                   :instances 'make-teddit-instances
                   :blocklist '(:path (:contains (not "/comments/" "/wiki/"))))
    (make-instance 'router:blocker
                   :trigger (match-regex ,(string-append (get-value 'tiktok-frontend config) "/.*"))
                   :instances 'make-proxitok-instances
                   :blocklist '(:path (:contains (not "/video/" "/t/"))))
    (make-instance 'router:blocker
                   :trigger (match-regex ,(string-append (get-value 'instagram-frontend config) "/.*"))
                   :blocklist '(:path (:contains (not "/media/"))))))

(define-public %nyxt-base-features
  (list
   (feature-nyxt-nx-mosaic)
   (feature-nyxt-nx-tailor
    #:auto? #f
    #:dark-theme? #t)
   (feature-nyxt-hint)
   (feature-nyxt-emacs
    #:autostart-delay 5)
   (feature-nyxt-blocker)
   (feature-nyxt-userscript
    #:userstyles
    '((make-instance
       'nyxt/user-script-mode:user-style
       :include '("https://github.com/*"
                  "https://gist.github.com/*")
       :code (cl-css:css
              `((,(str:join "," '("#dashboard .body"
                                  ".js-inline-dashboard-render"
                                  ".js-feed-item-component"
                                  ".js-yearly-contributions"
                                  ".js-profile-editable-area div .mb-3"
                                  ".starring-container"
                                  "#js-contribution-activity"
                                  "#year-list-container"
                                  "a[href$=watchers]"
                                  "a[href$=stargazers]"
                                  "a[href$=followers]"
                                  "a[href$=following]"
                                  "a[href$=achievements]"
                                  "[action*=follow]"))
                 :display "none !important")
                ("img[class*=avatar]"
                 :visibility "hidden"))))))
   (feature-nyxt-nx-search-engines)
   (feature-nyxt-nx-router
    #:extra-routes nyxt-extra-routes)))

(define-public %web-base-features
  (list
   (feature-emacs-browse-url)
   (feature-emacs-eww)
   (feature-emacs-webpaste
    #:webpaste-providers '("bpa.st" "bpaste.org" "dpaste.org" "dpaste.com"))))

(define-public %security-base-features
  (list
   (feature-password-store
    #:remote-password-store-url "git@git.sr.ht:~conses/pass")))

(define-public %forge-base-features
  (list
   (feature-forge-settings
    #:forge-accounts
    (list
     (forge-account
      (id 'sh)
      (forge 'sourcehut)
      (username (getenv "USERNAME"))
      (email (getenv "SOURCEHUT_EMAIL"))
      (token (getenv "SOURCEHUT_TOKEN")))
     (forge-account
      (id 'gh)
      (forge 'github)
      (username (getenv "GITHUB_USER"))
      (email (getenv "GITHUB_EMAIL"))
      (token (getenv "GITHUB_TOKEN")))))
   (feature-sourcehut)
   (feature-git
    #:primary-forge-account-id 'sh
    #:sign-commits? #t
    #:global-ignores '("**/.direnv" "node_modules" "*.elc" ".log"))))