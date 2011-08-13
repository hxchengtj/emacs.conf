;;; org-notmuch.el --- Support for links to notmuch messages from within Org-mode
;; Author: David Bremner <david@tethera.net>
;; License: GPL3+
;;; Commentary:

;; This file implements links to notmuch messages from within Org-mode.
;; Link types supported include 
;; - notmuch:id:message-id
;; - notmuch:show:search-terms
;; - notmuch:search:search-terms
;;
;; The latter two pass the search terms to the corresponding notmuch-*
;; function.  'id:' is an abbreviation for 'show:id:' search-terms is
;; a space delimited list of notmuch search-terms.
;;
;; Currently storing links is supported in notmuch-search and
;; notmuch-show mode.  It might make sense to support notmuch-folder
;; mode too.  Because threads-ids are currently not save/restore safe,
;; they are converted into a list of message-ids.
;;
;; Org-mode loads this module by default - if this is not what you want,
;; configure the variable `org-modules'.
;;; Code:

;; Install the link type
(org-add-link-type "notmuch" 'org-notmuch-open)
(add-hook 'org-store-link-functions 'org-notmuch-store-link)

;; Implementation
(defun org-notmuch-store-link ()
  "Store a link to the currently selected thread."
  (require 'notmuch)
  (when (memq major-mode '(notmuch-show-mode notmuch-search-mode))
    (if (equal major-mode 'notmuch-search-mode)
	(org-notmuch-do-store-link 
	 (org-notmuch-build-thread-link)
	 (notmuch-search-find-authors)
	 (notmuch-search-find-subject))
      (let* ((headers (notmuch-show-get-header))
	     (fpair (assoc 'from headers))
	     (spair (assoc 'subject headers)))
	(org-notmuch-do-store-link  (notmuch-show-get-message-id)
				    (if fpair (cdr fpair) nil)
				    (if spair (cdr spair) nil))))))

(defun org-notmuch-build-thread-link ()
  "Expand the thread-id on the current line to a list of message-ids"
  (require 'notmuch-query)
  (let* ((current-thread (or (notmuch-search-find-thread-id) 
			    (error "End of search results")))
	 (message-ids (notmuch-query-get-message-ids current-thread)))
    (concat "show:" 
	    (mapconcat (lambda (id) (concat "id:" id)) message-ids " "))))

(defun org-notmuch-do-store-link (id author subject)
  (let ((link  (org-make-link "notmuch:" id)))
    (org-store-link-props :type "notmuch" :from author :subject subject)
    (org-add-link-props :link link :description (org-email-link-description))
    link))


(defun org-notmuch-open (link)
  "Open a link with notmuch. id: or threadof: links are opened directly with notmuch-show
otherwise notmuch-search is used to give an index view"
  (require 'notmuch)
  (cond 
   ((string-match "^show:\\(.*\\)" link)
    (notmuch-show (match-string 1 link)))
   ((string-match "^search:\\(.*\\)" link)
    (notmuch-search (match-string 1 link)))
   ((string-match "^id:.*" link)
    (notmuch-show link))
   (t (notmuch-search link))))

    
(provide 'org-notmuch)

