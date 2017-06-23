(setq tab-always-indent 'complete)
(add-to-list 'completion-styles 'initals t)
(setq completion-cycle-threshold 5)

(use-package company
  :ensure t
  :diminish "CMP"
  :bind (("M-C-/" . company-complete)
	 :map company-mode-map
	 ("M-/" . company-complete)
	 :map company-active-map
	 ("M-/" . company-select-next)
	 ("C-n" . company-select-next)
	 ("C-p" . company-select-previous))
  :init
  (global-company-mode 1)
  (setq-default company-backends '((company-capf company-dabbrev-code) company-dabbrev)
		company-dabbrev-other-buffers 'all)
  :config
  (use-package company-quickhelp
    :ensure t
    :defer 10
    :config
    (company-quickhelp-mode 1)))

(defun sanityinc/local-push-company-backend (backend)
  "Add BACKEND to a buffer-local version of `company-backends'."
  (set (make-local-variable 'company-backends)
       (append (list backend)
	        company-backends)))

(defun sanityinc/dabbrev-friend-buffer (other-buffer)
  (< (buffer-size other-buffer) (* 1 1024 1024)))
(setq dabbrev-friend-buffer-function 'sanityinc/dabbrev-friend-buffer)

(global-set-key (kbd "M-/") 'hippie-expand)

(setq hippie-expand-try-functions-list
      '(yas-hippie-try-expand
        try-expand-all-abbrevs
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-dabbrev
        try-expand-dabbrev-from-kill
        try-expand-dabbrev-all-buffers
        try-expand-list
        try-expand-line
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

(provide 'init-completion)
