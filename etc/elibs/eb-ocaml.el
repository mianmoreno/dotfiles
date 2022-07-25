;; -*- lexical-binding: t; -*-
(require 'tuareg)
(require 'merlin)

(defgroup eb-ocaml nil
  "Personal customizations for OCaml."
  :group 'eb)

(defun eb-ocaml-load-merlin ()
  "Sets up `merlin-mode' for OCaml."
  (let ((opam-share (when (executable-find "opam")
                      (car (process-lines "opam" "var" "share")))))
    (when (and opam-share (file-directory-p opam-share))
      (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))
      (autoload #'merlin-mode "merlin" nil t nil))
    (add-hook 'tuareg-mode-hook #'merlin-mode)))

(defun eb-ocaml-set-environment ()
  "When using Opam, sets its corresponding environment variables."
  (when (executable-find "opam")
    (dolist (var (car (read-from-string
                       (shell-command-to-string "opam config env --sexp"))))
      (setenv (car var) (cadr var)))))

;;;###autoload
(define-minor-mode eb-ocaml-mode
  "Sets up convenient tweaks for `tuareg-mode' and `merlin-mode'. Namely,
it prevents a leading star from appearing on each comment line
in a multi-line OCaml comment, and it enables `prettify-symbols-mode'."
  :global t :group 'eb-ocaml
  (if eb-ocaml-mode
      (progn
        (setq-local comment-style 'multiline
                    comment-continue "   ")
        (when (fboundp #'prettify-symbols-mode)
          (prettify-symbols-mode 1))
        (eb-ocaml-load-merlin)
        (eb-ocaml-set-environment))))

(provide 'eb-ocaml)
