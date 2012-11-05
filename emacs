;;
;; fonts etc.
;;
(global-font-lock-mode t)
(setq tab-width 2)
(if window-system
    (if (<= (x-display-pixel-height) 800)
	;; (add-to-list 'default-frame-alist '(font . "Terminus-12")) ;; small screen!
	(add-to-list 'default-frame-alist '(font . "Monospace-14")) ;; small screen!
      (add-to-list 'default-frame-alist '(font . "Monospace-14"))))
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(column-number-mode t)
(setq-default fill-column 80)
(global-visual-line-mode 1)
(setq split-height-threshold nil)
;(setq split-width-threshold nil)
(setq inhibit-startup-screen t)
(delete-selection-mode 0)
(setq x-select-enable-clipboard t)
(setq vc-handled-backends nil)
(fset 'yes-or-no-p 'y-or-n-p)
(setq confirm-nonexistent-file-or-buffer nil)

(define-key function-key-map [C-kp-home] [?\M-<])
(define-key function-key-map [C-kp-end] [?\M->])

;; don't ask if I really want to kill a buffer with attached running process
(setq kill-buffer-query-functions
      (remq 'process-kill-buffer-query-function
	    kill-buffer-query-functions))

(setq set-mark-command-repeat-pop t)

(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/color-theme")
(require 'color-theme)
(if window-system
    (progn
      (load "~/.emacs.d/color-theme-almost-monokai.el")
      (color-theme-almost-monokai)
      (setq ansi-color-names-vector ["#1A1A1A" "red" "#A6E22A" "CadetBlue" "#66D9EF" "#F1266F" "#DFD874" "#75715D"])
      (setq ansi-term-color-vector [unspecified "#1A1A1A" "red" "#A6E22A" "CadetBlue" "#66D9EF" "#F1266F" "#DFD874" "#75715D"]))
  (progn
    (load "~/.emacs.d/zenburn.el")
    (color-theme-zenburn)))

(show-paren-mode 1)
(setq show-paren-delay 0)
(global-set-key (kbd "C-c TAB") 'completion-at-point)
(defun linum-mode-on ()
  (linum-mode t))
(add-hook 'emacs-lisp-mode-hook 'linum-mode-on)

;; disable backup
(setq make-backup-files nil)
(setq backup-inhibited t)
;; disable auto save
(setq auto-save-default nil)

;;
;; dired
;;
(require 'dired+)
(setq dired-listing-switches "-alh")
(setq dired-omit-files "^\\...+$")
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))

(defvar dired-sort-map (make-sparse-keymap))
(define-key dired-mode-map "s" dired-sort-map)
(define-key dired-sort-map "s" (lambda () "sort by Size" (interactive) (dired-sort-other (concat dired-listing-switches "S"))))
(define-key dired-sort-map "x" (lambda () "sort by eXtension" (interactive) (dired-sort-other (concat dired-listing-switches "X"))))
(define-key dired-sort-map "t" (lambda () "sort by Time" (interactive) (dired-sort-other (concat dired-listing-switches "t"))))
(define-key dired-sort-map "n" (lambda () "sort by Name" (interactive) (dired-sort-other dired-listing-switches)))
(define-key dired-sort-map "d" (lambda () "sort by name grouping Dirs" (interactive) (dired-sort-other (concat dired-listing-switches " --group-directories-first"))))

(defun dired-open (&optional file-list)
  (interactive
   (list (dired-get-marked-files t current-prefix-arg)))
  (apply 'call-process "xdg-open" nil 0 nil file-list))
(define-key dired-mode-map (kbd "s o") 'dired-open)

;; recentf
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-saved-items 500)
(setq recentf-max-menu-items 60)
(global-set-key (kbd "C-x C-r") 'ido-recentf-open)
(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))

;; desktop
;; save a list of open files in ~/.emacs.desktop
;; save the desktop file automatically if it already exists
(setq desktop-save 'if-exists)
(desktop-save-mode 1)

;; save a bunch of variables to the desktop file
;; for lists specify the len of the maximal saved data also
;;
;; Use M-x desktop-save once to save the desktop.
;; When it exists, Emacs updates it on every exit. 
;;
(setq desktop-globals-to-save
      (append '((extended-command-history . 30)
                (file-name-history        . 100)
                (grep-history             . 30)
                (compile-history          . 30)
                (minibuffer-history       . 50)
                (query-replace-history    . 60)
                (read-expression-history  . 60)
                (regexp-history           . 60)
                (regexp-search-ring       . 20)
                (search-ring              . 20)
                (shell-command-history    . 50)
                tags-file-name
                register-alist)))

;; ssh
(require 'ssh)

;;
;; IDO mode
;;
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)
(setq ido-create-new-buffer 'always)

(server-start)
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)

(global-set-key (kbd "<f12>") ; make F12 switch to .emacs; create if needed
		(lambda()(interactive)(find-file "~/.emacs")))
(global-set-key (kbd "<f11>") ; make F11 switch to gtd.org
		(lambda()(interactive)(find-file "~/GTD/gtd.org")))

;;
;; Bookmarks
;;
(add-to-list 'load-path "~/.emacs.d/bookmark-plus")
(require 'bookmark+)

;; FlySpell mode
(ispell-change-dictionary "en_GB")
(setq ispell-program-name "aspell")

(require 'printing)
(pr-update-menus t)

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; ESS
(setq user-full-name "Antonio, Fabio Di Narzo")
(add-to-list 'load-path "~/.emacs.d/ess/lisp")
(require 'ess-site)
(require 'ess-R-object-tooltip)
;; (add-hook 'ess-mode-hook 'linum-on)
(custom-set-faces
 '(tooltip ((t (:background "#1A1A1A" :foreground "#F8F8F2" :foundry "fixed")))))

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
(setq notmuch-command (executable-find "notmuch"))
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
;; git
;;
(add-to-list 'load-path "~/.emacs.d/egg")
(require 'egg)

;;
;; C++ and C mode...
;;
(setq HOME (expand-file-name ""))
(setq LOCAL-FLAGS (getenv "CFLAGS"))
(setq CFLAGS LOCAL-FLAGS)

(setq GSL-CONFIG (executable-find "gsl-config"))
(if GSL-CONFIG
    (progn
      (setq GSL-FLAGS (substring (shell-command-to-string (format "%s --cflags" GSL-CONFIG)) 0 -1))
      (setq CFLAGS (concat CFLAGS " " GSL-FLAGS))))

(setq R-CMD (executable-find "R"))
(if R-CMD
    (progn
      (setq R-FLAGS (substring (shell-command-to-string (format "%s CMD config --cppflags" R-CMD)) 0 -1))
      (setq CFLAGS (concat CFLAGS " " R-FLAGS))))

(setq MPICC (executable-find "mpicc"))
(if MPICC
    (progn
      (setq MPI-FLAGS (substring (shell-command-to-string (format "%s --showme:compile" MPICC)) 0 -1))
      (concat CFLAGS  " " MPI-FLAGS)))

;; eldoc
(setq c-eldoc-includes CFLAGS)
(load "c-eldoc")

;; flymake
(require 'flymake)
(setq flymake-gui-warnings-enabled nil)

(defun flymake-get-gcc-cmdline (source base-dir)
  (list "gcc"
	(append
	 (list
	  "-o" "nul"
	  "-S" source
	  "--std=c99"
	  (concat "-I" base-dir))
	 (split-string CFLAGS " "))))
(defun flymake-custom-c-init ()
  (let* ((args nil)
	 (source-file-name   buffer-file-name)
	 (buildfile-dir      (file-name-directory source-file-name)))
    (if buildfile-dir
	(let*
	    ((temp-source-file-name
	      (flymake-init-create-temp-buffer-copy 'flymake-create-temp-inplace)))
	  (setq args
		(flymake-get-syntax-check-program-args
		 temp-source-file-name buildfile-dir
		 t t
		 'flymake-get-gcc-cmdline))))
    args))
(add-to-list 'flymake-allowed-file-name-masks '(".+\\.c$" flymake-custom-c-init))

(defun flymake-get-g++-cmdline (source base-dir)
  (list "g++"
	(append
	 (list
	  "-o" "nul"
	  "-S" source
	  (concat "-I" base-dir))
	 (split-string CFLAGS " "))))
(defun flymake-custom-cc-init ()
  (let* ((args nil)
	 (source-file-name   buffer-file-name)
	 (buildfile-dir      (file-name-directory source-file-name)))
    (if buildfile-dir
	(let*
	    ((temp-source-file-name
	      (flymake-init-create-temp-buffer-copy 'flymake-create-temp-inplace)))
	  (setq args
		(flymake-get-syntax-check-program-args
		 temp-source-file-name buildfile-dir
		 t t
		 'flymake-get-g++-cmdline))))
    args))
(add-to-list 'flymake-allowed-file-name-masks '(".+\\.cc$" flymake-custom-cc-init))
(add-to-list 'flymake-allowed-file-name-masks '(".+\\.cpp$" flymake-custom-cc-init))

(defun my-flymake-show-help ()
  (when (get-char-property (point) 'flymake-overlay)
    (let ((help (get-char-property (point) 'help-echo)))
      (if help (message "%s" help)))))
(add-hook 'post-command-hook 'my-flymake-show-help)

(defun my-c++-mode-hook ()
  (linum-mode t)
  (flymake-mode 1)
  (auto-fill-mode))
(defun my-c-mode-hook ()
  (linum-mode t)
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
(global-set-key (kbd "C-c p f") 'project-root-find-file)
(global-set-key (kbd "C-c p g") 'project-root-ack)
(global-set-key (kbd "C-c p d") 'project-root-goto-root)
(global-set-key (kbd "C-c p p") 'project-root-run-default-command)
(global-set-key (kbd "C-c p l") 'project-root-browse-seen-projects)

(setq project-roots
      `(("Play Project"
         :root-contains-files ("app" "conf" ".git")
         :filename-regex ,(concat (regexify-ext-list '(java html xml txt conf yml css R js)) "\\|.*conf/.*")
	 :exclude-paths ("tmp")
         :on-hit (lambda (p) (message (car p))))))

;;
;; OCaml
;;
;; (add-to-list 'load-path "~/.emacs.d/tuareg-2.0.4")
;; (add-to-list 'auto-mode-alist '("\\.ml[iylp]?" . tuareg-mode))
;; (autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
;; (autoload 'camldebug "camldebug" "Run the Caml debugger" t)

;; Loading TypeRex mode for OCaml files
(add-to-list 'auto-mode-alist '("\\.ml[iylp]?" . typerex-mode))
(add-to-list 'interpreter-mode-alist '("ocamlrun" . typerex-mode))
(add-to-list 'interpreter-mode-alist '("ocaml" . typerex-mode))
(autoload 'typerex-mode "typerex" "Major mode for editing Caml code" t)

;; TypeRex mode configuration
(setq ocp-server-command "~/local/bin/ocp-wizard")
(setq typerex-in-indent 0)
(setq-default indent-tabs-mode nil)

;;
;; a general purpose Makefile can be as follows:
;;
;; OCAMLC = ocp-ocamlc.opt
;; OCAMLOPT = ocamlopt.opt
;; OCAMLDEP = ocamldep
;; OCAMLLEX = ocamllex
;; OCAMLYACC = ocamlyacc

;; lexers := $(wildcard *.mll)
;; parsers := $(wildcard *.mly)
;; sources := $(wildcard *.ml) $(lexers:.mll=.ml) $(parsers:.mly=.ml)
;; targets.byte := $(sources:.ml=.byte)
;; targets.native := $(sources:.ml=.native)
;; targets.annot := $(sources:.ml=.annot)

;; all: $(targets.byte) $(targets.native) $(targets.annot)

;; %.ml: %.mll
;; 	ocamlbuild -no-hygiene $@

;; %.ml: %.mly
;; 	ocamlbuild -no-hygiene $@

;; %.annot: %.ml
;; 	$(OCAMLC) -c -annot $< -o /dev/null && rm $(<:.ml=.cmi) $(<:.ml=.cmo)

;; %.byte: %.ml
;; 	ocamlbuild -no-hygiene -tag debug $@

;; %.native: %.ml
;; 	ocamlbuild -no-hygiene $@

;; Uncomment to enable typerex command menu by right click
;;(setq ocp-menu-trigger [mouse-3])

;; Uncomment to disable new syntax coloring and use Tuareg
;;(setq ocp-syntax-coloring nil)

;; It can be one of (check http://www.typerex.org/manual-setup.html):
;; - "syntactic" (default): the new TypeRex coloring, providing extended identifier kind distinction, and smarter comment/string handling
;; - "tuareg_like": The same TypeRex implementation, tuned to look almost like Tuareg mode (with minor improvements and differences, and with Tuareg faces renamed into typerex-font-lock-...)
;; - "caml_like": Same as tuareg_like, with Caml-mode colors (not renamed)
;; - "tuareg" The embedded Tuareg-mode implementation of syntax coloring (again with renamed Tuareg faces).
;; - "caml" The Caml-mode implementation of syntax coloring, which must be installed and present in the path (file caml-font.el). You may need to add the following to your .emacs: 
(setq ocp-theme "caml_like")

;;;; Auto completion (experimental)
;;;; Don't use M-x invert-face default with auto-complete! (emacs -r is OK)
(add-to-list 'load-path "~/.emacs.d/auto-complete-mode")
(setq ocp-auto-complete t)

;;;; Using <`> to complete whatever the context, and <C-`> for `
;; (setq auto-complete-keys 'ac-keys-backquote-backslash)
;;;; Options: nil (default), 'ac-keys-default-start-with-c-tab, 'ac-keys-two-dollar
;;;; Note: this overrides individual auto-complete key settings

;;;; Number of characters required to start (nil to disable)
(setq ac-auto-start 0)

;;;; I want immediate menu pop-up
(setq ac-auto-show-menu 0.)
;;;; Short delay before showing help
;; (setq ac-quick-help-delay 0.3)
