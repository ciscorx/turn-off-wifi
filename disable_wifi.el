;; This script should be invoked using the following command line statement: emacs -Q -l disable_wifi.el
;; This is for a typical at&t u-verse router.

(load-file "w3m-auto-fill.el")


(defun ciscorx/login_wifi ()
  (interactive)
  (w3m-browse-url "http://192.168.1.254/xslt?PAGE=C_2_1c")
  (sleep-for 7)
  (goto-char (point-min))
;  (while (not (looking-at "Location"))
 ; (sleep-for 3)
					;  )
  
  (if (re-search-forward "Device access code required." nil t)
      (progn
	(goto-char (point-min))
	(sleep-for 2)
	(w3m-next-anchor 5)  ;; goto password field
	(sleep-for 7)
	(w3m-view-this-url)  ;; submit password 
	(sleep-for 7)
	(w3m-next-anchor 1)  ;; goto submit button
	(sleep-for 4)
	(w3m-view-this-url)  ;; submit password for login
	)
    (goto-char (point-min))
    )
  )
 
(defun ciscorx/goto-nex (arg)
  "Jumps to the nth next w3m anchor"
  (interactive "P")
  (push-mark)
  (w3m-next-anchor arg) 
)


(defun ciscorx/disable_wifi_simple ()
  (interactive)
  (cancel-timer ciscorx/runobj)
  (if (re-search-forward "2.4 GHz Wi-Fi Radio Configuration" nil t)
      (progn
	(sleep-for 15)
	(goto-char (point-min))
	(sleep-for 2)
	(w3m-next-anchor 17) 
	(sleep-for 4)
	(setq w3m-selval "DISABLE")  ;; wifi0 config
	(sleep-for 2)
	(w3m-view-this-url)
	
	(sleep-for 8)
	(w3m-next-anchor 7) 
;  (goto-char 1206)            ;; wifi0 network
	(sleep-for 2)
	(setq w3m-selval "DISABLE")
	(sleep-for 1)
	(w3m-view-this-url)

	(sleep-for 6)
	(goto-char (point-max))
	(w3m-next-anchor -2)
	(sleep-for 2)
	(w3m-view-this-url)
	)
    (goto-char (point-min))
    )
  (sleep-for 20)
  (save-buffers-kill-terminal)
  )


(defun ciscorx/enable_wifi_simple ()
  (interactive)
  (cancel-timer ciscorx/runobj)
  (if (re-search-forward "2.4 GHz Wi-Fi Radio Configuration" nil t)
      (progn
	(sleep-for 15)
	(goto-char (point-min))
	(sleep-for 2)
	(w3m-next-anchor 17) 
	(sleep-for 2)
	(setq w3m-selval "ENABLE")  ;; wifi0 config
	(sleep-for 1)
	(w3m-view-this-url)
	
	(sleep-for 8)
	(w3m-next-anchor 7) 
;  (goto-char 1206)            ;; wifi0 network
	(sleep-for 2)
	(setq w3m-selval "ENABLE")
	(sleep-for 1)
	(w3m-view-this-url)       
	(sleep-for 4)
	(goto-char (point-max))
	(w3m-next-anchor -2)
	(sleep-for 2)
	(w3m-view-this-url)
	)
    (goto-char (point-min))
    )
  (sleep-for 20)
  (save-buffers-kill-terminal)
  )


(defun ciscorx/dis_wifi ()
;  (w3m-cookie-clear)
  (setq ciscorx/runobj (run-with-idle-timer 20 1 #'ciscorx/disable_wifi_simple))
  (ciscorx/login_wifi))

(defun ciscorx/en_wifi ()
 ; (w3m-cookie-clear)
  (setq ciscorx/runobj (run-with-idle-timer 20 1 #'ciscorx/enable_wifi_simple))
  (ciscorx/login_wifi))


(ciscorx/dis_wifi)
