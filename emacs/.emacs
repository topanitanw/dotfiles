;; nesc is the only one customized package
;; Modified Emacs should be downloaded from http://vgoulet.act.ulaval.ca/en/.
;;
;; emacs for window users
;; http://gregorygrubbs.com/emacs/10-tips-emacs-windows/
;;
;; emacs tutorial
;; http://www.jesshamrick.com/2012/09/10/absolute-beginners-guide-to-emacs/
;; popwin https://emacs.stackexchange.com/questions/459/how-to-automatically-kill-helm-buffers-i-dont-need
;; https://github.com/anschwa/emacs.d/blob/master/readme.org
;; https://github.com/angrybacon/dotemacs/blob/master/dotemacs.org#13-mode-line
;; https://sam217pa.github.io/2016/09/13/from-helm-to-ivy/#fnref:2
;; https://blog.aaronbieber.com/2016/09/24/an-agenda-for-life-with-org-mode.html
;;
;; cheatsheet
;; https://github.com/gnperdue/CheatSheets/blob/master/Emacs.markdown
;; https://caiorss.github.io/Emacs-Elisp-Programming/Keybindings.html
;; http://www.unexpected-vortices.com/emacs/quick-ref.html
;; =======================================================================
(setq use-spacemacs nil) ; t or nil
(when use-spacemacs
  (setq user-emacs-directory "~/.spacemacs.d/") ; default to ~/.emacs.d
  (load (expand-file-name "init.el" user-emacs-directory))
  (with-current-buffer " *load*"
    (goto-char (point-max))))

;; =======================================================================
;; ## Basic Settings
;; Use (setq ...) to set value locally to a buffer
;; Use (setq-default ...) to set value globally
;; set the default font
;; (set-frame-font Fontname-Size)
;; select the coding style of the emacs
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; save the custom file separately
(setq custom-file "~/.emacs-custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

(when (eq system-type 'windows-nt)
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
)

(cond ((string-equal system-type "windows-nt")
       (prefer-coding-system 'utf-8-dos))
      ; ((string-equal system-type "darwin")
      ; (prefer-coding-system 'utf-8-mac))
      ((string-equal system-type "gnu/linux")
       (prefer-coding-system 'utf-8-unix))
      (t (prefer-coding-system 'utf-8-auto)))

(when (eq system-type 'darwin) ;; mac specific settings
  (set-face-attribute 'default nil :height 160)
  (set-face-attribute 'mode-line nil :height 160)
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

  (prefer-coding-system 'utf-8)
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
  )

;; disable the alarm bell
(setq-default visible-bell 1)

;; keyboard scroll one line at a time
(setq-default scroll-step 1)

;; support mouse wheel scrolling
(when (require 'mwheel nil 'noerror)
  (mouse-wheel-mode t))

;; scroll down one line at a time
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

;; make emacs respond to mouse clicks on terminal
(xterm-mouse-mode 1)

;; set the format and spaces of the linenumber
(if (display-graphic-p)
    (setq linum-format "%3d \u2502")
    (setq linum-format "%3d |"))

;; TODO: might need to install the nlinum package
;; M-x linum-mode to display line number
;; (global-linum-mode 1)
;; this package of displaying line numbers runs very slowly.

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

;; go to the matching parenthesis
(defun forward-or-backward-sexp (&optional arg)
  "Go to the matching parenthesis character if one is adjacent to point."
  (interactive "^p")
  (cond ((looking-at "\\s(") (forward-sexp arg))
        ((looking-back "\\s)" 1) (backward-sexp arg))
        ;; Now, try to succeed from inside of a bracket
        ((looking-at "\\s)") (forward-char) (backward-sexp arg))
        ((looking-back "\\s(" 1) (backward-char) (forward-sexp arg))))
(global-set-key (kbd "C-%") 'forward-or-backward-sexp)

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

;; declare global variables to avoid the magic number
(defvar space-tap-offset 2 "the number of spaces per tap")

;; Indentation Setup

(defun my-coding-style ()
  (interactive)
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width space-tap-offset)

  ;; set the c-style indentation to ellemtel
  (setq-default c-default-style "ellemtel"
                c-basic-offset space-tap-offset)
  )
(my-coding-style)

(defun kdev-coding-style ()
  (interactive)
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 8)

  ;; set the c-style indentation to ellemtel
  (setq-default c-default-style "linux"
                c-basic-offset 4)
  )
  
;; set the indent of private, public keywords to be 0.5 x c-basic-offset
(c-set-offset 'access-label '/)
;; set the indent of all other elements in the class definition to equal
;; the c-basic-offset
(c-set-offset 'inclass      2)

;; Automatic(electric) Indentation
(global-set-key (kbd "RET") 'newline-and-indent)

;; (define-key global-map (kbd "RET") 'newline-and-indent)
(when (version< "24.4" emacs-version)
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
;; deleted first, and pressing del/backspace means delete the text.
(delete-selection-mode 1)

;; Set the emacs-grep to highlight the matching words
(setq grep-highlight-matches t)

;; Change "yes or no" to "y or n"
(fset 'yes-or-no-p 'y-or-n-p)

;; make searches case insensitive
(setq case-fold-search t)
;; detaching the custom-file from .emacs
;; (setq custom-file "~/.emacs.d/custom.el")
;; (when (file-exists-p custom-file)
;;   (load custom-file 'noerror))

;; set the number of characters per line
(setq-default fill-column 80)
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

;; ------------------------------------------------------------------------
;; Code folding
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

;; ----------------------------------------------------------------------
;; Shell
(defun eshell/clear ()
  "Clear the eshell buffer."
  ;; (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input)))

(setq eshell-prompt-function
      (lambda nil
        (concat "\n" (eshell/pwd) "\n$ ")))

(defun shell/clear ()
  "Clear the shell buffer."
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (comint-truncate-buffer)))

;; ----------------------------------------------------------------------
;; a new function to kill the whole line
;; this one moves the cursor to the proper indented position.
(defun smart-kill-whole-line (&optional arg)
  "A simple wrapper around `kill-whole-line' that respects indentation."
  (interactive "P")
  (kill-whole-line arg)
  (back-to-indentation))

(global-set-key [remap kill-whole-line] 'smart-kill-whole-line)

;; ----------------------------------------------------------------------
;; If the current line is commented, uncomment. If it is uncommented,
;; comment it. Morover, I would also to comment out the whole line,
;; not just from cursor position.
;; toggle the commented line
(defun toggle-comment-on-line ()
  "comment or uncomment current line"
  (interactive)
  (comment-or-uncomment-region (line-beginning-position)
                               (line-end-position)))
(global-set-key (kbd "C-;") 'toggle-comment-on-line)
;; ----------------------------------------------------------------------
;; ctags
;; find . -type f -iname "*.[chS]" -exec etags -a {} \;
;; find . -type f -iname "*.[chS]" | xargs etags -a
;; ctags -e -R *.[chS]
;; $ sudo apt-get install global # for gtags
;; $ sudo apt-get install exuberant-ctags
(defun build-ctags ()
  (interactive)
  (message "building project tags")
  (let ((root (eproject-root)))
    (shell-command (concat "ctags -e -R --extra=+fq --exclude=*~ --exclude=db --exclude=test --exclude=.git --exclude=public -f " root "TAGS " root)))
  (visit-project-tags)
  (message "tags built successfully"))

(defun my-find-tag ()
  (interactive)
  (if (file-exists-p (concat (eproject-root) "TAGS"))
      (visit-project-tags)
    (build-ctags))
  (etags-select-find-tag-at-point))

(global-set-key (kbd "M-.") 'my-find-tag)

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
;; (add-to-list 'package-archives
;;              '("marmalade" . "http://marmalade-repo.org/packages/") t)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(add-to-list 'package-archives
             '("org" . "http://orgmode.org/elpa/") t)
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

(eval-when-compile
  (require 'use-package)
  (setq-default use-package-always-defer t
                use-package-always-ensure t))
(require 'bind-key)

;; =======================================================================
;; Nlinum
;; =======================================================================
(use-package nlinum
  :demand t
  :config
  (if (display-graphic-p)
      (setq nlinum-format "%3d \u2502")
    (setq nlinum-format "%3d |"))

  (nlinum-mode)
)
;; =======================================================================
;; Beacon Mode
;; =======================================================================
;; highlight the cursor position when it moves suddenly
(use-package beacon
  :demand t
  :diminish beacon-mode
  :bind (("C-c b b" . beacon-blink))
  :config
  (beacon-mode 1)
  ;; (setq beacon-color "#666600")
  )
;; =======================================================================
;; Highlight the numbers
;; =======================================================================
;; http://www.wilfred.me.uk/blog/2014/09/27/the-definitive-guide-to-syntax-highlighting/
;; This package inherits the color of font-lock-constant-face of the theme
;; you are using.
(use-package highlight-numbers
  :init
  (add-hook 'prog-mode-hook #'highlight-numbers-mode))

;; =======================================================================
;; which keys
;; =======================================================================
(use-package which-key
  :demand t
  :init
  (which-key-mode)
  :config
  ;; after the which key window shows up, press C-h
  ;; to switch pages.
  ;; to call the helper character press C-h C-h
  (setq which-key-use-C-h-commands nil)
;  (setq which-key-use-C-h-commands nil)
  ; (setq which-key-popup-type 'minibuffer)
  (setq which-key-popup-type 'side-window)
  ;; location of which-key window. valid values: top, bottom, left, right, 
  ;; or a list of any of the two. If it's a list, which-key will always try
  ;; the first location first. It will go to the second location if there is
  ;; not enough room to display any keys in the first location
  (setq which-key-side-window-location 'bottom)

  ;; max width of which-key window, when displayed at left or right.
  ;; valid values: number of columns (integer), or percentage out of current
  ;; frame's width (float larger than 0 and smaller than 1)
  (setq which-key-side-window-max-width 0.33)

  ;; max height of which-key window, when displayed at top or bottom.
  ;; valid values: number of lines (integer), or percentage out of current
  ;; frame's height (float larger than 0 and smaller than 1)
  (setq which-key-side-window-max-height 0.25)

  ;; Set the time delay (in seconds) for the which-key popup to appear. A value of
  ;; zero might cause issues so a non-zero value is recommended.
  (setq which-key-idle-delay 1.0)

  ;; Set the special keys. These are automatically truncated to one character and
  ;; have which-key-special-key-face applied. Disabled by default. An example
  ;; setting is
  ;; (setq which-key-special-keys '("SPC" "TAB" "RET" "ESC" "DEL"))
  (setq which-key-special-keys nil)

  ;; Show the key prefix on the left, top, or bottom (nil means hide the prefix).
  ;; The prefix consists of the keys you have typed so far. which-key also shows
  ;; the page information along with the prefix.
  (setq which-key-show-prefix 'left)

  ;; Set to t to show the count of keys shown vs. total keys in the mode line.
  (setq which-key-show-remaining-keys nil))
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
  :demand t
  :config
  (load-theme 'zenburn t)
  ;; background of linum attribute will inherit from the
  ;; background of the text editor
  (set-face-attribute 'linum nil
                      ;; :foreground "#8FB28F"
                      ;; :background "#3F3F3F"
                      :family "DejaVu Sans Mono"
                      :height 130
                      :bold nil
                      :underline nil)
  )
;; =======================================================================
;; Powerline
;; =======================================================================
;; (use-package powerline
;;   :demand t
;;   :config
;;   (powerline-default-theme))

  
(use-package telephone-line
  :demand t
  ;:disabled
  :config
  (setq telephone-line-evil-use-short-tag t
        telephone-line-primary-left-separator telephone-line-flat
        telephone-line-secondary-left-separator telephone-line-nil
        telephone-line-primary-right-separator telephone-line-flat
        telephone-line-secondary-right-separator telephone-line-nil
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
  ;; (telephone-line-evil-config)
  (telephone-line-mode 1))

;; =======================================================================
;; Diminish
;; =======================================================================
;; rename the major-mode and minor-mode package on the mode line
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

;; =======================================================================
;; Company
;; =======================================================================
(use-package company
  :demand t
  :bind
  (("C-c <tab>" . company-complete))
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
        company-dabbrev-downcase nil ;; set it globally
        company-minimum-prefix-length 2
        ;; weight by frequency
        company-transformers '(company-sort-by-occurrence
                               company-sort-by-backend-importance))
  ;; call the function named company-select-next when tab is pressed
  ;; (define-key company-active-map [tab] 'company-select-next)
  (define-key company-active-map (kbd "TAB") 'company-select-next)
  (rename-minor-mode "company" company-mode "Com"))

(use-package company-math
  :after company
  :init
  ;; register company-math as a company backend
  (add-to-list 'company-backends 'company-math-symbols-unicode))

;; register company-web-... as a company backend
(use-package company-web
  :after company
  :init
  (add-to-list 'company-backends 'company-web-html)
  (add-to-list 'company-backends 'company-web-jade)
  (add-to-list 'company-backends 'company-web-slim))

(use-package company-anaconda
  :after company
  :config
  (add-to-list 'company-backends 'company-anaconda)
  (add-to-list 'python-mode-hook 'anaconda-mode)
  (rename-minor-mode "company-anaconda" company-anaconda "Com-Ana"))

(use-package company-c-headers
  :after company
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
  :disabled t
  :after company
  :config
  (company-flx-mode +1))

;; =======================================================================
;; ido
;; =======================================================================
;; Ido customization based on http://emacsist.com/10480
(use-package ido
  ;; :disabled t
  :ensure ido
  ;:defer 1
  :config
  (ido-mode 1)
  ;; (ido-everywhere)
  ;; customize all front colors
  (setq ido-use-faces t
        ;; make the ido display vertically
        ido-vertical-show-count t
        ;; enable ido flex matching containing all of the selection’s
        ;; characters in order will appear in the result set.
        ido-enable-flex-matching t
        ;; use the filename under the cursor as a starting point for
        ;; ido completion
        ido-use-filename-at-point 'guess)
  ;; ignore the file extension
  (add-to-list 'completion-ignored-extensions ".pyc")
  (add-to-list 'completion-ignored-extensions "~"))

(use-package ido-ubiquitous
  :disabled t
  :config
  (ido-ubiquitous-mode 1))

(use-package ido-vertical-mode
  ;; :disabled t
  :ensure ido-vertical-mode
  :demand t
  :config
  (ido-vertical-mode 1)
  (setq ido-use-virtual-buffers t)
  ;; show the count of the candidates
  (setq ido-vertical-show-count t)
  ;; customize font colors
  (set-face-attribute 'ido-vertical-first-match-face nil
                      :background nil
                      :foreground "orange")
  (set-face-attribute 'ido-vertical-only-match-face nil
                      :background nil
                      :foreground nil)
  (set-face-attribute 'ido-vertical-match-face nil
                      :foreground nil))

(use-package flx-ido
  :disabled t
  :config
  ;; (ido-mode 1)
  (flx-ido-mode 1)
  ;; disable ido faces to see flx highlights.
  (setq ido-enable-flex-matching nil
        flx-ido-threshold 1000
        ido-use-faces t))

;; -----------------------------------------------------------------------
;; smex
;; (use-package smex
;;   :ensure t
;;   :defer 1
;;   ;; :bind
;;   ;; (("M-x" . smex)
;;   ;;  ("M-X" . smex-major-mode-commands)
;;   ;;  ("C-c M-x" . execute-extended-command))
;;   :init
;;   (smex-initialize))
;; (global-set-key (kbd "M-x") #'smex)
;; (global-set-key (kbd "M-X") #'smex-major-mode-commands)
;; (global-set-key (kbd "C-c M-x") #'execute-extended-command)

;; I'm not quite satisfied with the leftover buffer from helm that
;; can still see them in the ibuffer.
;; https://tuhdo.github.io/helm-intro.html
;; https://writequit.org/denver-emacs/presentations/2016-03-01-helm.html
;; =======================================================================
;; evil
;; =======================================================================
(use-package evil
  :demand t
  :init
  (evil-mode 1)
  :config
  (setq evil-toggle-key "")
  (add-to-list 'evil-emacs-state-modes 'flycheck-error-list-mode)
  (add-to-list 'evil-emacs-state-modes 'occur-mode)
  (add-to-list 'evil-emacs-state-modes 'neotree-mode)
  ;; C-z to suspend-frame in evil normal state and evil emacs state
  (define-key evil-normal-state-map (kbd "C-z") 'suspend-frame)
  (define-key evil-emacs-state-map (kbd "C-z") 'suspend-frame)
  (define-key evil-insert-state-map (kbd "C-z") 'suspend-frame)
  ;; enable TAB to indent in the vistual mode
  (define-key evil-visual-state-map (kbd "TAB") 'indent-for-tab-command)
  ;; define :ls, :buffers to open ibuffer
  (evil-ex-define-cmd "ls" 'ibuffer)
  (evil-ex-define-cmd "buffers" 'ibuffer))  

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
  (;("C-x b" . helm-buffers-list)
   ("M-x" . helm-M-x)
   ("M-y" . helm-show-kill-ring)
   ;("C-x C-f" . helm-find-files)
   ("C-c h" . helm-mini)))

;; =======================================================================
;; drag-stuff
;; =======================================================================
(use-package drag-stuff
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
  :bind
  (("C-c C-l" . mc/edit-lines)
   ("C->" . mc/mark-next-like-this)
   ("C-<" . mc/mark-previous-like-this)
   ("C-c C-<" . mc/mark-all-like-this)
   ("C-S-<mouse-1>" . mc/add-cursor-on-click)))

;; =======================================================================
;; highlight-indentation
;; =======================================================================
;; (use-package highlight-indentation
;;   ;; :disabled t
;;   :config
;;   ;; (set-face-background 'highlight-indentation-face "#555555")
;;   ;; (set-face-background 'highlight-indentation-current-column-face "#c3b3b3")
;;   ;; hook the highlight mode to the python and the jav
;;   (add-hook 'yaml-mode-hook 'hightlight-indentation-mode)
;;   (add-hook 'yaml-mode-hook 'highlight-indentation-current-column-mode)
;;   ;; (add-hook 'css-mode-hook 'highlight-indentation-mode)
;;   ;; (add-hook 'css-mode-hook 'highlight-indentation-current-column-mode)
;;   ;; (add-hook 'nesc-mode-hook 'highlight-indentation-current-column-mode)
;;   ;; (add-hook 'python-mode-hook 'highlight-indentation-current-column-mode)
;;   ;; (add-hook 'java-mode-hook 'highlight-indentation-current-column-mode)
;;   ;; (add-hook 'js2-mode-hook 'highlight-indentation-current-column-mode)
;;   )

;; ===================================================================
;; hightlight indentation
(use-package highlight-indent-guides
  :demand t
  :config
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
  (setq highlight-indent-guides-method 'character)
  (setq highlight-indent-guides-auto-enabled nil)

  (set-face-background 'highlight-indent-guides-odd-face "darkgray")
  (set-face-background 'highlight-indent-guides-even-face "dimgray")
  (set-face-foreground 'highlight-indent-guides-character-face "dimgray"))
;; =======================================================================
;; fic-mode TODO BUG FIXME CLEANUP CHECKING(owner)
;; =======================================================================
(use-package fic-mode
  :init
  (if (>= emacs-major-version 24)
      (progn (add-hook 'prog-mode-hook 'fic-mode)
             (add-hook 'LaTeX-mode-hook 'fic-mode))
      (progn (add-hook 'c-mode-hook 'fic-mode)
             (add-hook 'nesc-mode-hook 'fic-mode)
             (add-hook 'java-mode-hook 'fic-mode)
             (add-hook 'python-mode-hook 'fic-mode)
             (add-hook 'c++-mode-hook 'fic-mode)
             (add-hook 'emacs-lisp-mode-hook 'fic-mode)
             (add-hook 'LaTeX-mode-hook 'fic-mode)))
  :config
  (dolist (word '("TODO" "CLEANUP" "CHECKING"))
    (when (not (member word fic-highlighted-words))
      (push word fic-highlighted-words))))
;; =======================================================================
;; rainbow-mode red '#ffffff'
;; =======================================================================
(use-package rainbow-mode
  :init
  (add-hook 'emacs-lisp-mode-hook 'rainbow-mode)
  (add-hook 'web-mode-hook 'rainbow-mode))

;; =======================================================================
;; rainbow-delimiters & color
;; =======================================================================
(use-package rainbow-delimiters
  :disabled t
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package color
  :disabled t
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
;; Swiper
;; =======================================================================
(use-package swiper
  :bind
  (("C-c s" . swiper))
  :init
  ;; (ivy-mode 1)
  ;; (setq ivy-display-style 'fancy)
  ;; using ivy to switch buffers
  ;; (setq ivy-use-virtual-buffers t)
  )

;; =======================================================================
;; Counsel
;; =======================================================================
(use-package counsel
  ;; :if (and (>= emacs-major-version 24)
  ;;          (>= emacs-minor-version 4))
  :if (version< "24.4" emacs-version)
  :bind
  (;("C-x C-f" . counsel-find-file)
   ("M-x" . counsel-M-x)))

;; =======================================================================
;; Avy
;; =======================================================================
;; jumping from places to places
(use-package avy
  :bind
  (("C-c j" . avy-goto-char-2)
   ("C-c l" . avy-goto-line)))

;; =======================================================================
;; bookmark
;; =======================================================================
(use-package bm
  :bind
  (("<C-f2>" . bm-toggle)
   ("<f2>" . bm-next)
   ("<S-f2>" . bm-previous)))

;; ==================================================================
;; uniquify
;; ==================================================================
;; a built-in package in emacs
;; make the buffer unique
(use-package uniquify
  :ensure nil
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/")
  (setq uniquify-after-kill-buffer-p t)    ; rename after killing uniquified
  (setq uniquify-ignore-buffers-re "^\\*")) ; don't muck with special buffers

(use-package hydra
  :demand t
  :init
  (defhydra hydra-ibuffer-main (:color pink :hint nil)
    "
     ^Navigation^ | ^Mark^        | ^Actions^        | ^View^
    -^----------^-+-^----^--------+-^-------^--------+-^----^-------
      _k_:    ʌ   | _m_: mark     | _D_: delete      | _g_: refresh
     _RET_: visit | _u_: unmark   | _S_: save        | _s_: sort
      _j_:    v   | _*_: specific | _a_: all actions | _/_: filter
    -^----------^-+-^----^--------+-^-------^--------+-^----^-------
    "
    ("j" ibuffer-forward-line)
    ("RET" ibuffer-visit-buffer :color blue)
    ("k" ibuffer-backward-line)

    ("m" ibuffer-mark-forward)
    ("u" ibuffer-unmark-forward)
    ("*" hydra-ibuffer-mark/body :color blue)

    ("D" ibuffer-do-delete)
    ("S" ibuffer-do-save)
    ("a" hydra-ibuffer-action/body :color blue)

    ("g" ibuffer-update)
    ("s" hydra-ibuffer-sort/body :color blue)
    ("/" hydra-ibuffer-filter/body :color blue)

    ("o" ibuffer-visit-buffer-other-window "other window" :color blue)
    ("q" ibuffer-quit "quit ibuffer" :color blue)
    ("." nil "toggle hydra" :color blue))

  (defhydra hydra-ibuffer-mark (:color teal :columns 5
                                       :after-exit (hydra-ibuffer-main/body))
    "Mark"
    ("*" ibuffer-unmark-all "unmark all")
    ("M" ibuffer-mark-by-mode "mode")
    ("m" ibuffer-mark-modified-buffers "modified")
    ("u" ibuffer-mark-unsaved-buffers "unsaved")
    ("s" ibuffer-mark-special-buffers "special")
    ("r" ibuffer-mark-read-only-buffers "read-only")
    ("/" ibuffer-mark-dired-buffers "dired")
    ("e" ibuffer-mark-dissociated-buffers "dissociated")
    ("h" ibuffer-mark-help-buffers "help")
    ("z" ibuffer-mark-compressed-file-buffers "compressed")
    ("b" hydra-ibuffer-main/body "back" :color blue))

  (defhydra hydra-ibuffer-action (:color teal :columns 4
                                         :after-exit
                                         (if (eq major-mode 'ibuffer-mode)
                                             (hydra-ibuffer-main/body)))
    "Action"
    ("A" ibuffer-do-view "view")
    ("E" ibuffer-do-eval "eval")
    ("F" ibuffer-do-shell-command-file "shell-command-file")
    ("I" ibuffer-do-query-replace-regexp "query-replace-regexp")
    ("H" ibuffer-do-view-other-frame "view-other-frame")
    ("N" ibuffer-do-shell-command-pipe-replace "shell-cmd-pipe-replace")
    ("M" ibuffer-do-toggle-modified "toggle-modified")
    ("O" ibuffer-do-occur "occur")
    ("P" ibuffer-do-print "print")
    ("Q" ibuffer-do-query-replace "query-replace")
    ("R" ibuffer-do-rename-uniquely "rename-uniquely")
    ("T" ibuffer-do-toggle-read-only "toggle-read-only")
    ("U" ibuffer-do-replace-regexp "replace-regexp")
    ("V" ibuffer-do-revert "revert")
    ("W" ibuffer-do-view-and-eval "view-and-eval")
    ("X" ibuffer-do-shell-command-pipe "shell-command-pipe")
    ("b" nil "back"))

  (defhydra hydra-ibuffer-sort (:color amaranth :columns 3)
    "Sort"
    ("i" ibuffer-invert-sorting "invert")
    ("a" ibuffer-do-sort-by-alphabetic "alphabetic")
    ("v" ibuffer-do-sort-by-recency "recently used")
    ("s" ibuffer-do-sort-by-size "size")
    ("f" ibuffer-do-sort-by-filename/process "filename")
    ("m" ibuffer-do-sort-by-major-mode "mode")
    ("b" hydra-ibuffer-main/body "back" :color blue))

  (defhydra hydra-ibuffer-filter (:color amaranth :columns 4)
    "Filter"
    ("m" ibuffer-filter-by-used-mode "mode")
    ("M" ibuffer-filter-by-derived-mode "derived mode")
    ("n" ibuffer-filter-by-name "name")
    ("c" ibuffer-filter-by-content "content")
    ("e" ibuffer-filter-by-predicate "predicate")
    ("f" ibuffer-filter-by-filename "filename")
    (">" ibuffer-filter-by-size-gt "size")
    ("<" ibuffer-filter-by-size-lt "size")
    ("/" ibuffer-filter-disable "disable")
    ("b" hydra-ibuffer-main/body "back" :color blue))
  ; (define-key ibuffer-mode-map "." 'hydra-ibuffer-main/body)
  (add-hook 'ibuffer-hook #'hydra-ibuffer-main/body)

  (use-package windmove
    :demand t)

  (defun hydra-move-splitter-left (arg)
    "Move window splitter left."
    (interactive "p")
    (if (let ((windmove-wrap-around))
          (windmove-find-other-window 'right))
        (shrink-window-horizontally arg)
        (enlarge-window-horizontally arg)))

  (defun hydra-move-splitter-right (arg)
    "Move window splitter right."
    (interactive "p")
    (if (let ((windmove-wrap-around))
          (windmove-find-other-window 'right))
        (enlarge-window-horizontally arg)
        (shrink-window-horizontally arg)))

  (defun hydra-move-splitter-up (arg)
    "Move window splitter up."
    (interactive "p")
    (if (let ((windmove-wrap-around))
      (windmove-find-other-window 'up))
    (enlarge-window arg)
    (shrink-window arg)))

  (defun hydra-move-splitter-down (arg)
    "Move window splitter down."
    (interactive "p")
    (if (let ((windmove-wrap-around))
      (windmove-find-other-window 'up))
    (shrink-window arg)
    (enlarge-window arg)))

  (global-set-key
   (kbd "C-c w")
   (defhydra hydra-window ()
     "
     Movement^^     ^Split^         ^Switch^		    ^Resize^
     ----------------------------------------------------------------
     _h_ ←        	_v_ertical       	_b_uffer		  _q_ X←
     _j_ ↓        	_x_ horizontal	  _f_ind files  _w_ X↓
     _k_ ↑        	_z_ undo      	  _a_ce 1		    _e_ X↑
     _l_ →        	_Z_ reset      	  _s_wap		    _r_ X→
     _F_ollow		    _D_lt Other   	  _S_ave		    max_i_mize
     _._ cancel	    _o_nly this   	  _d_elete
     "
     ("h" windmove-left )
     ("j" windmove-down )
     ("k" windmove-up )
     ("l" windmove-right )
     ("q" hydra-move-splitter-left)
     ("w" hydra-move-splitter-down)
     ("e" hydra-move-splitter-up)
     ("r" hydra-move-splitter-right)
     ("b" helm-mini)
     ("f" helm-find-files)
     ("F" follow-mode)
     ("a" (lambda ()
            (interactive)
            (ace-window 1)
            (add-hook 'ace-window-end-once-hook
                      'hydra-window/body))
      )
     ("v" (lambda ()
            (interactive)
            (split-window-right)
            (windmove-right))
      )
     ("x" (lambda ()
            (interactive)
            (split-window-below)
            (windmove-down))
      )
     ("s" (lambda ()
            (interactive)
            (ace-window 4)
            (add-hook 'ace-window-end-once-hook
                      'hydra-window/body)))
     ("S" save-buffer)
     ("d" delete-window)
     ("D" (lambda ()
            (interactive)
            (ace-window 16)
            (add-hook 'ace-window-end-once-hook
                      'hydra-window/body))
      )
     ("o" delete-other-windows)
     ("i" ace-maximize-window)
     ("z" (progn
            (winner-undo)
            (setq this-command 'winner-undo))
      )
     ("Z" winner-redo)
     ("." nil)
     )))

;; ==================================================================
;; ace-window
;; ==================================================================
;; switching between buffers
(use-package ace-window
  :bind (("C-x o" . ace-window))
  :config
  (global-set-key [remap other-window] 'ace-window)
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; ==================================================================
;; hideshow
;; ==================================================================
;; code folding
;; This minor mode will add little +/- displays to foldable regions in the
;; buffer and to folded regions. It is indented to be used in
;; conjunction with hideshow.el which is a part of GNU Emacs since
;; version 20.
(use-package hideshowvis
  :diminish hs-minor-mode
  :disabled
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

;; ==================================================================
;; neotree
;; ==================================================================
;; need to reconfig for evil node
;; n and p: next and previous
;; H: toggle to display the hidden files
;; A: minimize and maximize the neotree buffer
;; TAB or SPC or RET: fold/unfold files in a directory
;; g: refresh files
(use-package neotree
  :bind (("C-c n" . 'neotree-toggle))
  :config
  ;; (setq neo-theme (if (display-graphic-p)
  ;;                     'icons
  ;;                     'arrow))
  )

(use-package all-the-icons)
;; ==================================================================
;; vimrc-mode
(use-package vimrc-mode
  :mode ("\\.vim\\(rc\\)?\\'" . vimrc-mode))

;; ===================================================================
;; flycheck-mode
(use-package flycheck
  ;:demand t
  :if (not window-system))

;; ==================================================================
;; Gitignore mode
(use-package gitignore-mode)
;; git commit message mode
(use-package git-commit)

;; ===================================================================
;; python-mode
;; ===================================================================
;; Python Custom Identation Setup
;; set the python code to indent with the tab-width = 2
(use-package python
  :mode ("\\.py\\'" . python-mode)
  ;; :bind
  ;; (:map python-mode
  ;;  ("RET"  .  set-newline-and-indent))
  :config
  (add-hook 'python-mode-hook
            (lambda ()
              (setq indent-tabs-mode nil) ; disable tab mode
              (setq tab-width space-tap-offset)
              ; set the indentation width for python
              (setq python-indent space-tap-offset)
              (setq python-indent-offset space-tap-offset)
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
  :ensure nil
  :init
  (setq load-path (cons (expand-file-name "~/.emacs.d/nesC") load-path))
  (setq load-path (cons (expand-file-name "~/.emacs.d/nesC") load-path))
  (autoload 'nesc-mode "nesc.el")
  :mode ("\\.nc\\'" . nesc-mode))

;; ===================================================================
;; Java
(use-package java-mode
  :ensure nil
  :mode "\\.java\\'" ; ("\\.py\\'" . python-mode)
  :config
  (add-hook 'java-mode-hook (lambda ()
                              (setq c-basic-offset space-tap-offset
                                    tab-width space-tap-offset
                                    indent-tabs-mode nil))))

;; ==================================================================
;; shell mode
(use-package shell
  :config
  (add-hook 'sh-mode-hook (lambda ()
                            (setq indent-tabs-mode t
                                  tab-width 4
                                  sh-basic-offset 4
                                  sh-indentation 4))))

;; ==================================================================
;; Ruby mode
(use-package ruby-mode
  :config
  (add-hook 'ruby-mode-hook (lambda ()
                              (setq indent-tabs-mode nil
                                    tab-width space-tap-offset
                                    ruby-indent-level space-tap-offset)))
  (add-hook 'ruby-mode-hook 'robe-mode))

;; ==================================================================
;; Autocomplete for ruby
(use-package robe
  :after ruby-mode
  :config
  (add-to-list 'company-backends 'company-robe))

;; ==================================================================
;; Arduino mode
(use-package arduino-mode
  :mode ("\\.\\(pde\\|ino\\)$" . arduino-mode)
  :config
  (add-hook 'arduino-mode-hook
            (lambda ()
              (modify-syntax-entry ?_ "w"))))

;; ==================================================================
;; Matlab
;; ==================================================================
(use-package matlab-mode
  :mode ("\\.m\\'" . matlab-mode)
  :config
  (setq matlab-indent-level 4)
  (setq matlab-indent-function-body nil)
  (autoload 'matlab-shell "matlab" "Interactive Matlab mode." t))

;; =======================================================================
;; Web-mode
;; =======================================================================
(use-package web-mode
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

;; ======================================================================
;; Racket Mode https://github.com/greghendershott/racket-mode
;; prevents emacs from showing 'lambda' as 'λ'
;; in window, only lampda will change to a symbol, but in mac,
;; the logical operators in python will be shown as symbols ex or => v.
(when (and (version< "24.4" emacs-version)
           (window-system))
  (global-prettify-symbols-mode 1))

;; (if a   =>  (if a
;      b           b
;    c)            c)
(put 'if 'lisp-indent-function 3)

;; =======================================================================
;; racket mode setup
(use-package racket-mode
  :bind
  (("C-c r" . racket-run))
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
  (put '- 'racket-indent-function nil)
  (setq tab-always-indent 'complete)
  (when (window-system)
    (setq racket-racket-program "c:/Program Files/Racket/Racket.exe")
    (setq racket-raco-program "c:/Program Files/Racket/raco.exe")))
;; parendit
;; http://danmidwood.com/content/2014/11/21/animated-paredit.html
;; ==================================================================
;; sml a teaching programming language in coursera
;; type C-x C-s to call sml prompt in another buffer
;; type C-d to end the session
;; type C-c C-c to interrupt evaluation and get your prompt back
;; type M-p to print the previous line you used in REPL
;; type M-n to print the next line you used in REPL
(use-package sml-mode
  :mode ("\\.sml\\'" . sml-mode))

;; ==================================================================
;; assembly mode setup
(use-package asm-mode
  ;; an installed package
  :mode
  (("\\.S\\'" . asm-mode)
   ("\\.asm\\'" . asm-mode))
  :bind
  (("RET" . newline-and-indent))
  :config
  (setq asm-indent-level (* 2 space-tap-offset))
  (setq indent-tabs-mode nil) ; use spaces to indent
  (electric-indent-mode -1) ; indentation in asm-mode is annoying
  (setq tab-stop-list (number-sequence 2 60 2))
  )

;; ==================================================================
;; Scala
(use-package scala-mode
  :interpreter
  ("scala" . scala-mode)
  :config
  (setq prettify-symbols-alist scala-prettify-symbols-alist)
  (prettify-symbols-mode))

;; ==================================================================
;; YAML mode
;; C-x TAB = indent the region/line
;; C-n C-x $ = fold lines that indented more than n spaces
;; C-x $ = select display folded lines
(use-package yaml-mode
  :mode
  (("\\.yml\\'" . yaml-mode)
   ("\\.conf\\'" . yaml-mode))
  :bind
  ;; remap the ENTER key to newline-and-indent
  ;; (define-key yaml-mode-map "\C-m" 'newline-and-indent)
  ("RET" . newline-and-indent)
  :init
  (add-hook 'yaml-mode-hook #'highlight-numbers-mode)
  (add-hook 'yaml-mode-hook 'highlight-indent-guides-mode)
  (add-hook 'yaml-mode-hook 'fic-mode)
  ;; TODO find a way to fold the code
  )

;; ==================================================================
;; markdown mode-line
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode
  (("README\\.md\\'" . gfm-mode)
   ("\\.md\\'" . markdown-mode)
   ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "multimarkdown"))
;; ==================================================================
;; Org mode customization
(use-package org
  :bind
  (("C-c a" . org-agenda))
  :mode ("\\.org\\'" . org-mode) ;; redundant, emacs has this by default.
  :config
  ;; hide the structural markers in the org-mode
  (setq org-hide-emphasis-markers t)
  ;; Display emphasized text as you would in a WYSIWYG editor.
  (setq org-fontify-emphasized-text t)
  ;; add more work flow
  (setq org-todo-keywords
        '((sequence "TODO(t)" "IN-PROGRESS(i)" "HOLD(h@)" "WAITING(w@/!)" "|" "CANCELED(c@)" "DONE(d@/!)")))
  ;; set the source file to create an agenda
  (when window-system
    (setq org-agenda-files
          (list
           "e:/Dropbox/todolist/mytodolist.org"
           "e:/Dropbox/todolist/today_plan.org")))
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
  )

(dolist (mode-hook '(org-mode-hook
                     LaTeX-mode-hook))
  (add-hook mode-hook 'turn-on-auto-fill))
;; ==================================================================
;; setup the org-tree-slide mode
;; control functions
;; org-tree-slide-move-next-tree (C->)
;; org-tree-slide-move-previous-tree (C-<)
;; org-tree-slide-content (C-x s c)
(use-package org-tree-slide
  :bind
  (("<f8>" . org-tree-slide-mode)
   ("S-<f8>" . org-tree-slide-skip-done-toggle)))

;; ==================================================================
;; apple script
;; syntax highlight for apple script
(use-package apples-mode
  :mode ("\\.\\(applescri\\|sc\\)pt\\'" . apples-mode))
;; ==================================================================
;; Latex
;; get 2 spaces indentation for the \item
(use-package auctex
  :mode ("\\.tex\\'" . latex-mode)
  :init
  (add-hook 'LaTeX-mode-hook #'flyspell-mode)
  :config
  (setq LaTeX-item-indent 0))
;; ==================================================================
;; flyspell
;; check the spelling on the fly
(use-package flyspell
  ;; :diminish ""
  :config
  ;; remove/remap the minor-mode key map
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

  (when (string-equal 'gnu/linux system-type)
    (setq-default ispell-program-name "/usr/bin/aspell"))
  (when (string-equal system-type "darwin")
    (setq-default ispell-program-name "/usr/local/bin/ispell"))
  (setq-default ispell-list-command "list")
  )

;; ==================================================================
;; writegood-mode
(use-package writegood-mode)

;; ==================================================================
;; ==================================================================
;; Print out the emacs init time in the minibuffer
(run-with-idle-timer 1 nil (lambda ()
                             (message "emacs-init-time: %s"
                                      (emacs-init-time))))

;; ==================================================================
;; ## Emacs Lisp
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
;; (defcustom variable ... ) = a function to declare a customizable variable
;; window-system = this is a window system

;; ==================================================================
