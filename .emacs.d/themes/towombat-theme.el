;;; towombat-theme.el --- Custom face theme for Emacs  -*-coding: utf-8 -*-

;; Copyright (C) 2011-2015 Free Software Foundation, Inc.

;; Author: Kristoffer Grönlund <krig@koru.se>

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Code:

(deftheme towombat
  "Medium-contrast faces with a dark gray background.
Adapted, with permission, from a Vim color scheme by Lars H. Nielsen.
Basic, Font Lock, Isearch, Gnus, Message, and Ansi-Color faces
are included.")

(let ((class '((class color) (min-colors 89))))
  (custom-theme-set-faces
   'towombat
   `(default ((,class (:background "#2C2C2C" :foreground "#DCDCCC"))))
   `(cursor ((,class (:background "#656565"))))
   ;; Highlighting faces
   `(fringe ((,class (:background "#303030"))))
   `(highlight ((,class (:background "#454545"
			 :foreground "#ffffff"
			 :underline nil))))
   `(region ((,class (:background "#444444" :foreground "#f6f3e8"))))
   `(secondary-selection ((,class (:background "#333366" :foreground "#f6f3e8"))))
   `(isearch ((,class (:background "#343434" :foreground "#857b6f"))))
   `(lazy-highlight ((,class (:background "#384048" :foreground "#a0a8b0"))))
   ;; Mode line faces
   `(mode-line ((,class (:background "#444444" :foreground "#f6f3e8"))))
   `(mode-line-inactive ((,class (:background "#444444" :foreground "#857b6f"))))
   ;; Escape and prompt faces
   `(minibuffer-prompt ((,class (:foreground "#e5786d"))))
   `(escape-glyph ((,class (:foreground "#ddaa6f" :weight bold))))
   ;; Font lock faces
   `(font-lock-builtin-face ((,class (:foreground "#e5786d" :weight bold))))
   `(font-lock-comment-face ((,class (:foreground "#99968b"))))
   `(font-lock-constant-face ((,class (:foreground "#e5786d"))))
   `(font-lock-function-name-face ((,class (:foreground "#cae682"))))
   `(font-lock-keyword-face ((,class (:foreground "#8ac6f2" :weight bold))))
   `(font-lock-string-face ((,class (:foreground "#95e454"))))
   `(font-lock-type-face ((,class (:foreground "#92a65e" :weight bold))))
   `(font-lock-variable-name-face ((,class (:foreground "#cae682"))))
   `(font-lock-warning-face ((,class (:foreground "#ccaa8f"))))
   ;; Button and link faces
   `(link ((,class (:foreground "#8ac6f2" :underline t))))
   `(link-visited ((,class (:foreground "#e5786d" :underline t))))
   `(button ((,class (:background "#333333" :foreground "#f6f3e8"))))
   `(header-line ((,class (:background "#303030" :foreground "#e7f6da"))))
   ;; Gnus faces
   `(gnus-group-news-1 ((,class (:weight bold :foreground "#95e454"))))
   `(gnus-group-news-1-low ((,class (:foreground "#95e454"))))
   `(gnus-group-news-2 ((,class (:weight bold :foreground "#cae682"))))
   `(gnus-group-news-2-low ((,class (:foreground "#cae682"))))
   `(gnus-group-news-3 ((,class (:weight bold :foreground "#ccaa8f"))))
   `(gnus-group-news-3-low ((,class (:foreground "#ccaa8f"))))
   `(gnus-group-news-4 ((,class (:weight bold :foreground "#99968b"))))
   `(gnus-group-news-4-low ((,class (:foreground "#99968b"))))
   `(gnus-group-news-5 ((,class (:weight bold :foreground "#cae682"))))
   `(gnus-group-news-5-low ((,class (:foreground "#cae682"))))
   `(gnus-group-news-low ((,class (:foreground "#99968b"))))
   `(gnus-group-mail-1 ((,class (:weight bold :foreground "#95e454"))))
   `(gnus-group-mail-1-low ((,class (:foreground "#95e454"))))
   `(gnus-group-mail-2 ((,class (:weight bold :foreground "#cae682"))))
   `(gnus-group-mail-2-low ((,class (:foreground "#cae682"))))
   `(gnus-group-mail-3 ((,class (:weight bold :foreground "#ccaa8f"))))
   `(gnus-group-mail-3-low ((,class (:foreground "#ccaa8f"))))
   `(gnus-group-mail-low ((,class (:foreground "#99968b"))))
   `(gnus-header-content ((,class (:foreground "#8ac6f2"))))
   `(gnus-header-from ((,class (:weight bold :foreground "#95e454"))))
   `(gnus-header-subject ((,class (:foreground "#cae682"))))
   `(gnus-header-name ((,class (:foreground "#8ac6f2"))))
   `(gnus-header-newsgroups ((,class (:foreground "#cae682"))))
   ;; Message faces
   `(message-header-name ((,class (:foreground "#8ac6f2" :weight bold))))
   `(message-header-cc ((,class (:foreground "#95e454"))))
   `(message-header-other ((,class (:foreground "#95e454"))))
   `(message-header-subject ((,class (:foreground "#cae682"))))
   `(message-header-to ((,class (:foreground "#cae682"))))
   `(message-cited-text ((,class (:foreground "#99968b"))))
   `(message-separator ((,class (:foreground "#e5786d" :weight bold))))
   ;; org-mode
   `(org-date ((,class (:foreground "#00ffff" :underline t))))
   `(org-agenda-date-today ((,class (:foreground "#FFFFEF" :slant italic :weight bold))) t)   
   `(org-agenda-structure  ((,class (:bold nil :foreground "#699598"))))
   `(org-agenda-date ((,class (:inherit org-agenda-structure :weight bold))) t)
   `(org-agenda-date-weekend ((,class (:inherit org-agenda-structure))) t)
   `(org-deadline-announce ((,class (:foreground "#E090C7" :weight bold))))
   `(org-upcoming-deadline ((,class (:foreground "#E5786D" :weight bold))))
   `(org-special-keyword ((,class (:forground "#ECBCAC" :weight bold))))   
   `(org-level-1 ((,class (:bold t :foreground "#ECBC9F" :weight bold))))
   `(org-level-2 ((,class (:bold nil :foreground "#CCF88C"))))
   `(org-level-3 ((,class (:bold nil :foreground "#89C5C8"))))
   `(org-level-4 ((,class (:bold nil :foreground "#DDCC9C"))))
   `(org-level-5 ((,class (:bold nil :foreground "#A0EDF0"))))
   `(org-level-6 ((,class (:bold nil :foreground "#CAE682"))))
   `(org-level-7 ((,class (:bold nil :foreground "#996060"))))
   `(org-level-8 ((,class (:bold nil :foreground "#ACD2AC"))))
   ))

(custom-theme-set-variables
 'towombat
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682"
			    "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"]))

(provide-theme 'towombat)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; towombat-theme.el ends here
   ;; `(org-document-title ((,class (:foreground ,cyberpunk-blue-3 :background ,cyberpunk-black :weight bold :height 1.5))))
   ;; `(org-document-info ((,class (:foreground ,cyberpunk-blue-3 :background ,cyberpunk-black :weight bold))))
   ;; `(org-document-info-keyword ((,class (:foreground ,cyberpunk-gray-2 :background ,cyberpunk-black))))
   ;; `(org-agenda-date-today
   ;;   ((,class (:foreground ,cyberpunk-orange-2 :slant italic :weight bold))) t)
   ;; `(org-agenda-structure
   ;;   ((,class (:inherit font-lockcomment-face))))
   ;; `(org-archived ((,class (:slant italic))))
   ;; `(org-checkbox ((,class (:background ,cyberpunk-gray-2 :foreground ,cyberpunk-black
   ;;                                 :box (:line-width 1 :style released-button)))))
   ;; `(org-date ((,class (:foreground ,cyberpunk-blue-7 :underline t))))
   ;; `(org-done ((,class (:bold t :weight bold :foreground ,cyberpunk-green
   ;;                            :box (:line-width 1 :style none)))))
   ;; `(org-todo ((,class (:bold t :foreground ,cyberpunk-orange :weight bold
   ;;                            :box (:line-width 1 :style none)))))
   ;; `(org-level-1 ((,class (:foreground ,cyberpunk-pink-1 :height 1.3))))
   ;; `(org-level-2 ((,class (:foreground ,cyberpunk-yellow :height 1.2))))
   ;; `(org-level-3 ((,class (:foreground ,cyberpunk-blue-5 :height 1.1))))
   ;; `(org-level-4 ((,class (:foreground ,cyberpunk-green))))
   ;; `(org-level-5 ((,class (:foreground ,cyberpunk-orange))))
   ;; `(org-level-6 ((,class (:foreground ,cyberpunk-pink))))
   ;; `(org-level-7 ((,class (:foreground ,cyberpunk-green+3))))
   ;; `(org-level-8 ((,class (:foreground ,cyberpunk-blue-1))))
   ;; `(org-link ((,class (:foreground ,cyberpunk-blue-6 :underline t))))
   ;; `(org-tag ((,class (:bold t :weight bold))))
   ;; `(org-column ((,class (:background ,cyberpunk-yellow-3 :foreground ,cyberpunk-black))))
   ;; `(org-column-title ((,class (:background ,cyberpunk-bg-1 :underline t :weight bold))))
   ;; `(org-block ((,class (:foreground ,cyberpunk-fg :background ,cyberpunk-bg-05))))
   ;; `(org-block-begin-line 
   ;;   ((,class (:foreground "#008ED1" :background ,cyberpunk-bg-1))))
   ;; `(org-block-background ((,class (:background ,cyberpunk-bg-05))))
  ;; `(org-block-end-line 
   ;;   ((,class (:foreground "#008ED1" :background ,cyberpunk-bg-1))))

   ;; `(org-deadline-announce ((,class (:foreground ,cyberpunk-red-1))))
   ;; `(org-scheduled ((,class (:foreground ,cyberpunk-green+4))))
   ;; `(org-scheduled-previously ((,class (:foreground ,cyberpunk-red-4))))
   ;; `(org-scheduled-today ((,class (:foreground ,cyberpunk-blue+1))))
   ;; `(org-special-keyword ((,class (:foreground ,cyberpunk-yellow-1))))
   ;; `(org-table ((,class (:foreground ,cyberpunk-green+2))))
   ;; `(org-time-grid ((,class (:foreground ,cyberpunk-orange))))
   ;; `(org-upcoming-deadline ((,class (:inherit font-lock-keyword-face))))
   ;; `(org-warning ((,class (:bold t :foreground ,cyberpunk-red :weight bold :underline nil))))
   ;; `(org-formula ((,class (:foreground ,cyberpunk-yellow-2))))
   ;; `(org-headline-done ((,class (:foreground ,cyberpunk-green+3))))
   ;; `(org-hide ((,class (:foreground ,cyberpunk-bg-1))))
