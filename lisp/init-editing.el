(use-package unfill
  :ensure t)

(when (fboundp 'electric-pair-mode)
  (electric-pair-mode))

(when (eval-when-compile (version< "24.4" emacs-version))
  (electric-indent-mode 1))

;; Highlights matching parenthesis
(show-paren-mode 1)

(defun toggle-comment-on-line ()
  "Comment or uncomment current line."
  (interactive)
  (comment-or-uncomment-region (line-beginning-position) (line-end-position)))
(global-set-key (kbd "C-;") 'toggle-comment-on-line)

(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(use-package indent-guide
  :ensure t
  :diminish indent-guide-mode
  :init
  (add-hook 'prog-mode-hook 'indent-guide-mode))

;;----------------------------------------------------------------------------
;; Don't disable narrowing commands
;;----------------------------------------------------------------------------
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)

;;----------------------------------------------------------------------------
;; Don't disable case-change functions
;;----------------------------------------------------------------------------
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;----------------------------------------------------------------------------
;; Rectangle selections, and overwrite text when the selection is active
;;----------------------------------------------------------------------------
(cua-selection-mode t)                  ; for rectangles, CUA is nice

(provide 'init-editing)
