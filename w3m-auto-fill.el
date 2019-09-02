;; This is an ugly hack of emacs-w3m to enable auto filling of input select form entries and auto supplying passwords in order to automate web login and post submissions.  Unfortunately I cant figure out how to get emacs-w3m to do this in batch mode, but it seems to work ok from using the command line emacs -Q -l, whereas the loading file must call (save-buffers-kill-terminal) when finished.

;(shell-command "echo 'user_agent w3m/0.5.3' > ~/.w3m/config")  ;; You can find the user agent by excuting the shell command nc -l 9999 in one terminal and then the shell command w3m -header 'User:Agent: foo' http:localhost:9999 in another terminal.

(setq w3m-mail-user-agents '("w3m/0.5.3"))

(defconst w3m-default-face-colors
  (eval '(if (not (or (featurep 'xemacs)
		      (>= emacs-major-version 21)))
	     (let ((bg (face-background 'default))
		   (fg (face-foreground 'default)))
	       (append (if bg `(:background ,bg))
		       (if fg `(:foreground ,fg))))))
  "The initial `default' face color spec.  Since `defface' under Emacs
versions prior to 21 won't inherit the `dafault' face colors by default,
we will use this value for the default `defface' color spec.  Lifted from http://wal.sh/code/elisp/trunk/medew/site-lisp/w3m/w3m-util.el")

(defcustom w3m-use-japanese-menu nil "dont use this")

(load-file "~/.emacs.d/pp.el")  ;; pretty print, found at https://github.com/typester/emacs/blob/master/lisp/emacs-lisp/pp.el

;; many of these are not actually required
(add-to-list 'load-path "~/.emacs.d/emacs-w3m")
;(add-to-list 'load-path "~/.emacs.d/apel-10.8/")
(load-file "~/.emacs.d/emacs-w3m/w3m-util.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-ccl.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-proc.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-image.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-favicon.el")
;(load-file "~/.emacs.d/emacs-w3m/w3m-ems.el")
(load-file "~/.emacs.d/emacs-w3m/bookmark-w3m.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-fb.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-hist.el")
;(load-file "~/.emacs.d/emacs-w3m/w3m.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-tabmenu.el")

(load-file "~/.emacs.d/emacs-w3m/w3m-rss.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-antenna.el")

(load-file "~/.emacs.d/emacs-w3m/w3m-bookmark.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-bug.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-cookie.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-dtree.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-filter.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-form.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-form_emacs25.el")
(load-file "~/.emacs.d/emacs-w3m/w3mhack.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-lnum.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-load.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-mail.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-namazu.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-perldoc.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-save.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-search.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-session.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-symbol.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-tabmenu.el")
(load-file "~/.emacs.d/emacs-w3m/w3m-weather.el")

(load-file "~/.emacs.d/emacs-w3m/octet.el")
;(load-file "~/.emacs.d/mime_stuff/mime-def.el")
;(load-file "~/.emacs.d/mime_stuff/mime-parse.el")
(load-file "~/.emacs.d/emacs-w3m/mime-w3m.el")

(load-file "~/.emacs.d/emacs-w3m/w3m.el")





(defcustom w3m-password "default"
  "or some other"
  :type 'string
  )
(setq w3m-password "default")

(defcustom w3m-selval "default"
  "or some other"
  :type 'string
  )


(defun w3m-form-input-password (form id name)
  (if (get-text-property (point) 'w3m-form-readonly)
      (message "This input box is read-only.")
    (let* ((fvalue (w3m-form-get form id))
	    ;; (input (save-excursion
	    ;; 	    (read-passwd (concat "PASSWORD"
	    ;; 				 (if fvalue
	    ;; 				     " (default is no change)")
	    ;; 				 ": ")
	    ;; 			 nil
	    ;;			 fvalue)))
	   )
      (setq input w3m-password)
      (w3m-form-put form id name input)
      (w3m-form-replace input 'invisible))))



(defun w3m-form-input-select (form id name)
  (if (get-text-property (point) 'w3m-form-readonly)
      (w3m-message "This form is currently inactive")
    (let* ((value (w3m-form-get form id))
	   (cur-win (selected-window))
	   (wincfg (current-window-configuration))
	   (urlid (format "%s:%s:%d" w3m-current-url name id))
	   (w3mbuffer (current-buffer))
	   (point (point))
	   (size (min
		  (- (window-height cur-win)
		     window-min-height 1)
		  (- (window-height cur-win)
		     (max window-min-height
			  (1+ w3m-form-input-select-buffer-lines)))))
	   buffer cur pos)
      (setq input (w3m-form-get form id))
      (setcar input w3m-selval)
      (w3m-form-put form id name input)
      (w3m-form-replace (cdr (assoc cur (cdr input))))
      (message (pp input))
      )  ; let ends
    )
  )

(defun w3m-form-input (form id name type width maxlength value)
  (let ((fvalue (w3m-form-get form id)))
    (if (get-text-property (point) 'w3m-form-readonly)
	(w3m-message "READONLY %s: %s" (upcase type) fvalue)
      (save-excursion
	(let (
               ;(input (save-excursion
	;	       (read-from-minibuffer (concat (upcase type) ": ") fvalue)))
	      input
	      (coding (w3m-form-get-coding-system (w3m-form-charlst form))))
;	  (setq input (w3m-form-get form id))
;	  (setcar input w3m-selval)
	  (setq input w3m-selval)
	  (when (with-temp-buffer
		  (insert input)
		  (w3m-form-coding-system-accept-region-p nil nil coding))
	    (w3m-form-put form id name input)
	    (w3m-form-replace input)
	    (message (pp input)))
	  )
	)
      )
    )
  )
