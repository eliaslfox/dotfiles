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

;;; Misc

(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(fset 'yes-or-no-p 'y-or-n-p)

(setq sentence-end-double-space nil)
