(use-package git-blamed
  :ensure t)
(use-package gitignore-mode
  :ensure t)
(use-package gitconfig-mode
  :ensure t)
(use-package git-timemachine
  :ensure t)

(use-package magit
  :ensure t
  :bind (("M-<f12>" . magit-status)
	 ("C-x g" . magit-status)
	 ("C-x M-g" . magit-dispatch-popup)
	 :map magit-status-mode-map
	 ("C-M-<up>" . magit-section-up))
  :config
  (setq-default magit-diff-refine-hunk t)
  (add-hook 'magit-popup-mode-hook 'sanityinc/no-trailing-whitespace)
  (fullframe magit-status magit-mode-quit-window))

(use-package fullframe
  :ensure t)

(use-package git-commit
  :ensure t
  :config
  (add-hook 'git-commit-mode-hook 'goto-address-mode))


;; Convenient binding for vc-git-grep
(global-set-key (kbd "C-x v f") 'vc-git-grep)

(after-load 'compile
  (dolist (defn (list '(git-svn-updated "^\t[A-Z]\t\\(.*\\)$" 1 nil nil 0 1)
                      '(git-svn-needs-update "^\\(.*\\): needs update$" 1 nil nil 2 1)))
    (add-to-list 'compilation-error-regexp-alist-alist defn)
    (add-to-list 'compilation-error-regexp-alist (car defn))))

(defvar git-svn--available-commands nil "Cached list of git svn subcommands")
(defun git-svn--available-commands ()
  (or git-svn--available-commands
      (setq git-svn--available-commands
            (sanityinc/string-all-matches
             "^  \\([a-z\\-]+\\) +"
             (shell-command-to-string "git svn help") 1))))

(defun git-svn (dir command)
  "Run a git svn subcommand in DIR."
  (interactive (list (read-directory-name "Directory: ")
                     (completing-read "git-svn command: " (git-svn--available-commands) nil t nil nil (git-svn--available-commands))))
  (let* ((default-directory (vc-git-root dir))
         (compilation-buffer-name-function (lambda (major-mode-name) "*git-svn*")))
    (compile (concat "git svn " command))))

(use-package git-messenger
  :ensure t
  :bind (("C-x v p" . git-messenger:popup-message)))


(provide 'init-git)
