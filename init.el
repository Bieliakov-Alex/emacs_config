;;; init.el --- Summary
;;; Commentary:
;;; Code:
(package-initialize)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/" ) t)
(package-initialize)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(require 'bind-key)

(require 'org)
(org-babel-load-file (expand-file-name "~/.emacs.d/settings.org"))
(provide 'init)
;;; init.el ends here
