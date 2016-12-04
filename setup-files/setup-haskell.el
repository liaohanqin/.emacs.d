;; Time-stamp: <2016-12-04 12:44:01 csraghunandan>

;; haskell-mode configuration
;; https://github.com/haskell/haskell-mode
(use-package haskell-mode
  ;; haskell-mode swaps `C-m' and `C-j' behavior. Revert it back
  :bind (:map haskell-mode-map
              ("C-m" . newline)
              ("C-j" . electric-newline-and-maybe-indent))
  :config
  (defun my-haskell-mode-hook ()
    "Hook for `haskell-mode'."
    (set (make-local-variable 'company-backends)
         '((company-intero company-files))))
  (add-hook 'haskell-mode-hook 'my-haskell-mode-hook)
  (add-hook 'haskell-mode-hook 'company-mode)
  (add-hook 'haskell-mode-hook 'haskell-indentation-mode)

  ;; intero-mode for a complete IDE solution to haskell
  ;; commercialhaskell.github.io/intero
  (use-package intero
    :config (add-hook 'haskell-mode-hook 'intero-mode))

  ;; hindent - format haskell code automatically
  ;; https://github.com/chrisdone/hindent
  (when (executable-find "hindent")
    (use-package hindent
      :diminish hindent-mode
      :config
      (add-hook 'haskell-mode-hook #'hindent-mode)
      ;; reformat the buffer using hindent on save
      (setq hindent-reformat-buffer-on-save t)))

  (add-to-list 'load-path "/Users/csraghunandan/structured-haskell-mode/elisp")
  (require 'shm)
  (add-hook 'haskell-mode-hook (lambda ()
                                 (haskell-indentation-mode -1)
                                 (smartparens-mode -1)))
  (add-hook 'haskell-mode-hook 'structured-haskell-mode))

(provide 'setup-haskell)

;; Haskell intero config
;; `C-c C-l' to load the current file to stack GHCi
;; `C-c C-z' to open stack GHCi
;; `C-c C-t' to see the type of the thing at point
;; `M-.' jump to definition
;; `M-,' jump back from definition
;; `M-q' to format the expression at point using hindent
;; `C-M-\' to format the selected region using hindent
