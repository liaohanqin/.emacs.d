;;; setup-python.el -*- lexical-binding: t; -*-
;; Time-stamp: <2020-01-19 09:44:00 csraghunandan>

;; Copyright (C) 2016-2020 Chakravarthy Raghunandan
;; Author: Chakravarthy Raghunandan <rnraghunandan@gmail.com>

;; emacs lsp-mode client for Microsoft's python language server
;; https://github.com/emacs-lsp/lsp-python-ms
(use-package lsp-python-ms
  :hook ((python-mode . (lambda ()
                          ;; (require 'lsp-python-ms)
                          (setq-local lsp-ui-flycheck-enable nil)
                          (lsp)
                          (lsp-ui-mode)
                          (setq-local flycheck-checker 'python-pycheckers)
                          (lsp-ui-doc-mode))))
  :init
  ;; set path of MS python language server
  (setq lsp-python-ms-executable
        "~/src/dotnet/python-language-server/output/bin/Debug/Microsoft.Python.LanguageServer"))

;; Multiple syntax checker for Python in Emacs, using Flycheck
;; https://github.com/msherry/flycheck-pycheckers
(use-package flycheck-pycheckers)

;; TODO: add pyflakes linter
(use-package python
  :ensure nil
  :hook ((python-mode . (lambda ()
                          (smart-dash-mode)
                          (company-mode)
                          (flycheck-mode)
                          (eldoc-mode)))
         (python-mode . (lambda ()
                          (setq-local tab-width 4)))
         (inferior-python-mode . company-mode))
  :config
  ;; don't try to guess python indent offset
  (setq python-indent-guess-indent-offset nil)
  (setq python-shell-completion-native-enable nil)

  (defun my-python-mode-hook ()
    (set (make-local-variable 'company-backends)
         '((company-files :with company-yasnippet)
           (company-dabbrev-code company-dabbrev))))
  (add-hook 'python-mode-hook #'my-python-mode-hook)

  ;; from https://www.snip2code.com/Snippet/127022/Emacs-auto-remove-unused-import-statemen
  (defun python-remove-unused-imports()
    "Use Autoflake to remove unused function"
    "autoflake --remove-all-unused-imports -i unused_imports.py"
    (interactive)
    (if (executable-find "autoflake")
        (progn
          (shell-command (format "autoflake --remove-all-unused-imports -i %s"
                                 (shell-quote-argument (buffer-file-name))))
          (revert-buffer t t t))
      (warn "python-mode: Cannot find autoflake executable, automatic removal of unused imports disabled"))))

;; pytest: for testing python code
;; https://github.com/ionrock/pytest-el
(use-package pytest :defer t)

;; pyenv-mode: Integrate pyenv with python-mode.
;; https://github.com/proofit404/pyenv-mode
(use-package pyenv-mode
  :hook ((python-mode . pyenv-mode))
  :config
  ;; integrate pyenv with projectile
  (defun projectile-pyenv-mode-set ()
    "Set pyenv version matching project name."
    (let ((project (projectile-project-name)))
      (if (member project (pyenv-mode-versions))
          (pyenv-mode-set project)
        (pyenv-mode-unset))))
  (add-hook 'projectile-switch-project-hook 'projectile-pyenv-mode-set))

;; python-docstring: format and highlight syntax for python docstrings
;; https://github.com/glyph/python-docstring-mode
(use-package python-docstring
  :hook ((python-mode . python-docstring-mode)))

;; Python Black formatter for Emacs
;; https://github.com/pythonic-emacs/blacken/
(use-package blacken
  :hook ((python-mode . blacken-mode))
  :config (setq blacken-line-length 80))

;; pip-requirements: Major mode for editing pip requirements files
;; https://github.com/Wilfred/pip-requirements.el
(use-package pip-requirements
  :hook ((pip-requirements-mode . company-mode)))

;; sphinx-doc: add sphinx-doc comments easily
;; https://github.com/naiquevin/sphinx-doc.el
;; to add sphinx-docs to a function, press `C-c M-d' on a function definition
(use-package sphinx-doc
  :hook ((python-mode . sphinx-doc-mode)))

(provide 'setup-python)
