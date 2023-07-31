;; begin creation of emacs init.el file hand made
;; no evil-keybindings at the beginning, just plain old emacs keybinds
;; copied from emacs from scratch github and YT ref guide

;; created july 29, 2023
;; evil mode is on but jk as escape is not activated
;; take note of the errors in the Warnings buffer
(defvar em/default-font-size 240)
(defvar em/default-variable-font-size 180)
;; make frame transparency override
(defvar em/frame-transparency '(90 . 90))
;; emacs garbage collection override
(setq gc-cons-threshold (* 50 1000 1000))

;; (add-to-list 'load-path "~/.emacs.d")
;; https://www.emacswiki.org/emacs/LoadPath#:~:text=The%20value%20of%20variable%20'load,directories%20for%20the%20Emacs%20distribution.
(concat user-emacs-directory
        (convert-standard-filename "elisp/")) ;; load your elisp files here

;; skip display startup time
;; initialize package sources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

;; package initialize
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(unless package-archive-contents
  (package-refresh-contents))

;; use package
(require 'use-package)
(setq use-package-always-ensure t)
;; auto update use-package
(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "09:00"))
;; no littering
;; (use-package no-littering)
;; related to no-littering
;; see https://melpa.org/#/no-littering
;; (setq auto-save-file-name-transforms
;;      '((".*" '(no-littering-expand-var-file-name "auto-save/") t)))
(setq inhibit-startup-message t)
;; setup the visible bell
(setq visible-bell t)
;; enable line numbers globally
(global-display-line-numbers-mode t)
;; display line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		treemacs-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))
;; make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
;; use evil vim keybindings
(use-package general
  :after evil
  :config
  (general-create-definer em/leader-keys
			   :keymaps '(normal insert visual emacs)
			   :prefix "SPC"
			   :global-prefix "C-SPC")
  (em/leader-keys
   "t" '(:ignore t :which-key "toggles")
   "tt" '(counsel-load-theme :which-key "choose theme")
   "fde" '(lambda () (interactive) (find-file (expand-file-name "~/.emacs.d/Emacs.org")))))
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  ;; use visual line motions even outside of visual-line-mode-buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))
  
(use-package evil-collection
:after evil
:config
(evil-collection-init))

;; add comment install command-log-mode
(use-package command-log-mode
  :commands command-log-mode)
(use-package doom-themes
  :init (load-theme 'doom-palenight t))

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  (which-key-mode)
  (setq which-key-idle-delay 1))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line) ;; why repeat of the above?
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  ;; uncomment the below line to have sorting remembered across sessions
  (prescient-persist-mode 1)
  (ivy-prescient-mode 1))

(use-package hydra
  :defer t)
(defhydra hydra-text-scale (:timeout 4)
	  "scale text"
	  ("j" text-scale-increase "in")
	  ("k" text-scale-increase "out")
	  ("f" nil "finished" :exit t))
(em/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))


;; add new comment from archlinux box to push to GH
;; todo install magit
;; see this link 
;; https://medium.com/helpshift-engineering/configuring-emacs-from-scratch-use-package-c30382297877
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))
;; todo install org-mode
;; also install evil-escape package

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(magit hydra ivy-prescient ivy command-log-mode auto-package-update use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "IosevkaTerm Nerd Font" :foundry "UKWN" :slant normal :weight semi-bold :height 203 :width normal)))))
