
(provide 'init-theme)

;;(defvar deos/background 'light)
(defvar deos/background 'dark)

(use-package beacon
   :ensure t
   :diminish beacon-mode
   :init (beacon-mode 1)
   :config
   (add-to-list 'beacon-dont-blink-major-modes 'eshell-mode))

(use-package paren-face
  :ensure t
  :init (global-paren-face-mode))

(setq use-dialog-box nil)

(setq-default line-spacing 0)

(if (eq deos/background 'dark)
    (progn
      (use-package color-theme-sanityinc-tomorrow
        :ensure t
        :init
        (load-theme 'sanityinc-tomorrow-night t)
        ;; Just ever so slightly more bright foreground text, default is
        ;; "#c5c8c6". Makes it easier to see on a sunny day
        (set-face-foreground 'default "#e5e8e6")
        ;; darken newline whitespace marks and blend in to the background
        (require 'whitespace)
        (set-face-foreground 'whitespace-newline "#555856")
        (set-face-background 'whitespace-newline (face-attribute 'default :background)))
      (use-package tao-theme
        :ensure t
        :disabled t
        :init
        (load-theme 'tao-yin t)
        (require 'git-gutter)
        (require 'git-gutter-fringe)
        (set-face-attribute 'git-gutter:deleted nil :foreground "red")
        (set-face-attribute 'git-gutter-fr:deleted nil :foreground "red")
        (set-face-attribute 'git-gutter:modified nil :foreground "light blue")
        (set-face-attribute 'git-gutter-fr:modified nil :foreground "light blue")
        (set-face-attribute 'git-gutter:added nil :foreground "green")
        (set-face-attribute 'git-gutter-fr:added nil :foreground "green")
        (require 'linum)
        (set-face-attribute 'linum nil :foreground "#444444"))
      (use-package doom-themes
        :ensure t
        :disabled t
        :init
        (load-theme 'doom-one t)
        (diminish 'doom-buffer-mode)
        ;; Doom currently has a broken modeline
        (set-face-attribute 'mode-line-buffer-id nil
                            :foreground "white" :bold t))
      (use-package zerodark-theme
        :ensure t
        :disabled t
        :init
        (load-theme 'zerodark t)
        (zerodark-setup-modeline-format)))
  (use-package leuven-theme
    :ensure t
    :disabled t
    :init
    (load-theme 'leuven t)
    ;; Ever-so-slightly darker background
    (set-face-background 'default "#F7F7F7"))
  (use-package github-theme
    :ensure t
    :disabled t
    :init
    (load-theme 'github t))
  (use-package tao-theme
    :ensure t
    :disabled t
    :init
    (load-theme 'tao-yang t)
    (require 'git-gutter)
    (require 'git-gutter-fringe)
    (set-face-attribute 'git-gutter:deleted nil :foreground "red")
    (set-face-attribute 'git-gutter-fr:deleted nil :foreground "red")
    (set-face-attribute 'git-gutter:modified nil :foreground "light blue")
    (set-face-attribute 'git-gutter-fr:modified nil :foreground "light blue")
    (set-face-attribute 'git-gutter:added nil :foreground "green")
    (set-face-attribute 'git-gutter-fr:added nil :foreground "green"))
  (use-package dakrone-light-theme
    :ensure t
    :init (load-theme 'dakrone-light t)))

(setq ns-use-srgb-colorspace t)
;; Anti-aliasing
(setq mac-allow-anti-aliasing t)

;; The original font height (so it can be restored too at a later time)
(setq deos/original-height 90)

(defun deos/setup-fonts ()
  (when (eq window-system 'x)
    ;; default font and variable-pitch fonts
    (set-face-attribute 'default nil
                        :family "Hack"
                        :height deos/original-height)
    (dolist (face '(mode-line mode-line-inactive minibuffer-prompt))
      (set-face-attribute face nil :family "Hack"
                          :height deos/original-height))
    (set-face-attribute 'variable-pitch nil
                        :family "DejaVu Sans" :height deos/original-height)
    ;; font for all unicode characters
    ;;(set-fontset-font t 'unicode "DejaVu Sans Mono" nil 'prepend)
    ))

(when (eq window-system 'x)
  (add-hook 'after-init-hook #'deos/setup-fonts))

(defvar deos/height-modifier 15
  "Default value to increment the size by when jacking into a monitor.")

(defun deos/monitor-jack-in ()
  "Increase the font size by `deos/height-modifier' amount, for
when you jack into an external monitor."
  (interactive)
  (dolist (face '(default
                   mode-line
                   mode-line-inactive
                   minibuffer-prompt
                   variable-pitch))
    (set-face-attribute face nil :height (+ (face-attribute face :height)
                                            deos/height-modifier))))

(defun deos/monitor-jack-out ()
  "Decreas the font size by `deos/height-modifier' amount, for
when you jack out of an external monitor."
  (interactive)
  (dolist (face '(default
                   mode-line
                   mode-line-inactive
                   minibuffer-prompt
                   variable-pitch))
    (set-face-attribute face nil :height (- (face-attribute face :height)
                                            deos/height-modifier))))

(defun deos/monitor-reset ()
  "Go back to the default font size and `line-spacing'"
  (interactive)
  (set-face-attribute 'default nil :height deos/original-height)
  (set-face-attribute 'variable-pitch nil :height deos/original-height)
  (text-scale-adjust 0)
  (when (fboundp 'minimap-mode)
    (condition-case err
        (minimap-mode 0)
      ('error 0)))
  (setq line-spacing 0))

(defun deos/code-reading-mode ()
  "Do a bunch of fancy stuff to make reading/browsing code
easier. When you're done, `deos/monitor-jack-out' is a great way
to go back to a normal setup."
  (interactive)
  (delete-other-windows)
  (text-scale-increase 1)
  (setq line-spacing 5)
  (use-package minimap :ensure t)
  (when (not minimap-mode)
    (minimap-mode 1)))

(setq
 ;; don't display info about mail
 display-time-mail-function (lambda () nil)
 ;; update every 15 seconds instead of 60 seconds
 display-time-interval 15)
(display-time-mode 1)

(setq display-time-format "")

;;(display-battery-mode 1)

(use-package smart-mode-line
  :ensure t
  :init
  (if (eq deos/background 'dark)
      (setq sml/theme deos/background)
    (setq sml/theme 'light))
  (sml/setup)
  :config
  (setq sml/shorten-directory t
        sml/shorten-modes t)
  (add-to-list 'sml/replacer-regexp-list '("^~/Sync/org/" ":org:"))
  (add-to-list 'sml/replacer-regexp-list '("^~/es/elasticsearch-extra/x-pack/" ":X-PACK:"))
  (add-to-list 'sml/replacer-regexp-list '("^~/es/elasticsearch/" ":ES:") t))

(use-package spaceline
  :ensure t
  :disabled t
  :init
  (setq powerline-default-separator 'arrow-fade
        spaceline-minor-modes-separator " ")
  (require 'spaceline-config)
  (spaceline-spacemacs-theme)
  (spaceline-helm-mode)
  (use-package info+
    :ensure t
    :init
    (spaceline-info-mode))
  (use-package fancy-battery
    :ensure t
    :init
    (add-hook 'after-init-hook #'fancy-battery-mode)
    (display-battery-mode -1)))

(use-package spaceline-all-the-icons
  :after spaceline
  :ensure t
  :config
  (spaceline-all-the-icons-theme)
  (spaceline-all-the-icons--setup-anzu))

(defun deos/custom-mode-line ()
  "Set up the customized DEOS mode line (very basic)"
  (interactive)

  (setq mode-line-position
        '(;; %p print percent of buffer above top of window, o Top, Bot or All
          ;; (-3 "%p")
          ;; %I print the size of the buffer, with kmG etc
          ;; (size-indication-mode ("/" (-4 "%I")))
          ;; " "
          ;; %l print the current line number
          ;; %c print the current column
          (line-number-mode ("%l" (column-number-mode ":%c")))))

  (defun shorten-directory (dir max-length)
    "Show up to `max-length' characters of a directory name `dir'."
    (let ((path (reverse (split-string (abbreviate-file-name dir) "/")))
          (output ""))
      (when (and path (equal "" (car path)))
        (setq path (cdr path)))
      (while (and path (< (length output) (- max-length 4)))
        (setq output (concat (car path) "/" output))
        (setq path (cdr path)))
      (when path
        (setq output (concat ".../" output)))
      output))

  (defvar mode-line-directory
    '(:propertize
      (:eval (if (buffer-file-name)
                 (concat " " (shorten-directory default-directory 15)) " ")))
    "Formats the current directory.")

  (put 'mode-line-directory 'risky-local-variable t)

  (setq-default mode-line-buffer-identification
                (propertized-buffer-identification "%b "))

  (defun deos/workspace-number ()
    "The current workspace name or number. Requires `eyebrowse-mode' to be
enabled."
    (when (and (bound-and-true-p eyebrowse-mode)
               (< 1 (length (eyebrowse--get 'window-configs))))
      (let* ((num (eyebrowse--get 'current-slot))
             (tag (when num (nth 2 (assoc num (eyebrowse--get 'window-configs)))))
             (str (if (and tag (< 0 (length tag)))
                      tag
                    (when num (int-to-string num)))))
        (propertize str 'face '(:foreground "brown")))))

  ;; (use-package major-mode-icons
  ;;   :ensure t)

  (setq-default mode-line-format
                '("%e"
                  mode-line-front-space
                  (anzu-mode
                   (:eval
                    (anzu--update-mode-line)))
                  ;; I'm always on utf-8
                  ;;mode-line-mule-info
                  mode-line-client
                  mode-line-modified
                  " "
                  mode-line-position
                  " ["
                  (eyebrowse-mode
                   (:eval
                    (deos/workspace-number)))
                  "]"
                  ;; no need to indicate this specially
                  ;;mode-line-remote
                  ;; this is for text-mode emacs only
                  ;;mode-line-frame-identification
                  " "
                  ;; TODO: https://github.com/stardiviner/major-mode-icons/issues/4
                  ;; ((:eval (major-mode-icons/show)))
                  mode-line-directory
                  mode-line-buffer-identification
                  " "
                  ;; I use magit, not vc-mode
                  ;;(vc-mode vc-mode)
                  (flycheck-mode flycheck-mode-line)

                  " "
                  (org-agenda-mode
                   (:eval (format "%s" org-agenda-filter)))
                  ;; no need to dispaly the modes
                  ;;mode-line-modes
                  ;;mode-line-misc-info
                  (which-func-mode
                   ("" which-func-format " "))
                  (global-mode-string
                   ("" global-mode-string " "))
                  mode-line-end-spaces)))

;; (add-hook 'after-init-hook #'deos/custom-mode-line)

(setq scroll-margin 3
      scroll-conservatively 101
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01
      scroll-preserve-screen-position t
      auto-window-vscroll nil
      hscroll-margin 5
      hscroll-step 5)

(setq deos/hl-line-enabled t)

(defun deos/turn-on-hl-line ()
  (interactive)
  (when deos/hl-line-enabled
    (hl-line-mode 1)))

(defun deos/turn-off-hl-line ()
  (interactive)
  (hl-line-mode -1))

(add-hook 'prog-mode-hook #'deos/turn-on-hl-line)
(add-hook 'mu4e-view-mode-hook #'deos/turn-on-hl-line)
(add-hook 'erc-mode-hook #'deos/turn-on-hl-line)

(defun deos/set-fringe-background ()
  "Set the fringe background to the same color as the regular background."
  (setq deos/fringe-background-color
        (face-background 'default))
  (custom-set-faces
   `(fringe ((t (:background ,deos/fringe-background-color))))))

(add-hook 'after-init-hook #'deos/set-fringe-background)

(setq-default indicate-buffer-boundaries nil ;; 'right
              fringe-indicator-alist
              (delq (assq 'continuation fringe-indicator-alist)
                    fringe-indicator-alist)
              fringes-outside-margins t
              ;; Keep cursors and highlights in current window only
              cursor-in-non-selected-windows nil)

(when (fboundp 'fringe-mode)
  (fringe-mode 4))

(setq deos/variable-org-enabled nil)

(when (and deos/variable-org-enabled
           (and window-system
                ;; Only if I have a custom patched org-mode
                (file-exists-p "~/src/elisp/org-mode")))
  (add-hook 'org-mode-hook 'variable-pitch-mode)
  (add-hook 'markdown-mode-hook 'variable-pitch-mode)

  (defun deos/adjoin-to-list-or-symbol (element list-or-symbol)
    (let ((list (if (not (listp list-or-symbol))
                    (list list-or-symbol)
                  list-or-symbol)))
      (require 'cl-lib)
      (cl-adjoin element list)))

  ;; Fontify certain org things with fixed-width
  (eval-after-load "org"
    '(mapc
      (lambda (face)
        (set-face-attribute
         face nil
         :inherit
         (deos/adjoin-to-list-or-symbol
          'fixed-pitch
          (face-attribute face :inherit))))
      (list 'org-code 'org-block 'org-table 'org-block-background
            'org-verbatim 'org-formula 'org-macro)))

  ;; Fontify certain markdown things with fixed-width
  (eval-after-load "markdown-mode"
    '(mapc
      (lambda (face)
        (set-face-attribute
         face nil
         :inherit
         (deos/adjoin-to-list-or-symbol
          'fixed-pitch
          (face-attribute face :inherit))))
      (list 'markdown-pre-face 'markdown-inline-code-face))))

(use-package rainbow-delimiters
  :ensure t
  :disabled t
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
  :config
  (set-face-attribute 'rainbow-delimiters-unmatched-face nil
                      :foreground 'unspecified
                      :inherit 'error))

(defun deos/make-local-face (face-name &rest args)
  "Make a buffer face local"
  (interactive)
  (let ((local-face (intern (concat (symbol-name face-name) "-local"))))
    ;; First create new face which is a copy of the old face
    (copy-face face-name local-face)
    (apply 'set-face-attribute local-face nil args)
    (set (make-local-variable face-name) local-face)))

(use-package color-identifiers-mode
  :ensure t
  :diminish color-identifiers-mode
  :init
  (defun deos/turn-on-color-identifiers ()
    (interactive)
    (let ((faces '(;; font-lock-comment-face
                   ;; font-lock-comment-delimiter-face
                   font-lock-constant-face
                   font-lock-type-face
                   font-lock-function-name-face
                   font-lock-variable-name-face
                   ;; font-lock-keyword-face
                   ;; font-lock-string-face
                   ;; font-lock-builtin-face
                   font-lock-preprocessor-face
                   font-lock-warning-face
                   font-lock-doc-face)))
      (dolist (face faces)
        (deos/make-local-face face :foreground nil))
      (deos/make-local-face 'font-lock-keyword-face :foreground nil :weight 'bold)
      (deos/make-local-face 'font-lock-builtin-face :foreground nil :weight 'bold)
      (color-identifiers-mode 1)))
  ;;(add-hook 'java-mode-hook #'color-identifiers-mode)
  ;;(add-hook 'emacs-lisp-mode-hook #'color-identifiers-mode)
  ;;(global-color-identifiers-mode 1)
  )

(use-package rainbow-identifiers
  :ensure t)

(use-package visible-mark
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'visible-mark-mode)
  :config
  (setq visible-mark-max 1)
  (setq visible-mark-faces '(visible-mark-active))

  (if (eq deos/background 'dark)
      (set-face-attribute 'visible-mark-active nil :background "#444444")
    (set-face-attribute 'visible-mark-active nil :background "#DDDDDD"))
  (set-face-attribute 'visible-mark-active nil :foreground nil))

(use-package nlinum
  :ensure t
  :init
  (setq nlinum-format "%d ")
  ;;(add-hook 'prog-mode-hook 'nlinum-mode)
  :config
  (set-face-attribute 'linum nil :height 0.85 :slant 'normal))

(use-package nlinum
  :ensure t
  :preface
  (defun goto-line-with-feedback ()
    "Show line numbers temporarily, while prompting for the line number input"
    (interactive)
    (unwind-protect
  (progn
    (nlinum-mode 1)
    (let ((num (read-number "Goto line: ")))
      (goto-char (point-min))
      (forward-line (1- num))))
      (nlinum-mode -1)))
  :init
  (bind-key "C-c g" #'goto-line)
  (global-set-key [remap goto-line] 'goto-line-with-feedback))
