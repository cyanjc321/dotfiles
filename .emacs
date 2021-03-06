; (setq debug-on-error t)

; List package archives and initialize them
(require 'package)

(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos)) (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (setq package-archives ())
  (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.emacs-china.org/gnu/")) t)
  
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  ;(add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (add-to-list 'package-archives (cons "melpa" (concat proto "://elpa.emacs-china.org/melpa/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  ;(add-to-list 'package-archives (cons "org" (concat proto "://orgmode.org/elpa/")) t)
  (add-to-list 'package-archives (cons "org" (concat proto "://elpa.emacs-china.org/org/")) t)
  ;(when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    ;(add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))
  ;)
)
(package-initialize)

;; Make sure Org is installed
(unless (package-installed-p 'org)
  (package-refresh-contents)
  (package-install 'org))

;; Org plus contrib needs to be loaded before any org related functionality is called
(unless (package-installed-p 'org-plus-contrib)
  (package-refresh-contents)
  (package-install 'org-plus-contrib)
  (package-install 'ox-gfm)
  (package-install 'htmlize))

(setq user-full-name "Chao Jiang")

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(when window-system
  (tool-bar-mode 0)
  (scroll-bar-mode 0)
  (tooltip-mode 0))

;; No welcome screen - opens directly in scratch buffer
(setq inhibit-startup-message t
      initial-scratch-message ""
      initial-major-mode 'fundamental-mode
      inhibit-splash-screen t)

;; Change the echo message
(defun display-startup-echo-area-message ()
  (message "Let the games begin!"))

;; Backups at .saves folder in the current folder
(setq backup-by-copying t      ; don't clobber symlinks
      backup-directory-alist
      '(("." . "~/.saves"))    ; don't litter my fs tree
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)       ; use versioned backups

(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
      create-lockfiles nil)

(setq-default truncate-lines t)
(setq large-file-warning-threshold (* 15 1024 1024))
(fset 'yes-or-no-p 'y-or-n-p)
(setq save-abbrevs 'silently)
(setq-default abbrev-mode t)
(global-visual-line-mode t)

(setq ediff-window-setup-function 'ediff-setup-windows-plain
      ediff-split-window-function 'split-window-horizontally)

(setq tramp-default-method "ssh"
      tramp-backup-directory-alist backup-directory-alist
      tramp-ssh-controlmaster-options "ssh")

(subword-mode)

(setq sentence-end-double-space nil)

;;(setq search-whitespace-regexp ".*?")

(savehist-mode)

(put 'narrow-to-region 'disabled nil)

(setq doc-view-continuous t)

(when (fboundp 'winner-mode)
  (winner-mode 1))

;; Recentf mode changes
(setq recentf-max-saved-items 1000
      recentf-exclude '("/tmp/" "/ssh:"))
(recentf-mode)

(cond ((eq system-type 'gnu/linux)
       (set-frame-font "Hack-10"))
      ((eq system-type 'darwin)
       (set-frame-font "Hack-12"))
      ((eq system-type 'windows-nt)
       (set-frame-font "Consolas-10")))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(require 'bind-key)                ;; if you use any :bind variant

(use-package dired
             :bind (:map dired-mode-map
                         ("C-c C-e" . wdired-change-to-wdired-mode))
             :init
             (setq dired-dwim-target t
                   dired-recursive-copies 'top
                   dired-recursive-deletes 'top
                   dired-listing-switches "-alh")
             :config
             (add-hook 'dired-mode-hook 'dired-hide-details-mode))

(use-package wc-mode
             :ensure t)

(use-package diminish
             :ensure t
             :demand t
             :diminish (visual-line-mode . "ω")
             :diminish hs-minor-mode
             :diminish abbrev-mode
             :diminish auto-fill-function
             :diminish subword-mode)

(use-package flyspell
             :diminish (flyspell-mode . "φ")
             :bind* (("M-m ] s" . flyspell-goto-next-error)))

(cond ((eq system-type 'gnu/linux)
       (setq langtool-language-tool-jar "/usr/share/java/languagetool/languagetool-commandline.jar"))
      ((eq system-type 'darwin)
       (setq langtool-language-tool-jar "/usr/local/Cellar/languagetool/4.2/libexec/languagetool-commandline.jar"))
      ((eq system-type 'windows-nt)
       (setq langtool-language-tool-jar "")))
(use-package langtool
             :ensure t
             :init
             (setq langtool-disabled-rules '("CURRENCY"
                                             "COMMA_PARENTHESIS_WHITESPACE"
                                             "WHITESPACE_RULE"
                                             )))

(use-package eww
             :bind* (("M-m g x" . eww)
                     ("M-m g :" . eww-browse-with-external-browser)
                     ("M-m g #" . eww-list-histories)
                     ("M-m g {" . eww-back-url)
                     ("M-m g }" . eww-forward-url))
             :config
             (progn
               (add-hook 'eww-mode-hook 'visual-line-mode)))

(use-package exec-path-from-shell
             :ensure t
             :demand t
             :init
             (setq exec-path-from-shell-check-startup-files nil)
             :config
             ;; (exec-path-from-shell-copy-env "PYTHONPATH")
             (when (memq window-system '(mac ns x))
               (exec-path-from-shell-initialize)))

(use-package async
             :ensure t
             :commands (async-start))

(use-package cl-lib
             :ensure t)

(use-package dash
             :ensure t)

(use-package s
             :ensure t)

(use-package restart-emacs
             :ensure t
             :bind* (("C-x M-c" . restart-emacs)))

;; Tangle on save
(defun tangle-if-init ()
  "If the current buffer is 'init.org' the code-blocks are
  tangled, and the tangled file is compiled."

  (when (string-suffix-p "config.org" (buffer-file-name))
    (tangle-init)))

(defun tangle-init-sync ()
  (interactive)
  (message "Tangling init")
  ;; Avoid running hooks when tangling.
  (let ((prog-mode-hook nil)
        (src  (expand-file-name "config.org" user-emacs-directory))
        (dest (expand-file-name "config.el"  user-emacs-directory)))
    (require 'ob-tangle)
    (org-babel-tangle-file src dest)
    (if (byte-compile-file dest)
      (byte-compile-dest-file dest)
      (with-current-buffer byte-compile-log-buffer
                           (buffer-string)))))

(defun tangle-init ()
  "Tangle init.org asynchronously."

  (interactive)
  (message "Tangling init")
  (async-start
    (symbol-function #'tangle-init-sync)
    (lambda (result)
      (message "Init tangling completed: %s" result))))

(use-package which-key
             :ensure t
             :defer t
             :diminish which-key-mode
             :init
             (setq which-key-sort-order 'which-key-key-order-alpha)
             :bind* (("M-m ?" . which-key-show-top-level))
             :config
             (which-key-mode)
             (which-key-add-key-based-replacements
               "M-m ?" "top level bindings"))

(use-package modalka
             :ensure t
             :demand t
             :bind* (("C-z" . modalka-mode))
             :diminish (modalka-mode . "μ")
             :init
             (setq modalka-cursor-type 'box)
             :config
             (global-set-key (kbd "<escape>") #'modalka-mode)
             (modalka-global-mode 1)
             (add-to-list 'modalka-excluded-modes 'magit-status-mode)
             (add-to-list 'modalka-excluded-modes 'magit-popup-mode)
             (add-to-list 'modalka-excluded-modes 'eshell-mode)
             (add-to-list 'modalka-excluded-modes 'deft-mode)
             (add-to-list 'modalka-excluded-modes 'term-mode)
             (which-key-add-key-based-replacements
               "M-m"     "Modalka prefix"
               "M-m :"   "extended prefix"
               "M-m m"   "move prefix"
               "M-m s"   "send code prefix"
               "M-m SPC" "user prefix"
               "M-m g"   "global prefix"
               "M-m o"   "org prefix"
               "M-m a"   "expand around prefix"
               "M-m i"   "expand inside prefix"
               "M-m ["   "prev nav prefix"
               "M-m ]"   "next nav prefix"))

(modalka-define-kbd "0" "C-0")
(modalka-define-kbd "1" "C-1")
(modalka-define-kbd "2" "C-2")
(modalka-define-kbd "3" "C-3")
(modalka-define-kbd "4" "C-4")
(modalka-define-kbd "5" "C-5")
(modalka-define-kbd "6" "C-6")
(modalka-define-kbd "7" "C-7")
(modalka-define-kbd "8" "C-8")
(modalka-define-kbd "9" "C-9")

(modalka-define-kbd "h" "C-b")
(modalka-define-kbd "j" "C-n")
(modalka-define-kbd "k" "C-p")
(modalka-define-kbd "l" "C-f")
(modalka-define-kbd "e" "M-f")
(modalka-define-kbd "b" "M-b")
(modalka-define-kbd "n" "M-n")
(modalka-define-kbd "N" "M-p")
(modalka-define-kbd "{" "M-{")
(modalka-define-kbd "}" "M-}")
(modalka-define-kbd "0" "C-a")
(modalka-define-kbd "$" "C-e")
(modalka-define-kbd "G" "M->")
(modalka-define-kbd "y" "M-w")
(modalka-define-kbd "p" "C-y")
(modalka-define-kbd "P" "M-y")
(modalka-define-kbd "x" "C-d")
(modalka-define-kbd "D" "C-k")
(modalka-define-kbd "z" "C-l")
(modalka-define-kbd "!" "M-&")
(modalka-define-kbd "J" "C-v")
(modalka-define-kbd "K" "M-v")
(modalka-define-kbd "M" "C-u")
(modalka-define-kbd "(" "M-a")
(modalka-define-kbd ")" "M-e")
(modalka-define-kbd "/" "C-s")
(modalka-define-kbd "E" "C-g")
(modalka-define-kbd "d" "C-w")
(modalka-define-kbd "w" "C-x o")
(modalka-define-kbd "W" "M-m W")
(modalka-define-kbd "B" "M-m B")
(modalka-define-kbd "H" "C-x >")
(modalka-define-kbd "L" "C-x <")
(modalka-define-kbd "Z" "C-x 1")
(modalka-define-kbd "q" "C-x (")
(modalka-define-kbd "Q" "C-x )")
(modalka-define-kbd "." "M-m .")
(modalka-define-kbd "?" "M-m ?")
(modalka-define-kbd "v" "C-SPC")
(modalka-define-kbd "V" "M-m V")
(modalka-define-kbd "=" "M-m =")
(modalka-define-kbd "R" "M-m R")
(modalka-define-kbd "X" "C-x C-x")
(modalka-define-kbd "+" "C-x r m")
(modalka-define-kbd "'" "C-x r b")
(modalka-define-kbd "\\" "C-c C-c")
(modalka-define-kbd "u" "C-x u")

(modalka-define-kbd "g g" "M-<")
(modalka-define-kbd "g o" "C-x C-e")
(modalka-define-kbd "g O" "C-M-x")
(modalka-define-kbd "g m" "M-m g m")
(modalka-define-kbd "g M" "M-m g M")
(modalka-define-kbd "g n" "M-m g n")
(modalka-define-kbd "g N" "M-m g N")
(modalka-define-kbd "g f" "M-m g f")
(modalka-define-kbd "g F" "M-m g F")
(modalka-define-kbd "g j" "M-m g j")
(modalka-define-kbd "g k" "M-m g k")
(modalka-define-kbd "g q" "M-m g q")
(modalka-define-kbd "g w" "C-x 3")
(modalka-define-kbd "g W" "C-x 2")
(modalka-define-kbd "g @" "M-m g @")
(modalka-define-kbd "g ;" "M-m g ;")
(modalka-define-kbd "g :" "M-m g :")
(modalka-define-kbd "g #" "M-m g #")
(modalka-define-kbd "g {" "M-m g {")
(modalka-define-kbd "g }" "M-m g }")
(modalka-define-kbd "g (" "M-m g (")
(modalka-define-kbd "g )" "M-m g )")
(modalka-define-kbd "^" "M-m ^")
(modalka-define-kbd "&" "M-m &")
(modalka-define-kbd "g S" "C-j")
(modalka-define-kbd "g ?" "C-h k")

(modalka-define-kbd "i a" "C-x h")

(modalka-define-kbd "] ]" "C-x n n")
(modalka-define-kbd "] s" "M-m ] s")

(modalka-define-kbd "[ [" "C-x n w")

(modalka-define-kbd ": q" "C-x C-c")
(modalka-define-kbd ": r" "C-x M-c")
(modalka-define-kbd ": t" "M-m : t")
(modalka-define-kbd ": w" "C-x C-s")

(modalka-define-kbd "g U" "C-c C-k")
(modalka-define-kbd "SPC j" "M-x")
(modalka-define-kbd "SPC a" "C-x b")
(modalka-define-kbd "SPC k" "C-x k")
(modalka-define-kbd "SPC g" "M-g g")
(modalka-define-kbd "SPC d" "C-x d")
(modalka-define-kbd "SPC q" "C-x 0")
(modalka-define-kbd "SPC f" "C-x C-f")
(modalka-define-kbd "SPC w" "C-x C-s")
(modalka-define-kbd "SPC c" "M-m SPC c")
(modalka-define-kbd "SPC R" "M-m SPC R")
(modalka-define-kbd "SPC ?" "M-m SPC ?")

(which-key-add-key-based-replacements
  "0" "0"
  "1" "1"
  "2" "2"
  "3" "3"
  "4" "4"
  "5" "5"
  "6" "6"
  "7" "7"
  "8" "8"
  "9" "9")

(which-key-add-key-based-replacements
  "ESC" "toggle mode"
  "DEL" "smart del"
  "TAB" "smart tab"
  "RET" "smart enter"
  "h"   "prev char"
  "j"   "next line"
  "k"   "prev line"
  "l"   "next char"
  "e"   "next word"
  "b"   "prev word"
  "n"   "next history item"
  "N"   "prev history item"
  "{"   "next para"
  "}"   "prev para"
  "0"   "start of line"
  "$"   "end of line"
  "("   "start of sentence"
  ")"   "end of sentence"
  "/" "search"
  "E"   "exit anything"
  "B"   "previous buffer"
  "W"   "winner undo"
  "w"   "other window"
  "G"   "end of file"
  "d"   "delete selection"
  "y"   "copy selection"
  "p"   "paste"
  "P"   "paste history"
  "x"   "delete char"
  "D"   "delete rest of line"
  "M"   "modify argument"
  "z"   "scroll center/top/bot"
  "Z"   "zoom into window"
  "H"   "scroll left"
  "J"   "scroll down"
  "K"   "scroll up"
  "L"   "scroll right"
  "'"   "org edit separately"
  "q"   "start macro"
  "Q"   "end macro"
  "?"   "top level bindings"
  "v"   "start selection"
  "R"   "overwrite mode"
  "X"   "exchange point and mark"
  "+"   "set bookmark"
  "'"   "jump to bookmark"
  "="   "indent region"
  "\\"  "C-c C-c"
  "!"   "async shell command"
  "&"   "shell command"
  "u"   "undo")

(which-key-add-key-based-replacements
  "g"   "global prefix"
  "g g" "start of file"
  "g m" "make frame"
  "g M" "delete frame"
  "g n" "select frame by name"
  "g N" "name frame"
  "g j" "next pdf page"
  "g k" "previous pdf page"
  "g f" "file/url at cursor"
  "g F" "enable follow mode"
  "g o" "eval elisp"
  "g O" "eval defun"
  "g w" "vertical split win"
  "g W" "horizontal split win"
  "g S" "split line"
  "g @" "compose mail"
  "g #" "list eww histories"
  "g x" "browse with eww"
  "g :" "browse with external browser"
  "g {" "eww back"
  "g }" "eww forward"
  "g (" "info previous"
  "g )" "info next"
  "^"   "info up"
  "&"   "info goto"
  "g q" "format para"
  "g ?" "find command bound to key")

(which-key-add-key-based-replacements
  "i"   "expand prefix"
  "i a" "expand entire buffer")

(which-key-add-key-based-replacements
  "]"   "forward nav/edit"
  "] ]" "narrow region"
  "] s" "next spell error")

(which-key-add-key-based-replacements
  "["   "backward nav/edit"
  "[ [" "widen region")

(which-key-add-key-based-replacements
  ":"   "extended prefix"
  ": q" "quit emacs"
  ": r" "restart emacs"
  ": t" "initiliazation time"
  ": w" "save buffer")

(which-key-add-key-based-replacements
  "SPC"   "custom prefix"
  "SPC ?" "describe bindings"
  "SPC j" "jump to cmd"
  "SPC f" "find file"
  "SPC a" "switch buffers"
  "SPC g" "goto line"
  "SPC d" "dired"
  "SPC k" "close buffer"
  "SPC w" "save buffer"
  "SPC c" "load theme"
  "SPC R" "locate"
  "SPC q" "quit window"
  "g U"   "simulate C-c C-k")

(setq org-hide-emphasis-markers t)
(setq org-startup-indented t
      org-hide-leading-stars t)
(setq org-image-actual-width '(300))
(setq org-src-fontify-natively t
      org-src-tab-acts-natively t)
(setq org-todo-keywords
      '((sequence "TODO(t)" "IN-PROGRESS(i)" "|" "DONE(d!)")
        (sequence "WAITING(w@/!)" "|" "CANCELED(c@)")))
(setq org-log-done t)
(setq org-clock-idle-time 1)
(setq org-clock-x11idle-program-name "xprintidle")
(setq org-latex-pdf-process '("texi2dvi --pdf --clean --verbose --batch %f"))
(setq org-latex-packages-alist '())
(add-to-list 'org-latex-packages-alist '("" "colortbl" t))
(add-to-list 'org-latex-packages-alist '("table" "xcolor" t))
(add-to-list 'org-latex-packages-alist '("" "siunitx" t))
(add-to-list 'org-latex-packages-alist '("" "longtable" t))
(add-to-list 'org-latex-packages-alist '("font=small,labelfont=bf" "caption" t))
(add-to-list 'org-latex-packages-alist '("" "rotating" t))
(add-to-list 'org-latex-packages-alist '("" "booktabs" t))
(add-to-list 'org-latex-packages-alist '("" "physics" t))
(add-to-list 'org-latex-packages-alist '("" "amsmath" t))
(add-to-list 'org-latex-packages-alist '("" "amssymb" t))
(add-to-list 'org-latex-packages-alist '("" "xfrac" t))
(add-to-list 'org-latex-packages-alist '("" "multirow,multicol,array" t))
(add-to-list 'org-latex-packages-alist '("" "enumitem" t))
(add-to-list 'org-latex-packages-alist '("LGR,TS1,T1" "fontenc" t))
(use-package org
             :ensure org
             :bind* (("M-m o a"   . org-agenda)
                     ("M-m o c"   . org-capture)
                     ("M-m o i"   . org-insert-link)
                     ("M-m o s"   . org-store-link)
                     ("M-m o S"   . org-list-make-subtree)
                     ("M-m o A"   . org-archive-subtree)
                     ("M-m o g"   . org-goto)
                     ("M-m o l"   . org-toggle-latex-fragment)
                     ("M-m o L"   . org-toggle-link-display)
                     ("M-m o I"   . org-toggle-inline-images)
                     ("M-m o k"   . org-cut-subtree)
                     ("M-m o V"   . org-reveal)
                     ("M-m o R"   . org-refile)
                     ("M-m o y"   . org-copy-subtree)
                     ("M-m o h"   . org-toggle-heading)
                     ("M-m o H"   . org-insert-heading-respect-content)
                     ("M-m o e"   . org-export-dispatch)
                     ("M-m o u"   . org-update-dblock)
                     ("M-m o U"   . org-update-all-dblocks)
                     ("M-m o O"   . org-footnote)
                     ("M-m o ]"   . org-narrow-to-subtree)
                     ("M-m o ["   . widen)
                     ("M-m o N"   . org-add-note)
                     ("M-m o E"   . org-set-effort)
                     ("M-m o B"   . org-table-blank-field)
                     ("M-m o <"   . org-date-from-calendar)
                     ("M-m o >"   . org-goto-calendar)
                     ("M-m o d"   . org-todo)
                     ("M-m o t"   . org-set-tags-command)
                     ("M-m o w"   . org-edit-special)
                     ("M-m o q"   . org-edit-src-exit)
                     ("M-m o z"   . clone-indirect-buffer-other-window)
                     ("M-m a s"   . org-mark-subtree)
                     ("M-m o RET" . org-open-at-point))
             :config
             ;; More of those nice template expansion
             )

(which-key-add-key-based-replacements
  "M-m o" "org mode prefix")
(modalka-define-kbd "o a"   "M-m o a")
(modalka-define-kbd "o c"   "M-m o c")
(modalka-define-kbd "o i"   "M-m o i")
(modalka-define-kbd "o s"   "M-m o s")
(modalka-define-kbd "o S"   "M-m o S")
(modalka-define-kbd "o A"   "M-m o A")
(modalka-define-kbd "o g"   "M-m o g")
(modalka-define-kbd "o l"   "M-m o l")
(modalka-define-kbd "o L"   "M-m o L")
(modalka-define-kbd "o I"   "M-m o I")
(modalka-define-kbd "o k"   "M-m o k")
(modalka-define-kbd "o V"   "M-m o V")
(modalka-define-kbd "o R"   "M-m o R")
(modalka-define-kbd "o y"   "M-m o y")
(modalka-define-kbd "o h"   "M-m o h")
(modalka-define-kbd "o H"   "M-m o H")
(modalka-define-kbd "o e"   "M-m o e")
(modalka-define-kbd "o u"   "M-m o u")
(modalka-define-kbd "o U"   "M-m o U")
(modalka-define-kbd "o O"   "M-m o O")
(modalka-define-kbd "o ]"   "M-m o ]")
(modalka-define-kbd "o ["   "M-m o [")
(modalka-define-kbd "o N"   "M-m o N")
(modalka-define-kbd "o E"   "M-m o E")
(modalka-define-kbd "o B"   "M-m o B")
(modalka-define-kbd "o <"   "M-m o <")
(modalka-define-kbd "o >"   "M-m o >")
(modalka-define-kbd "o d"   "M-m o d")
(modalka-define-kbd "o t"   "M-m o t")
(modalka-define-kbd "o z"   "M-m o z")
(modalka-define-kbd "o w"   "M-m o w")
(modalka-define-kbd "o q"   "M-m o q")
(modalka-define-kbd "a s"   "M-m a s")
(modalka-define-kbd "o RET" "M-m o RET")

(which-key-add-key-based-replacements
  "o"     "org prefix"
  "o a"   "org agenda"
  "o c"   "org capture"
  "o i"   "org insert link"
  "o s"   "org store link"
  "o S"   "org subtree from list"
  "o A"   "org archive subtree"
  "o g"   "org goto"
  "o l"   "org latex preview"
  "o L"   "org toggle link display"
  "o I"   "org image preview"
  "o k"   "org kill subtree"
  "o V"   "org reveal"
  "o R"   "org refile"
  "o y"   "org copy subtree"
  "o h"   "org toggle heading"
  "o H"   "org insert heading"
  "o e"   "org export"
  "o u"   "org update current"
  "o U"   "org update all"
  "o O"   "org footnote"
  "o ]"   "org narrow subtree"
  "o ["   "org widen"
  "o N"   "org note"
  "o F"   "org attach"
  "o E"   "org set effort"
  "o B"   "org table blank field"
  "o <"   "org select from cal"
  "o >"   "org goto cal"
  "o t"   "org tag"
  "o d"   "org todo"
  "o z"   "split and clone"
  "o w"   "org special edit"
  "o q"   "org special edit quit"
  "a s"   "mark org subtree"
  "o RET" "org open link")

(eval-after-load "org"
                 '(require 'ox-gfm nil t))

(use-package org-ref
             :ensure t
             :init
             (setq reftex-default-bibliography '("~/workspace/writings/thesis/thesis.bib"))
             (setq org-ref-default-bibliography '("~/workspace/writings/thesis/thesis.bib")))

(use-package org-bullets
             :ensure t
             :config
             (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package helm
             :ensure t
             :demand t
             :diminish helm-mode
             :bind (("M-x"     . helm-M-x)
                    ("M-y"     . helm-show-kill-ring)
                    ("C-x C-f" . helm-find-files)
                    ("C-x 8"   . helm-ucs))
             :bind* (("M-m SPC h r" . helm-resume)
                     ("M-m SPC r"   . helm-for-files)
                     ("M-m SPC x"   . helm-apropos)
                     ("M-m SPC C" . helm-colors)
                     ("M-m SPC h R" . helm-regexp)
                     ("M-m SPC h u" . helm-surfraw)
                     ("M-m SPC h t" . helm-top)
                     ("M-m SPC h p" . helm-list-emacs-process)
                     ("M-m SPC F"   . helm-find)
                     ("M-m SPC h k" . helm-calcul-expression)
                     ("M-m SPC h i" . helm-info-at-point)
                     ("M-m SPC h d" . helm-man-woman)
                     ("M-m SPC h h" . helm-documentation)
                     ("M-m SPC h e" . helm-run-external-command)
                     ("M-m ;"       . helm-all-mark-rings)
                     ("M-m SPC h x" . helm-select-xfont)
                     ("M-m t"       . helm-semantic-or-imenu))
             :bind (:map helm-map
                         ("<return>"   . helm-maybe-exit-minibuffer)
                         ("RET"        . helm-maybe-exit-minibuffer)
                         ("<tab>"      . helm-select-action)
                         ("C-i"        . helm-select-action)
                         ("S-<return>" . helm-maybe-exit-minibuffer)
                         ("S-RET"      . helm-maybe-exit-minibuffer)
                         ("C-S-m"      . helm-maybe-exit-minibuffer))
             :bind (:map helm-find-files-map
                         ("<return>"    . helm-execute-persistent-action)
                         ("RET"         . helm-execute-persistent-action)
                         ("<backspace>" . dwim-helm-find-files-up-one-level-maybe)
                         ("DEL"         . dwim-helm-find-files-up-one-level-maybe)
                         ("<tab>"       . helm-select-action)
                         ("C-i"         . helm-select-action)
                         ("S-<return>"  . helm-maybe-exit-minibuffer)
                         ("S-RET"       . helm-maybe-exit-minibuffer)
                         ("C-S-m"       . helm-maybe-exit-minibuffer))
             :bind (:map helm-read-file-map
                         ("<return>"    . helm-execute-persistent-action)
                         ("RET"         . helm-execute-persistent-action)
                         ("<backspace>" . dwim-helm-find-files-up-one-level-maybe)
                         ("DEL"         . dwim-helm-find-files-up-one-level-maybe)
                         ("<tab>"       . helm-select-action)
                         ("C-i"         . helm-select-action)
                         ("S-<return>"  . helm-maybe-exit-minibuffer)
                         ("S-RET"       . helm-maybe-exit-minibuffer)
                         ("C-S-m"       . helm-maybe-exit-minibuffer))
             :commands (helm-mode
                         helm-M-x
                         helm-smex
                         helm-find-files
                         helm-buffers
                         helm-recentf)
             :config
             ;; require basic config
             (require 'helm-config)
             (helm-mode 1)

             ;; use silver searcher when available
             (when (executable-find "ag-grep")
               (setq helm-grep-default-command "ag-grep -Hn --no-group --no-color %e %p %f"
                     helm-grep-default-recurse-command "ag-grep -H --no-group --no-color %e %p %f"))

             ;; Fuzzy matching for everything
             (setq helm-M-x-fuzzy-match t
                   helm-recentf-fuzzy-match t
                   helm-buffers-fuzzy-matching t
                   helm-locate-fuzzy-match nil
                   helm-mode-fuzzy-match t)

             ;; set height and stuff
             (helm-autoresize-mode 1)
             (setq helm-autoresize-max-height 20
                   helm-autoresize-min-height 20)

             ;; Work with Spotlight on OS X instead of the regular locate
             (setq helm-locate-command "mdfind -name -onlyin ~ %s %s")

             ;; Make sure helm always pops up in bottom
             (setq helm-split-window-in-side-p t)

             (add-to-list 'display-buffer-alist
                          '("\\`\\*helm.*\\*\\'"
                            (display-buffer-in-side-window)
                            (inhibit-same-window . t)
                            (window-height . 0.2)))

             ;; provide input in the header line and hide the mode lines above
             (setq helm-echo-input-in-header-line t)

             (defvar bottom-buffers nil
               "List of bottom buffers before helm session.
               Its element is a pair of `buffer-name' and `mode-line-format'.")

             (defun bottom-buffers-init ()
               (setq-local mode-line-format (default-value 'mode-line-format))
               (setq bottom-buffers
                     (cl-loop for w in (window-list)
                              when (window-at-side-p w 'bottom)
                              collect (with-current-buffer (window-buffer w)
                                                           (cons (buffer-name) mode-line-format)))))

             (defun bottom-buffers-hide-mode-line ()
               (setq-default cursor-in-non-selected-windows nil)
               (mapc (lambda (elt)
                       (with-current-buffer (car elt)
                                            (setq-local mode-line-format nil)))
                     bottom-buffers))

             (defun bottom-buffers-show-mode-line ()
               (setq-default cursor-in-non-selected-windows t)
               (when bottom-buffers
                 (mapc (lambda (elt)
                         (with-current-buffer (car elt)
                                              (setq-local mode-line-format (cdr elt))))
                       bottom-buffers)
                 (setq bottom-buffers nil)))

             (defun helm-keyboard-quit-advice (orig-func &rest args)
               (bottom-buffers-show-mode-line)
               (apply orig-func args))

             (add-hook 'helm-before-initialize-hook #'bottom-buffers-init)
             (add-hook 'helm-after-initialize-hook #'bottom-buffers-hide-mode-line)
             (add-hook 'helm-exit-minibuffer-hook #'bottom-buffers-show-mode-line)
             (add-hook 'helm-cleanup-hook #'bottom-buffers-show-mode-line)
             (advice-add 'helm-keyboard-quit :around #'helm-keyboard-quit-advice)

             ;; remove header lines if only a single source
             (setq helm-display-header-line nil)

             (defvar helm-source-header-default-background (face-attribute 'helm-source-header :background))
             (defvar helm-source-header-default-foreground (face-attribute 'helm-source-header :foreground))
             (defvar helm-source-header-default-box (face-attribute 'helm-source-header :box))

             (defun helm-toggle-header-line ()
               (if (> (length helm-sources) 1)
                 (set-face-attribute 'helm-source-header
                                     nil
                                     :foreground helm-source-header-default-foreground
                                     :background helm-source-header-default-background
                                     :box helm-source-header-default-box
                                     :height 1.0)
                 (set-face-attribute 'helm-source-header
                                     nil
                                     :foreground (face-attribute 'helm-selection :background)
                                     :background (face-attribute 'helm-selection :background)
                                     :box nil
                                     :height 0.1)))

             (add-hook 'helm-before-initialize-hook 'helm-toggle-header-line)

             ;; hide the minibuffer when helm is active
             (defun helm-hide-minibuffer-maybe ()
               (when (with-helm-buffer helm-echo-input-in-header-line)
                 (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
                   (overlay-put ov 'window (selected-window))
                   (overlay-put ov 'face (let ((bg-color (face-background 'default nil)))
                                           `(:background ,bg-color :foreground ,bg-color)))
                   (setq-local cursor-type nil))))

             (add-hook 'helm-minibuffer-set-up-hook 'helm-hide-minibuffer-maybe)

             ;; Proper find file behavior
             (defun dwim-helm-find-files-up-one-level-maybe ()
               (interactive)
               (if (looking-back "/" 1)
                 (call-interactively 'helm-find-files-up-one-level)
                 (delete-backward-char 1)))

             (defun dwim-helm-find-files-navigate-forward (orig-fun &rest args)
               "Adjust how helm-execute-persistent actions behaves, depending on context"
               (if (file-directory-p (helm-get-selection))
                 (apply orig-fun args)
                 (helm-maybe-exit-minibuffer)))

             (advice-add 'helm-execute-persistent-action :around #'dwim-helm-find-files-navigate-forward)

             ;; better smex integration
             (use-package helm-smex
                          :ensure t
                          :bind* (("M-x" . helm-smex)
                                  ("M-X" . helm-smex-major-mode-commands)))

             ;; Make helm fuzzier
             (use-package helm-fuzzier
                          :ensure t
                          :config
                          (helm-fuzzier-mode 1))

             ;; Add support for flx
             (use-package helm-flx
                          :ensure t
                          :config
                          (helm-flx-mode 1))

             ;; Add helm-bibtex
             (use-package helm-bibtex
                          :ensure t
                          :bind* (("M-m SPC b" . helm-bibtex))
                          :init
                          (setq bibtex-completion-bibliography '("~/workspace/writings/thesis/thesis.bib"))
                          (setq bibtex-completion-library-path "~/Dropbox/org/references/pdfs")
                          (setq bibtex-completion-notes-path "~/Dropbox/org/references/articles.org"))

             ;; to search in projects - the silver searcher
             (use-package helm-ag
                          :ensure t
                          :bind* (("M-m g s" . helm-do-ag-project-root)
                                  ("M-m g e" . helm-do-ag)))

             ;; to search in files
             (use-package helm-swoop
                          :ensure t
                          :bind (("C-s" . helm-swoop-without-pre-input))
                          :bind* (("M-m #"   . helm-swoop)
                                  ("M-m g /" . helm-multi-swoop)
                                  ("M-m o /" . helm-multi-swoop-org)
                                  ("M-m g E" . helm-multi-swoop-all))
                          :init
                          (setq helm-swoop-split-with-multiple-windows nil
                                helm-swoop-split-direction 'split-window-vertically
                                helm-swoop-split-window-function 'helm-default-display-buffer))

             ;; to help with projectile
             (use-package helm-projectile
                          :ensure t
                          :bind* (("M-m SPC d" . helm-projectile))
                          :init
                          (setq projectile-completion-system 'helm))

             ;; to describe bindings
             (use-package helm-descbinds
                          :ensure t
                          :bind* (("M-m SPC ?" . helm-descbinds)))

             ;; Control AWS via helm
             (use-package helm-aws
                          :ensure t
                          :bind* (("M-m SPC h w" . helm-aws)))

             ;; Control circe with helm
             (use-package helm-circe
                          :ensure t
                          :bind* (("M-m SPC h j" . helm-circe)
                                  ("M-m SPC h J" . helm-circe-new-activity)))

             ;; List errors with helm
             (use-package helm-flycheck
                          :ensure t
                          :bind* (("M-m SPC l" . helm-flycheck)))

             ;; Flyspell errors with helm
             (use-package helm-flyspell
                          :ensure t
                          :bind* (("M-m SPC h s" . sk/helm-correct-word))
                          :config
                          (defun sk/helm-correct-word ()
                            (interactive)
                            (save-excursion
                              (sk/flyspell-goto-previous-error 1)
                              (helm-flyspell-correct))))

             ;; Select snippets with helm
             (use-package helm-c-yasnippet
                          :ensure t
                          :bind (("C-o" . helm-yas-complete))
                          :bind* (("C-,"        . helm-yas-create-snippet-on-region)
                                  ("C-<escape>" . helm-yas-visit-snippet-file)))

             ;; Helm integration with make
             (use-package helm-make
                          :ensure t
                          :init
                          (setq helm-make-build-directory "build")
                          :bind* (("M-m SPC m" . helm-make-projectile)
                                  ("M-m SPC M" . helm-make))))

(modalka-define-kbd "t" "M-m t")
(modalka-define-kbd "#" "M-m #")
(modalka-define-kbd ";" "M-m ;")
(modalka-define-kbd "SPC J" "M-X")
(modalka-define-kbd "g E" "M-m g E")
(modalka-define-kbd "g s" "M-m g s")
(modalka-define-kbd "g /" "M-m g /")
(modalka-define-kbd "o /" "M-m o /")
(modalka-define-kbd "g e" "M-m g e")
(modalka-define-kbd "g u" "C-c C-e")
(modalka-define-kbd "SPC r" "M-m SPC r")
(modalka-define-kbd "SPC b" "M-m SPC b")
(modalka-define-kbd "SPC x" "M-m SPC x")
(modalka-define-kbd "SPC F" "M-m SPC F")
(modalka-define-kbd "SPC C" "M-m SPC C")
(modalka-define-kbd "SPC m" "M-m SPC m")
(modalka-define-kbd "SPC M" "M-m SPC M")
(modalka-define-kbd "SPC h r" "M-m SPC h r")
(modalka-define-kbd "SPC h e" "M-m SPC h e")
(modalka-define-kbd "SPC h w" "M-m SPC h w")
(modalka-define-kbd "SPC h i" "M-m SPC h i")
(modalka-define-kbd "SPC h R" "M-m SPC h R")
(modalka-define-kbd "SPC h u" "M-m SPC h u")
(modalka-define-kbd "SPC h t" "M-m SPC h t")
(modalka-define-kbd "SPC h p" "M-m SPC h p")
(modalka-define-kbd "SPC h k" "M-m SPC h k")
(modalka-define-kbd "SPC h d" "M-m SPC h d")
(modalka-define-kbd "SPC h h" "M-m SPC h h")
(modalka-define-kbd "SPC h x" "M-m SPC h x")
(modalka-define-kbd "SPC h j" "M-m SPC h j")
(modalka-define-kbd "SPC h J" "M-m SPC h J")
(modalka-define-kbd "SPC h s" "M-m SPC h s")

(which-key-add-key-based-replacements
  "t"       "tags/func in buffer"
  "#"       "swoop at point"
  ";"       "previous edit points"
  "g E"     "extract word from buffers"
  "g s"     "search project"
  "g /"     "multi file search"
  "o /"     "org swoop"
  "g e"     "extract word from dir"
  "SPC r"   "find any file"
  "SPC C"   "color picker"
  "g u"     "simulate C-c C-e"
  "SPC b"   "bibliography"
  "SPC x"   "helm apropos"
  "SPC J"   "helm major mode cmds"
  "SPC F"   "find command"
  "SPC h"   "helm prefix"
  "SPC h r" "resume last helm "
  "SPC h e" "external command"
  "SPC h w" "AWS instances"
  "SPC h i" "information at point"
  "SPC h R" "build regexp"
  "SPC h u" "surfraw"
  "SPC h t" "system processes"
  "SPC h p" "emacs processes"
  "SPC h k" "calc expression"
  "SPC h d" "manual docs"
  "SPC h h" "helm docs"
  "SPC h x" "select font"
  "SPC h j" "circe chat"
  "SPC h J" "circe new activity"
  "SPC h s" "helm spelling"
  "SPC m" "make in project"
  "SPC M" "make in current dir")


(use-package magit
             :ensure t
             :bind* (("M-m SPC e" . magit-status)
                     ("M-m g b"   . magit-blame)))

(modalka-define-kbd "SPC e" "M-m SPC e")
(modalka-define-kbd "g b"   "M-m g b")

(which-key-add-key-based-replacements
  "SPC e" "explore git"
  "g b"   "git blame")


(use-package diff-hl
             :ensure t
             :commands (global-diff-hl-mode
                         diff-hl-mode
                         diff-hl-next-hunk
                         diff-hl-previous-hunk
                         diff-hl-mark-hunk
                         diff-hl-diff-goto-hunk
                         diff-hl-revert-hunk)
             :bind* (("M-m ] h" . diff-hl-next-hunk)
                     ("M-m [ h" . diff-hl-previous-hunk)
                     ("M-m i h" . diff-hl-mark-hunk)
                     ("M-m a h" . diff-hl-mark-hunk)
                     ("M-m g h" . diff-hl-diff-goto-hunk)
                     ("M-m g H" . diff-hl-revert-hunk))
             :config
             (global-diff-hl-mode)
             (diff-hl-flydiff-mode)
             (diff-hl-margin-mode)
             (diff-hl-dired-mode))

(modalka-define-kbd "] h" "M-m ] h")
(modalka-define-kbd "[ h" "M-m [ h")
(modalka-define-kbd "g h" "M-m g h")
(modalka-define-kbd "g H" "M-m g H")
(modalka-define-kbd "i h" "M-m i h")
(modalka-define-kbd "a h" "M-m a h")

(which-key-add-key-based-replacements
  "] h" "next git hunk"
  "[ h" "previous git hunk"
  "g h" "goto git hunk"
  "g H" "revert git hunk"
  "i h" "select git hunk"
  "a h" "select a git hunk")

(use-package git-timemachine
             :ensure t
             :commands (git-timemachine-toggle
                         git-timemachine-switch-branch)
             :bind* (("M-m g l" . git-timemachine-toggle)
                     ("M-m g L" . git-timemachine-switch-branch)))

(modalka-define-kbd "g l" "M-m g l")
(modalka-define-kbd "g L" "M-m g L")

(which-key-add-key-based-replacements
  "g l" "git time machine"
  "g L" "time machine switch branch")

(use-package browse-at-remote
             :ensure t
             :bind* (("M-m g i" . browse-at-remote)
                     ("M-m g I" . browse-at-remote-kill)))

(modalka-define-kbd "g i" "M-m g i")
(modalka-define-kbd "g I" "M-m g I")

(which-key-add-key-based-replacements
  "g i" "browse file/region remote"
  "g I" "copy remote URL")

(use-package color-theme-sanityinc-tomorrow
             :ensure t)
(use-package tangotango-theme
             :ensure t)
(load-theme 'tangotango t)

(use-package company
             :ensure t
             :commands (company-mode
                         company-complete
                         company-complete-common
                         company-complete-common-or-cycle
                         company-files
                         company-dabbrev
                         company-ispell
                         company-c-headers
                         company-jedi
                         company-tern
                         company-web-html
                         company-auctex)
             :init
             (setq company-minimum-prefix-length 2
                   company-require-match 0
                   company-selection-wrap-around t
                   company-dabbrev-downcase nil
                   company-tooltip-limit 20                      ; bigger popup window
                   company-tooltip-align-annotations 't          ; align annotations to the right tooltip border
                   company-idle-delay .4                         ; decrease delay before autocompletion popup shows
                   company-begin-commands '(self-insert-command)) ; start autocompletion only after typing
             (eval-after-load 'company
                              '(add-to-list 'company-backends '(company-files
                                                                 company-capf)))
             :bind (("M-t"   . company-complete)
                    ("C-c f" . company-files)
                    ("C-c a" . company-dabbrev)
                    ("C-c d" . company-ispell)
                    :map company-active-map
                    ("C-n"    . company-select-next)
                    ("C-p"    . company-select-previous)
                    ([return] . company-complete-selection)
                    ("C-w"    . backward-kill-word)
                    ("C-c"    . company-abort)
                    ("C-c"    . company-search-abort))
             :diminish (company-mode . "ς")
             :config
             (global-company-mode)
             ;; C++ header completion
             (use-package company-c-headers
                          :ensure t
                          :bind (("C-c c" . company-c-headers))
                          :config
                          (add-to-list 'company-backends 'company-c-headers))
             ;; Python auto completion
             (use-package company-jedi
                          :ensure t
                          :bind (("C-c j" . company-jedi))
                          :config
                          (add-to-list 'company-backends 'company-jedi))
             ;; Tern for JS
             (use-package company-tern
                          :ensure t
                          :bind (("C-c t" . company-tern))
                          :init
                          (setq company-tern-property-marker "")
                          (setq company-tern-meta-as-single-line t)
                          :config
                          (add-to-list 'company-backends 'company-tern))
             ;; HTML completion
             (use-package company-web
                          :ensure t
                          :bind (("C-c w" . company-web-html))
                          :config
                          (add-to-list 'company-backends 'company-web-html))
             ;; LaTeX autocompletion
             (use-package company-auctex
                          :ensure t
                          :bind (("C-c l" . company-auctex))
                          :config
                          (add-to-list 'company-backends 'company-auctex)))

