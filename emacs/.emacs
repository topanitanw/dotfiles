;; -*- mode: emacs-lisp -*-
;; - Note that if there is an error when you start up emacs. You should restart it with --debug-init flag.
;;   Once the debugger can pinpoint where the error happens, you can type M-x goto-char and type in the error
;;   position in the .emacs buffer in order to jump to that position.
;; - to reload this file when you run emacs, you should M-x load-file.
;; - If you want to download a new package, please check this out
;;   https://github.com/emacs-tw/awesome-emacs
;; ----------------------------------------------------------------------
;; basic setup
;; (when (<= 27 emacs-major-version)
;;     (setq package-enable-at-startup nil)
;;     )

(setq package-enable-at-startup nil)

;; load a customized machine specific file
(when (file-exists-p "~/.emacs-init-machine.el")
    (load-file "~/.emacs-init-machine.el"))

(defvar mine-debug-show-modes-in-modeline nil
    "show the mode symbol in the mode line.")

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

;; enable the code folding with the hide and show mode
(add-hook 'prog-mode-hook #'hs-minor-mode)

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

    ;; (prefer-coding-system 'utf-8)
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
        ;; note that in the old emacs version such as emacs 25, this
        ;; fboundp returns a string of the symbol when this symbol is unbound instead of nil.
        ;; for this reason, checking if this function returns true is added to handle this case.
        (if (eq (fboundp 'file-name-concat) t)
            (file-name-concat (getenv "HOME") "obsidian_vault" "panitan_notes")
            (format "%s/%s/%s" (getenv "HOME") "obsidian_vault" "panitan_notes")
        )
        "The path of the obsidian notes")

    (setq exec-path (append exec-path '("/opt/homebrew/bin" "/opt/homebrew/sbin")))
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
    ;; veryLongFunctionName(
    ;;     |void* arg1, <--- arglist-intro is at the | symbol
    ;;     void* arg2,
    ;; |); <--- arglist-close is at the | symbol.
    (c-set-offset 'arglist-close 0)
    )

(mine-coding-style)
(add-to-list 'auto-mode-alist '("\\.spc\\'" . javascript-mode))

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
    "Remove ^M at end of line in the whole buffer from Steve."
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
    (file-name-concat mine-backup-directory-path mine-recentf-directory-name))
(setq recentf-save-file mine-recentf-directory-path)
(setq recentf-max-saved-items 300)

;; bookmark
;; http://xahlee.info/emacs/emacs/bookmark.html
(defvar mine-bookmark-default-file-path
    (file-name-concat mine-backup-directory-path "bookmarks"))
(setq bookmark-default-file mine-bookmark-default-file-path)

;; =======================================================================
;; Straight
;; =======================================================================
;; note that for emacs version before 27, this straight might not work.
(setq package-archives
    '(("gnu" . "http://elpa.gnu.org/packages/")
      ("melpa" . "http://melpa.org/packages/")))
(defvar bootstrap-version)
(let ((bootstrap-file (expand-file-name "straight/repos/straight.el/bootstrap.el"
                          (or (bound-and-true-p straight-base-dir)
                              user-emacs-directory)
                          )
          )
      (bootstrap-version 7))

  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
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
;; objective: color theme
;; theme: Zenburn
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

;; =======================================================================
;; mode-line: telephone-line
;; =======================================================================
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

;; highlight extra spaces and tabs
(use-package whitespace
    :ensure t
    :delight '(:eval (if mine-debug-show-modes-in-modeline
                         whitespace-mode
                         ""))
    :init
    (global-whitespace-mode 1)

    :config

    ;; highlight the only part of the text longer than 80 characters on a line 00000
    ;; highlight the trailing whitespaces
    (setq-default whitespace-line-column 80)
    (setq whitespace-style '(face tabs tab-mark lines-tail trailing))
    (add-hook 'prog-mode-hook #'whitespace-mode)
    (add-hook 'before-save-hook 'whitespace-cleanup)
    )

;; =======================================================================
;; hl-todo
;; objective: highlight the keywords TODO FIXME HACK REVIEW NOTE DEPRECATED
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
;; highlight-indent-guides
;; objective: provide the indentation guide
;; =======================================================================
(use-package highlight-indent-guides
    :ensure t ; Ensures the package is installed from MELPA if not already present
    :hook (prog-mode . highlight-indent-guides-mode) ; Activates the mode in programming buffers
    :config
    ;; Customization options for highlight-indent-guides
    (setq highlight-indent-guides-method 'character) ; Use characters for guides (e.g., '│')
    (setq highlight-indent-guides-character ?│) ; Specify the character to use
    (setq highlight-indent-guides-responsive 'top) ; Highlight guides based on the top-level indentation
    ;; Further customization of faces for visual appearance
    ;; (custom-set-faces
    ;;     '(highlight-indent-guides-face ((t (:foreground "white"))))
    ;;     '(highlight-indent-guides-current-face ((t (:foreground "red")))))

    (setq highlight-indent-guides-auto-enabled nil)
    (set-face-background 'highlight-indent-guides-odd-face "black")
    (set-face-background 'highlight-indent-guides-even-face "black")
    (set-face-foreground 'highlight-indent-guides-character-face "dim gray")

    (setq highlight-indent-guides-auto-character-face-perc 5)
    )

;; =======================================================================
;; evil
;; objective: emulate vim keybindings
;; =======================================================================
(use-package evil
    :demand t
    ;; :disabled
    :init
    (setq evil-want-abbrev-expand-on-insert-exit nil)
    (setq evil-want-keybinding nil)
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
;; objective: emulate vim keybindings
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
;; objective: enable other keys to escape from insert mode
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
    (setq-default eil-escape-key-sequence "jk")
    (setq-default evil-escape-delay 0.2)
    ;; (rename-minor-mode "evil-escape" evil-escape-mode "jk")
    )

(use-package evil-collection
    :custom
    (evil-collection-setup-minibuffer t)

    :config
    (setq evil-want-keybinding nil)

    :init
    (evil-collection-init)
    )
;; =======================================================================
;; vertico
;; objective: a highly customizable minibuffer extension
;; ref: vertico, marginalia, orderless https://kristofferbalintona.me/posts/202202211546
;;      https://www.reddit.com/r/emacs/comments/qfrxgb/using_emacs_episode_80_vertico_marginalia_consult/
;; =======================================================================
(use-package vertico
    :bind (:map vertico-map
              ("C-j" . vertico-next)         ; Alternative next binding
              ("C-k" . vertico-previous)     ; Alternative previous binding
    )
    :custom
    ;; Enable cycling for vertico-next/previous
    (vertico-cycle t)

    :init
    (vertico-mode +1))

;; =======================================================================
;; posfram
;; objective: provide support for emacs to create a minibuffer any where on the screen/emacs window
;; =======================================================================
(use-package posframe
    :ensure t
    :demand t)

;; =======================================================================
;; vertico-posframe
;; objective: provide the support of posframe to vertico
;; disable: due to the bug if the path is very long
;; =======================================================================
(use-package vertico-posframe
    :disabled
    :ensure nil
    :demand nil
    :init
    (vertico-posframe-mode))

;; =======================================================================
;; orderless
;; objective: enable the advanced pattern matching
;; =======================================================================
(use-package orderless
    :init
    (setq completion-styles '(orderless basic))
    )

;; =======================================================================
;; marginalia
;; objective: enable more description in the minibuffer
;; =======================================================================
(use-package marginalia
    :demand t
    :custom
    (marginalia-max-relative-age 0)
    (marginalia-align 'left)

    :init
    ;; Marginalia must be activated in the :init section of use-package such that
    ;; the mode gets enabled right away. Note that this forces loading the
    ;; package.
    (marginalia-mode 1)
    )

;; =======================================================================
;; consult
;; objective: enable functionalities such as consult-find-notes
;; =======================================================================
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

    (defun consult-ripgrep-single-file ()
        "Call `consult-ripgrep' for the current buffer (single file)."
        (interactive)
        (let ((consult-project-function (lambda (x) nil)))
            (consult-ripgrep (list (shell-quote-argument buffer-file-name)))))

    (when (featurep 'evil-leader)
        (evil-leader/set-key
            ;; list all buffers
            "ls" #'consult-buffer
            ;; find a file within the currenlt directory
            "ff" #'consult-find
            ;; search for a note from a place
            "fn" #'consult-find-notes
            ;; provide a list of recently-accessed files
            "fr" #'consult-recent-file
            ;; find the definition of variables/functions
            "fd" #'consult-imenu-multi
            ;; "fg" #'consult-ripgrep-single-file
            ;; search for a keyword in a file
            "fl" #'consult-line
            ;; search for a keyword from multiple buffers
            "fm" #'consult-line-multi
            ;; display the result of the ripgrip
            "rg" #'consult-ripgrep
           ;; open a list of bookmark
            "bl" #'consult-bookmark
            )
        )
    )

;; =======================================================================
;; avy
;; objective: enable cursor moving functions to go to a specific line
;;     or a set of characters
;; =======================================================================
(use-package avy
    :demand t
    :config
    (when (featurep 'evil-leader)
        (evil-leader/set-key
            "jl" #'avy-goto-line
            "jc" #'avy-goto-char-2))
    )

;; =======================================================================
;; ace-window
;; objective: enable the window switching function
;; =======================================================================
(use-package ace-window
    :demand t
    :bind (("C-x o" . ace-window))
    :init
    (when (featurep 'evil-leader)
        (evil-leader/set-key "w" 'ace-window))
    :config
    (global-set-key [remap other-window] 'ace-window)
    (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
    )

;; =======================================================================
;; which-key
;; objective: enable the minibuffer to guide you based on pressed key
;;     binding
;; =======================================================================
(use-package which-key
    :ensure t
    :demand t
    :config
    (which-key-mode)
    (which-key-setup-side-window-bottom)
    )

;; =======================================================================
;; rainbow-delimiters
;; objective: enable the colorful-highlight delimiter such as parenthesis
;;    this plugin should be used with color
;; =======================================================================
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


;; =======================================================================
;; vterm
;; objective: a terminal emulator
;; usage:
;; - to exit from the insert mode to normal mode, you can type jk.
;; - to enter into the insert mode, you can type i.
;; =======================================================================
(use-package vterm
    :ensure t
    :custom
    (vterm-max-scrollback 10000))

;; =======================================================================
;; multi-vterm
;; objective: a package to allow multiple instance of vterm
;; usage: call multi-vterm command to create a new vterm instance
;; =======================================================================
(use-package multi-vterm
    :ensure t)

;; =======================================================================
;; ranger
;; objective: a file explorer
;; =======================================================================
;; zh to enable the hidden files
;; ? to open help
(use-package ranger
    :ensure t
    :demand t
    :config
    (when (featurep 'evil-leader)
        (evil-leader/set-key
            ;; list all buffers
            "r" #'ranger)
        )
    )

(use-package dashboard
    :ensure t
    :demand t
    :config
    (dashboard-setup-startup-hook)
    )

;; =======================================================================
;; copilot
;; objective: enable github copilot
;; =======================================================================
;; Setup:
;; - There are two ways to install copilot language server
;;   1. npm install -g @github/copilot-language-server
;;   2. M-x copilot-install-server
;; - Log in to copilot by M-x copilot-login
;;
;; Etc.
;; - You can disable the copilot mode by M-x copilot-mode
(use-package copilot
    :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
    :disabled disable-github-copilot
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


;; =======================================================================
;; corfu
;; objective: enable a new UI for the auto-complete
;; =======================================================================
;; issue: the output of the corfu has a suffix garbage such as "=", "_"
(use-package corfu
    :disabled
    :ensure t
    :demand t
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
    (corfu-min-width 80)
    (corfu-max-width corfu-min-width)     ; Always have the same width
    (corfu-count 14)
    (corfu-scroll-margin 4)

    ;; Optionally use TAB for cycling, default is `corfu-complete'.
    :bind
    (
        :map corfu-map
        ("S-SPC"    . corfu-insert-separator)
        ("TAB"      . corfu-next)
        ([tab]      . corfu-next)
        ("S-TAB"    . corfu-previous)
        ([backtab]  . corfu-previous)
        ("S-<return>" . corfu-insert)
        ("M-l"      . corfu-show-location)
        ("<escape>" . corfu-quit)
        ("RET"      . nil) ;; leave my enter alone!
        )

    :init
    (global-corfu-mode)

    :config
    (setq tab-always-indent 'complete)
    ; Enable popup info
    ; it does not work in terminal
    (corfu-popupinfo-mode 1)
    (setq corfu-popupinfo-delay '(0.4 . 0.2)) ; Set delay for popup info
    )

;; =======================================================================
;; corfu-terminal
;; objective: enable corfu in terminal
;; =======================================================================
;; https://kristofferbalintona.me/posts/202202270056/
(use-package corfu-terminal
    :disabled
    :demand t
    :config
    (unless (display-graphic-p)
        (corfu-terminal-mode +1))
    )

;; =======================================================================
;; kind-icon
;; objective: adds colorful icons for completion in Emacs
;; =======================================================================
;; https://kristofferbalintona.me/posts/202202270056/
(use-package kind-icon
    :after corfu
    :custom
    (kind-icon-use-icons t)
    (kind-icon-default-face 'corfu-default) ; Have background color be the same as `corfu' face background
    (kind-icon-blend-background nil)  ; Use midpoint color between foreground and background colors ("blended")?
    (kind-icon-blend-frac 0.08)

    ;; NOTE 2022-02-05: `kind-icon' depends `svg-lib' which creates a cache
    ;; directory that defaults to the `user-emacs-directory'. Here, I change that
    ;; directory to a location appropriate to `no-littering' conventions, a
    ;; package which moves directories of other packages to sane locations.
    (svg-lib-icons-dir (no-littering-expand-var-file-name "svg-lib/cache/")) ; Change cache dir

    :config
    (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter) ; Enable `kind-icon'

    ;; Add hook to reset cache so the icon colors match my theme
    ;; NOTE 2022-02-05: This is a hook which resets the cache whenever I switch
    ;; the theme using my custom defined command for switching themes. If I don't
    ;; do this, then the backgound color will remain the same, meaning it will not
    ;; match the background color corresponding to the current theme. Important
    ;; since I have a light theme and dark theme I switch between. This has no
    ;; function unless you use something similar
    (add-hook 'kb/themes-hooks #'(lambda () (interactive) (kind-icon-reset-cache)))
    )

;; =======================================================================
;; company
;; objective: enable the autocompletion
;; =======================================================================
(use-package company
;    :defer 8
    :bind
    (("C-p" . company-complete))
    :init
    (global-company-mode)
    ;; (add-hook 'after-init-hook 'global-company-mode)
    :hook
    ((racket-mode . company-mode)
        (racket-repl-mode . company-mode))
    :config
    ;; (setq lsp-completion-provider :capf)
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

;; a company font-end with icons
;; note that it works on for gui
(use-package company-box
    :after company
    :diminish
    :hook (company-mode . company-box-mode)
    )

;; (use-package company-lsp
;;     :after company
;;     :diminish
;;     :demand t
;;     :ensure t
;;     :commands company-lsp
;;     )

(use-package company-quickhelp
    :after company
    :diminish
    :demand t
    :ensure t
    :config
    (company-quickhelp-mode)
    )

(use-package company-flx
    :after company
    :demand t
    :ensure t
    :config
    (company-flx-mode +1)
    )

;; =======================================================================
;; fussy
;; objective: provide a completion-style to Emacs that is able to
;;     leverage flx as well as various other libraries such as fzf-native
;;     to provide intelligent scoring and sorting.
;; =======================================================================
(use-package fzf-native
  :straight (fzf-native :type git :host github :repo "dangduc/fzf-native" :files (:defaults "bin"))
  :config
  (fzf-native-load-dyn)
  (setq fussy-score-fn 'fussy-fzf-native-score))

(use-package fussy
  :straight (fussy :type git :host github :repo "jojojames/fussy")
  :config
  (setq fussy-score-ALL-fn 'fussy-fzf-score)
  (setq fussy-filter-fn 'fussy-filter-default)
  (setq fussy-use-cache t)
  (setq fussy-compare-same-score-fn 'fussy-histlen->strlen<)
  (fussy-setup)
  (fussy-eglot-setup)
  (fussy-company-setup))

;; =======================================================================
;; markdown mode
;; objective: enable the markdown mode to read and render
;; =======================================================================
(use-package markdown-mode
    :ensure t)


;;; org
(use-package org
    :defer 10
    :bind
    (
        ("C-c a" . org-agenda)
        ("C-c SPC" . org-table-blank-field)
    )

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

;; (use-package lsp-mode
;;     :init
;;     ;; Set up lsp-mode to be deferred, meaning it loads only when needed
;;     (setq lsp-enable-text-document-sync-on-save nil) ; or t, depending on preference

;;     :commands lsp

;;     :config
;;     ;; Global settings for lsp-mode
;;     (lsp-mode 1)
;;     ;; Bind common lsp commands to a prefix key
;;     ;; (define-key lsp-mode-map (kbd "C-c l") 'lsp-command-map)
;;     (add-hook 'python-mode-hook #'lsp-deferred)
;;     (add-hook 'js-mode-hook #'lsp-deferred)
;;     (add-hook 'typescript-mode-hook #'lsp-deferred)
;;     (add-hook 'sh-mode-hook #'lsp-deferred)
;;     )

;; (use-package company-lsp
;;     :after lsp-mode
;;     :config
;;     (setq company-lsp-async t) ; Enable asynchronous completion
;;     :hook (lsp-mode . company-mode)) ; Enable company-mode in lsp-mode buffers

;; (use-package lsp-ui
;;     :after lsp-mode
;;     :config
;;     (setq lsp-ui-doc-enable t
;;         lsp-ui-sideline-enable t
;;         lsp-ui-peek-enable t)
;;     :hook (lsp-mode . lsp-ui-mode))

(use-package exec-path-from-shell
    :ensure t
    :if (memq window-system '(mac ns x))
    :config
    (exec-path-from-shell-initialize))

(use-package flycheck
    :ensure t
    :init
    (global-flycheck-mode)

    :config
    (add-hook 'after-init-hook #'global-flycheck-mode)

    )

(use-package evil-owl
    :ensure t
    :demand t
    :diminish ""
    :config
    (setq evil-owl-idle-delay 0.3)
    (setq evil-owl-max-string-length 500)
    (add-to-list 'display-buffer-alist
        '("*evil-owl*"
             (display-buffer-in-side-window)
             (side . bottom)
             (window-height . 20)))
    (evil-owl-mode)
    )
;; ==================================================================
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
;;    ...)
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
;; I recommend installing no-littering. It automatically puts backup
;; files (file~) in ~/.emacs.d/var/backup/.  It doesn't do anything
;; about autosaves (#file#), but there is a note about putting those
;; files in a specified directory in the README:
;;
;; (setq auto-save-file-name-transforms
;;      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
;; - https://nathantypanski.com/blog/2014-08-03-a-vim-like-emacs-config.html
;; - https://tkf.github.io/emacs-jedi/latest/
;; - https://github.com/jorgenschaefer/elpy?tab=readme-ov-file
;; - https://github.com/emacs-exordium/exordium
;; - https://tuhdo.github.io/c-ide.html
;; - https://emacs-lsp.github.io/lsp-mode/tutorials/CPP-guide/
;; - https://justinbarclay.ca/posts/from-zero-to-ide-with-emacs-and-lsp/
