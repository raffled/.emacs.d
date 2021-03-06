;(add-to-list 'load-path "/home/raffle/.emacs.d/elisp/")
(add-to-list 'load-path "~/.emacs.d/")

;;set up color theme
;; (require 'color-theme)
;; (eval-after-load "color-theme"
;;   '(progn
;;      (color-theme-initialize)
;;      (color-theme-hober)))
;; ;color theme GREY
;; (defun grey.theme ()
;;   (interactive)
;;   (color-theme-install
;;    '(grey.theme
;;       ((background-color . "grey9")
;;       (background-mode . dark)
;;       (border-color . "#1a1a1a")
;;       (cursor-color . "#fce94f")
;;       (foreground-color . "cornsilk")
;;       (mouse-color . "black"))
;;      (fringe ((t (:background "grey9"))))
;;      (mode-line ((t (:foreground "grey99" :background "grey20"))))
;;      (region ((t (:background "DarkRed"))))
;;      (font-lock-builtin-face ((t (:foreground "chocolate"))))
;;      (font-lock-comment-face ((t (:foreground "red2"))))
;;      (font-lock-function-name-face ((t (:foreground "OrangeRed"))))
;;      (font-lock-keyword-face ((t (:foreground "OrangeRed" :bold))))
;;      (font-lock-string-face ((t (:foreground "goldenrod1" :italic))))
;;      (font-lock-type-face ((t (:foreground"yellow" :bold))))
;;      (font-lock-constant-face ((t (:foreground "orange" :bold))))
;;      (font-lock-variable-name-face ((t (:foreground "#b0b0b0"))))
;;      (minibuffer-prompt ((t (:foreground "DodgerBlue" :bold t))))
;;      (font-lock-warning-face ((t (:foreground "red" :bold t))))
;;      )))
;; (provide 'grey.theme)
;; (grey.theme)


;paren matching options
(setq show-paren-delay 0)
(show-paren-mode t)
(set-face-background 'show-paren-match-face "red2")

; comment out the following if you are not using R/S-Plus on ACPUB
; add a ";" in front of each line
;; Load ESS and activate the nifty feature showing function arguments
;; in the minibuffer until the call is closed with ')'.
;; (load "/usr/pkg/ess/lisp/ess-site")
(load "/usr/share/emacs/site-lisp/ess/ess-site")
(setq-default inferior-S+6-program-name "Splus")
(setq-default inferior-R-program-name "R")
(require 'ess-eldoc)


(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)

; automatically get the correct mode
auto-mode-alist (append (list '("\\.c$" . c-mode)
			      '("\\.tex$" . latex-mode)
			      '("\\.S$" . S-mode)
			      '("\\.s$" . S-mode)
			      '("\\.R$" . R-mode)
			      '("\\.r$" . R-mode)
			      '("\\.html$" . html-mode)
                              '("\\.emacs$" . emacs-lisp-mode)
			      '("\\.php$" . php-mode)
			      '("\\.Rmd$" . markdown-mode)
			      '("\\.rmd$" . markdown-mode)
	                )
		      auto-mode-alist)

;; Set code indentation following the standard in R sources.
(setq-default c-default-style "bsd")
(setq-default c-basic-offset 4)
;; (add-hook 'ess-mode-hook
;; 	  '(lambda()
;; 	     (ess-set-style 'C++ 'quiet)
;; 	     (add-hook 'write-file-functions
;;                            (lambda ()
;;                              (ess-nuke-trailing-whitespace)))))
;; (setq ess-nuke-trailing-whitespace-p t)

;get php-mode set up

;; (load "php-mode")
;; (add-to-list 'auto-mode-alist
;;      	     '("\\.php[34]?\\'\\|\\.phtml\\'" . php-mode))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (wombat)))
 '(custom-safe-themes (quote ("36affb6b6328d2bfa7a31b3183cd65d6dd1a8c0945382f94de729233b9737359" default)))
 '(inhibit-startup-screen t)
 '(pos-tip-background-color "#36473A")
 '(pos-tip-foreground-color "#FFFFC8")
 '(require-final-newline (quote visit-save))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "unknown" :slant normal :weight normal :height 120 :width normal)))))

;window layout option
(defun toggle-fullscreen (&optional f)
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
       (set-frame-parameter nil 'fullscreen
            (if (equal 'fullboth current-value)
                (if (boundp 'old-fullscreen) old-fullscreen nil)
                    (progn (setq old-fullscreen current-value)
                           'fullboth)))))

(global-set-key [f11] 'toggle-fullscreen)
;;(toggle-fullscreen)

;some better keyboard shortcuts
(global-set-key [C-tab] 'other-window)
(defun uncomment-region (beg end)
  "Like `comment-region' invoked with a C-u prefix arg."
  (interactive "r")
  (comment-region beg end -1))

;;(define-key ess-mode-map (kbd "C-d") 'comment-region)
;;(define-key ess-mode-map (kbd "C-S-d") 'uncomment-region)

;make shift-enter an adaptive eval key in R
(setq ess-ask-for-ess-directory nil)
(setq ess-local-process-name "R")
(setq ansi-color-for-comint-mode 'filter)
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)
(setq comint-move-point-for-output t)
(setq ess-close-paren-offset '(0))
(defun my-ess-start-R ()
  (interactive)
  (if (not (member "*R*" (mapcar (function buffer-name) (buffer-list))))
      (progn
        (delete-other-windows)
        (setq w1 (selected-window))
        (setq w1name (buffer-name))
        (setq w2 (split-window w1 nil t))
        (R)
        (set-window-buffer w2 "*R*")
        (set-window-buffer w1 w1name))))
(defun my-ess-eval ()
  (interactive)
  (my-ess-start-R)
  (if (and transient-mark-mode mark-active)
      (call-interactively 'ess-eval-region)
    (call-interactively 'ess-eval-line-and-step)))
(add-hook 'ess-mode-hook
          '(lambda()
             (local-set-key [(shift return)] 'my-ess-eval)))
(add-hook 'inferior-ess-mode-hook
          '(lambda()
             (local-set-key [C-up] 'comint-previous-input)
             (local-set-key [C-down] 'comint-next-input)))
(add-hook 'Rnw-mode-hook
          '(lambda()
             (local-set-key [(shift return)] 'my-ess-eval)))
(require 'ess-site)

;;set up ESS for R Markdown
;; (autoload ‘markdown-mode “markdown-mode” “Major mode for editing
;;   Markdown files” t) 
;; (add-to-list ’auto-mode-alist’(“\.text\‘" . markdown-mode)) 
;; (add-to-list ’auto-mode-alist’(“\.md\’” . markdown-mode))  

;;;;; Poly Mode
(setq load-path
      (append '("~/.emacs.d/polymode"  
		"~/.emacs.d/polymode/modes")
              load-path))
(require 'poly-R)
(require 'poly-markdown)

;;; MARKDOWN
(add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))


;;set hook for prolog mode
(setq auto-mode-alist
  (cons (cons "\\.pl" 'prolog-mode)
     auto-mode-alist))
(put 'upcase-region 'disabled nil)

;; auto-revert for docview
(add-hook 'doc-view-mode-hook 'auto-revert-mode)
(put 'downcase-region 'disabled nil)

;;;;; transparency
;;(set-frame-parameter (selected-frame) 'alpha '(<active> [<inactive>]))
 (set-frame-parameter (selected-frame) 'alpha '(90 85))
 (add-to-list 'default-frame-alist '(alpha 90 85))

 (eval-when-compile (require 'cl))
 (defun toggle-transparency ()
   (interactive)
   (if (/=
        (cadr (frame-parameter nil 'alpha))
        100)
       (set-frame-parameter nil 'alpha '(100 100))
     (set-frame-parameter nil 'alpha '(95 95))))
 (global-set-key (kbd "C-c t") 'toggle-transparency)

 ;; Set transparency of emacs
 (defun transparency (value)
   "Sets the transparency of the frame window. 0=transparent/100=opaque"
   (interactive "nTransparency Value 0 - 100 opaque:")
   (set-frame-parameter (selected-frame) 'alpha value))

;; interactive do (better buffer switch, etc.
(require 'ido)
(ido-mode t)

;; ;; fill column indicator
;; (require 'fill-column-indicator)
;; ;set up a global minor
;; (define-globalized-minor-mode
;;   global-fci-mode fci-mode (lambda () (fci-mode 1)))
;; (global-fci-mode t)
;; (setq fci-rule-column 75)

;; auto fill
(setq-default auto-fill-function 'do-auto-fill)

;; line wrap
(global-visual-line-mode 1)

;;;; image manipulation mode
(require 'eimp)
(autoload 'eimp-mode "eimp" "Emacs Image Manipulation Package." t)
(add-hook 'image-mode-hook 'eimp-mode)

;;;; pretty model-line
(add-to-list 'load-path "~/.emacs.d/mode-line-themes/")
(add-to-list 'load-path "~/.emacs.d/mode-line-themes/svg-mode-line-themes/")
(require 'xmlgen)
(require 'svg-mode-line-themes)
(smt/enable)
(set-face-attribute 'mode-line nil :box nil)
(set-face-attribute 'mode-line-inactive nil :box nil)
(require 'ocodo-slim-svg-mode-line)


;;;; set up MELPA package management
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line
(add-to-list 'load-path "~/.emacs.d/elpa/")
(load-theme 'darktooth)
