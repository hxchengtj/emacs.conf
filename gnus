(setq gnus-select-method '(nnimap "gmail"
                                  (nnimap-authinfo-file "~/.authinfo.gpg")
				  (nnimap-address "imap.gmail.com")
				  (nnimap-server-port 993)
				  (nnimap-stream ssl)))

(gnus-demon-add-handler 'gnus-group-get-new-news 10 t)
(gnus-demon-init)

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.gmail.com" 465 nil nil))
      smtpmail-auth-credentials '(nnimap-authinfo-file "~/.authinfo.gpg")
      ;; '(("smtp.gmail.com" 465 "antonio.fabio@gmail.com" nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 465
                                        ;     smtpmail-debug-verb t
                                        ;     smtpmail-debug-info t
      smtpmail-local-domain nil
      smtpmail-stream-type 'ssl)
(setq user-mail-address "antonio.fabio@gmail.com")
(setq user-full-name "Antonio, Fabio Di Narzo")

(add-to-list 'load-path "~/.emacs.d/bbdb")
(require 'bbdb-autoloads)
(require 'bbdb)
;; (load "bbdb-com" t)
(bbdb-initialize 'gnus 'message)
;; (bbdb-insinuate-reportmail)
(bbdb-insinuate-message)
;; (bbdb-insinuate-sc)
;; (bbdb-insinuate-w3)
(setq bbdb-north-american-phone-numbers nil)
(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
(setq bbdb-auto-notes-alist
      (quote (("To"
               ("w3o" . "w3o")
               ("plug" . "plug")
               ("linux" . "linux")
               ))))
(setq bbdb-auto-notes-ignore (quote (("Organization" . "^Gatewayed from\\\\|^Source only"))))
(setq bbdb-auto-notes-ignore-all nil)
(setq bbdb-check-zip-codes-p nil)
(setq bbdb-default-area-code 632)
(setq bbdb-default-country "US")
;; (setq bbdb-ignore-some-messages-alist (quote (("From" . "hotmail") ("To" . "handhelds") ("From" . "yahoo.com"))))
(setq bbdb-notice-hook (quote (bbdb-auto-notes-hook)))
(setq bbdb/mail-auto-create-p t)
(setq bbdb/news-auto-create-p (quote bbdb-ignore-some-messages-hook))
