(fset 'yes-or-no-p 'y-or-n-p)

;; No need for ~ files when editing
(setq create-lockfiles nil)

(use-package guide-key
  :ensure t
  :diminish guide-key-mode
  :config
  (setq guide-key/guide-key-sequence '("C-x" "C-c" "C-x 4" "C-x 5" "C-c ; f" "C-c ' f" "C-x n" "C-x C-r" "C-x r" "M-s" "C-h" "C-c p"))
  (add-hook 'after-init-hook (lambda ()
				(guide-key-mode 1))))


(provide 'init-misc)
