# Emacs第一天（2020.2.26 10:43）

## 1、下载

官网： <https://www.gnu.org/software/emacs/>

Linux下载：`pacman -S emacs` 或者 `pacman -S mingw-w64-x86_64-emacs`

win下载：<http://mirrors.nju.edu.cn/gnu/emacs/windows/> 选择emacs-XX/下载

Mac下载：`brew cask install emacs` 或者 `sudo port install emacs-app`

## 2、初始环境

1、不需要安装，解压缩到某个路径就可以了

2、为了方便全局调用，请添加bin路径到环境变量（比如我的，`C:\opt\emacs-26.3\bin`）。你可能需要先了解下环境变量和命令行的基本知识。搜索关键词“windows环境变量PATH”。

3、“启动cmd”测试下，在cmd里，输入`emacs -nw`[[详情请看简书的一篇教学博客\]](https://www.jianshu.com/p/b4cf683c25f3#fn2)，以终端模式来运行emacs；只输入`emacs`，以GUI模式来运行

4、文档介绍了bin目录下各个exe文件的功能，也介绍了怎样完全卸载，直接删除就好

5、测试完成后，可以运行`bin\addpm.exe`，这样会自动生成配置文件`.emac`和目录`.emacs.d`，并且在启动菜单里添加应用程序快捷方式。另外，官方文档里说还会添加注册表的相关条目。不过在我的电脑上，注册表并未新增相应条目

6、可以在桌面上新建一个快捷方式（shortcut），位置（location）填入`emacs的安装路径\bin\runemacs.exe --debug-init`。加了flag `--debug-init`，是为了方便调试（debug）配置文件。不推荐为`emacs.exe`建立快捷方式，因为会额外启动一个命令行窗口。

7、解决Emacs卡顿问题，首先说明卡顿的原因是Emacs版本对部分中文支持不好，处理办法是：点击菜单栏的Options -> Set Default Font 把默认字体改成宋体，或者换成我使用的字体（YaHei.Consolas.1.11b）文件里已经附带，换好就解决了，这种问题在24.x版之前就不存在。

> **注意**
>
> 如果想让字体设置长期有效，就必须更改配置文件，具体方法如下：
>
> 0、在Emacs窗口设置好以后不要急着退出，打开文件资源管理器
>
> 1、首先打开系统当前用户所在的目录：“C:\用户\登录用户名”
>
> 2、点击【查看】-->勾选【隐藏的项目】
>
> 3、进入显示出来的隐藏目录“AppData”中
>
> 4、接着点击进入“Roaming”目录
>
> 5、进入“.emacs.d”目录，如果该目录不存在，请手动新建一个
>
> 6、新建一个文本文件，把文件名包括扩展名修改为“init.el”,注意文件的扩展名为“.el”，是elisp脚本语言的前两个字母
>
> 7、回到emacs，输入命令【M-x describe-font】连按两次Enter键
>
> PS：
>
> M-x：是键盘快捷键，也就是【Alt + x】组合快捷键。M-x是emacs文档中常用的写法。笔者之所以写出来，是为了让读友尽快熟悉这种写法。
>
> 8、选中：`-outline...-1` 的内容按快捷键【C-w】复制第一行emacs对当前字体的描述
>
> PS：
>
> C-w：是键盘快捷键，也就是【Ctrl + w】组合快捷键。C-w是emacs文档中常用的写法。笔者之所以写出来，是为了让读友尽快熟悉这种写法
>
> 9、用文本编辑器，比如记事本、UE、Gvim等打开init.el文件，输入：`(set-default-font "")`
>
> 然后把复制的字体描述粘贴到""里，保存文件
>
> 10、这样下次启动emacs时，emacs就会读取此配置文件，字体设置得以长久生效。

## 3、基本操作

1、打开emacs，同时按下`Ctrl`和`h`，然后键入`t`，阅读新手教程，熟悉界面，基本术语和操作。**请不要跳过这一步！**（但不要求熟练掌握）本文后面的部分已经假定你阅读了这个教程，所以默认遵循emacs的术语规范。

2、`C`代表`Ctrl`键。`M`代表`Alt`键。`RET`代表`Enter`键（回车键）。`C-x`代表同时按下`Ctrl`和`x`。`C-x d RET`代表先同时按下`Ctrl`和`x`，再按下`d`，最后再按下`RET`。我在后文的按键描述中，会经常省略最后一步的回车操作。另外，请留意描述所用的英文字母的大小写。

3、Emacs里的大部分地方都支持自动补全，快捷键是`TAB`。

## 4、让Emacs变成idea的外部编辑器方法如下：

1、打开diea编辑器

2、File --> settings --> Tools --> External Tools --> 点+添加Emacs --> name:Emacs --- Description:Open Emacs --- Program:Emacs的安装目录选择runemacs.exe --- 将文件路径作为参数传递给程序：在“ 参数”字段中，键入$FilePath$ --- woeking...会自己生成（就是Emacs的bin目录）---> 然后一路确定 ---> 然后你会在状态栏的Tools里的External Tools里看到Emacs

3、为了方便使用我为他设了一个快捷键，步骤如下：

 File --> settings --> keymap --> 然后搜索Emacs --> 右键External Tools下面的Eamcs --> 选择add-key... ---> 我设置的是C-M-shift-e ---> 保存就可以使用

## 5、win cmd编码设置

几种常用的编码:

> 代码页 描述
>
> 65001 UTF-8代码页
>
> 950 繁体中文
>
> 936 GBK(一般情况下为默认编码)
>
> 437 MS-DOS 美国英语

临时的方法：

> 要设置CMD窗口编码格式为UTF-8:
>
> 1.运行CMD 2.在命令行中输入 chcp 65001 回车, 控制台会切换到新的代码页.
>
> 3.在标题栏点击右键, 打开属性面板, 会看到”选项”标签页下方显示”当前代码页”的编码. 然后选择”字体”标签页, 把字体设置为Lucia Console, 然后确定关闭.

> 如果要设置回默认编码: 1.运行CMD
>
> 2.在命令行中输入 chcp 936 回车, 控制台会切换到新的代码页.
>
> 3.这时该代码页的编码已经换为默认, 但可以关闭后重新打开还是其他编码,可以在标题栏点击右键, 打开属性面板, 选择”选项”标签页, 选中”丢弃旧的副本”多选项, 然后确定关闭.

永久生效的方法：

> 在运行中通过regedit进入注册表 找到HKEY_CURRENT_USER\Console%SystemRoot%_system32_cmd.exe 新建一个 DWORD（32位值）,命名为CodePage，值设为65001 已有CodePage的话，修改它，改为十进制，65001

## 6、win键位映射

#### 1、WIN+R下，输入：regedit

#### 2、进入后，直接在划框位置粘贴地址：`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout`

#### 3、在路径目录下(Keyboard Layout)新建二进制值，命名为Scancode Map，下面是我的完成示例，它实现了大小写与左Ctrl键的功能互换、右shift与右Ctrl键功能互换、大小写与esc键功能互换

> 00 00 00 00 00 00 00 00
>
> 06 00 00 00 1D 00 3A 00
>
> 3A 00 01 00 01 00 1D 00
>
> 36 00 1D E0 1D E0 36 00
>
> 00 00 00 00

#### 4、数据格式我是从rainrcn的博客中学到的，里面还详细说明了各种键位的二进制值。涉及修改的部分有三块：

> 映射键数量，示例为一个，根据需要累加 映射后键位，示例为左Ctrl键，根据需要修改 映射前键位，示例为大写键，根据需要修改

我所做的只是替换，并不是交换，交换的方法可以看作是多个替换的组合。目前对我而言，shift大写是足够的了，向hhkb看齐

#### 5、先解释一下每一排的含义

| 0000     | 00 00 00 00 00 00 00 00 | . . . . . . . .           |
| -------- | ----------------------- | ------------------------- |
| 相对地址 | 数据                    | 每对数据所对应的ASCII字符 |

现在解释一下图中我所设置的含义：

> 00,00,00,00,//固定格式 00,00,00,00,//固定格式 02,00,00,00, //02指本行之后还有2行 1c,00,3a,00, //把键盘上的3a,00这个键赋予1c,00的意义，可选，可以同时进行更多的按键映射 00,00,00,00//固定格式

根据我的计划，我的两组映射应该这么来：

按键编码表

| **按键**      | **码表** |
| ------------- | -------- |
| Escape        | 01 00    |
| Tab           | 0F 00    |
| Caps Lock     | 3A 00    |
| Left Alt      | 38 00    |
| Left Ctrl     | 1D 00    |
| Left Shift    | 2A 00    |
| Left Windows  | 5B E0    |
| Right Alt     | 38 E0    |
| Right Ctrl    | 1D E0    |
| Right Shift   | 36 00    |
| Right Windows | 5C E0    |
| Backspace     | 0E 00    |
| Delete        | 53 E0    |
| Enter         | 1C 00    |
| Space         | 39 00    |
| Insert        | 52 E0    |
| HOME          | 47 E0    |
| End           | 4F E0    |
| Num Lock      | 45 00    |
| Page Down     | 51 E0    |
| Page Up       | 49 E0    |
| Scroll Lock   | 46 00    |
| 无动作        | 00 00    |

#### 6、如何让某个键失效？

如果想要某个键失效，将它的扫描码映射为“00 00”即可。

#### 7、如何撤销更改？

若要恢复键盘键位原来的布局，只需定位于注册表[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout] 删除"Scancode Map"键值就可以了

#### 附录：

> **键位表**
>
> Backspace 00 0E Caps Lock 00 3A Delete E0 53 End E0 4F Enter 00 1C Escape 00 01 HOME E0 47 Insert E0 52 Left Alt 00 38 Left Ctrl 00 1D Left Shift 00 2A Left Windows E0 5B Num Lock 00 45 Page Down E0 51 Page Up E0 49 Power E0 5E PrtSc E0 37 Right Alt E0 38 Right Ctrl E0 1D Right Shift 00 36 Right Windows E0 5C Scroll Lock 00 46 Sleep E0 5F Space 00 39 Tab 00 0F Wake E0 63 0 00 52 1 00 4F 2 00 50 3 00 51 4 00 4B 5 00 4C 6 00 4D 7 00 47 8 00 48 9 00 49
>
> - 00 4A /* 00 37 . 00 53 / 00 35 /+ 00 4E Enter E0 1C F1 00 3B F2 00 3C F3 00 3D F4 00 3E F5 00 3F F6 00 40 F7 00 41 F8 00 42 F9 00 43 F10 00 44 F11 00 57 F12 00 58 F13 00 64 F14 00 65 F15 00 66 Down E0 50 Left E0 4B Right E0 4D Up E0 48 Calculator E0 21 E-Mail E0 6C Media Select E0 6D Messenger E0 11 My Computer E0 6B ’ ” 00 28
> - _ 00 0C , < 00 33 . > 00 34 / ? 00 35 ; : 00 27 [ { 00 1A \ | 00 2B ] } 00 1B ` ~ 00 29 = + 00 0D 0 ) 00 0B 1 ! 00 02 2 @ 00 03 3 # 00 04 4 $ 00 05 5 % 00 06 6 ^ 00 07 7 & 00 08 8 * 00 09 9 ( 00 0A A 00 1E B 00 30 C 00 2E D 00 20 E 00 12 F 00 21 G 00 22 H 00 23 I 00 17 J 00 24 K 00 25 L 00 26 M 00 32 N 00 31 O 00 18 P 00 19 Q 00 10 R 00 13 S 00 1F T 00 14 U 00 16 V 00 2F W 00 11 X 00 2D Y 00 15 Z 00 2C Close E0 40 Fwd E0 42 Help E0 3B New E0 3E Office Home E0 3C Open E0 3F Print E0 58 Redo E0 07 Reply E0 41 Save E0 57 Send E0 43 Spell E0 23 Task Pane E0 3D Undo E0 08 Mute E0 20 Next Track E0 19 Play/Pause E0 22 Prev Track E0 10 Stop E0 24 Volume Down E0 2E Volume Up E0 30 ? - 00 7D E0 45 Next to Enter E0 2B Next to L-Shift E0 56 Next to R-Shift E0 73 DBE_KATAKANA E0 70 DBE_SBCSCHAR E0 77 CONVERT E0 79 NONCONVERT E0 7B Internet E0 01 iTouch E0 13 Shopping E0 04 Webcam E0 12 Back E0 6A Favorites E0 66 Forward E0 69 HOME E0 32 Refresh E0 67 Search E0 65 Stop E0 68 My Pictures E0 64 My Music E0 3C Mute E0 20 Play/Pause E0 22 Stop E0 24
>
> - (Volume up) E0 30
>
> - (Volume down) E0 2E Media E0 6D Mail E0 6C Web/Home E0 32 Messenger E0 05 Calculator E0 21 Log Off E0 16 Sleep E0 5F Help(on F1 key) E0 3B Undo(on F2 key) E0 08 Redo(on F3 key) E0 07 Fwd (on F8 key) E0 42 Send(on F9 key) E0 43