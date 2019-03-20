(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/" ) t)
(package-initialize)

(require 'use-package)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
;(toggle-frame-maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq inhibit-splash-screen t)
(setq make-backup-files nil)
(global-linum-mode 1)
(defalias 'yes-or-no-p 'y-or-n-p)
(display-time-mode 1)
(display-battery-mode 1)
(setq column-number-mode t)
(global-hl-line-mode 1)
(electric-pair-mode 1)
(show-paren-mode 1)
(custom-set-faces  '(show-paren-match ((t (:underline "green")))))
(savehist-mode 1)
(global-auto-revert-mode 1)
(global-visual-line-mode 1)
(desktop-save-mode 1)

(ido-mode 1)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
(setq ido-create-new-buffer 'always)
(setq ido-file-extension-order '(".org" ".txt" ".csv"))

(winner-mode 1)

(add-hook 'prog-mode-hook (lambda () (hs-minor-mode 1)))
(global-set-key (kbd "C-c @ @") 'hs-hide-all)
(global-set-key (kbd "C-c @ h") 'hs-hide-block)
(global-set-key (kbd "C-c @ s") 'hs-show-block)
(global-set-key (kbd "C-c @ SPC") 'hs-show-all)

(use-package dracula-theme
:ensure t)

(ido-grid-mode 1)

(use-package cycle-themes
:ensure t
:init 
(setq cycle-themes-theme-list '(dracula exotica))
:config
(cycle-themes-mode))

(use-package org-bullets
:ensure t
:init
(add-hook 'org-mode-hook (lambda() (org-bullets-mode 1))))

(use-package counsel
:ensure t)
(use-package ivy
:ensure t
:init
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
:bind
(
("\C-s" . swiper)
("C-c C-r" . ivy-resume)
("<f6>" . ivy-resume)
("M-x" . counsel-M-x)
;(global-set-key (kbd "C-x C-f") 'counsel-find-file) ;;; keep IDO mode for find file
("C-y" . counsel-yank-pop)
("<f1> f" . counsel-describe-function)
("<f1> v" . counsel-describe-variable)
("<f1> l" . counsel-find-library)
("<f2> i" . counsel-info-lookup-symbol)
("<f2> u" . counsel-unicode-char)
("C-c g" . counsel-git)
("C-c j" . counsel-git-grep)
("C-c k" . counsel-ag)
("C-x l" . counsel-locate)
("C-S-o" . counsel-rhythmbox)
:map minibuffer-local-map
("C-r" . counsel-minibuffer-history))
)

(use-package magit
:ensure t
:bind
("C-x g" . magit-status)
)

(use-package iedit
:ensure t)

(use-package paredit
:ensure t
:init
(paredit-mode 1)
:hook
(c++-mode . enable-paredit-mode)
:bind
("C-<left>" . paredit-forward-slurp-sexp)
("C-M-<left>" . paredit-backward-slurp-sexp)
("C-<right>" . paredit-forward-barf-sexp)
("C-M-<right>" . paredit-backward-barf-sexp)
("M-S" . paredit-split-sexp)
("M-J" . paredit-join-sexp)
)

(use-package irony
:ensure t
:hook
(
(c++-mode . irony-mode)
(c-mode . irony-mode)
(irony . irony-cdb-autosetup-compile-options)
))

(use-package company
:ensure t
:hook
(after-init . global-company-mode)
:config
(global-company-mode t)
(setq company-minimum-prefix-length 1)
(setq company-idle-delay 0)
)

(use-package company-quickhelp
:ensure t
:init
(company-quickhelp-mode 1)
:config
(setq company-quickhelp-delay 0)
)

(use-package company-irony
:ensure t
:after company
:init
(add-to-list 'company-backends 'company-irony))

(use-package company-irony-c-headers
:ensure t
:after company
:init
(add-to-list
'company-backends '(company-irony-c-headers company-irony)))

(use-package yasnippet
:ensure t
:init
(yas-global-mode 1)
(defun check-expansion ()
    (save-excursion
      (if (looking-at "\\_>") t
        (backward-char 1)
        (if (looking-at "\\.") t
          (backward-char 1)
          (if (looking-at "->") t nil)))))

  (defun do-yas-expand ()
    (let ((yas/fallback-behavior 'return-nil))
      (yas/expand)))

  (defun tab-indent-or-complete ()
    (interactive)
    (if (minibufferp)
        (minibuffer-complete)
      (if (or (not yas/minor-mode)
              (null (do-yas-expand)))
          (if (check-expansion)
              (company-complete-common)
            (indent-for-tab-command)))))
:bind
  ([tab] . tab-indent-or-complete)
)

(use-package ivy-yasnippet
:ensure t
:init
(add-hook 'yas-minor-mode 'ivy-snippet)
:bind
("M-z" . ivy-yasnippet)
)

(use-package highlight-indent-guides
:ensure t
:hook
(c++-mode . highlight-indent-guides-mode)
:init
(setq highlight-indent-guides-method 'character)
)

(global-set-key (kbd "C-?") 'hippie-expand)
(global-set-key (kbd "M-D") 'backward-kill-word )
(global-set-key (kbd "DEL") 'backward-delete-char)
(global-set-key (kbd "C-z") 'replace-string)
(global-set-key (kbd "C-M-z")'replace-regex)
(global-set-key (kbd "C-Z")'count-matches)

(load-theme 'dracula t)
