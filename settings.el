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
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline t)

(winner-mode 1)

(add-hook 'prog-mode-hook (lambda () (hs-minor-mode 1)))
(global-set-key (kbd "C-c @ @") 'hs-hide-all)
(global-set-key (kbd "C-c @ h") 'hs-hide-block)
(global-set-key (kbd "C-c @ s") 'hs-show-block)
(global-set-key (kbd "C-c @ SPC") 'hs-show-all)

(use-package dracula-theme
:ensure t)

(use-package helm
:ensure t
  :init
  (progn
    (require 'helm-config)
    (require 'helm-grep)
    ;; To fix error at compile:
    ;; Error (bytecomp): Forgot to expand macro with-helm-buffer in
    ;; (with-helm-buffer helm-echo-input-in-header-line)
    (if (version< "26.0.50" emacs-version)
        (eval-when-compile (require 'helm-lib)))

    (defun helm-hide-minibuffer-maybe ()
      (when (with-helm-buffer helm-echo-input-in-header-line)
        (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
          (overlay-put ov 'window (selected-window))
          (overlay-put ov 'face (let ((bg-color (face-background 'default nil)))
                                  `(:background ,bg-color :foreground ,bg-color)))
          (setq-local cursor-type nil))))

    (add-hook 'helm-minibuffer-set-up-hook 'helm-hide-minibuffer-maybe)
    ;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
    ;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
    ;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
    (global-set-key (kbd "C-c h") 'helm-command-prefix)
    (global-unset-key (kbd "C-x c"))

    (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebihnd tab to do persistent action
    (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
    (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

    (define-key helm-grep-mode-map (kbd "<return>")  'helm-grep-mode-jump-other-window)
    (define-key helm-grep-mode-map (kbd "n")  'helm-grep-mode-jump-other-window-forward)
    (define-key helm-grep-mode-map (kbd "p")  'helm-grep-mode-jump-other-window-backward)

    (when (executable-find "curl")
      (setq helm-google-suggest-use-curl-p t))

    (setq helm-google-suggest-use-curl-p t
          helm-scroll-amount 4 ; scroll 4 lines other window using M-<next>/M-<prior>
          ;; helm-quick-update t ; do not display invisible candidates
          helm-ff-search-library-in-sexp t ; search for library in `require' and `declare-function' sexp.

          ;; you can customize helm-do-grep to execute ack-grep
          ;; helm-grep-default-command "ack-grep -Hn --smart-case --no-group --no-color %e %p %f"
          ;; helm-grep-default-recurse-command "ack-grep -H --smart-case --no-group --no-color %e %p %f"
          helm-split-window-in-side-p t ;; open helm buffer inside current window, not occupy whole other window

          helm-echo-input-in-header-line t

          ;; helm-candidate-number-limit 500 ; limit the number of displayed canidates
          helm-ff-file-name-history-use-recentf t
          helm-move-to-line-cycle-in-source t ; move to end or beginning of source when reaching top or bottom of source.
          helm-buffer-skip-remote-checking t

          helm-mode-fuzzy-match t

          helm-buffers-fuzzy-matching t ; fuzzy matching buffer names when non-nil
                                        ; useful in helm-mini that lists buffers
          helm-org-headings-fontify t
          ;; helm-find-files-sort-directories t
          ;; ido-use-virtual-buffers t
          helm-semantic-fuzzy-match t
          helm-M-x-fuzzy-match t
          helm-imenu-fuzzy-match t
          helm-lisp-fuzzy-completion t
          ;; helm-apropos-fuzzy-match t
          helm-buffer-skip-remote-checking t
          helm-locate-fuzzy-match t
          helm-display-header-line nil)

    (add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)

    ;(global-set-key (kbd "M-x") 'helm-M-x)
    ;(global-set-key (kbd "M-y") 'helm-show-kill-ring)
    (global-set-key (kbd "C-x b") 'helm-buffers-list)
    (global-set-key (kbd "C-x C-f") 'helm-find-files)
    (global-set-key (kbd "C-c r") 'helm-recentf)
    (global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
    (global-set-key (kbd "C-c h o") 'helm-occur)
    (global-set-key (kbd "C-c h o") 'helm-occur)

    (global-set-key (kbd "C-c h w") 'helm-wikipedia-suggest)
    (global-set-key (kbd "C-c h g") 'helm-google-suggest)

    (global-set-key (kbd "C-c h x") 'helm-register)
    ;; (global-set-key (kbd "C-x r j") 'jump-to-register)

    (define-key 'help-command (kbd "C-f") 'helm-apropos)
    (define-key 'help-command (kbd "r") 'helm-info-emacs)
    (define-key 'help-command (kbd "C-l") 'helm-locate-library)

    ;; use helm to list eshell history
    (add-hook 'eshell-mode-hook
              #'(lambda ()
                  (define-key eshell-mode-map (kbd "M-l")  'helm-eshell-history)))

;;; Save current position to mark ring
    (add-hook 'helm-goto-line-before-hook 'helm-save-current-pos-to-mark-ring)

    ;; show minibuffer history with Helm
    (define-key minibuffer-local-map (kbd "M-p") 'helm-minibuffer-history)
    (define-key minibuffer-local-map (kbd "M-n") 'helm-minibuffer-history)

    (define-key global-map [remap find-tag] 'helm-etags-select)

    (define-key global-map [remap list-buffers] 'helm-buffers-list)

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; PACKAGE: helm-swoop                ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Locate the helm-swoop folder to your path
    (use-package helm-swoop
      :bind (("C-c h o" . helm-swoop)
             ("C-c s" . helm-multi-swoop-all))
      :config
      ;; When doing isearch, hand the word over to helm-swoop
      (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)

      ;; From helm-swoop to helm-multi-swoop-all
      (define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)

      ;; Save buffer when helm-multi-swoop-edit complete
      (setq helm-multi-swoop-edit-save t)

      ;; If this value is t, split window inside the current window
      (setq helm-swoop-split-with-multiple-windows t)

      ;; Split direcion. 'split-window-vertically or 'split-window-horizontally
      (setq helm-swoop-split-direction 'split-window-vertically)

      ;; If nil, you can slightly boost invoke speed in exchange for text color
      (setq helm-swoop-speed-or-color t))

    (helm-mode 1)

    (use-package helm-projectile
:ensure t
      :init
      (helm-projectile-on)
      (setq projectile-completion-system 'helm)
      (setq projectile-indexing-method 'alien))))

;(provide 'setup-helm)

;(helm-mode 1)

(use-package all-the-icons
:ensure t)
(use-package neotree
:ensure t
:bind
(([f8] . neotree-toggle)
)
:init
(setq neo-theme (if(display-graphic-p) 'icons 'arrow))
)

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

(use-package yasnippet-snippets
:ensure t)

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

(use-package flycheck
:ensure t
:init
(global-flycheck-mode)
)
(use-package flycheck-irony
:ensure t
:after flycheck
:init
(add-hook 'flycheck-mode-hook #'flycheck-irony-setup)
)

(use-package cmake-mode
:ensure t
:mode ("\\.cmake\\'"
"CMakeLists\\.txt\\'")
:config (use-package cmake-font-lock
:ensure t)
)

(use-package rtags
:ensure t
:init
  ;; make sure you have company-mode installed
(use-package company
:ensure t)
:bind(
:map c-mode-base-map
("M-." . rtags-find-symbol-at-point)
("M-," . rtags-find-references-at-point)
("<C-tab>" . company-complete)
)
:init
(rtags-enable-standard-keybindings)
(setq rtags-use-helm t)
(setq rtags-autostart-diagnostics t)
(rtags-diagnostics)
(setq rtags-completions-enabled t)
(push 'company-rtags company-backends)
(global-company-mode)
(use-package flycheck-rtags
:ensure t)
(add-hook 'c-mode-hook 'rtags-start-process-unless-running)
(add-hook 'c++-mode-hook 'rtags-start-process-unless-running))

(use-package clang-format
:ensure t
:bind(
("C-c i" . clang-format-region)
("C-c u" . clang-format-buffer)
))

(global-set-key (kbd "C-?") 'hippie-expand)
(global-set-key (kbd "M-D") 'backward-kill-word )
(global-set-key (kbd "DEL") 'backward-delete-char)
(global-set-key (kbd "C-z") 'replace-string)
(global-set-key (kbd "C-M-z")'replace-regex)
(global-set-key (kbd "C-Z")'count-matches)

(load-theme 'dracula t)
