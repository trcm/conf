
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;; SETUP

(set-default-font "Hack-10")
;; (set-default-font "Fixedsys Excelsior-14")

(load-theme 'challenger-deep t)
;; (load-theme 'spacemacs-dark t)
;; (load-theme 'solarized-dark t)

(set-frame-parameter (selected-frame) 'alpha '(95 95)) ;;; transperancy
(add-to-list 'default-frame-alist '(alpha 95 95))

(setq inhibit-startup-message t) ; get rid of the welcome screen
;; (global-linum-mode 1) ; adds line numbers
(setq system-uses-terminfo nil)
(setq redisplay-dont-pause t)
(tool-bar-mode -1) ;; removes toolbar
(menu-bar-mode -1) ;; remove menu bar
(column-number-mode t) ;; display column numbers
(scroll-bar-mode -1) ;; remove scroll bars
(setq ring-bell-function 'ignore)
(add-hook 'after-init-hook 'global-company-mode)
(require 'smartparens-config)
(smartparens-global-mode t)
(show-smartparens-global-mode t)
(setq sp-autoescape-string-quote 0)
(setq sp-autoskip-closing-pair 'always)
(setq sp-highlight-pair-overlay nil)
(add-to-list 'sp-sexp-suffix (list 'js2-mode 'regexp ""))
(add-to-list 'sp-sexp-suffix (list 'rust-mode 'regexp ""))
(add-to-list 'sp-sexp-suffix (list 'web-mode 'regexp ""))
(add-to-list 'sp-sexp-suffix (list 'rjsx-mode 'regexp ""))

(setq sml/no-confirm-load-theme t)
(setq sml/theme 'dark)
(sml/setup)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH")
  (exec-path-from-shell-copy-env "GOROOT"))

(ivy-mode t)
(setq projectile-completion-system 'ivy)
(setq projectile-enable-caching t)
(projectile-global-mode t)
(global-auto-revert-mode t)

;; Backups
(setq backup-directory-alist '(("." . "/Users/tom/.emacs.d/backups/")))

;; KEYBINDINGS
(global-set-key (kbd "C-x 4") 'thirds)
(global-set-key "\C-x\C-m"	'counsel-M-x)
(global-set-key (kbd "C-x m")	'counsel-M-x)
(global-set-key "\C-c\C-m"	'counsel-M-x)
(global-set-key (kbd "C-c b")   'back-to-other-buffer)
(global-set-key (kbd "C-c i") 'counsel-semantic)
(global-set-key (kbd "C-c d") 'rjsx-delete-creates-full-tag)
(global-set-key (kbd "C-=") 'er/expand-region)

;; SMART PARENS KEYBINDING
(define-key smartparens-mode-map (kbd "C-<right>") 'sp-forward-slurp-sexp)
(define-key smartparens-mode-map (kbd "C-<left>") 'sp-forward-barf-sexp)
(define-key smartparens-mode-map (kbd "C-M-<left>") 'sp-backward-slurp-sexp)
(define-key smartparens-mode-map (kbd "C-M-<right>") 'sp-backward-barf-sexp)

;; Dumb Jump
(dumb-jump-mode)
(setq dumb-jump-selector 'ivy)


;; JS
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(defadvice js-jsx-indent-line (after js-jsx-indent-line-after-hack activate)
  "Workaround sgml-mode and follow airbnb component style."
  (let* ((cur-line (buffer-substring-no-properties
                    (line-beginning-position)
                    (line-end-position))))
    (if (string-match "^\\( +\\)\/?> *$" cur-line)
      (let* ((empty-spaces (match-string 1 cur-line)))
        (replace-regexp empty-spaces
                        (make-string (- (length empty-spaces) sgml-basic-offset) 32)
                        nil
                        (line-beginning-position) (line-end-position))))))
;; http://www.flycheck.org/manual/latest/index.html
(require 'flycheck)

;; turn on flychecking globally
(add-hook 'after-init-hook #'global-flycheck-mode)

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)

;; customize flycheck temp file prefix
(setq-default flycheck-temp-prefix ".flycheck")

;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(json-jsonlist)))
(flycheck-add-mode 'javascript-eslint 'js2-jsx-mode)
(flycheck-add-mode 'javascript-eslint 'web-mode)
(flycheck-add-mode 'javascript-eslint 'rjsx-mode)

(add-hook 'js2-mode-hook 'tern-mode)
(add-hook 'jsx-mode-hook 'tern-mode)

(js2r-add-keybindings-with-prefix "C-c C-m")
;; JSX

(require 'flycheck-flow)
(flycheck-add-next-checker 'javascript-eslint 'javascript-flow)
(add-hook 'rjsx-mode-hook 'flow-minor-mode)

;; ORG MODE

(setq org-todo-keywords
       '((sequence "TODO" "IN PROGRESS" "FORWARD" "DONE")))

(setq org-todo-keyword-faces
			'(("IN PROGRESS" . "red") ("FORWARD" . "yellow")))

(require 'deft)
(setq deft-default-extension "org")
(setq deft-extensions '("org"))
(setq deft-directory "~/.deft")
(setq deft-recursive t)
(setq deft-use-filename-as-title t)
(setq deft-org-mode-title-prefix t)
(setq deft-use-filter-string-for-filename t)

;; RUST

(add-hook 'rust-mode-hook 'racer-mode)
(add-hook 'rust-mode-hook 'flycheck-rust-setup)

;; C Sharp

(add-hook 'csharp-mode-hook 'omnisharp-mode)

;; Haskell

(add-hook 'haskell-mode-hook 'intero-mode)

;; COMPANY
(use-package company
  :init
  (setq company-idle-delay 0.3)
  (setq company-tooltip-limit 20)
  (setq company-minimum-prefix-length 2)
  (setq company-echo-delay 0)
  (setq company-auto-complete nil)
  (global-company-mode 1)
  (add-to-list 'company-backends 'company-dabbrev t)
  (add-to-list 'company-backends 'company-ispell t)
  (add-to-list 'company-backends 'company-files t)
  (setq company-backends (remove 'company-ropemacs company-backends)))

(require 'color)

(let ((bg (face-attribute 'default :background)))
  (custom-set-faces
   `(company-tooltip ((t (:inherit default :background ,(color-lighten-name bg 2)))))
   `(company-scrollbar-bg ((t (:background ,(color-lighten-name bg 10)))))
   `(company-scrollbar-fg ((t (:background ,(color-lighten-name bg 5)))))
   `(company-tooltip-selection ((t (:inherit font-lock-function-name-face))))
   `(company-tooltip-common ((t (:inherit font-lock-constant-face))))))

;; EVIL ;;
;; (require 'linum-relative)
(require 'evil)
(evil-mode 1)
(global-evil-leader-mode 1)
(global-evil-surround-mode)
(global-evil-mc-mode)
(evilnc-default-hotkeys)
(setq evil-leader/leader ",")
;;; evil leader custom keybinds
(evil-leader/set-key
  "w"    'save-buffer
  "a"    'avy-goto-char
  "s"    'avy-goto-word-1
  "z"    'avy-goto-line
  "b"    'ido-switch-buffer
  "i"    'indent-region
  "k"    'kill-buffer
  "r"    'revert-buffer
  ;; "s"    'ace-jump-word-mode
  "m"    'mark-whole-buffer
  ;; "d"    'swiper
	"d"    'counsel-grep-or-swiper
  "o"    'back-to-other-buffer
  "e"    'eval-buffer
  "g"    'projectile-switch-project
  "j"    'counsel-git
  "b"    'switch-to-buffer
  "n"    'neotree-toggle
  "p"    'counsel-git-grep
  "t"    'rjsx-mode
  "ci"   'evilnc-comment-or-uncomment-lines
	"cb"   'cargo-process-build
	"cr"   'cargo-process-run
	"ct"   'cargo-process-test
  "q"    'ace-window
	"fn"   'flycheck-next-error
	)

(require 'key-chord)
(key-chord-mode 1)
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
(key-chord-define evil-visual-state-map "jk" 'evil-normal-state)

(evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
(evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
;; FUNCTIONS

(defun back-to-other-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer)))

(defun thirds ()
	(interactive)
  (split-window-horizontally)
  (split-window-horizontally)
  (balance-windows)
	)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
	 [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
	 ["#000000" "#8b0000" "#00ff00" "#ffa500" "#7b68ee" "#dc8cc3" "#93e0e3" "#dcdccc"])
 '(company-backends
	 (quote
		(company-files company-bbdb company-anaconda company-irony company-tern company-flow company-go company-elm company-nxml company-css company-clang company-xcode company-cmake company-capf company-files
									 (company-dabbrev-code company-gtags company-etags company-keywords)
									 company-oddmuse company-dabbrev)))
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-safe-themes
	 (quote
		("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "ea4ae3c179b4fd23f50b50062ca0312f7bf0151aa4ba8c10088bba87943d8b93" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "dcc7c8507c5f65957b110cadf6801e001465868588344521892b97348dc586b1" "cc2ef305435e2a40c64a6c9f18b954008a27a8f520680dca12597408e8872ec2" "a285e7bc4714013b6cd74ac4663b9fa5e8f734e989fcca42069c45ed702d4b72" "31ad958e92b874720d8962c6d3d149f6b80aa836d3509d8b210dc70069f71430" "e658f796fb205c9e46e4a14697d69e7ca06a5c830f61c5c097e494470f0b7434" "ff7625ad8aa2615eae96d6b4469fcc7d3d20b2e1ebc63b761a349bebbb9d23cb" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "34c6da8c18dcbe10d34e3cf0ceab80ed016552cb40cee1b906a42fd53342aba3" "2e5700152b4a79656cf60b038afb92ca972635b7936cbe3d474cac8768923fff" "227e2c160b0df776257e1411de60a9a181f890cfdf9c1f45535fc83c9b34406b" "01490fa7832bdadd9502e5e1c831e2b18a5f48c37ed48780741081d0414ee7f2" "ed1d4f68fdb738bc5c3e650fb92f75f811c596e73ff01a82caa206b75ea0ba7d" "6c7db7fdf356cf6bde4236248b17b129624d397a8e662cf1264e41dab87a4a9a" "a4bd55761752bddac75bad0a78f8c52081a1effb33b69354e30a64869b5a40b9" "0ad9ed23b1f323e4ba36a7f0cbef6aff66128b94faa473aacd79317fbd24abda" "4aafea32abe07a9658d20aadcae066e9c7a53f8e3dfbd18d8fa0b26c24f9082c" "22dcee36032834da7c7a1b344c3635313d8ba2c48c1f5bd25eb330949e15e815" "cdf96318f1671344564ba74ef75cc2a3f4692b2bee77de9ce9ff5f165de60b1f" "e506ff92aaa3ab1d91b750b8e37ce1faecdb2b978c60498eef7967a48279b299" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "8ec2e01474ad56ee33bc0534bdbe7842eea74dccfb576e09f99ef89a705f5501" "38e64ea9b3a5e512ae9547063ee491c20bd717fe59d9c12219a0b1050b439cdd" "704a108ab29ea8fc8feb718a538e9ce45d732dce41e5b04585f43a6352c5519e" "d8f76414f8f2dcb045a37eb155bfaa2e1d17b6573ed43fb1d18b936febc7bbc2" "dc65b57fa51eb557725aaf7fd6d52d1b8cfe6ed7d154a9769b376c594447a12c" "0f0db69b7a75a7466ef2c093e127a3fe3213ce79b87c95d39ed1eccd6fe69f74" "945fe66fbc30a7cbe0ed3e970195a7ee79ee34f49a86bc96d02662ab449b8134" default)))
 '(diff-hl-margin-mode t)
 '(fci-rule-character-color "#1c1c1c")
 '(fci-rule-color "#383838")
 '(flycheck-disabled-checkers
	 (quote
		(javascript-jshint json-jsonlist javascript-jshint json-jsonlist javascript-flow)))
 '(flycheck-javascript-flow-args nil)
 '(flycheck-javascript-flow-executable "~/work/DocketApp/node_modules/.bin/flow")
 '(fringe-mode 10 nil (fringe))
 '(global-hl-line-mode t)
 '(global-linum-mode nil)
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
	 (--map
		(solarized-color-blend it "#002b36" 0.25)
		(quote
		 ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
	 (quote
		(("#073642" . 0)
		 ("#546E00" . 20)
		 ("#00736F" . 30)
		 ("#00629D" . 50)
		 ("#7B6000" . 60)
		 ("#8B2C02" . 70)
		 ("#93115C" . 85)
		 ("#073642" . 100))))
 '(hl-bg-colors
	 (quote
		("#7B6000" "#8B2C02" "#990A1B" "#93115C" "#3F4D91" "#00629D" "#00736F" "#546E00")))
 '(hl-fg-colors
	 (quote
		("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36")))
 '(js-indent-level 2)
 '(linum-format " %6d ")
 '(linum-relative-current-symbol "")
 '(linum-relative-global-mode nil)
 '(magit-diff-use-overlays nil)
 '(main-line-color1 "#222232")
 '(main-line-color2 "#333343")
 '(neo-theme (quote nerd))
 '(nrepl-message-colors
	 (quote
		("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4")))
 '(org-fontify-whole-heading-line t)
 '(package-selected-packages
	 (quote
		(web-beautify kotlin-mode expand-region js2-refactor tuareg zerodark-theme racket-mode flycheck-haskell intero rainbow-mode nlinum-relative nlinum-hl evil-goggles spacemacs-theme toml-mode company-go go-mode dockerfile-mode docker tide love-minor-mode nord-theme company-lua lua-mode dracula-theme indium color-identifiers-mode solarized-theme restclient company-flow flow-mode flycheck-flow spaceline prassee-theme nimbus-theme diff-hl jade challenger-deep-theme fsharp-mode yoshi-theme dumb-jump jbeans-theme kaolin-theme omnisharp csharp-mode markdown-mode color-theme-sanityinc-tomorrow deft fancy-narrow clues-theme cyberpunk-theme jazz-theme darktooth-theme spacegray-theme gotham-theme yaml-mode company-anaconda anaconda-mode relative-line-numbers cargo emmet-mode company-irony flycheck-irony irony ace-window groovy-mode gradle-mode swift3-mode fish-mode racer neotree counsel-projectile magit cider elm-mode flycheck-rust web-mode json-mode exec-path-from-shell flycheck company-racer company-tern tern use-package rust-mode rjsx-mode avy projectile linum-relative smooth-scrolling evil-nerd-commenter evil-matchit evil-leader evil-surround key-chord yasnippet smart-mode-line company smartparens swiper-helm doom-themes counsel evil)))
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(powerline-color1 "#222232")
 '(powerline-color2 "#333343")
 '(racket-program "/Applications/Racket v6.9/bin/racket")
 '(semantic-mode t)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(tab-width 2)
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
	 (quote
		((20 . "#cc6666")
		 (40 . "#de935f")
		 (60 . "#f0c674")
		 (80 . "#b5bd68")
		 (100 . "#8abeb7")
		 (120 . "#81a2be")
		 (140 . "#b294bb")
		 (160 . "#cc6666")
		 (180 . "#de935f")
		 (200 . "#f0c674")
		 (220 . "#b5bd68")
		 (240 . "#8abeb7")
		 (260 . "#81a2be")
		 (280 . "#b294bb")
		 (300 . "#cc6666")
		 (320 . "#de935f")
		 (340 . "#f0c674")
		 (360 . "#b5bd68"))))
 '(vc-annotate-very-old-color nil)
 '(window-divider-default-right-width 1)
 '(window-divider-mode t)
 '(xterm-color-names
	 ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#eee8d5"])
 '(xterm-color-names-bright
	 ["#002b36" "#cb4b16" "#586e75" "#657b83" "#839496" "#6c71c4" "#93a1a1" "#fdf6e3"])
 '(yas-global-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-scrollbar-bg ((t (:background "#2f294d"))))
 '(company-scrollbar-fg ((t (:background "#25213c"))))
 '(company-tooltip ((t (:inherit default :background "#1f1b32"))))
 '(company-tooltip-common ((t (:inherit font-lock-constant-face))))
 '(company-tooltip-selection ((t (:inherit font-lock-function-name-face))))
 '(hl-line ((t (:background "gray21"))))
 '(term ((t (:inherit default :background "#1b182c" :foreground "#839496")))))
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
;; ## end of OPAM user-setup addition for emacs / base ## keep this line
