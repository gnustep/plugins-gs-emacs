;; Copyright (C) 2014, 2015 Germán A. Arias

;; This file is part of gs-emacs package

;; This application is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public
;; License as published by the Free Software Foundation; either
;; version 3 of the License, or (at your option) any later version.
 
;; This application is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; Library General Public License for more details.
 
;; You should have received a copy of the GNU General Public
;; License along with this library; if not, write to the Free
;; Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.

;; Menu for GNUstep development environment.
(require 'easymenu)

;; Get the path of gs-emacs resources.
(defconst gnustep-resources-dir (file-name-directory load-file-name)
  "Directory containing GNUstep's resource files.")

;; Add the path of GNUstep script, if necessary. For example:
;;(defconst gs-script ". /usr/GNUstep/System/Library/Makefiles/GNUstep.sh;")
;; If not, leave this empty.
(defconst gs-script "")

;; Add the table for auto-completion.
(setq tags-file-name (expand-file-name "TAGS" gnustep-resources-dir))

;; Define a handler to open gorm/nib/xib files.
(defun gorm-file-handler (operation &rest args)
  (cond ((eq operation 'load)
	 (shell-command (concat gs-script "gopen " (nth 0 args)))
	 (message "Open a gorm file")
	 (run-at-time "4 sec" nil 'close-buffer
		      (file-name-nondirectory (nth 0 args))))
	;; Handle any operation we don't know about.
	(t (let ((inhibit-file-name-handlers
		  (cons 'gorm-file-handler
			(and (eq inhibit-file-name-operation operation)
			     inhibit-file-name-handlers)))
		 (inhibit-file-name-operation operation))
	     (apply operation args)))))

;; Close buffer of gorm/nib/xib file after load it.
(defun close-buffer (name) (kill-buffer name))

;; Add handlers.
(add-to-list 'file-name-handler-alist
	     (cons ".gorm\\'" 'gorm-file-handler))
(add-to-list 'file-name-handler-alist
	     (cons ".nib\\'" 'gorm-file-handler))
(add-to-list 'file-name-handler-alist
	     (cons ".xib\\'" 'gorm-file-handler))

;; Make a simple app project.
(defun make-app ()
  (interactive)
  (setq dir (read-file-name "Create App Project: "
			    default-directory
			    default-directory
			    nil
			    nil))
  (setq dir (expand-file-name dir))
  (setq gsapp (expand-file-name "Resources/App" gnustep-resources-dir))
  (copy-directory gsapp
		  dir nil nil t)
  ;; Rename the interface file
  (rename-file (expand-file-name "Resources/interface.gorm" dir)
	       (expand-file-name (concat "Resources/" (file-name-base dir)
					 ".gorm")
				 dir) 1)
  ;; Rename the Info.plist file
  (rename-file (expand-file-name "Info.plist" dir)
	       (expand-file-name (concat (file-name-base dir) "Info.plist")
				 dir) 1)
  (dired dir)

  (setq file (expand-file-name (concat (file-name-base dir) "Info.plist") dir))
  (find-file-other-window file)
  (goto-char (point-min))
  (replace-string "[APP_NAME]" (file-name-base dir))
  (save-buffer)

  (setq file (expand-file-name "GNUmakefile" dir))
  ;;(find-file-other-window file)
  (find-file file)
  (goto-char (point-min))
  (replace-string "[APP_NAME]" (file-name-base dir))
  (save-buffer))

;; Make a simple tool project.
(defun make-tool ()
  (interactive)
  (setq dir (read-file-name "Create Tool Project: "
			    default-directory
			    default-directory
			    nil
			    nil))
  (setq dir (expand-file-name dir))
  (setq gsapp (expand-file-name "Resources/Tool" gnustep-resources-dir))
  (copy-directory gsapp
		  dir nil nil t)
  (dired dir)
  (setq file (expand-file-name "GNUmakefile" dir))
  (find-file-other-window file)
  (goto-char (point-min))
  (replace-string "[TOOL_NAME]" (file-name-base dir))
  (save-buffer))

;; Replace foreign characters.
(defun replace-foreign-characters ()
  (interactive)
  (goto-char (point-min))
  (replace-string "Á" "\\U00C1")
  (goto-char (point-min))
  (replace-string "É" "\\U00C9")
  (goto-char (point-min))
  (replace-string "Í" "\\U00CD")
  (goto-char (point-min))
  (replace-string "Ó" "\\U00D3")
  (goto-char (point-min))
  (replace-string "Ú" "\\U00DA")
  (goto-char (point-min))
  (replace-string "á" "\\U00E1")
  (goto-char (point-min))
  (replace-string "é" "\\U00E9")
  (goto-char (point-min))
  (replace-string "í" "\\U00ED")
  (goto-char (point-min))
  (replace-string "ó" "\\U00F3")
  (goto-char (point-min))
  (replace-string "ú" "\\U00FA")
  (goto-char (point-min))
  (replace-string "Ü" "\\U00DC")
  (goto-char (point-min))
  (replace-string "ü" "\\U00FC")
  (goto-char (point-min))
  (replace-string "¡" "\\U00A1")
  (goto-char (point-min))
  (replace-string "¿" "\\U00BF")
  (goto-char (point-min))
  (replace-string "Ñ" "\\U00D1")
  (goto-char (point-min))
  (replace-string "ñ" "\\U00F1")
  (goto-char (point-min))
  (replace-string "Ä" "\\U00C4")
  (goto-char (point-min))
  (replace-string "Ö" "\\U00D6")
  (goto-char (point-min))
  (replace-string "ß" "\\U00DF")
  (goto-char (point-min))
  (replace-string "ä" "\\U00E4")
  (goto-char (point-min))
  (replace-string "ö" "\\U00F6")
  (goto-char (point-min))
  (replace-string "Ç" "\\U00C7")
  (goto-char (point-min))
  (replace-string "ç" "\\U00E7")
  (goto-char (point-min))
  (replace-string "Ë" "\\U00CB")
  (goto-char (point-min))
  (replace-string "Ï" "\\U00CF")
  (goto-char (point-min))
  (replace-string "ë" "\\U00EB")
  (goto-char (point-min))
  (replace-string "ï" "\\U00EF")
  )

;; Define the gs-emacs menu.
(easy-menu-define gnustep-menu global-map
  "Menu for GNUstep development environment."
  '("GNUstep"
    ;;:visible (string= "objc-mode" major-mode)
    ["App Project..." (make-app)
     :enable (menu-bar-non-minibuffer-window-p)]
    ["Tool Project..." (make-tool)
     :enable (menu-bar-non-minibuffer-window-p)]
    ["--" 'ignore]
    ["Replace foreign characters" (replace-foreign-characters)]))
