(when (>= emacs-major-version 24)
     (require 'package)
     (package-initialize)
     (setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
			      ("melpa" . "http://elpa.emacs-china.org/melpa/")
			      ("melpa-cn" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
                              ("org-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
                              ("gnu-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/"))))

;; 注意 elpa.emacs-china.org 是 Emacs China 中文社区在国内搭建的一个 ELPA 镜像

;; cl - Common Lisp Extension
(require 'cl)
;; Add Packages
(defvar my/packages '(
               ;; --- Auto-completion ---
               company
               ;; --- Better Editor ---
               hungry-delete
               swiper
               counsel
               smartparens
               ;; --- Major Mode ---
               js2-mode
               ;; --- Minor Mode ---
               nodejs-repl
               exec-path-from-shell
               ;; --- Themes ---
               monokai-theme
               ;; solarized-theme
               ;; --- 多鼠标---
               multiple-cursors
	       ;; --- markdown ---
	       markdown-mode
	       helm
	       find-file-in-project
	       ace-jump-mode
               ) "Default packages")
(setq package-selected-packages my/packages)
(defun my/packages-installed-p ()
    (loop for pkg in my/packages
          when (not (package-installed-p pkg)) do (return nil)
          finally (return t)))
(unless (my/packages-installed-p)
    (message "%s" "Refreshing package database...")
    (package-refresh-contents)
    (dolist (pkg my/packages)
      (when (not (package-installed-p pkg))
        (package-install pkg))))
;; Find Executable Path on OS X
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;;(add-to-list 'load-path "/Users/fengshu/.emacs.d/elpa/")
;;============== 开启插件 ===================

;; yaml
(require 'yaml-mode)
    (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

;; 开启全局 Company 补全
(global-company-mode 1)

;; 开启markdown
(setq auto-mode-alist  
(cons '(".markdown" . markdown-mode) auto-mode-alist))

;; 开启快速打开文件
(require 'find-file-in-project)

;; 多鼠标
(require 'multiple-cursors)
(global-set-key (kbd "C-c C-a") 'mc/edit-lines)
(global-set-key (kbd "C-c C-n") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c C-p") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-l") 'mc/mark-all-like-this)
(global-unset-key (kbd "M-<down-mouse-1>"))
(global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)

;; find-file-in-project 设置-----
(setq ffip-project-root "/Users/fengshu/Documents/test")

;; Helm设置----------
(require 'helm)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(defun spacemacs//helm-hide-minibuffer-maybe ()
  "Hide minibuffer in Helm session if we use the header line as input field."
  (when (with-helm-buffer helm-echo-input-in-header-line)
    (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
      (overlay-put ov 'window (selected-window))
      (overlay-put ov 'face
                   (let ((bg-color (face-background 'default nil)))
                     `(:background ,bg-color :foreground ,bg-color)))
      (setq-local cursor-type nil))))


(add-hook 'helm-minibuffer-set-up-hook
          'spacemacs//helm-hide-minibuffer-maybe)

(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)
(helm-autoresize-mode 1)

(helm-mode 1)
;; end-----------------

;;=================END====================

;; 关闭工具栏，tool-bar-mode 即为一个 Minor Mode
(tool-bar-mode 0)

;; 不显示菜单
(menu-bar-mode 0)

;; 关闭文件滑动控件
(scroll-bar-mode 0)

;; 显示行号
(global-linum-mode 1)

;; 关闭备份
(setq make-backup-files nil)

;; 设置字体
(set-default-font "YaHei Consolas Hybrid-14")

;; 更改光标的样式（不能生效，解决方案见第二集）
(setq-default cursor-type 'box)

;; 关闭启动帮助画面
(setq inhibit-splash-screen 1)

;; 关闭缩进 (第二天中被去除)
;; (electric-indent-mode -1)

;; 更改显示字体大小 16pt
;; http://stackoverflow.com/questions/294664/how-to-set-the-font-size-in-emacs
;;
;; (set-face-attribute 'default nil :height 140)

;; 快速打开配置文件
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

;; 这一行代码，将函数 open-init-file 绑定到 <f2> 键上
(global-set-key (kbd "<f2>") 'open-init-file)

;; 美化行号
(setq linum-format "%3d||")

;; 跳转到当前 buffer 对应文件所在目录
(define-key global-map (kbd "C-x C-j") 'dired-jump)
(define-key global-map (kbd "C-x 4 C-j") 'dired-jump-other-window)

;;start 设置剪切板共享 
(defun copy-from-osx () 
(shell-command-to-string "pbpaste")) 
(defun paste-to-osx (text &optional push) 
(let ((process-connection-type nil)) 
(let ((proc (start-process"pbcopy" "*Messages*" "pbcopy"))) 
(process-send-string proc text) 
(process-send-eof proc)))) 
(setq interprogram-cut-function 'paste-to-osx) 
(setq interprogram-paste-function 'copy-from-osx) 
;;end 设置剪切板共享 

;;设置默认读入文件编码
(prefer-coding-system 'utf-8)
;;设置写入文件编码
(setq default-buffer-file-coding-system 'utf-8)

;; ----------操作习惯-----------
;;设置打开文件的缺省路径，这里为桌面，默认的路径为“～/” 
(setq default-directory "/Users/fengshu/Documents/test") 

;; shell 去掉特殊符号
;;; Fix junk characters in shell-mode
(add-hook 'shell-mode-hook 
          'ansi-color-for-comint-mode-on)

;;让 Emacs 可以直接打开和显示图片。 
(setq auto-image-file-mode t) 
 
;;防止页面滚动时跳动， 
;;scroll-margin 3 可以在靠近屏幕边沿3行时就开始滚动 
;;scroll-step 1 设置为每次翻滚一行，可以使页面更连续 
(setq scroll-step 1 scroll-margin 3 scroll-conservatively 10000) 
 
;; 当光标在行尾上下移动的时候，始终保持在行尾。 
(setq track-eol t)

;; 启用时间显示设置，在minibuffer上面的那个杠上 
(display-time-mode t) 
  
;; 使用24小时制 
(setq display-time-24hr-format t)

;; 设置Tab, space 等的显示
(setq whitespace-display-mappings
   '(
        (space-mark   ?\     [? ]) ;; use space not dot
        (space-mark   ?\xA0  [?\u00A4]     [?_])
        (space-mark   ?\x8A0 [?\x8A4]      [?_])
        (space-mark   ?\x920 [?\x924]      [?_])
        (space-mark   ?\xE20 [?\xE24]      [?_])
        (space-mark   ?\xF20 [?\xF24]      [?_])
        (newline-mark ?\n    [?$ ?\n])
        (tab-mark     ?\t    [?\u00BB ?\t] [?\\ ?\t])
   )
)

;; 缩进tab宽度为四个空格，同时设置c代码中语句首字母与括号对齐
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)
(setq c-default-style "Linux")
(setq c-basic-offset 4)

;; -----绑定键------
;; 改变Emacs要你回答yes的行为,按y或空格键表示yes，n表示no。 
(fset 'yes-or-no-p 'y-or-n-p) 
;;设置C->键作为窗口之间的切换，默认的是C-x-o,比较麻烦
(global-set-key (kbd "C-o") 'other-window)

;;;分屏
;;屏幕大小
(require 'windresize)
(global-set-key (kbd "C-c m") 'windresize)

;;可以使用 Ctrl-c ← （就是向左的箭头键）组合键，退回你的上一个窗口设置。）
;;可以使用 Ctrl-c → （前进一个窗口设置。）
(when (fboundp 'winner-mode)
  (winner-mode) 
  (windmove-default-keybindings)) 

;;;windmove-mode
(when (fboundp 'windmove-default-keybindings)
      (windmove-default-keybindings)
    (global-set-key (kbd "C-c d")  'windmove-left) 
    (global-set-key (kbd "C-c n") 'windmove-right)
    (global-set-key (kbd "C-c t")    'windmove-up)
    (global-set-key (kbd "C-c h")  'windmove-down))

;; ===========install package=============
;; --find-file-in-project---
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (diredful yaml-mode company hungry-delete swiper counsel smartparens js2-mode nodejs-repl exec-path-from-shell monokai-theme multiple-cursors markdown-mode helm find-file-in-project ace-jump-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-space ((((class color) (background dark)) (:foreground "gray")) (((class color) (background light)) (:foreground "black")) (t (:inverse-video t)))))

;;-- ace jump mode---
;;
;; ace jump mode major function
;; 
(add-to-list 'load-path "/full/path/where/ace-jump-mode.el/in/")
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; you can select the key you prefer to
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; 
;; enable a more powerful jump back function from ace jump mode
;;
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

;;custom

(global-set-key "\C-c_w" 'whitespace-mode)
(global-set-key "\C-c_t" 'whitespace-toggle-options)
(global-set-key "\C-c=w" 'global-whitespace-mode)
(global-set-key "\C-c=t" 'global-whitespace-toggle-options)

;; dired-view
(add-to-list 'load-path "/Users/fengshu/.emacs.d/elpa/")

;; ~/.emacs:
(require 'dired-isearch)


