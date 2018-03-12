;; Time-stamp: <2018-03-12 23:19:13 csraghunandan>

;; flash the modeline instead of ringing the bell
;; https://github.com/purcell/mode-line-bell
(use-package mode-line-bell
  :defer 1
  :config (mode-line-bell-mode))

(use-package moody
  :config
  (setq moody-slant-function #'moody-slant-apple-rgb)
  (setq x-underline-at-descent-line t)
  (setq moody-mode-line-height 22)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode)
  (column-number-mode)
  (size-indication-mode))

(use-package minions
  :init (minions-mode)
  :config
  (setq minions-direct '(flycheck-mode
                         multiple-cursors-mode)))

;; macro to rename mode-name for major-modes
(defmacro rename-modeline (package-name mode new-name)
  `(eval-after-load ,package-name
     '(defadvice ,mode (after rename-modeline activate)
        (setq mode-name ,new-name))))

(rename-modeline "js2-mode" js2-mode "JS2")
(rename-modeline "typescript-mode" typescript-mode "TS")
(rename-modeline "haskell-mode" haskell-mode "𝞴=")

(let ((line (face-attribute 'mode-line :underline)))
  (zenburn-with-color-variables
    (set-face-attribute 'mode-line          nil :overline   line)
    (set-face-attribute 'mode-line-inactive nil :overline   line)
    (set-face-attribute 'mode-line-inactive nil :underline  line)
    (set-face-attribute 'mode-line          nil :box        nil)
    (set-face-attribute 'mode-line-inactive nil :box        nil)
    (set-face-attribute 'mode-line-inactive nil :background zenburn-bg+05)
    (set-face-attribute 'mode-line-inactive nil :foreground zenburn-blue-2)))

(provide 'setup-mode-line)
