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
      '(try-complete-file-name-partially
        try-complete-file-name
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
	try-expand-dabbrev-from-kill
        ))

(use-package yasnippet
  :ensure t
  :bind (("M-=" . yas-insert-snippet))
  :diminish yas-minor-mode
  :init
  (yas-global-mode 1)
  :config
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets")
  (yas-reload-all))

(provide 'init-completion)
