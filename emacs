;;
;; fonts etc.
;;
(global-font-lock-mode t)
(setq tab-width 2)
;; (add-to-list 'default-frame-alist '(font . "Lucida Console-12"))
(add-to-list 'default-frame-alist '(font . "Terminus-12"))
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(global-linum-mode t)
(column-number-mode t)
(setq-default fill-column 80)
(setq split-height-threshold nil)
;(setq split-width-threshold nil)
(setq inhibit-startup-screen t)

(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/color-theme")
(require 'color-theme)
;; (load "~/.emacs.d/zenburn.el")
;; (color-theme-zenburn)
(load "~/.emacs.d/color-theme-almost-monokai.el")
(color-theme-almost-monokai)

(show-paren-mode 1)
(setq show-paren-delay 0)

;; disable backup
(setq make-backup-files nil)
(setq backup-inhibited t)
;; disable auto save
(setq auto-save-default nil)

;; ssh
(require 'ssh)

;;
;; IDO mode
;;
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)
(delete-selection-mode 0)
(setq x-select-enable-clipboard t)
(setq vc-handled-backends nil)

(server-start)
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)

(global-set-key (kbd "<f12>") ; make F12 switch to .emacs; create if needed
		(lambda()(interactive)(find-file "~/.emacs")))
(global-set-key (kbd "<f11>") ; make F11 switch to gtd.org
		(lambda()(interactive)(find-file "~/GTD/gtd.org")))

;; FlySpell mode
(ispell-change-dictionary "en_GB")
(setq ispell-program-name "aspell")

(require 'printing)
(pr-update-menus t)

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; ESS
(add-to-list 'load-path "~/.emacs.d/ess/lisp")
(require 'ess-site)
(require 'ess-R-object-tooltip)
(custom-set-faces
 `(tooltip ((t (:background "#1A1A1A" :foreground "#F8F8F2" :foundry "fixed")))))

;; AUCTEX
(add-to-list 'load-path "/usr/share/emacs23/site-lisp")
(load "auctex.el" nil t t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'turn-on-auto-fill)
(load "preview-latex.el" nil t t)
(setq reftex-plug-into-AUCTeX t)
(require 'reftex)
(autoload 'reftex-mode "reftex" "RefTeX Minor Mode" t)
(autoload 'turn-on-reftex "reftex" "RefTeX Minor Mode" t)
(autoload 'reftex-citation "reftex-cite" "Make citation" t)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex) ;; with AucTeX
(add-hook 'LaTeX-mode-hook 'turn-on-flyspell)
(setq TeX-output-view-style
      (quote
       (("^dvi$" ("^landscape$" "^pstricks$\\|^pst-\\|^psfrag$") "%(o?)dvips -t landscape %d -o && gv %f")
	("^dvi$" "^pstricks$\\|^pst-\\|^psfrag$" "%(o?)dvips %d -o && gv %f")
	("^dvi$" ("^\\(?:a4\\(?:dutch\\|paper\\|wide\\)\\|sem-a4\\)$" "^landscape$") "%(o?)xdvi %dS -paper a4r -s 0 %d")
	("^dvi$" "^\\(?:a4\\(?:dutch\\|paper\\|wide\\)\\|sem-a4\\)$" "%(o?)xdvi %dS -paper a4 %d")
	("^dvi$" ("^\\(?:a5\\(?:comb\\|paper\\)\\)$" "^landscape$") "%(o?)xdvi %dS -paper a5r -s 0 %d")
	("^dvi$" "^\\(?:a5\\(?:comb\\|paper\\)\\)$" "%(o?)xdvi %dS -paper a5 %d")
	("^dvi$" "^b5paper$" "%(o?)xdvi %dS -paper b5 %d")
	("^dvi$" "^letterpaper$" "%(o?)xdvi %dS -paper us %d")
	("^dvi$" "^legalpaper$" "%(o?)xdvi %dS -paper legal %d")
	("^dvi$" "^executivepaper$" "%(o?)xdvi %dS -paper 7.25x10.5in %d")
	("^dvi$" "." "%(o?)xdvi %dS %d")
	("^pdf$" "." "evince %o %(outpage)")
	("^html?$" "." "netscape %o"))))
(setq preview-default-document-pt 12)
(setq preview-scale-function 1.5)

;;
;; org mode
;;
(add-to-list 'load-path "~/.emacs.d/org/lisp")
(add-to-list 'load-path "~/.emacs.d/org/contrib/lisp")
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(setq org-agenda-files (list "~/GTD/gtd.org" "~/GTD/journal.org"))
(setq org-cycle-include-plain-lists t)
(setq org-use-fast-todo-selection t)
(setq org-use-tag-inheritance nil)
(add-hook 'org-mode-hook 'turn-on-auto-fill)
(setq org-link-abbrev-alist
      '(("PMID" . "http://www.ncbi.nlm.nih.gov/pubmed/")
	("DOI" . "http://dx.doi.org/")))
(global-set-key (kbd "\C-ca") 'org-agenda)
(global-set-key (kbd "\C-cl") 'org-store-link)
(global-set-key "\C-cb" 'org-iswitchb)
(require 'org-latex)
(unless (boundp 'org-export-latex-classes)
  (setq org-export-latex-classes nil))
(add-to-list 'org-export-latex-classes
             '("article"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; send emails
(setq send-mail-function 'smtpmail-send-it
      message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials
      '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials
      (expand-file-name "~/.authinfo")
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-debug-info t
      starttls-extra-arguments nil
      smtpmail-warn-about-unknown-extensions t
      starttls-use-gnutls nil)
(setq smtpmail-debug-verb t)
(require 'smtpmail)
(setq user-mail-address "antonio.fabio@gmail.com")
(setq user-full-name "Antonio, Fabio Di Narzo")

;; bbdb
(add-to-list 'load-path "~/.emacs.d/bbdb")
(require 'bbdb)

;; notmuch
(add-to-list 'load-path "~/.emacs.d/notmuch")
(setq notmuch-search-authors-width 40)
(setq notmuch-search-oldest-first nil)
;(setq notmuch-command "/export/users/ubuntu/local/bin/notmuch")
(require 'notmuch)
(require 'org-notmuch)

;; ASCII editing utilities
(autoload 'ascii-on        "ascii" "Turn on ASCII code display."   t)
(autoload 'ascii-off       "ascii" "Turn off ASCII code display."  t)
(autoload 'ascii-display   "ascii" "Toggle ASCII code display."    t)
(autoload 'ascii-customize "ascii" "Customize ASCII code display." t)
(setq ascii-show-nonascii-message "non-ascii!!")

(autoload 'word-count-mode "word-count" "Minor mode to count words." t nil)

(defun count-words-region (beginning end)
  "Print number of words in the region.
Words are defined as at least one word-constituent
character followed by at least one character that
is not a word-constituent.  The buffer's syntax
table determines which characters these are."
  (interactive "r")
  (message "Counting words in region ... ")

;;; 1. Set up appropriate conditions.
  (save-excursion
    (goto-char beginning)
    (let ((count 0))

;;; 2. Run the while loop.
      (while (< (point) end)
        (re-search-forward "\\w+\\W*")
        (setq count (1+ count)))

;;; 3. Send a message to the user.
      (cond ((zerop count)
             (message
              "The region does NOT have any words."))
            ((= 1 count)
             (message
              "The region has 1 word."))
            (t
             (message
              "The region has %d words." count))))))

(defun fullscreen ()
  "Fullscreen."
  (interactive)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                         ;; if first parameter is '1', can't toggle fullscreen status
                         '(1 "_NET_WM_STATE_FULLSCREEN" 0)))

(defun fullscreen-toggle ()
  "Toggle fullscreen status."
  (interactive)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                         ;; if first parameter is '2', can toggle fullscreen status
                         '(2 "_NET_WM_STATE_FULLSCREEN" 0)))
(global-set-key (kbd "<f10>") (lambda () (interactive) (fullscreen-toggle)))

(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))

(defun big-margin-toggle ()
  (interactive)
  (cond
   ((= left-margin-width 0)
    (setq left-margin-width 40)
    (setq right-margin-width 40))
   (t
    (setq left-margin-width 0)
    (setq right-margin-width 0)))
  (set-window-margins (selected-window)
		      left-margin-width
		      right-margin-width))
(global-set-key (kbd "<f9>") (lambda () (interactive) (big-margin-toggle)))

;;
;; OCaml
;;
(add-to-list 'load-path "~/.emacs.d/tuareg-2.0.4")
(add-to-list 'auto-mode-alist '("\\.ml[iylp]?" . tuareg-mode))
(autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
(autoload 'camldebug "camldebug" "Run the Caml debugger" t)

;;
;; C++ and C mode...
;;

;; eldoc
(setq c-eldoc-includes "`gsl-config --cflags` -I/export/users/ubuntu/local/include -I/export/users/ubuntu/local/src/MCMCBenchmarks/include")
(load "c-eldoc")

;; flymake
(defun my-flymake-show-help ()
  (when (get-char-property (point) 'flymake-overlay)
    (let ((help (get-char-property (point) 'help-echo)))
      (if help (message "%s" help)))))
(add-hook 'post-command-hook 'my-flymake-show-help)

(defun my-c++-mode-hook ()
  (auto-fill-mode))
(defun my-c-mode-hook ()
  (flymake-mode 1)
  (auto-fill-mode)
  (c-turn-on-eldoc-mode))
(add-hook 'c++-mode-hook 'my-c++-mode-hook)
(add-hook 'c-mode-hook 'my-c-mode-hook)
(global-set-key (kbd "M-s") (lambda () (interactive) (flymake-display-err-menu-for-current-line)))

;; html
(require 'hl-tags-mode)
(add-hook 'sgml-mode-hook (lambda () (hl-tags-mode 1)))
(add-hook 'nxml-mode-hook (lambda () (hl-tags-mode 1)))

;;
;; project-root
;;
(add-to-list 'load-path "~/.emacs.d/project-root")
(require 'project-root)
(require 'full-ack)
(setq ack-executable (executable-find "ack-grep"))
(global-set-key (kbd "M-f") 'project-root-find-file)
(global-set-key (kbd "M-g") 'project-root-ack)
(global-set-key (kbd "M-d") 'project-root-goto-root)
(global-set-key (kbd "C-c p p") 'project-root-run-default-command)
(global-set-key (kbd "M-l") 'project-root-browse-seen-projects)

(setq project-roots
      `(("Play Project"
         :root-contains-files ("app" "conf" ".git")
         :filename-regex ,(concat (regexify-ext-list '(java html xml txt conf yml css R js)) "\\|.*conf/.*")
	 :exclude-paths ("tmp")
         :on-hit (lambda (p) (message (car p))))))
