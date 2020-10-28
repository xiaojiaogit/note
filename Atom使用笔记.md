# atom使用记录
> keyboard Maestro  --> mac上全局快捷键软件

## Atom改国内源
```shell
linux
#进入目录
cd /home/你的用户名/.atom
#创建文件并编辑
vim .apmrc
#添加国内源
registry=https://registry.npm.taobao.org
#保存退出
#测试是否成功
apm install --check
```

```shell
windows
#进入目录
找到C:\Users\用户名\.atom目录
#创建名为 .apmrc 的文件并编辑
#添加国内源
registry=https://registry.npm.taobao.org
strict-ssl=false
#保存退出
#测试是否成功
apm install --check
重新打开atom搜索安装插件即可
```

## 界面设置
csp -->搜索style --> 选择长的

atom-text-editor .wrap-guide {
  visibility: hidden;       --> 去掉中间的竖线，很讨厌
}

.tree-view .tree-view-root {
  padding-left: 8;          --> 设置目录树边距
}

.list-tree.has-collapsable-children .list-nested-item > .list-tree > li, .list-tree.has-collapsable-children .list-nested-item > .list-group > li {
  padding-left: 16px;
}

.list-tree.has-collapsable-children .list-nested-item > .list-item::before {
  margin-right: 18px;
}

.list-tree.has-collapsable-children .list-nested-item > .list-item::before {
  margin-left: 24px;
}



## 快捷键 \ 转义字符
Ctrl + ,  --> 打开设置面板
ctrl + \` --> 打开终端
ctrl + shift + c --> 打开css颜色面板
ctrl + shift + p --> 打开搜索框
ctrl + shift + i --> 打开调试窗口

## 快捷键设置
'body':
  'cmd-1': 'pane:show-previous-item'  --> 上一个标签
  'cmd-2': 'pane:show-next-item'  --> 下一个标签

'atom-workspace atom-text-editor:not([mini])':
  'cmd-3': 'editor:fold-current-row'  --> 折叠代码
  'cmd-4': 'editor:unfold-current-row'  --> 打开折叠的代码

'atom-text-editor:not([mini])':
  'cmd-e': 'emmet:expand-abbreviation'   --> 自定义标签快捷操作

## 插件安装
platformio-ide-terminal  --> 打开终端
autocomplete-modules  --> 非常实用的一款，自动检测导入包所在位置，及路径
color-plcker  --> css颜色面板
emmet --> 代码补全
linter --> 自动语法检测
prettier-atom --> 语法格式化
sync-settings --> 备份设置，需要在GitHub上操作
atom-material-ui --> 主题

simplified-chinese-menu   --> 汉化
file-icons  --> 图标美化
minimap  --> 小地图
activate-power-mode  --> 输入时有震撼效果

merge-conflicts  --> 在 Atom 里面处理合并产生冲突的文件
tortoise-svn  --> svn
vim-mode-plus --> vim
emacs-plus  --> emacs

markdown-preview-enhanced  --> markdown
browser-plus --> 内置浏览器
open-in-browsers  --> 在安装过的任意浏览器打开代码
atom-html-preview -->   实时预览HTML页面

go-plus  --> go语言支持
java-plus
atom-ide-ui  --> 集成ide
ide-go
ide-scala
ide-java
ide-html






















## @@@@@@@@@@@@@@@@@@@@@@@@@@@@
