;;Backups

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;;History
(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
	search-ring
	regexp-search-ring))

;; Window configuration
(when window-system
  (tooltip-mode -1)
  (tool-bar-mode -1)
  (menu-bar-mode 1)
  (scroll-bar-mode -1))


;;Help
(use-package guide-key
  :diminish guide-key-mode
  :config
  (progn
    (setq guide-key/guide-key-sequence '("C-x r" "C-x 4" "C-c"))
    (guide-key-mode 1)))

;; Moving between windows
(use-package windmove
  :ensure t
  :bind
  (("<f2> <right>" . windmove-right)
   ("<f2> <left>" . windmove-left)
   ("<f2> <up>" . windmove-up)
   ("<f2> <down>" . windmove-down)
   ))

;; Split windows by golden ratio
(use-package golden-ratio
	:ensure t
	:diminish golden-ratio-mode
	:config
	(progn
		(golden-ratio-mode 1)))

(use-package switch-window
  :ensure t
  :bind (("C-x o" . switch-window)))

;;Recent files
(require 'recentf)
(setq recentf-max-saved-items 200
			recentf-max-menu-items 15)
(recentf-mode)

;; reload buffers when file changes on disk
(global-auto-revert-mode t)

;; start emacs maximized
;; found here http://thestandardoutput.com/posts/how-to-properly-maximize-the-active-emacs-frame-on-startup-on-windows/
(defun w32-maximize-frame ()
  "Maximize the current frame (windows only)"
  (interactive)
  (w32-send-sys-command 61488))

(if (eq system-type 'windows-nt)
    (progn
      (add-hook 'window-setup-hook 'w32-maximize-frame t))
  (set-frame-parameter nil 'fullscreen 'maximized))

;; ask y or n instead of yes or no
(fset 'yes-or-no-p 'y-or-n-p)

(provide 'init-general)
