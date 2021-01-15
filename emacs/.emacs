;; -*- origami-fold-style: triple-braces -*-
(defvar mine-debug-show-modes-in-modeline nil
  "show the mode symbol in the mode line")

(defvar mine-space-tap-offset 4
  "the number of spaces per tap")

(setq-default fill-column 70)
;; elisp tutorial is written below:
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;; UTF-8 as default encoding
(set-language-environment "UTF-8")

;; disable the alarm bell
(setq-default visible-bell 1)
(setq ring-bell-function 'ignore)

;; enable the highlight current line
(global-hl-line-mode +1)

(if (version< emacs-version "26")
    (global-linum-mode 1)
    (global-display-line-numbers-mode))

;; Enable column-number-mode in the mode line
(setq column-number-mode t)

;; Enable show-paren-mode
;; show the matching parenthesis
(show-paren-mode t)
;; deactivate the delay to show the matching paren
(setq show-paren-delay 0)
;; save the custom file separately
(setq custom-file "~/.emacs-custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

(when (eq system-type 'darwin) ;; mac specific settings
  (set-face-attribute 'default nil
                      :family "JetBrains Mono"
                      :height 150
                      :weight 'normal
                      :width 'normal)
  (set-face-attribute 'mode-line nil :height 150)
  ;; for emacs on terminal in mac, to copy to and paste from clipboard
  ;; M-| pbcopy and M-| pbpaste commands or set these new commmands.
  (defun pbcopy ()
    (interactive)
    (call-process-region (point) (mark) "pbcopy")
    (setq deactivate-mark t))

  (defun pbpaste ()
    (interactive)
    (call-process-region (point) (if mark-active (mark) (point)) "pbpaste" t t))

  (defun pbcut ()
    (interactive)
    (pbcopy)
    (delete-region (region-beginning) (region-end)))

  (global-set-key (kbd "C-c c") 'pbcopy)
  (global-set-key (kbd "C-c v") 'pbpaste)
  (global-set-key (kbd "C-c x") 'pbcut)
  ;; sets fn-delete to be right-delete
  (global-set-key [kp-delete] 'delete-char)
  ;; set the ispell path to the emacs for mac machines
  (setq ispell-program-name "/usr/local/bin/ispell")
  ;; set the alt key to be the option key
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'alt)

  ; (prefer-coding-system 'utf-8)
  ;; set the background mode
  (setq frame-background-mode 'light)

  ;; mouse setup with iterm2
  (setq mouse-wheel-follow-mouse 't)
  (require 'mouse) ;; needed for iterm2 compatibility
  (global-set-key [mouse-4] '(lambda ()
                               (interactive)
                               (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda ()
                               (interactive)
                               (scroll-up 1)))
  (setq mouse-sel-mode t)
  (defun track-mouse (e))

  ;; add the pdflatex path
  (setenv "PATH" (concat "/Library/TeX/texbin"
                         ":"
                         (getenv "PATH")))
  )

(defun mine-coding-style ()
  "My coding style."
  (interactive)
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width mine-space-tap-offset)

  ;; set the c-style indentation to ellemtel
  (setq-default c-default-style "ellemtel"
                c-basic-offset mine-space-tap-offset)
  ;;------------------------------------------------------------
  ;; +   `c-basic-offset' times 1
  ;; -   `c-basic-offset' times -1
  ;; ++  `c-basic-offset' times 2
  ;; --  `c-basic-offset' times -2
  ;; *   `c-basic-offset' times 0.5
  ;; /   `c-basic-offset' times -0.5
  ;; access-label: private/public label
  (c-set-offset 'access-label '--)
  ;; inclass: indentation level of others inside the class definition
  (c-set-offset 'inclass '+)
  ;; the first argument of the function after the brace
  (c-set-offset 'arglist-intro '+)
  ;; the closing brace of the function argument
  ;; void
  ;;;veryLongFunctionName(
  ;;     |void* arg1, <--- arglist-intro is at the | symbol
  ;;     void* arg2,
  ;; |); <--- arglist-close is at the | symbol.
  (c-set-offset 'arglist-close 0)
  )
(mine-coding-style)

;; set the indent of private, public keywords to be 0.5 x c-basic-offset
(c-set-offset 'access-label '--)
;; set the indent of all other elements in the class definition to equal
;; the c-basic-offset
(c-set-offset 'inclass      mine-space-tap-offset)

;; =======================================================================
;; Straight
;; =======================================================================

(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")))
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

;; use-package-always-ensure variable is related to the package,
;; so you are not supposed to use it.
(setq-default
  straight-use-package-by-default t
  use-package-always-defer t)

(use-package diminish
  :demand t
  :config
  (defmacro rename-major-mode (package-name mode new-name)
    `(eval-after-load ,package-name
       '(defadvice ,mode (after rename-modeline activate)
          (setq mode-name ,new-name))))

  ;; how to call the macro
  ;; (rename-major-mode "ruby-mode" ruby-mode "RUBY")
  (defmacro rename-minor-mode (package mode new-name)
    `(eval-after-load ,package
       '(diminish ',mode ,new-name)))
  ;; how to call the macro
  ;; (rename-minor-mode "company" company-mode "CMP")
  )

(use-package delight)

;; =======================================================================
;; Zenburn
;; =======================================================================
(use-package zenburn-theme
  :demand t
  :config
  (load-theme 'zenburn t)
  ;; background of linum attribute will inherit from the
  ;; background of the text editor
  (when (version< emacs-version "26")
    (set-face-attribute 'linum nil
                        ;; :foreground "#8FB28F"
                        ;; :background "#3F3F3F"
                        :family "DejaVu Sans Mono"
                        :height 130
                        :bold nil
                        :underline nil))
  ;; To keep syntax highlighting in the current line:
  (set-face-foreground 'highlight nil)
  ;; Set any color as the background face of the current line
  ; (set-face-background 'hl-line "#3e4446") ;; "#3e4446"
  ;; (set-face-background hl-line-face "gray13") ;; SeaGreen4 gray13
  )

(use-package telephone-line
  :if (>= emacs-major-version 25)
  :demand t
  ;; :disabled
  :config
  ;; if there are error messages in the message buffer,
  ;; change the telephone-line-flat to telephone-line-nil
  (setq telephone-line-evil-use-short-tag t
        telephone-line-primary-left-separator telephone-line-nil
        ;; telephone-line-secondary-left-separator telephone-line-nil
        telephone-line-primary-right-separator telephone-line-nil
        ;; telephone-line-secondary-right-separator telephone-line-nil
        )
  (setq telephone-line-lhs
        '((evil   . (telephone-line-evil-tag-segment))
          (accent . (telephone-line-buffer-segment
                     telephone-line-process-segment))
          (nil    . (telephone-line-vc-segment))))
  (setq telephone-line-rhs
        '((nil    . (telephone-line-misc-info-segment
                     telephone-line-minor-mode-segment))
          (accent . (telephone-line-misc-info-segment
                     telephone-line-major-mode-segment))
          (evil   . (telephone-line-airline-position-segment))))
  (telephone-line-evil-config)
  (telephone-line-mode 1))

;; =======================================================================
;; hl-todo highlight the keywords TODO FIXME HACK REVIEW NOTE DEPRECATED
;; =======================================================================
(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :config
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        `(("TODO"       warning bold)
          ("FIXME"      error bold)
          ("HACK"       font-lock-constant-face bold)
          ("REVIEW"     font-lock-keyword-face bold)
          ("NOTE"       success bold italic)
          ("DEPRECATED" font-lock-doc-face bold))))

;; =======================================================================
;; restart emacs
;; =======================================================================
(use-package restart-emacs
  :defer t)

;; =======================================================================
;; Company
;; =======================================================================
(use-package company
  :demand t
  :bind
  (("C-p" . company-complete))
  :init
  (global-company-mode)
  ;; (add-hook 'after-init-hook 'global-company-mode)
  :hook
  ((racket-mode . company-mode)
   (racket-repl-mode . company-mode))
  :config
  ;; decrease delay before autocompletion popup shows
  (setq company-idle-delay 0.2
        ;; remove annoying blinking
        company-echo-delay 0
        ;; start autocompletion only after typing
        company-begin-commands '(self-insert-command)
        ;; turn on the company-selection-wrap-around
        company-selection-wrap-around t
        ;; make the text completion output case-sensitive
        company-dabbrev-downcase nil ;; set it globally
        ;; need to type at least 3 characters until the autocompletion starts
        company-minimum-prefix-length 3
        ;; weight by frequency
        company-transformers '(company-sort-by-occurrence
                               company-sort-by-backend-importance))

  ;; call the function named company-select-next when tab is pressed
  ;; (define-key company-active-map [tab] 'company-select-next)
  ;; (define-key company-active-map (kbd "TAB") 'company-select-next)

  ;; press S-TAB to select the previous option
  (define-key company-active-map (kbd "S-TAB") 'company-select-previous)
  (define-key company-active-map (kbd "<backtab>") 'company-select-previous)

  ;; press tab to complete the common characters and cycle to the next option
  (define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
  (rename-minor-mode "company" company-mode "Com"))

;; =======================================================================
;; Evil
;; =======================================================================
(use-package evil
  :demand t
  ;; :disabled
  :init
  (setq evil-want-abbrev-expand-on-insert-exit nil)
  (evil-mode 1)

  :config
  (setq evil-search-wrap t
        evil-regexp-search t)
  (setq evil-toggle-key "")
  (add-to-list 'evil-emacs-state-modes 'flycheck-error-list-mode)
  (add-to-list 'evil-emacs-state-modes 'occur-mode)
  (add-to-list 'evil-emacs-state-modes 'neotree-mode)
  ;; C-z to suspend-frame in evil normal state and evil emacs state
  (define-key evil-normal-state-map (kbd "C-z") 'suspend-frame)
  (define-key evil-emacs-state-map (kbd "C-z") 'suspend-frame)
  (define-key evil-insert-state-map (kbd "C-z") 'suspend-frame)

  ;; shift width for evil-mode users
  ;; For the vim-like motions of ">>" and "<<"
  (setq evil-shift-width mine-space-tap-offset)
  ;; define :ls, :buffers to open ibuffer
  (evil-ex-define-cmd "ls" 'ibuffer)
  (evil-ex-define-cmd "buffers" 'ibuffer)

  (evil-set-initial-state 'deft-mode 'emacs)
  )

;; =======================================================================
;; evil-leader
;; =======================================================================
(use-package evil-leader
  :after (evil)
  :demand t
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC>")
  ; (evil-leader/set-key "l" 'avy-goto-line)
  ; (evil-leader/set-key "c" 'avy-goto-char-2)
  )

;; =======================================================================
;; evil-escape
;; =======================================================================
;; use the jk to escape from the insert mode
(use-package evil-escape
  :after (evil)
  :demand t
  :delight '(:eval (if mine-debug-show-modes-in-modeline
                       "jk"
                       ""))
  :config
  (evil-escape-mode)
  (setq-default evil-escape-key-sequence "jk")
  (setq-default evil-escape-delay 0.2)
  ; (rename-minor-mode "evil-escape" evil-escape-mode "jk")
  )

;; =======================================================================
;; Undo Tree
;; =======================================================================
;; Undo-tree makes the undo and redo in emacs more easy-to-use
;; C-_ or C-/  (`undo-tree-undo') Undo changes.
;; M-_ or C-?  (`undo-tree-redo') Redo changes.
;; C-x u to run undo-tree-visualize which opens a second buffer
;; displaying a tree view of your undo history in a buffer. You can
;; navigate this with the arrow keys and watch the main buffer change
;; through its previous states, and hit q to exit when you have the
;; buffer the way you wanted it, or C-q to quit without making any
;; changes. 1 2 3
(use-package undo-tree
  :delight '(:eval (if mine-debug-show-modes-in-modeline
                       undo-tree
                       ""))
  :init
  (global-undo-tree-mode 1)
  (setq undo-tree-visualizer-timestamp t
        undo-tree-visualizer-diff t)
  (defun clear-undo-tree ()
    (interactive)
    (setq buffer-undo-tree nil))
  :bind
  (("C-c u" . clear-undo-tree))
  :config
  (rename-minor-mode "undo-tree" undo-tree-mode "UT")
  (when (featurep 'evil)
    (evil-set-undo-system 'undo-tree))
  )

;; =======================================================================
;; helm
;; =======================================================================
(use-package helm
  ;; disabled if emacs version is before 24.4
  :if (version< "24.4" emacs-version)
  :diminish (helm-mode)
  :init
  (progn
    (require 'helm-config)
    (setq helm-candidate-number-limit 100
    ;; From https://gist.github.com/antifuchs/9238468
          helm-idle-delay 0.0 ; update fast sources immediately (doesn't).
          ; this actually updates things reeeelatively quickly.
          helm-input-idle-delay 0.01
          helm-yas-display-key-on-candidate t
          helm-quick-update t
          helm-M-x-requires-pattern nil
          ;; ignore boring files like .o and .a
          helm-ff-skip-boring-files t)
    (helm-mode))
  :bind
  (("C-x b" . helm-buffers-list)
   ("M-x" . helm-M-x)
   ; ("M-y" . helm-show-kill-ring)
   ("C-x C-f" . helm-find-files)
   ("C-c h" . helm-mini))
  :config
  (recentf-mode 1)
  (setq-default recent-save-file "~/.emacs.d/recentf")
  (setq helm-ff-file-name-history-use-recentf t)
 )

;; =======================================================================
;; highlight the indentation of the code
;; =======================================================================
(use-package highlight-indent-guides
  :delight '(:eval (if mine-debug-show-modes-in-modeline
		       highlight-indent-guides
                       ""))
  :demand t
  :config
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
  (setq highlight-indent-guides-method 'character)
  (setq highlight-indent-guides-auto-enabled nil)

  (set-face-background 'highlight-indent-guides-odd-face "darkgray")
  (set-face-background 'highlight-indent-guides-even-face "dimgray")
  (set-face-foreground 'highlight-indent-guides-character-face "dimgray")
  )

;; =======================================================================
;; Mode
;; =======================================================================
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode
  (("README\\.md\\'" . gfm-mode)
   ("\\.md\\'" . markdown-mode)
   ("\\.markdown\\'" . markdown-mode))
  :init
  ;(setq markdown-command "multimarkdown")
  (setq markdown-enable-math t)
  )

(use-package auctex
  :mode ("\\.tex\\'" . latex-mode)
  :init
  (add-hook 'LaTeX-mode-hook #'flyspell-mode)
  :config
  (setq LaTeX-item-indent 0))

(use-package org
  :bind
  (("C-c a" . org-agenda))
  :mode (("\\.org\\'" . org-mode) ;; redundant, emacs has this by default.
         ("\\.txt\\'" . org-mode))
  :config
  ;; hide the structural markers in the org-mode
  (setq org-hide-emphasis-markers t)
  ;; Display emphasized text as you would in a WYSIWYG editor.
  (setq org-fontify-emphasized-text t)
  ;; add more work flow
  (setq org-todo-keywords
        '((sequence "TODO(t)" "DOING(i)" "HOLD(h@)" "WAITING(w@/!)" "|" "CANCELED(c@)" "DONE(d@/!)")))
  ;; set the source file to create an agenda
  ;; (when window-system
  ;;   (setq org-agenda-files
  ;;         (list
  ;;          "e:/Dropbox/todolist/mytodolist.org"
  ;;          "e:/Dropbox/todolist/today_plan.org")))
  ;; turn on auto fill mode to avoid pressing M-q too often
  ;; set the amount of whitespaces between a headline and its tag
  ;; -70 comes from the width of ~70 characters per line. Thus,
  ;; tags willl be shown up at the end of the headline's line
  (setq org-tags-column -70)
  ;; let me determine the image width
  (setq org-image-actual-width nil)
  ;; highlight syntax in the code block
  (setq org-src-fontify-natively t)
  ;; keep track of when a certain TODO item was finished
  (setq org-log-done 'time)
  (setq org-startup-folded 'nofold)
  (setq org-startup-indented t)
  (setq org-startup-with-inline-images t)
  (setq org-startup-truncated t)
  ;; set the archive file org-file.s_archieve
  (setq org-archive-location "%s_archive::")
  (setq org-adapt-indentation nil)
  ;; (require 'ob-sh)
  ;; (org-babel-do-load-languages 'org-babel-do-load-languages
  ;;                              '((sh . t)))
  ;; customize the todo keyword faces
  ;; (setq org-todo-keyword-faces
  ;;       '(("TODO" . (:foreground "green" :weight bold))
  ;;         ("NEXT" :foreground "blue" :weight bold)
  ;;         ("WAITING" :foreground "orange" :weight bold)
  ;;         ("HOLD" :foreground "magenta" :weight bold)
  ;;         ("CANCELLED" :foreground "forest green" :weight bold)))

  ;; make sure that the exported source code in html has the same
  ;; indentation as the one in the org file
  (setq org-src-preserve-indentation t)
  (setq org-edit-src-content-indentation 0)
  (setq org-startup-with-inline-images t)
  (setq org-src-preserve-indentation nil)
  ;; we build a template to create a source code block
  ;; <s|
  (require 'org-tempo)
  )

(use-package deft
  :init
  (when (featurep 'evil-leader)
    (evil-leader/set-key
      "d" #'deft))
  :config
  (setq deft-extensions '("txt" "org" "md"))
  (setq deft-directory (file-truename "~/Dropbox/notes"))
  (setq deft-recursive t)
  (setq deft-use-filename-as-title t)
  (setq deft-file-naming-rules '((noslash . "_")
                                 (nospace . "_")
                                 (case-fn . downcase)))
  (setq deft-text-mode 'org-mode)
  (setq deft-org-mode-title-prefix t)
  (setq deft-use-filter-string-for-filename t)
  (setq deft-default-extension "txt")
  )

(use-package md-roam
  :straight (md-roam :type git :host github :repo "nobiot/md-roam")
  :config
  (require 'md-roam)
  (setq md-roam-file-extension-single "md")
  (setq md-roam-use-markdown-file-links t)
  )

(use-package org-roam
  :after org
  :delight '(:eval (if mine-debug-show-modes-in-modeline
                       org-roam
                       ""))
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory (file-truename "~/Dropbox/notes"))
  :init
  (when (featurep 'evil-leader)
    (evil-leader/set-key
      "rr"  #'org-roam
      "rf"  #'org-roam-find-file
      "rg"  #'org-roam-graph
      "ri"  #'org-roam-insert
      "rt"  #'org-roam-tag-add))
  ; :bind (:map org-roam-mode-map
  ; 	      (("C-c r r" . org-roam)
  ; 	       ("C-c r f" . org-roam-find-file)
  ; 	       ("C-c r g" . org-roam-graph))
  ; 	      :map org-mode-map
  ; 	      (("C-c r i" . org-roam-insert))
  ; 	      (("C-c r I" . org-roam-insert-immediate)))
  :config
  (setq org-roam-db-update-method 'immediate)
  ; set the file name without the date format
  (setq org-roam-capture-templates
        '(("d" "default" plain (function org-roam--capture-get-point)
          "%?"
          :file-name "${slug}"
          :head "# -*- mode: org; -*-\n#+title: ${title}\n"
          :immediate-finish t
          :unnarrowed t)))
  ; the first element in the list is the default extension of the org-roam
  (setq org-roam-file-extensions '("md" "txt" "org"))
  (setq org-roam-graph-executable (executable-find "dot"))
  (setq org-roam-graph-viewer "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")
  (setq org-roam-title-sources '(title))
  (setq org-id-link-to-org-use-id t)

  (require 'org-protocol)
  (require 'org-roam-protocol)
  )

(use-package org-roam-server
  :after org-roam
  :config
  (setq org-roam-server-host "127.0.0.1"
	org-roam-server-port 8080
	org-roam-server-export-inline-images t
	org-roam-server-authenticate nil
	org-roam-server-network-poll t
	org-roam-server-network-arrows nil
	org-roam-server-network-label-truncate t
	org-roam-server-network-label-truncate-length 60
	org-roam-server-network-label-wrap-length 20)
  )

;; =======================================================================
;; Avy
;; =======================================================================
(use-package avy
  ; :bind
  ; (("C-c j" . avy-goto-char-2)
  ;  ("C-c l" . avy-goto-line))
  :config
  (when (featurep 'evil-leader)
    (evil-leader/set-key
      "jl" #'avy-goto-line
      "jc" #'avy-goto-char-2))
  )

;{{{vim
; (use-package vimish-fold
;   :ensure
;   :after evil
;   )
;
; (use-package evil-vimish-fold
;   :ensure
;   :after vimish-fold
;   :init
;   (setq evil-vimish-fold-mode-lighter " |")
;   (setq evil-vimish-fold-target-modes '(prog-mode conf-mode text-mode))
;   :config
;   (global-evil-vimish-fold-mode)
;   )
;}}}
; (use-package s
;   :ensure
;   )
;
; (use-package dash
;   :ensure
;   )

(use-package origami
  :ensure
  :config
  (global-origami-mode)
  )

;; lsp-origami provides support for origami.el using language server protocol’s
;; textDocument/foldingRange functionality.
;; https://github.com/emacs-lsp/lsp-origami/
(use-package lsp-origami
  :disabled
  :hook ((lsp-after-open . lsp-origami-mode))
  )
;; ==================================================================
;; Print out the emacs init time in the minibuffer
(run-with-idle-timer 1 nil
                     (lambda () (message "emacs-init-time: %s" (emacs-init-time))))
;; # Emacs Lisp
;; ## Basic Settings
;; Use (setq ...) to set value locally to a buffer
;; Use (setq-default ...) to set value globally
;; set the default font
;; (set-frame-font Fontname-Size)
;; (member 1 (cons 1 (cons 2 '()))) -> return (1)
;; (display-grpahic-p) = check whether emacs is on the terminal mode or not
;; (interactive) = it will call this function if we press M-x function-name
;; function name = mode-name/what-to-type -> read what we type in that mode
;; (package-installed-p 'package-name) = check whether the package is installed
;; or not
;; (progn
;;   ...
;;   ...)    =  execute the statements in sequence and return the value
;;              of the last one
;; (load-file "directory/file.el")

;; window-system = this is a window system

;; Reference:
;; 1. general emacs setup
;;    https://github.com/chadhs/dotfiles/blob/master/editors/emacs-config.org
;; 2. evil setup
;;    http://evgeni.io/posts/quick-start-evil-mode/
