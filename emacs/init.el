;;  Emacs 设置为开启默认全屏
;(setq initial-frame-alist (quote ((fullscreen . maximized))))  ; 窗口最大化
(toggle-frame-fullscreen)

;; 显示当前行
(global-hl-line-mode t)

;; 显示行号
(global-linum-mode 1)

;; 显示我们近期打开过的文件
(require 'recentf)

;; 设置标题栏
(setq frame-title-format "mingwang IDE")

;; 实现窗口透明
(setq alpha-list '((100 100) (95 65) (85 55) (75 45) (65 35)))
(defun loop-alpha ()
  (interactive)
  (let ((h (car alpha-list)))                ;; head value will set to
    ((lambda (a ab)
       (set-frame-parameter (selected-frame) 'alpha (list a ab))
       (add-to-list 'default-frame-alist (cons 'alpha (list a ab)))
       ) (car h) (car (cdr h)))
    (setq alpha-list (cdr (append alpha-list (list h))))
    )
  )
;; 设置窗口透明的快捷键
(global-set-key [(f12)] 'loop-alpha)

;;防止页面滚动时跳动，
;;scroll-margin 3 可以在靠近屏幕边沿3行时就开始滚动
;;scroll-step 1 设置为每次翻滚一行，可以使页面更连续
(setq scroll-step 1 scroll-margin 3 scroll-conservatively 10000)

;; 关闭烦人的警报声
(setq ring-bell-function 'ignore)

;; 如果装有版本控制可以把这个打开，关闭Emacs的自动备份。
(setq make-backup-files nil)
;; 关闭自动记录的文件
(setq auto-save-default nil)



--------------------------以上为我喜欢的配置设置------------------------------
(add-to-list 'load-path
             (expand-file-name (concat user-emacs-directory "lisp")))

; 图形界面设置产生的文件目录
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(require 'init-startup)
(require 'init-elpa)
(require 'init-package)
(require 'init-ui)

; 配置文件发生更改加载
(when (file-exists-p custom-file)
  (load-file custom-file)



----------------------以上是init.el文件----------------------
; 主题
(use-package gruvbox-theme
  :init (load-theme 'gruvbox-dark-soft t))

; buffer栏样式
(use-package smart-mode-line
  :init
  (setq sml/no-confirm-load-theme t
        sml/theme 'respectful)
  (sml/setup))

(provide 'init-ui)
----------------------以上是init-ui.el文件--------------------------
; 软件源
(setq package-archives '(("melpa" . "http://mirrors.cloud.tencent.com/elpa/melpa/")
                         ("gnu" . "http://mirrors.cloud.tencent.com/elpa/gnu/")
                         ("org" . "http://mirrors.cloud.tencent.com/elpa/org/")))

; 个别时候会出现签名校验失败
(setq package-check-signature nil)

(require 'package)

; 初始化包管理器,避免重新初始化
(unless (bound-and-true-p package--initialized) ;; 避免27警告
  ;; (when (version< emacs-version "27.0")
  (setq package-enable-at-startup nil)
  (package-initialize))

; 刷新软件源索引
(unless package-archive-contents
  (package-refresh-contents))

; 使用软件包的设置
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

; 在加载使用包之前配置它
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-always-defer t
        use-package-always-demand nil
        use-package-expand-minimally t
        use-package-verbose t))
(setq load-prefer-newer t)

(eval-when-compile
  (require 'use-package))


(provide 'init-elpa)
--------------------------- 以上是init-elpa.el文件----------------------------
; 菜单栏
(menu-bar-mode -1)
; 工具栏
(tool-bar-mode -1)
; 滚动条
(scroll-bar-mode -1)
; 关闭启动界面
(setq inhibit-startup-screen t)


(provide 'init-startup)
--------------------------- 以上是init-startup.el文件----------------------------
; 一系列快捷命令的扩展
(use-package crux
  :bind (("C-a" . crux-move-beginning-of-line)
         ("C-c ^" . crux-top-join-line)
	     ("C-," . crux-find-user-init-file)
         ("C-S-d" . crux-duplicate-current-line-or-region)
         ("C-S-k" . crux-smart-kill-line))) ; We can use C-S-<Backspace> instead.

; 一次性删除到前/后面的第一个非空字符（删除连续的空白）
(use-package hungry-delete
  :bind (("C-c DEL" . hungry-delete-backward)
         ("C-c d" . hungry-delete-forward)))

; 整行或整段上下移动
(use-package drag-stuff
  :bind (("<M-up>". drag-stuff-up)
         ("<M-down>" . drag-stuff-down)))

; 强化搜索（同时优化了一列Minibuffer的操作）
(use-package ivy
  :defer 1
  :demand
  :diminish
  :hook (after-init . ivy-mode)
  :config (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        ivy-initial-inputs-alist nil
        ivy-count-format "%d/%d "
        enable-recursive-minibuffers t
        ivy-re-builders-alist '((t . ivy--regex-ignore-order))))

(use-package counsel
  :after (ivy)
  :bind (("M-x" . counsel-M-x)
	     ("C-h b" . counsel-descbinds)
	     ("C-h f" . counsel-describe-function)
	     ("C-h v" . counsel-describe-variable)
         ("C-x C-f" . counsel-find-file)
         ("C-c f" . counsel-recentf)
         ("C-c g" . counsel-git)))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper-isearch-backward))
  :config (setq swiper-action-recenter t
                swiper-include-line-number-in-search t))

; 快捷键提醒插件
(use-package which-key
  :defer nil
  :config (which-key-mode))

(use-package company
  :diminish (company-mode " Com.")
  :defines (company-dabbrev-ignore-case company-dabbrev-downcase)
  :hook (after-init . global-company-mode)
  :config (setq company-dabbrev-code-everywhere t
		        company-dabbrev-code-modes t
		        company-dabbrev-code-other-buffers 'all
		        company-dabbrev-downcase nil
		        company-dabbrev-ignore-case t
		        company-dabbrev-other-buffers 'all
		        company-require-match nil
		        company-minimum-prefix-length 1
		        company-show-numbers t
		        company-tooltip-limit 20
		        company-idle-delay 0
		        company-echo-delay 0
		        company-tooltip-offset-display 'scrollbar
		        company-begin-commands '(self-insert-command)))
;; (use-package company-quickhelp
;;   :hook (prog-mode . company-quickhelp-mode)
;;   :init (setq company-quickhelp-delay 0.3))

;; 将minibuffer移到中央位置
(use-package ivy-posframe
  :init
  (setq ivy-posframe-display-functions-alist
        '((swiper .ivy-posframe-display-at-frame-center)
          (complete-symbol .ivy-posframe-display-at-point)
          (counsel-M-x .ivy-posframe-display-at-frame-center)
          (counsel-find-file .ivy-posframe-display-at-frame-center)
          (ivy-switch-buffer .ivy-posframe-display-at-frame-center)
          (t .ivy-posframe-display-at-frame-center)))


; 最好的排序与过滤
(use-package company-prescient
  :init (company-prescient-mode 1))

(use-package restart-emacs)

; 语法检查全局使用
(use-package flycheck
  :hook (after-init . global-flycheck-mode))

; 分屏管理插件
(use-package ace-window
  :bind (("M-o" . 'ace-window)))

(provide 'init-package)
--------------------------- 以上是init-package.el文件----------------------------



--------------------------- 以上是 文件----------------------------


--------------------------- 以上是 文件----------------------------
; 快捷键统计（整理）

C-t  光标前后两个字符互换
M-t  光标前后两个单词互换
M-x sort-lines  文本编辑之行排序
M-=  或者 M-x count-word-regin   对整个buffer中的字数统计
先选中 然后 M-x count-words    统计选中的区域

; buffer管理
C-x b buffer切换
C-x k 杀死当前buffer
; 批量管理buffer
C-x C-b  ; 进入buffer列表
d        ; 标记删除
u        ; 取消当前标记
U        ; 取消全部标记
x        ; 执行操作
?        ; 查看按键帮助
;; 分屏
C-x 3    横向分屏
C-x 2    纵向分屏
C-x 1    只保存当前屏
C-x 0    关闭当前分屏

;; 调整窗口的大小
C-x ^    增加高度
C-x {    增加/减少宽度
C-x }
C-x o    进行窗口的循环跳转（我们用插件替换，但命令行就要使用源配置了）

;; 撤销命令
C-x u      向后撤销
C-g C-x u  向前撤销
