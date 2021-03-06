;;; setup-theme.el -*- lexical-binding: t; -*-
;; Time-stamp: <2020-08-19 00:04:31 csraghunandan>

;; Copyright (C) 2016-2020 Chakravarthy Raghunandan
;; Author: Chakravarthy Raghunandan <rnraghunandan@gmail.com>

;; function to disable all enabled themes
(defun gh/disable-all-themes ()
  (interactive)
  (mapc #'disable-theme custom-enabled-themes))

;;; Theme hooks
(defvar gh/theme-hooks nil
  "((theme-id . function) ...)")

(defun gh/add-theme-hook (theme-id hook-func)
  (add-to-list 'gh/theme-hooks (cons theme-id hook-func)))

(defun gh/load-theme-advice (f theme-id &optional no-confirm no-enable &rest args)
  "Enhances `load-theme' in two ways:
1. Disables enabled themes for a clean slate.
2. Calls functions registered using `gh/add-theme-hook'."
  (unless no-enable
    (gh/disable-all-themes))
  (prog1
      (apply f theme-id no-confirm no-enable args)
    (unless no-enable
      (pcase (assq theme-id gh/theme-hooks)
        (`(,_ . ,f) (funcall f))))))

(advice-add 'load-theme
            :around
            #'gh/load-theme-advice)

;; a pack of modern color themes for emacs
;; https://github.com/hlissner/emacs-doom-themes/
(use-package doom-themes
  :init
  (defun rag/doom-nord-hook ()
        ;; don't use obnoxious colors for `golden-ratio-scroll'
    (with-eval-after-load "golden-ratio-scroll-screen"
      (set-face-attribute 'golden-ratio-scroll-highlight-line-face nil
                          :background 'unspecified :foreground 'unspecified))

    ;; don't use variable pitch for info buffers. Looks jarring
    (set-face-attribute 'Info-quoted nil :inherit 'font-lock-function)
    (set-face-attribute 'info-title-4 nil :inherit nil :weight 'bold)
    (set-face-attribute 'info-menu-header nil :inherit nil :weight 'bold)
    (set-face-attribute 'info-colors-lisp-code-block nil :inherit nil
                        :weight 'bold)

    (with-eval-after-load 'magit
      ;; remove ugly box for `magit-branch-remote-head'
      (set-face-attribute 'magit-branch-remote-head nil
                          :box nil :weight 'bold
                          :inherit 'magit-branch-remote)))

  (defun rag/doom-challenger-deep-theme-hook()
    ;; make volatile highlights have the same face as region, comments are
    ;; intangible inside volatile highlights face
    (with-eval-after-load "volatile-highlights"
      (set-face-attribute 'vhl/default-face nil :background 'unspecified
                          :inherit 'region))

    ;; don't use variable pitch for info buffers. Looks jarring
    (set-face-attribute 'Info-quoted nil :inherit 'font-lock-function)
    (set-face-attribute 'info-title-4 nil :inherit nil :weight 'bold)
    (set-face-attribute 'info-menu-header nil :inherit nil :weight 'bold)
    (set-face-attribute 'info-colors-lisp-code-block nil :inherit nil
                        :weight 'bold)

    ;; make ivy matches more prominent
    (set-face-attribute 'ivy-current-match nil :weight 'bold)

    (with-eval-after-load 'magit
      ;; make `magit-header-line' more readable
      (set-face-attribute 'magit-header-line nil :background "#3D4551"
                          :box '(:line-width 3 :color "#3D4551"))
      ;; remove ugly box for `magit-branch-remote-head'
      (set-face-attribute 'magit-branch-remote-head nil
                          :box nil :weight 'bold
                          :inherit 'magit-branch-remote)))
  (gh/add-theme-hook 'doom-nord #'rag/doom-nord-hook)
  :config

  ;; load my theme: doom-challenger-deep
  (defun my/load-theme (frame)
    (select-frame frame)
    (load-theme 'doom-nord))
  (if (daemonp)
      (add-hook 'after-make-frame-functions #'my/load-theme)
    (load-theme 'doom-nord))

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; use my font instead of the default variable pitch font used by
  ;; doom-themes-treemacs-theme
  (setq doom-themes-treemacs-enable-variable-pitch nil)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(provide 'setup-theme)
