;; -*- lexical-binding: t; -*-
(require 'cl-lib)
(require 'eshell)
(require 'esh-mode)
(require 'eb-util)

(defgroup eb-shell nil
  "Shell customizations for Emacs."
  :group 'eb)

;;;###autoload
(defvar eb-shell-buffer-source
  `(:name "Comint"
          :narrow ?c
          :category buffer
          :preview-key ,(kbd "M-.")
          :state ,#'consult--buffer-state
          :items ,(lambda ()
                    (mapcar #'buffer-name (eb-util--mode-buffers
                                           'comint-mode 'cider-repl-mode))))
  "Source for `comint-mode' buffers to be set in `consult-buffer-sources'.")

(defun eb-shell--bookmark-make-record ()
  "Create a bookmark in an `eshell-mode' buffer."
  (let ((eshell-buffer-name (with-current-buffer (current-buffer)
                              (substring-no-properties (buffer-name))))
        (bookmark `(,eshell-buffer-name
                    ,@(bookmark-make-record-default 'no-file)
                    (handler . eb-shell--jump-to-bookmark)
                    (filename . ,default-directory))))
    bookmark))

(defun eb-shell--jump-to-bookmark (bookmark)
  "Jump to BOOKMARK in Eshell buffer."
  (when-let ((eshell-buffer-name eshell-buffer-name))
    (eshell)
    (setq default-directory (alist-get 'filename bookmark))
    (eshell-reset)))

;;;###autoload
(defun eb-shell--set-bookmark-handler ()
  "Set up corresponding `bookmark-make-record-function' for `eshell-mode' buffers."
  (setq-local bookmark-make-record-function #'eb-shell--bookmark-make-record))

;;;###autoload
(define-minor-mode eb-shell-mode-setup
  "Sets up environment on `eshell-mode' invocation."
  :global t :group 'eb-shell
  (if eb-shell-mode-setup
      (progn
        (setenv "PAGER" "")
        (define-key eshell-mode-map "\C-cL" #'eshell/clear))
    (local-unset-key #'eshell/clear)))

(provide 'eb-shell)
