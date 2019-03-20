
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
