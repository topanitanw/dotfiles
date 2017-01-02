;; nesc and zenburn are two customized packages 
;; Modified Emacs should be downloaded from http://vgoulet.act.ulaval.ca/en/.
;; emacs for window users
;; http://gregorygrubbs.com/emacs/10-tips-emacs-windows/
;; emacs tutorial
;; http://www.jesshamrick.com/2012/09/10/absolute-beginners-guide-to-emacs/
;; =======================================================================
;; ## Basic Settings
;; Use (setq ...) to set value locally to a buffer
;; Use (setq-default ...) to set value globally 
;; set the default font
;; (set-frame-font Fontname-Size)
;; (set-frame-font "DejaVu Sans Mono-13")
;; (set-face-attribute 'default nil :font "DejaVu Sans Mono-13")
;; (set-face-attribute 'mode-line nil :font "DejaVu Sans Mono-14")
(set-face-attribute 'default nil 
                    :family "DejaVu Sans Mono"
                    :height 130
                    :weight 'normal
                    :width 'normal)

(set-face-attribute 'mode-line nil
                    :family "DejaVu Sans Mono"
                    :height 130
                    :weight 'normal
                    :width 'normal)
;; select the coding style of the emacs
(prefer-coding-system 'utf-8)

;; disable the alarm bell
(setq-default visible-bell 1)

;; keyboard scroll one line at a time
(setq-default scroll-step 1)

;; support mouse wheel scrolling
(mouse-wheel-mode t)

;; scroll down one line at a time
;; (setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

;; M-x linum-mode to display line number
(global-linum-mode 1)
;; this package of displaying line numbers runs very slowly.

;; set the format and spaces of the linenumber
(if (display-graphic-p)
    (setq linum-format "%3d \u2502")
    (setq linum-format "%3d |"))

;; M-x hl-line-mode to highlight the current line
;; (global-hl-line-mode 1)

;; Set any color as the background face of the current line
;; (set-face-background 'hl-line "#3e4446") ;; "#3e4446"
;; (set-face-background hl-line-face "gray13") ;; SeaGreen4 gray13

;; To keep syntax highlighting in the current line:
;; (set-face-foreground 'highlight nil)

;; Enable column-number-mode in the mode line
(setq column-number-mode t)

;; Enable show-paren-mode
;; show the matching parenthesis
(show-paren-mode t)
;; deactivate the delay to show the matching paren
(setq show-paren-delay 0)

;; "If a matching paren is off-screen, echo the matching line."
(defadvice show-paren-function
    (after show-matching-paren-offscreen activate)
  "If the matching paren is offscreen, show the matching line in the
   echo area. Has no effect if the character before point is not
   of the syntax class ')'."
  (interactive)
  (let* ((cb (char-before (point)))
         (matching-text (and cb
                             (char-equal (char-syntax cb) ?\) )
                             (blink-matching-open))))
    (when matching-text (message matching-text))))

;; auto close bracket insertion. New in emacs 24
;; insert a closing delimiter when we insert
;; an opening delimiter
;; (electric-pair-mode 1)
;; make electric-pair-mode work on more brackets
;; (setq electric-pair-pairs '(
;;                             (?\{ . ?\})
;;                             ))
;; I comment out this electric pair mode since sometimes
;; it is very annoying.

;; Set cursor color to white
;; (set-cursor-color "#ffffff") 

;; When the GUI emacs is running,
;; switch the windows with Meta + an arrow key
;; If Emacs is running in the terminal, use C-c + arrow key
;;(if (display-graphic-p)
;;    (windmove-default-keybindings 'meta)
;;  (progn
;;    (global-set-key (kbd "C-c <left>")  'windmove-left)
;;    (global-set-key (kbd "C-c <right>") 'windmove-right)
;;    (global-set-key (kbd "C-c <up>")    'windmove-up)
;;    (global-set-key (kbd "C-c <down>")  'windmove-down)))

;; disable ESC to unsplit windows
(global-unset-key (kbd "ESC ESC ESC"))

;; auto-revert-mode
(global-auto-revert-mode 1)
;; - if it does not work, M-x revert-buffer RET yes RET
;; - use a more practice trick: use C-x C-v RET. This tell to find an
;;   alternate file and by default emacs suggests you the current file.

;; to install a plugin file myplugin.el to this folder and add the
;; second line
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))
;; if this one does not work (load "myplugin.el"),
;; try this (require 'myplugin)

;; Indentation Setup
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

;; set the c-style indentation to ellemtel
(setq-default c-default-style "ellemtel" c-basic-offset 2)

;; Automatic(electric) Indentation
(global-set-key (kbd "RET") 'newline-and-indent)
;; (define-key global-map (kbd "RET") 'newline-and-indent)
(when (and (>= emacs-major-version 24)
           (>= emacs-minor-version 4))
  (electric-indent-mode +1))

;; activate the auto-fill-mode as a minor mode when opening a text
;; file. The auto-fill-mode will start a new line when the current
;; line is too long if the SPC or RET is pressed.
;; I do not quite like this feature. 
;; (add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Disable the Menu-bar, tool bar and scroll bar
;; (when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
;; (when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;; (when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; prevent the creation of backup files
;; (setq make-backup-files nil)

;; Make a backup file by copying
(setq backup-by-copying t)

;; Have it save the backup files in some other directory, where they
;; won't bother you unless you go looking for them. I have the following
;; in my .emacs:
;; (setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
;;   backup-by-copying t    ; Don't delink hardlinks
;;   version-control t      ; Use version numbers on backups
;;   delete-old-versions t  ; Automatically delete excess backups
;;   kept-new-versions 20   ; how many of the newest versions to keep
;;   kept-old-versions 5    ; and how many of the old
;;   )

;; If you enable Delete Selection mode, a minor mode, then inserting
;; text while the mark is active causes the selected text to be
;; deleted first.
(delete-selection-mode 1)

;; Set the emacs-grep to highlight the matching words
(setq grep-highlight-matches t)

;; make emacs respond to mouse clicks on terminal
(xterm-mouse-mode 1)

;; Change "yes or no" to "y or n"
(fset 'yes-or-no-p 'y-or-n-p)

;; make searches case insensitive
(setq case-fold-search t)
;; =======================================================================
;; =======================================================================
;; ## Package Installation
;; =======================================================================
;; All packages from repositories
;; start package.el with emacs
(require 'package)
;; add MELPA to repository list
;; melpa is a package archive managed by Milkypostman. It's the
;; easiest package archive to add packages too, and is automatically
;; updated when the package is. The go-to source for up to date, and
;; the vast majority of, packages. However it's worth noting that with
;; cutting-edge comes instability, so that is a risk of stability one
;; should be aware of. It's worth noting I've never been broken for
;; any package I've installed via melpa, however.
;; (add-to-list 'package-archives
;; '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; marmalade is another third-party package manager. Marmalade tends to
;; be more stable, due to the requirement that developers explicitely
;; upload new versions of their packages.
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

;; initialize package.el
(setq package-enable-at-startup nil)
(package-initialize)
;; =======================================================================
;; use-package
;; =======================================================================
;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; =======================================================================
;; Highlight the numbers
;; =======================================================================
;; http://www.wilfred.me.uk/blog/2014/09/27/the-definitive-guide-to-syntax-highlighting/
;; This package inherits the color of font-lock-constant-face of the theme
;; you are using.
(use-package highlight-numbers
  :ensure t
  :defer t
  :init
  (add-hook 'prog-mode-hook #'highlight-numbers-mode))

;; =======================================================================
;; Emacs theme setup
;; =======================================================================
;; (setq custom-safe-themes t)
;; load a customized theme in a new directory
;; (setq custom-safe-themes t)
;; (if (and (>= emacs-major-version 24)
;;          (>= emacs-minor-version 4))
;;     (add-to-list 'custom-theme-load-path
;;                  "~/.emacs.d/themes")    
;;   (add-to-list 'load-path "~/.emacs.d/themes"))
(use-package zenburn-theme
  :ensure t
  :init
  (load-theme 'zenburn t))

;; =======================================================================
;; Powerline
;; =======================================================================
;; (use-package powerline
;;   :ensure t
;;   :config
;;   (powerline-default-theme))

;; =======================================================================
;; Diminish
;; =======================================================================
;; rename the major-mode and minor-mode package on the mode line
(use-package diminish
  :ensure t
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
;; =======================================================================
;; Company 
;; =======================================================================
(use-package company
  :ensure t
  :defer t
  :init
  (global-company-mode)
  ;; (add-hook 'after-init-hook 'global-company-mode)
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
        company-dabbrev-downcase nil) ;; set it globally
  ;; call the function named company-select-next when tab is pressed  
  (define-key company-active-map [tab] 'company-select-next)
  (rename-minor-mode "company" company-mode "Com"))

(use-package company-math
  :ensure t
  :defer t
  :init
  ;; register company-math as a company backend
  (add-to-list 'company-backends 'company-math-symbols-unicode))

;; register company-web-... as a company backend
(use-package company-web
  :ensure t
  :defer t
  :init
  (add-to-list 'company-backends 'company-web-html)
  (add-to-list 'company-backends 'company-web-jade)
  (add-to-list 'company-backends 'company-web-slim))

(use-package company-anaconda
  :ensure t
  :defer t
  :config
  (add-to-list 'python-mode-hook 'company-anaconda))

(use-package company-c-headers
  :ensure t
  :defer t
  :init
  (add-to-list 'company-backends 'company-c-headers))

;; (use-package company-auctex
;;   :ensure t
;;   :defer 2
;;   :init
;;   (add-to-list 'company-backends 'company-auctex))

;; (use-package company-bibtex
;;   :ensure t
;;   :defer 2
;;   :init
;;   (add-to-list 'company-backends 'company-bibtex)
;;   (company-auctex-init))

(use-package company-flx
  :ensure t
  :defer t
  :config
  (progn
    (with-eval-after-load 'company
      (company-flx-mode +1))))

;; =======================================================================
;; ido
;; =======================================================================
;; (use-package ido ;;ido-vertical-mode
;;   :ensure ido;; ido-vertical-mode
;;   :defer 1
;;   ;; :init
;;   ;;(ido-vertical-mode 1)
;;   :config
;;   (ido-mode t)
;;   ;; customize all front colors
;;   (setq ido-use-faces t
;;         ;; make the ido display vertically
;;         ido-vertical-show-count t)
;;   (set-face-attribute 'ido-vertical-first-match-face nil
;;                       :background nil
;;                       :foreground "orange")
;;   (set-face-attribute 'ido-vertical-only-match-face nil
;;                       :background nil
;;                       :foreground nil)
;;   (set-face-attribute 'ido-vertical-match-face nil
;;                       :foreground nil)) 
(use-package flx-ido
  :ensure t
  :config
  (ido-mode 1)
  (flx-ido-mode 1)
  ;; disable ido faces to see flx highlights.
  (setq ido-enable-flex-matching nil
        flx-ido-threshold 1000
        ido-use-faces t))

;; =======================================================================
;; smex
;; =======================================================================
(use-package smex
  :ensure t
  :defer t
  :bind
  (("M-x" . smex)
   ("M-X" . smex-major-mode-commands)
   ("C-c M-x" . execute-extended-command))
  :config
  (smex-initialize))

;; =======================================================================
;; drag-stuff 
;; =======================================================================
(use-package drag-stuff
  :ensure t
  :defer t
  :init
  (drag-stuff-global-mode t)
  :bind
  (("M-S-<up>" . drag-stuff-up)
	 ("M-S-<down>" . drag-stuff-down)
	 ("M-S-<left>" . drag-stuff-left)
	 ("M-S-<right>" . drag-stuff-right))
  :config
  (rename-minor-mode "drag-stuff" drag-stuff-mode "Drag"))

;; =======================================================================
;; multiple-cursor 
;; =======================================================================
(use-package multiple-cursors
  :ensure t
  :defer t
  :bind 
  (("C-S-l C-S-l" . mc/edit-lines)
   ("C->" . mc/mark-next-like-this)
   ("C-<" . mc/mark-previous-like-this)
   ("C-c C-<" . mc/mark-all-like-this)
   ("C-S-<mouse-1>" . mc/add-cursor-on-click)))

;; =======================================================================
;; highlight-indentation
;; =======================================================================
(use-package highlight-indentation
  :ensure t
  :defer t 
  :config
  (set-face-background 'highlight-indentation-face "#555555")
  (set-face-background 'highlight-indentation-current-column-face "#c3b3b3")
  ;; hook the highlight mode to the python and the jav
  ;; (add-hook 'css-mode-hook 'highlight-indentation-mode)
  (add-hook 'css-mode-hook 'highlight-indentation-current-column-mode)
  (add-hook 'nesc-mode-hook 'highlight-indentation-current-column-mode)
  (add-hook 'python-mode-hook 'highlight-indentation-current-column-mode)
  (add-hook 'java-mode-hook 'highlight-indentation-current-column-mode)
  (add-hook 'js2-mode-hook 'highlight-indentation-current-column-mode))

;; =======================================================================
;; fic-mode TODO BUG FIXME
;; =======================================================================
(use-package fic-mode
  :ensure t
  :defer t
  :init
  (if (>= emacs-major-version 24)
      (add-hook 'prog-mode-hook 'fic-mode)
    (prog
     (add-hook 'c-mode-hook 'fic-mode)
     (add-hook 'nesc-mode-hook 'fic-mode)
     (add-hook 'java-mode-hook 'fic-mode)
     (add-hook 'python-mode-hook 'fic-mode)
     (add-hook 'c++-mode-hook 'fic-mode)
     (add-hook 'emacs-lisp-mode-hook 'fic-mode))))

;; =======================================================================
;; rainbow-mode red '#ffffff'
;; =======================================================================
(use-package rainbow-mode
  :ensure t
  :defer t
  :init
  (add-hook 'emacs-lisp-mode-hook 'rainbow-mode)
  (add-hook 'web-mode-hook 'rainbow-mode))
;; =======================================================================
;; rainbow-delimiters & color
;; =======================================================================
(use-package rainbow-delimiters
  :ensure t
  :defer t
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package color
  :ensure t
  :defer t
  :config
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
          (let ( (rainbow-var-name (concat "rainbow-delimiters-depth-" (number-to-string i) "-face"))
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
;; undo tree
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
  :ensure t
  :defer t
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
  (rename-minor-mode "undo-tree" undo-tree-mode "UT"))

;; =======================================================================
;; Bookmark
;; =======================================================================
(use-package bm
  :ensure t
  :defer t
  :bind
  (("<C-f2>" . bm-toggle)
   ("<f2>" . bm-next)
   ("<S-f2>" . bm-previous)))

;; ==================================================================
;; uniquify
;; ==================================================================
;; a built-in package in emacs
(use-package uniquify
  :defer t
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/")
  (setq uniquify-after-kill-buffer-p t)    ; rename after killing uniquified
  (setq uniquify-ignore-buffers-re "^\\*")) ; don't muck with special buffers

;; ==================================================================
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
;; =======================================================================
;; Code folding
;; =======================================================================
;; do not know how to use origami yet
;; in C mode 
(dolist (mode-hook '(c-mode-common-hook
                     python-mode-hook
                     emacs-lisp-mode-hook))
  (add-hook mode-hook
            (lambda ()
              (local-set-key (kbd "C-c <right>") 'hs-show-block)
              (local-set-key (kbd "C-c <left>")  'hs-hide-block)
              (local-set-key (kbd "C-c <up>")    'hs-hide-all)
              (local-set-key (kbd "C-c <down>")  'hs-show-all)
              (hs-minor-mode t))))

;; This minor mode will add little +/- displays to foldable regions in the
;; buffer and to folded regions. It is indented to be used in
;; conjunction with hideshow.el which is a part of GNU Emacs since
;; version 20.
(use-package hideshowvis
  :ensure t
  :defer t
  :init
  (dolist (hook (list 'emacs-lisp-mode-hook
                      'c++-mode-hook
                      'nesc-mode-hook
                      'python-mode-hook))
    (add-hook hook 'hideshowvis-enable))
  (hideshowvis-symbols)
  :config
  (setq hideshowvis-ignore-same-line nil))

(autoload 'hideshowvis-enable "hideshowvis" "Highlight foldable regions")
(autoload 'hideshowvis-minor-mode
  "hideshowvis"
  "Will indicate regions foldable with hideshow in the fringe."
  'interactive)
;; ==================================================================
;; vimrc-mode
(use-package vimrc-mode
  :ensure t
  :defer t
  :mode ("\\.vim\\(rc\\)?\\'" . vimrc-mode))
  
;; ==================================================================
;; a new function to kill the whole line
;; this one moves the cursor to the proper indented position.
(defun smart-kill-whole-line (&optional arg)
  "A simple wrapper around `kill-whole-line' that respects indentation."
  (interactive "P")
  (kill-whole-line arg)
  (back-to-indentation))

(global-set-key [remap kill-whole-line] 'smart-kill-whole-line)
;; ==================================================================
;; If the current line is commented, uncomment. If it is uncommented,
;; comment it. Morover, I would also to comment out the whole line,
;; not just from cursor position.
;; toggle the commented line 
(defun toggle-comment-on-line ()
  "comment or uncomment current line"
  (interactive)
  (comment-or-uncomment-region (line-beginning-position)
                               (line-end-position)))

;; binding the key M-c with toggle-comment-on-line
;; In fact, this key binding is used to capitalize the first
;; letter of a word, but I cannot find a better binding.
(global-set-key (kbd "M-c") 'toggle-comment-on-line)
;; ===================================================================
;; python-mode
;; ===================================================================
;; Python Custom Identation Setup
;; set the python code to indent with the tab-width = 2
(use-package python
  :mode ("\\.py\\'" . python-mode)
  :defer t
  ;; :bind
  ;; (:map python-mode
  ;;  ("RET"  .  set-newline-and-indent))
  :config
  (add-hook 'python-mode-hook 
            (lambda () 
              (setq indent-tabs-mode nil) ; disable tab mode
              (setq tab-width 2)
              (setq python-indent 2) ; set the indentation width for python
              (setq electric-indent-chars '(?\n))))
  ;; Ignoring electric indentation
  (defun electric-indent-ignore-python (char)
    "Ignore electric indentation for python-mode"
    (if (equal major-mode 'python-mode)
        `no-indent'
      nil))
  (add-hook 'electric-indent-functions 'electric-indent-ignore-python)

  ;; Enter key executes newline-and-indent
  (defun set-newline-and-indent ()
    "Map the return key with `newline-and-indent'"
    (local-set-key (kbd "RET") 'newline-and-indent))
  (add-hook 'python-mode-hook 'set-newline-and-indent))
;; ===================================================================
;; Nesc
;; ===================================================================
(use-package nesc
  :defer t
  :init
  (setq load-path (cons (expand-file-name "~/.emacs.d/nesC") load-path))  
  (setq load-path (cons (expand-file-name "~/.emacs.d/nesC") load-path))
  (autoload 'nesc-mode "nesc.el")
  :mode ("\\.nc\\'" . nesc-mode))

;; ===================================================================
;; Java
(use-package java-mode
  :mode "\\.java\\'"
  :defer t
  :config
  (add-hook 'java-mode-hook (lambda ()
                              (setq c-basic-offset 2
                                    tab-width 2
                                    indent-tabs-mode nil))))

;; ==================================================================
;; shell mode
(use-package shell
  :defer t
  :config
  (add-hook 'sh-mode-hook (lambda ()
                            (setq indent-tabs-mode t
                                  tab-width 4
                                  sh-basic-offset 4
                                  sh-indentation 4))))

;; ==================================================================
;; Ruby mode
(use-package ruby-mode
  :defer t
  :config
  (add-hook 'ruby-mode-hook (lambda ()
                              (setq indent-tabs-mode nil
                                    tab-width 2
                                    ruby-indent-level 2))))

;; ==================================================================  
;; Arduino mode
(use-package arduino-mode
  :ensure t
  :defer t
  :mode ("\\.\\(pde\\|ino\\)$" . arduino-mode)
  :config
  (add-hook 'arduino-mode-hook
            (lambda ()
              (modify-syntax-entry ?_ "w"))))

;; ==================================================================  
;; Matlab
;; ==================================================================
(use-package matlab-mode
  :ensure t
  :defer t
  :mode ("\\.m\\'" . matlab-mode)
  :defer t)

;; =======================================================================
;; Web-mode
;; =======================================================================
(use-package web-mode
  :ensure t
  :defer t
  :mode
  (("\\.phtml\\'" . web-mode)
   ("\\.tpl\\.php\\'" . web-mode)
   ("\\.[agj]sp\\'" . web-mode)
   ("\\.as[cp]x\\'" . web-mode)
   ("\\.erb\\'" . web-mode)
   ("\\.mustache\\'" . web-mode)
   ("\\.djhtml\\'" . web-mode)
   ("\\.html?\\'" . web-mode)
   ("\\.js\\'" . web-mode))
  :config
  ;; HTML element offset indentation
  (setq web-mode-markup-indent-offset 2)

  ;; CSS offset indentation
  (setq web-mode-css-indent-offset 2)

  ;; Script/code offset indentation (for JavaScript, Java, PHP,
  ;; Embedded Ruby (.erb), VBScript, Python, etc.)
  (setq web-mode-code-indent-offset 2)

  ;; highlight the current column with
  (setq web-mode-enable-current-column-highlight t))

;; ==================================================================
;; Gitignore mode
(use-package gitignore-mode
  :ensure t)
;; ==================================================================  
;; Shell
;; ==================================================================  
(defun eshell/clear ()
  "Clear the eshell buffer."
  ;; (interactive) 
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input)))

(defun shell/clear ()
  "Clear the shell buffer."
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (comint-truncate-buffer)))
;; ======================================================================
;; Racket Mode https://github.com/greghendershott/racket-mode
;; prevents emacs from showing 'lambda' as 'λ'
(global-prettify-symbols-mode 1)

;; (if a   =>  (if a
;      b           b
;    c)            c)
(put 'if 'lisp-indent-function 3)
;; =======================================================================
(use-package racket-mode
  :ensure t
  :defer t
  :init
  (add-hook 'racket-mode-hook      #'racket-unicode-input-method-enable)
  (add-hook 'racket-repl-mode-hook #'racket-unicode-input-method-enable)
  :config 
  (setq racket-mode-pretty-lambda t)
  ;; (type-case FAW a-fae
  ;     [a ...
  ;     [b ... 
  (put 'type-case 'racket-indent-function 2)
  (put 'local 'racket-indent-function nil)
  (put '+ 'racket-indent-function nil)
  (put '- 'racket-indent-function nil))

;; ==================================================================
;; Org mode customization

;; hide the structural markers in the org-mode
(setq org-hide-emphasis-markers t)	

;; add more work flow
(setq org-todo-keywords
      '((sequence "TODO" "|" "PENDING" "|" "DONE")))
;; set the source file to create an agenda
(setq org-agenda-files (list 
                        "E:/Dropbox/todolist/mytodolist.org"))
;; set the amount of whitespaces between a headline and its tag
;; -70 comes from the width of ~70 characters per line. Thus,
;; tags willl be shown up at the end of the headline's line
(setq org-tags-column -70)
;; let me determine the image width
(setq org-image-actual-width nil)
;; turn on auto fill mode to avoid pressing M-q too often
(dolist (mode-hook '(org-mode-hook
                     LaTeX-mode-hook))
  (add-hook mode-hook 'turn-on-auto-fill))

;; ==================================================================
;; ==================================================================  
;; Print out the emacs init time in the minibuffer
(run-with-idle-timer 1 nil (lambda ()
                             (message "emacs-init-time: %s"
                                      (emacs-init-time))))

;; ==================================================================
;; ## Emacs Lisp
;; (display-grpahic-p) = check whether emacs is on the terminal mode or not
;; (interactive) = it will call this function if we press M-x function-name
;; function name = mode-name/what-to-type -> read what we type in that mode
;; (progn
;;   ...
;;   ...)    =  execute the statements in sequence and return the value
;;              of the last one 
