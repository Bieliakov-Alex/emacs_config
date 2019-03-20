
(package-initialize)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/" ) t)
(package-initialize)

(require 'package)
  (setq package-archives '(("MELPA" . "http://melpa.org/packages/")
		   ("ELPA" . "http://tromey.com/elpa/")
		   ("gnu"  . "http://elpa.gnu.org/packages/"))
load-prefer-newer t
package-user-dir "~/.emacs.d/elpa"
package--init-file-ensured t
package-enable-at-startup nil)
  (unless (file-directory-p package-user-dir)
    (make-directory package-user-dir t))
  (package-initialize)


(require 'org)
(org-babel-load-file (expand-file-name "~/.emacs.d/settings.org"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("274fa62b00d732d093fc3f120aca1b31a6bb484492f31081c1814a858e25c72e" default)))
 '(package-selected-packages
   (quote
    (highlight-indent-guides ivy-yasnippet yasnippet company-irony-c-headers company-irony company-quickhelp company irony paredit iedit magit counsel org-bullets cycle-themes dracula-theme use-package ido-grid-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(show-paren-match ((t (:underline "green")))))
