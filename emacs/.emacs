;; *-* mode: lisp *-*

;; Note that if there is an error when you start up emacs. You should restart it with --debug-init flag.
;; Once the debugger can pinpoint where the error happens, you can type M-x goto-char and type in the error
;; position in the .emacs buffer in order to jump to that position.
;; ----------------------------------------------------------------------
;; basic setup
(when (<= 27 emacs-major-version)
    (setq package-enable-at-startup nil))

(defvar mine-debug-show-modes-in-modeline nil
    "show the mode symbol in the mode line")

(defvar mine-space-tap-offset 4
    "the number of spaces per tap")

(defun show-mode-in-modeline (mode-sym)
    (if mine-debug-show-modes-in-modeline
        mode-sym
        ""))

;; Change "yes or no" to "y or n"
(fset 'yes-or-no-p 'y-or-n-p)

;; make searches case insensitive
(setq case-fold-search t)

(setq-default fill-column 70)
;; elisp tutorial is written below:
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;; UTF-8 as default encoding
(set-language-environment "UTF-8")

;; disable the alarm bell
(setq-default visible-bell 1)
(setq ring-bell-function 'ignore)

;; keyboard scroll one line at a time
(setq-default scroll-step 1)

;; support mouse wheel scrolling
(when (require 'mwheel nil 'noerror)
    (mouse-wheel-mode t))

;; enable the highlight current line
(global-hl-line-mode +1)

;; enable the line number mode
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

;; we can use either one of the two to check the os
;; (when (string-equal system-type "darwin")
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
    (setq ispell-program-name (executable-find "ispell"))
    ;; set the alt key to be the option key
    (setq mac-option-modifier 'meta)
    (setq mac-command-modifier 'alt)

                                        ; (prefer-coding-system 'utf-8)
    ;; set the background mode
    (setq frame-background-mode 'light)

    ;; mouse setup with iterm2
    (setq mouse-wheel-follow-mouse 't)
    (require 'mouse) ;; needed for iterm2 compatibility
    (setq mouse-sel-mode t)
    (defun track-mouse (e))

    ;; add the pdflatex path
    (when (executable-find "pdflatex")
        (setenv "PATH" (concat (file-name-directory (executable-find "pdflatex"))
                           ":"
                           (getenv "PATH"))))

    (when (not (executable-find "node"))
        (push "/opt/homebrew/bin" exec-path))

    ;; we have to check if the file-name-concat is bound since this function is
    ;; introduced in emacs 27
    (defvar mine-obsidian-notes-path
        (if (fboundp 'file-name-concat)
            (file-name-concat (getenv "HOME") "Dropbox" "notes")
            (format "%s/%s/%s" (getenv "HOME") "Dropbox" "notes"))
        "The path of the obsidian notes")
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
(c-set-offset 'inclass mine-space-tap-offset)
(setq lisp-indent-offset mine-space-tap-offset)

;;; ibuffer
;; ----------------------------------------------------------------------
;; Ensure ibuffer opens with point at the current buffer's entry.
;; How to use iBuffer
;; call ibuffer C-x C-b and mark buffers in the list with
;; - m (mark the buffer you want to keep)
;; - t (toggle marks)
;; - D (kill all marked buffers)
;; - g (update ibuffer)
;; - x (execute the commands)
(defadvice ibuffer
    (around ibuffer-point-to-most-recent) ()
    "Open ibuffer with cursor pointed to most recent buffer name."
    (let ((recent-buffer-name (buffer-name)))
        ad-do-it
        (ibuffer-jump-to-buffer recent-buffer-name)))
(ad-activate 'ibuffer)

;; nearly all of this is the default layout
(setq ibuffer-formats
    '((mark modified read-only " "
          (name 25 25 :left :elide) ; change: 30s were originally 18s
          " "
          (size 9 -1 :right)
          " "
          (mode 16 16 :left :elide)
          " " filename-and-process)
         (mark " "
             (name 16 -1)
             " " filename)))

(global-set-key (kbd "C-x C-b") 'ibuffer)

;;----------------------------------------------------------------------
;; remove the ^M
;; There are two solutions to solve this problem.
;; 1. call this function
(defun remove-control-M ()
    "Remove ^M at end of line in the whole buffer. from Steve"
    (interactive)
    (save-match-data
        (save-excursion
            (let ((remove-count 0))
                (goto-char (point-min))
                (while (re-search-forward (concat (char-to-string 13) "$") (point-max) t)
                    (setq remove-count (+ remove-count 1))
                    (replace-match "" nil nil))
                (message (format "%d ^M removed from buffer." remove-count))))))
;; 2. press M-% or M-x replace-string
;;    - C-q C-M RET
;;    - RET
;;    - ! (replace the entire file)

;;----------------------------------------------------------------------
;; file storage
(defvar mine-backup-directory-path "~/.emacs.data")
(make-directory mine-backup-directory-path t)
(defvar mine-recentf-directory-name "recentf")
(defvar mine-recentf-directory-path
    (file-name-concat mine-backup-directory-path
        mine-recentf-directory-name))
(setq recentf-save-file mine-recentf-directory-path)

;; bookmark
;; http://xahlee.info/emacs/emacs/bookmark.html
(defvar mine-bookmark-default-file-path
    (file-name-concat mine-backup-directory-path
        "bookmarks"))
(setq bookmark-default-file mine-bookmark-default-file-path)

;; =======================================================================
;; Straight
;; =======================================================================
;; note that for emacs version before 27, this straight might not work.
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
;; :ensure as well.
(setq-default
    straight-use-package-by-default t
    use-package-always-defer t
    use-package-expand-minimally t)

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
    :defer 2
    :bind
    (("C-p" . company-complete))
    :init
    (global-company-mode)
    ;; (add-hook 'after-init-hook 'global-company-mode)
    :hook
    ((racket-mode . company-mode)
        (racket-repl-mode . company-mode))
    :config
    (setq lsp-completion-provider :capf)
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
        company-minimum-prefix-length 2
        company-tooltip-align-annotations 't
        company-show-numbers t
        company-tooltip-align-annotations 't
        ;; weight by frequency
        company-transformers '(company-sort-by-occurrence
                                  company-sort-by-backend-importance))

    ;; call the function named company-select-next when tab is pressed
    ;; (define-key company-active-map [tab] 'company-select-next)
    ;; (define-key company-active-map (kbd "TAB") 'company-select-next)

    ;; press S-TAB to select the previous option
    (define-key company-active-map (kbd "S-TAB") #'company-select-previous)
    (define-key company-active-map (kbd "<backtab>") #'company-select-previous)

    ;; press tab to complete the common characters and cycle to the next option
    (define-key company-active-map (kbd "<tab>") #'company-complete-common-or-cycle)
    (define-key company-active-map (kbd "TAB")   #'company-complete-common-or-cycle)
    (rename-minor-mode "company" company-mode "Com")
    (add-hook 'after-init-hook 'global-company-mode)
    )

(use-package company-box
    :after company
    :diminish
    :hook (company-mode . company-box-mode))

(use-package company-lsp
    :demand t
    :ensure t
    :commands company-lsp)

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

    (evil-set-initial-state 'deft-mode 'emacs)

    ;; set up search in the evil mode
    (setq evil-search-module 'evil-search)
    ;; use up and down keys to scroll the search history
    (define-key isearch-mode-map (kbd "<down>") #'isearch-ring-advance)
    (define-key isearch-mode-map (kbd "<up>")   #'isearch-ring-retreat)
    (evil-define-key 'normal org-mode-map (kbd "<tab>") #'org-cycle)
    (evil-set-leader nil (kbd "SPC"))
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
    ;; (evil-leader/set-key "l" 'avy-goto-line)
    ;; (evil-leader/set-key "c" 'avy-goto-char-2)
    )

;; =======================================================================
;; evil-escape
;; =======================================================================
;; use the jk to escape from the insert mode
(use-package evil-escape
    :after (evil)
    :demand t
    ;; :delight '(:eval (if mine-debug-show-modes-in-modeline
    ;;                      "jk"
    ;;                      ""))
    :delight '(:eval (show-mode-in-modeline "jk"))
    :config
    (evil-escape-mode)
    (setq-default evil-escape-key-sequence "jk")
    (setq-default evil-escape-delay 0.2)
    ;; (rename-minor-mode "evil-escape" evil-escape-mode "jk")
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
    ;;:delight '(:eval (if mine-debug-show-modes-in-modeline
    ;;                     undo-tree
    ;;                     ""))
    :delight '(:eval (show-mode-in-modeline 'undo-tree))
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
    :disabled ; if emacs version is before 24.4
    :requires helm-config
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
    (setq helm-ff-file-name-history-use-recentf t)
    (when (featurep 'evil-leader)
        (evil-leader/set-key
            "ls" #'helm-buffers-list
            "gf" #'helm-projectile-find-file
            "d"  #'helm-projectile-find-file-dwim
            "ff" #'helm-projectile-find-file
            )
        )
    )

;; https://www.reddit.com/r/emacs/comments/qfrxgb/using_emacs_episode_80_vertico_marginalia_consult/
(use-package vertico
    :init
    (vertico-mode +1))

(use-package orderless
    :init
    (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion))))
    )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
    :init
    (savehist-mode))

(use-package general
    :demand t)

(use-package consult
    :ensure t
    :demand t
    ;; Enable automatic preview at point in the *Completions* buffer. This is
    ;; relevant when you use the default completion UI.
    :hook (completion-list-mode . consult-preview-at-point-mode)
    :config
    (recentf-mode)
    (setq completion-ignore-case t)
    (setq read-file-name-completion-ignore-case t)
    (defun consult-find-notes ()
        "Find notes in the notes directory."
        (interactive)
        (consult-find mine-obsidian-notes-path))
    (when (featurep 'evil-leader)
        (evil-leader/set-key
            "ls" #'consult-buffer
            "ff" #'consult-find
            "fn" #'consult-find-notes
            "fr" #'consult-recent-file
            "gf" #'consult-grep
            "bl" #'consult-bookmark
            ))
    )

(use-package marginalia
    :ensure t
    :config
    (marginalia-mode)
    (marginalia-max-relative-age 0)
    (marginalia-align 'right))

;; we enable this package only it is in mac.
(use-package consult-notes
    :if (eq system-type `darwin)
    :demand t
    :after consult
    :straight (:type git :host github :repo "mclear-tools/consult-notes")
    :commands (
                  consult-notes
                  consult-notes-search-in-all-notes
                  )
    :config
    (setq consult-notes-use-rg nil)

    (when (featurep 'evil-leader)
        (evil-leader/set-key
            "nn" #'consult-notes
            "ng" #'consult-notes-search-in-all-notes))

    ;; note that the consult-notes-file-dir-sources is a list of alist
    ;; we put a quote in front of the list so that it is not evaluated
    ;; and we put a comma in front of a variable so that it is evaluated.
    ;; so that the value of the variable is used.
    (when (boundp `mine-obsidian-notes-path)
        (setq consult-notes-file-dir-sources
            `(("obsidian"  ?o  ,mine-obsidian-notes-path))))

    ;; set notes dir(s), see below
    ;; Set org-roam integration, denote integration, or org-heading integration e.g.:
    ;; (setq consult-notes-org-headings-files '("~/path/to/file1.org"
    ;;                                          "~/path/to/file2.org"))
    ;; (consult-notes-org-headings-mode)
    ;; (when (locate-library "denote")
    ;;   (consult-notes-denote-mode))
    )

(use-package embark
    :disabled
    :ensure t
    :bind
    (("C-." . embark-act)         ;; pick some comfortable binding
        ("C-;" . embark-dwim)        ;; good alternative: M-.
        ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
    :init
    ;; Optionally replace the key help with a completing-read interface
    (setq prefix-help-command #'embark-prefix-help-command)
    ;; Show the Embark target at point via Eldoc.  You may adjust the Eldoc
    ;; strategy, if you want to see the documentation from multiple providers.
    (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
    ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

    :config
    (define-key minibuffer-local-map (kbd "M-.") #'my-embark-preview)
    (defun my-embark-preview ()
        "Previews candidate in vertico buffer, unless it's a consult command"
        (interactive)
        (unless (bound-and-true-p consult--preview-function)
            (save-selected-window
                (let ((embark-quit-after-action nil))
                    (embark-dwim)))))  

    ;; Hide the mode line of the Embark live/completions buffers
    (add-to-list 'display-buffer-alist
        '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
             nil
             (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
    :disabled
    :ensure t ; only need to install it, embark loads it after consult if found
    :hook
    (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu
    ;; Optional customizations
    :custom
    (corfu-cycle t)                 ; Allows cycling through candidates
    (corfu-auto t)                  ; Enable auto completion
    (corfu-auto-prefix 2)
    (corfu-auto-delay 0.0)
    (corfu-echo-documentation 0.25) ; Enable documentation for completions
    (corfu-preview-current 'insert) ; Do not preview current candidate
    (corfu-preselect-first nil)
    (corfu-on-exact-match nil)      ; Don't auto expand tempel snippets

    ;; Optionally use TAB for cycling, default is `corfu-complete'.
    :bind (:map corfu-map
              ("M-SPC" . corfu-insert-separator)
              ("TAB"     . corfu-next)
              ([tab]     . corfu-next)
              ("S-TAB"   . corfu-previous)
              ([backtab] . corfu-previous)
              ("S-<return>" . corfu-insert)
              ("RET"     . nil) ;; leave my enter alone!
              )

    :init
    (global-corfu-mode)

    :config
    (setq tab-always-indent 'complete)
    (add-hook 'eshell-mode-hook
        (lambda ()
            (setq-local corfu-quit-at-boundary t
                corfu-quit-no-match t
                corfu-auto nil)
            (corfu-mode)))
    )

;; =======================================================================
;; highlight the indentation of the code
;; =======================================================================
(use-package highlight-indent-guides
    :delight '(:eval (show-mode-in-modeline 'highlight-indent-guides))
    :demand t
    :hook ((prog-mode . highlight-indent-guides-mode))
    :config
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
    ;;(setq markdown-command "multimarkdown")
    (setq markdown-enable-math t)
    )

(use-package auctex
    :mode ("\\.tex\\'" . latex-mode)
    :init
    (add-hook 'LaTeX-mode-hook #'flyspell-mode)
    (setq
        Tex-brace-indent-level mine-space-tap-offset
        LaTeX-indent-level mine-space-tap-offset
        LaTeX-item-indent 0 ;;mine-space-tap-offset
        )
    :config
    )

;;; org
(use-package org
    :bind
    (("C-c a" . org-agenda)
        ("C-c SPC" . org-table-blank-field))

    :mode
    (("\\.org\\'" . org-mode) ;; redundant, emacs has this by default.
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
    (setq org-cycle-emulate-tab t)
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

    (org-babel-do-load-languages
        'org-babel-load-languages
        '((python . t)))
    )

;; use the consult-note instead
(use-package deft
    :disabled
    :init
    (when (featurep 'evil-leader)
        (evil-leader/set-key
            "d" #'deft))
    :config
    (setq deft-extensions '("txt" "org" "md"))
    ;; mac specific settings
    (when (eq system-type 'darwin)
        (setq deft-directory (file-truename "~/Dropbox/notes"))
        (setq deft-recursive-ignore-dir-regexp
            (concat "\\(?:"
                "\\."
                "\\|\\.\\."
                "\\|\\.obsidian"
                "\\)$")))
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
                                        ;:delight '(:eval (if mine-debug-show-modes-in-modeline
                                        ;                     org-roam
                                        ;                     ""))
    :delight '(:eval (show-mode-in-modeline 'org-roam))
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

    (setq org-roam-v2-ack t)
    ;; :bind (:map org-roam-mode-map
    ;; 	      (("C-c r r" . org-roam)
    ;; 	       ("C-c r f" . org-roam-find-file)
    ;; 	       ("C-c r g" . org-roam-graph))
    ;; 	      :map org-mode-map
    ;; 	      (("C-c r i" . org-roam-insert))
    ;; 	      (("C-c r I" . org-roam-insert-immediate)))
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
    ;; :bind
    ;; (("C-c j" . avy-goto-char-2)
    ;;  ("C-c l" . avy-goto-line))
    :demand t
    :config
    (when (featurep 'evil-leader)
        (evil-leader/set-key
            "jl" #'avy-goto-line
            "jc" #'avy-goto-char-2))
    )

(use-package ace-window
    :bind (("C-x o" . ace-window))
    :config
    (global-set-key [remap other-window] 'ace-window)
    (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
    (when (featurep 'evil-leader)
        (evil-leader/set-key "w" 'ace-window))
    )

(use-package origami
    :disabled
    :hook (prog-mode . origami-mode)
    :config
    (global-origami-mode)
    (setq-local origami-fold-style 'triple-braces)
    (setq origami-show-fold-header t)     ;highlight fold headers
                                        ; (add-hook 'prog-mode-hook
                                        ;           (lambda ()
                                        ;             (setq-local origami-fold-style 'triple-braces)))
    )

(use-package hideshowvis
    :diminish hs-minor-mode
    ;; on mac (25.3) this module has a problem
    :ensure nil
    :init
    (dolist (hook (list 'emacs-lisp-mode-hook
                      'c++-mode-hook
                      'nesc-mode-hook
                      'python-mode-hook))
        (add-hook hook 'hideshowvis-enable))
    ;; (hideshowvis-symbols)
    :config
    (setq hideshowvis-ignore-same-line nil))

(autoload 'hideshowvis-enable "hideshowvis" "Highlight foldable regions")
(autoload 'hideshowvis-minor-mode
    "hideshowvis"
    "Will indicate regions foldable with hideshow in the fringe."
    'interactive)
;; lsp-origami provides support for origami.el using language server protocol’s
;; textDocument/foldingRange functionality.
;; https://github.com/emacs-lsp/lsp-origami/
(use-package lsp-origami
    :disabled
    :hook ((lsp-after-open . lsp-origami-mode))
    )

(use-package vimish-fold
    :disabled
    :after evil
    :config
    (vimish-fold-global-mode 1)
    )

(use-package evil-vimish-fold
    :disabled
    :after vimish-fold
    :init
    (setq evil-vimish-fold-target-modes '(prog-mode conf-mode text-mode))
    :config
    (global-evil-vimish-fold-mode))

(use-package vimrc-mode
    :config
    (add-to-list 'auto-mode-alist '("\\.vim\\(rc\\)?\\'" . vimrc-mode))
    )

(use-package flyspell
    :delight '(:eval (show-mode-in-modeline "flys"))
    :config
    ;; remove/remap the minor-mode key map
    ;; (rename-minor-mode "flyspell" flyspell-mode "FlyS")
    (define-key flyspell-mode-map (kbd "C-;") nil)

    ;; Enable spell check in program comments
    (add-hook 'prog-mode-hook 'flyspell-prog-mode)
    ;; Enable spell check in plain text / org-mode
    (add-hook 'text-mode-hook 'flyspell-mode)
    (add-hook 'org-mode-hook 'flyspell-mode)
    (setq flyspell-issue-welcome-flag nil)
    (setq flyspell-issue-message-flag nil)

    ;; ignore repeated words
    (setq flyspell-mark-duplications-flag nil)
    (when (and (or (eq system-type 'gnu/linux)
                   (eq system-type 'darwin))
              (executable-find "aspell"))
        (setq-default ispell-program-name (executable-find "aspell")))
    (setq-default ispell-list-command "list")
    )

;; https://www.linw1995.com/en/blog/Write-Racket-With-Emacs/
;; https://marketsplash.com/tutorials/emacs/how-to-use-racket-mode-in-emacs/
(use-package racket-mode
    :bind
    (("C-c r" . racket-run))
    :init
    (add-hook 'racket-mode-hook      #'racket-unicode-input-method-enable)
    (add-hook 'racket-mode-hook      #'racket-xp-mode)
    (add-hook 'racket-repl-mode-hook #'racket-unicode-input-method-enable)
    :config
    (setq racket-mode-pretty-lambda nil)
    ;; (type-case FAW a-fae
    ;;     [a ...
    ;;     [b ...
    (put 'type-case 'racket-indent-function 2)
    (put 'local 'racket-indent-function nil)
    (put '+ 'racket-indent-function nil)
    (put '- 'racket-indent-function nil)
    (setq tab-always-indent 'complete)
    (when (eq system-type 'darwin) ;; mac specific settings
        (setq racket-program "/opt/homebrew/bin/racket")
        )
    )

(use-package geiser-mit
    :ensure t)

(use-package verilog-mode
    :ensure nil
    :init 
    (setq auto-mode-alist (cons '("\\.v\\'" . verilog-mode) auto-mode-alist))
    (setq auto-mode-alist (cons '("\\.sv\\'" . verilog-mode) auto-mode-alist))
    :config
    (setq verilog-align-ifelse t
        verilog-auto-delete-trailing-whitespace t
        verilog-auto-inst-param-value t
        verilog-auto-inst-vector nil
        verilog-auto-lineup nil ;(quote all)
        verilog-auto-indent-on-newline t
        verilog-auto-newline nil
        verilog-auto-save-policy nil
        verilog-auto-template-warn-unused t
        verilog-case-indent mine-space-tap-offset
        verilog-cexp-indent mine-space-tap-offset
        verilog-highlight-grouping-keywords t
        verilog-highlight-modules t
        verilog-indent-lists nil
        verilog-indent-level mine-space-tap-offset
        verilog-indent-level-behavioral mine-space-tap-offset
        verilog-indent-level-declaration mine-space-tap-offset
        verilog-indent-level-module mine-space-tap-offset
        verilog-indent-level-directive mine-space-tap-offset
        verilog-tab-to-comment t
        verilog-indent-begin-after-if nil
        verilog-case-indent mine-space-tap-offset)
    )

(use-package yaml-mode)

(use-package websocket
    :after org-roam)

(use-package simple-httpd)

(use-package f)

(use-package org-roam-ui
    :straight
    (:host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out"))
    :after org-roam
    :hook (org-roam . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t)
    )

(use-package vterm
    :ensure t)

(use-package cmake-mode
    :ensure t)

(use-package proof-general
    :ensure t
    :disabled
    :config
    (load-file "/opt/homebrew/Cellar/math-comp//1.15.0_1/share/emacs/site-lisp/math-comp/pg-ssr.el"))

(use-package company-coq
    :ensure t)

(use-package go-mode
    :ensure t
    :mode
    (("\\.go\\'" . go-mode)))

(use-package helm-projectile
    :ensure t)

(use-package dockerfile-mode
    :ensure t)

;; Setup:
;; - There are two ways to install copilot language server
;;   1. npm install -g @github/copilot-language-server
;;   2. M-x copilot-install-server
;; - Log in to copilot by M-x copilot-login
;;
;; Etc.
;; - You can disable the copilot mode by M-x copilot-mode
;;
(use-package copilot
    :disabled
    :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
    :demand t
    :ensure t
    :config
    (add-hook 'prog-mode-hook 'copilot-mode)
    (define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
    (define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)
    (setq copilot-use-auto-complete t)
    (setq copilot--indent-warning-printed-p t)
    ;; if you see the warning message, you can set the copilot--indent-warning-printed-p to nil
    ;; you should check copilot--indentation-alist to see if the indentation is set correctly.
    )

;; (use-package lsp-mode
;;   :ensure t
;;   :config
;;   ;; Start lsp when you open a file for each langauge
;;   (add-hook 'python-mode-hook #'lsp)
;;   (add-hook 'go-mode-hook     #'lsp)
;;   (add-hook 'verilog-mode-hook #'lsp)
;;   (setq lsp-prefer-flymake nil)
;;   )

;; (use-package lsp-ui
;;   :config
;;   ;; Show the peek view even if there is only 1 cross reference
;;   (setq lsp-ui-peek-always-show t)
;;   (setq lsp-ui-peek-fontify (quote always))
;;   ;; sideline config
;;   (setq lsp-ui-sideline-show-diagnostics t)
;;   (setq lsp-ui-sideline-show-hover t)
;;   (setq lsp-ui-sideline-show-code-actions t)
;;   (setq lsp-ui-sideline-diagnostic-max-line-length 80) ; we have treemacs taking up space
;;   (setq lsp-ui-sideline-ignore-duplicate t)
;;   ;; doc popup config
;;   (setq lsp-ui-doc-show-with-cursor nil)
;;   (setq lsp-ui-doc-show-with-mouse nil)
;;   ;; remap xref bindings to use peek
;;   (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
;;   (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
;;   ;; custom sideline
;;   :bind ("M-RET" . lsp-execute-code-action)
;;   :bind ("C-c h" . lsp-ui-doc-show)
;;   )

(use-package dashboard
    :ensure t
    :demand t
    :config
    (dashboard-setup-startup-hook)
    )

(use-package which-key
    :ensure t
    :demand t
    :config
    (which-key-mode)
    (which-key-setup-side-window-bottom)
    )

(use-package rainbow-delimiters
    :ensure t
    :demand t
    :init
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
    (add-hook 'latex-mode 'rainbow-delimiters-mode)
    )

(use-package color
    :ensure t
    :config
    ;; referene: https://github.com/mariusk/emacs-color
    (defun gen-col-list (length s v &optional hval)
        (cl-flet ( (random-float () (/ (random 10000000000) 10000000000.0))
                     (mod-float (f) (- f (ffloor f))) )
            (unless hval
                (setq hval (random-float)))
            (let ((golden-ratio-conjugate (/ (- (sqrt 5) 1) 2))
                     (h hval)
                     (current length)
                     (ret-list '()))
                (while (> current 0)

                    (setq ret-list
                        (append ret-list
                            (list (apply 'color-rgb-to-hex (color-hsl-to-rgb h s v)))))
                    (setq h (mod-float (+ h golden-ratio-conjugate)))
                    (setq current (- current 1)))
                ret-list)))

    (defun set-random-rainbow-colors (s l &optional h)
        ;; Output into message buffer in case you get a scheme you REALLY like.
        ;; (message "set-random-rainbow-colors %s" (list s l h))
        (rainbow-delimiters-mode t)

        ;; I also want css style colors in my code.
        ;; (xah-syntax-color-hex)
        ;; This function and fg-from-bg are redundant with rainbow mode.

        ;; Show mismatched braces in bright red.
        (set-face-background 'rainbow-delimiters-unmatched-face "red")

        ;; Rainbow delimiters based on golden ratio
        (let ( (colors (gen-col-list 9 s l h))
                 (i 1) )
            (let ( (length (length colors)) )
                ;;(message (concat "i " (number-to-string i) " length " (number-to-string length)))
                (while (<= i length)
                    (let ( (rainbow-var-name (concat "rainbow-delimiters-depth-"
                                                 (number-to-string i)
                                                 "-face"))
                             (col (nth i colors)) )
                        ;; (message (concat rainbow-var-name " => " col))
                        (set-face-foreground (intern rainbow-var-name) col))
                    (setq i (+ i 1))))))
    ;; saturation: s [gray 0 - 1 pure color]
    ;; lightness: l [dark 0 - 1 fully illuminated (completely white)]
    ;; the default values of s and l are 0.5 and 0.49, and
    ;; the color of braskets looks quite nice for the theme with the
    ;; white background.
    ;; (add-hook 'emacs-lisp-mode-hook
    ;;           '(lambda () (set-random-rainbow-colors 0.5 0.49)))
    ;; (add-hook 'lisp-mode-hook
    ;;           '(lambda () (set-random-rainbow-colors 0.5 0.49)))
    (add-hook 'prog-mode-hook
        '(lambda () (set-random-rainbow-colors 0.8 0.6 0.7))))

;; (use-package centaur-tabs
;;   :disabled
;;   :demand t
;;   :config
;;   (centaur-tabs-mode t)
;;   :bind
;;   ("C-<prior>" . centaur-tabs-backward)
;;   ("C-<next>" . centaur-tabs-forward))

;; ;; https://amaikinono.github.io/introduce-awesome-tab.html
;; (use-package awesome-tab
;;   :disabled
;;   :config
;;   (awesome-tab-mode t)
;;   (setq awesome-tab-show-tab-index t))

;; (use-package tabbar
;;   :disabled
;;   :config
;;   (customize-set-variable 'tabbar-background-color "gray20")
;;   (customize-set-variable 'tabbar-separator '(0.5))
;;   (customize-set-variable 'tabbar-use-images nil)
;;   (tabbar-mode 1)

;;   ;; My preferred keys
;;   (define-key global-map [(alt j)] 'tabbar-backward)
;;   (define-key global-map [(alt k)] 'tabbar-forward)

;;   ;; Colors
;;   (set-face-attribute 'tabbar-default nil
;;                       :background "gray20" :foreground
;;                       "gray60" :distant-foreground "gray50"
;;                       :family "Helvetica Neue" :box nil)
;;   (set-face-attribute 'tabbar-unselected nil
;;                       :background "gray80" :foreground "black" :box nil)
;;   (set-face-attribute 'tabbar-modified nil
;;                       :foreground "red4" :box nil
;;                       :inherit 'tabbar-unselected)
;;   (set-face-attribute 'tabbar-selected nil
;;                       :background "#4090c0" :foreground "white" :box nil)
;;   (set-face-attribute 'tabbar-selected-modified nil
;;                       :inherit 'tabbar-selected :foreground "GoldenRod2" :box nil)
;;   (set-face-attribute 'tabbar-button nil
;;                       :box nil)
;;   )

(use-package obsidian
  :disabled
  :ensure t
  :demand t
  :config
  ;; (obsidian-specify-path mine-obsidian-notes-path)
  (global-obsidian-mode t)
  :custom
  ;; This directory will be used for `obsidian-capture' if set.
  (obsidian-inbox-directory "Inbox")
  ;; Create missing files in inbox? - when clicking on a wiki link
  ;; t: in inbox, nil: next to the file with the link
  ;; default: t
  ;(obsidian-wiki-link-create-file-in-inbox nil)
  ;; The directory for daily notes (file name is YYYY-MM-DD.md)
  (obsidian-daily-notes-directory "Daily Notes")
  ;; Directory of note templates, unset (nil) by default
  ;(obsidian-templates-directory "Templates")
  ;; Daily Note template name - requires a template directory. Default: Daily Note Template.md
  ;(setq obsidian-daily-note-template "Daily Note Template.md")
  :bind (:map obsidian-mode-map
  ;; Replace C-c C-o with Obsidian.el's implementation. It's ok to use another key binding.
  ("C-c C-o" . obsidian-follow-link-at-point)
  ;; Jump to backlinks
  ("C-c C-b" . obsidian-backlink-jump)
  ;; If you prefer you can use `obsidian-insert-link'
  ("C-c C-l" . obsidian-insert-wikilink)))

(use-package ediff
    :config
    (setq ediff-split-window-function 'split-window-horizontally)
    (setq ediff-window-setup-function 'ediff-setup-windows-plain)
    (defun my/command-line-diff (switch)
        (setq initial-buffer-choice nil)
        (let ((file1 (pop command-line-args-left))
              (file2 (pop command-line-args-left)))
            (ediff file1 file2)))
    ;; show the ediff command buffer in the same frame
    (add-to-list 'command-switch-alist '("-diff" . my/command-line-diff)))

(use-package woman
    :disabled)

;; show weird characters
;; (use-package xeft
;;     :disabled
;;     :config
;;     (setq xeft-extensions '("txt" "org" "md"))
;;     (setq xeft-recursive t)
;;     (setq xeft-directory mine-obsidian-notes-path)
;;     )
;; ;; ==================================================================
;; Print out the emacs init time in the minibuffer
(run-with-idle-timer 1 nil
    (lambda () (message "emacs-init-time: %s" (emacs-init-time))))

;; # Emacs Lisp 
;; ## Basic Settings
;; - Use (setq ...) to set value locally to a buffer
;; - Use (setq-default ...) to set value globally
;; - Set the default font
;;   (set-frame-font Fontname-Size)
;; - (member 1 (cons 1 (cons 2 '()))) -> return (1)
;; - (display-grpahic-p) = check whether emacs is on the terminal mode or not
;; - (interactive) = it will call this function if we press M-x function-name
;; - function name = mode-name/what-to-type -> read what we type in that mode
;; - (package-installed-p 'package-name) = check whether the package is installed
;; or not
;; - (progn

;;   ...)    =  execute the statements in sequence and return the value
;;              of the last one
;; - (load-file "directory/file.el")

;; - window-system = this is a window system

;; Reference:
;; 1. general emacs setup
;;    https://github.com/chadhs/dotfiles/blob/master/editors/emacs-config.org
;; 2. evil setup
;;    http://evgeni.io/posts/quick-start-evil-mode/

;; Note
;; - To write the emacs configurations in the org mode, put this
;;   following lines in the .emacs or init.el file.
;;   (require 'org)
;;   (org-babel-load-file
;;      (expand-file-name "config.org"
;;      		   user-emacs-directory))
;; - To render the html file, run the command 
;; - https://www.reddit.com/r/emacs/comments/x7ahgz/how_many_of_you_switched_from_ivycounsel_or_helm/
;; TODO list:
;; install
;; - https://github.com/emacscollective/no-littering
;; I recommend installing no-littering. It automatically puts backup files (file~) in ~/.emacs.d/var/backup/.
;; It doesn't do anything about autosaves (#file#), but there is a note about putting those files in a specified directory in the README:
;; 
;; (setq auto-save-file-name-transforms
;;      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

