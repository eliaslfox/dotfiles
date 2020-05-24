(eval-when-compile
  (require 'use-package))

(package-initialize)

;;; Evil Mode
(setq evil-want-keybinding nil)
(use-package evil
    :config
    (evil-mode 1))
(use-package evil-collection
  :after evil)

;;; UI
(set-frame-font "Fira Code 14" nil t)

(toggle-scroll-bar -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(fringe-mode 0)

(setq x-underline-at-descent-line t)
(setq solarized-high-contrast-mode-line t)

(setq solarized-emphasize-indicators nil)
(setq solarized-use-variable-pitch nil)
(setq solarized-scale-org-headlines nil)

(setq solarized-height-minus-1 1)
(setq solarized-height-plus-1 1)
(setq solarized-height-plus-2 1)
(setq solarized-height-plus-3 1)
(setq solarized-height-plus-4 1)

(use-package solarized-theme
  :config (load-theme 'solarized-dark t))

;;; Org Mode
(use-package org)
(require 'org-mouse)

(setq org-log-done 'time) ;;; log the closing time of a todo item
(setq org-columsn-default-format "%25ITEM %TAGS %TODO %DEADLINE %SCHEDULED %CLOSED") ;; default column view format
(setq org-archive-save-context-info '()) ;;; skip adding context info when archiving
(setq org-archive-location "~/Documents/org/archive.org::* From %s") ;;; archive to a single file

(setq org-file-apps '(
    ("\.mkv" . "mpv %s")
    ("\.mp4" . "mpv %s")
    ("\.m4a" . "mpv %s")
    ("\.pdf" . "zathura %s")))

;;; Misc

(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(fset 'yes-or-no-p 'y-or-n-p)

(setq sentence-end-double-space nil)

(setq org-agenda-files '("~/Documents/org"))
