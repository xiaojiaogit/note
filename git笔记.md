# github学习

## 重温 （2020.6.14）

#### git的本地初始化配置

0、git的配置有三种情况 —> system、global、不写：当前系统、当前用户、当前项目 

1、mkdir XXX —>新建目录XXX

 2、cd XXX —>进入到新建的目录

 3、pwd —>查看当前文件位置

4、 git config --global user.name [CTF-mingwang]   —>设置用户名 

5、git config --global user.email [2633024983@qq.com]  —>设置邮箱 

6、git config –global color.status auto —>设置 git status的颜色。 

7、git config –global core.editor emacs —>指定emacs为编辑器 

8、git config –global merge.tool vimdiff —>你的比较工具(Your Diff Tool)【Git可以接受kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, 和 opendiff作为有效的合并工具】 

9、git config –list —>列出git所有设置 

10、git init —>生成一个.git的文件，用来储存本地仓库的信息

### 学习git管理远程仓库(实现代码共享)

#### 把git仓库的内容克隆到本地

1、git clone 仓库地址 —> 就可以把仓库克隆下来

 2、git push —> 把本地内容推送到git远程仓库

 3、报403错误的时候，处理办法如下：编辑.get/config —> 在[remote “origin”] 处的url = https://用户名:密码@github.com/用户名/仓库名.git 改成这样即可

### 区域

工作区 暂存区 版本库

### 对象

#### Git对象

1、向数据库写入内容 并返回对应键值 命令：scho ‘text countent’ | git hash-object -w –stdin –>根据内容生成内容对应的哈希值，不加-w就不会生成文件 find ./git/object/ -type f 就可以查看对应目录你的文件 

2、git cat-file -p 哈希值 —>就可以看到哈希值对应的内容 把-p换成-t可以看git存储的是什么类型的对象 

3、向数据库写入文件，并返回对应键值 命令：scho hash-object -w 文件路径 —>就可以返回对应的哈希值，win和linux的换行格式不同，LF是win的、CRLF是Linux的（可能写反了） 目录名和文件名组成一个完整的哈希值 

4、git cat-file -p 哈希值 就可以看到哈希值对应的内容（类型是bobl）

#### 树对象

#### 提交对象

## 命令

### 基础

1、git status —>查看当前文件的状况（了解他在那个区域，一般分为：工作区、暂存区、git仓库） 

2、git add ./ 或者 文件名 —>把工作区的文件添加到暂存区 

3、git rm 文件名 —>从git中删除文件

4、git mv 源文件 改后的文件 —>修改文件名 

5、git commit -m “提交描述” —>提交你行为的描述

### 进阶

查看： git diff —>查看哪些更新还没有暂存 git diff –cached 或者 git diff –staged(1.6.1以上) —>查看那些东西已经被缓存了还没有提交 git ls-files -s —>查看当前缓存区的内容 find .git/object/ -type f —>查看库里的文件（回退会用到） 打包： git commit —>方便我们多行编辑,注释多的时候使用 git commit -a -m “提交描述” —>可以跳过git add 直接打包 换名字： 直接git add ./ 即可完成 查看日志（历史记录）： git log —>多行打印日志 git log –pretty=oneline —>让日志在一行打印 git log –oneline —>在一行打印简短日志

## 分支

### 基础

0、使用过git add 命令后下一次打包就可以省略这个步骤—>git commit -a -m “提交内容” 

1、git branch 分支名 —>创建一个可移动的新指针（分支） git branch —>显示所有分支（分支列表） git branch -d 分支名 —>删处分支（注意不能自己删自己，必须切换一个分支进行操作，会有提醒） git branch -D 分支名 —>强制删除 git branch -v —>查看当前分支的最后一次提交 git branch 分支名 哈希值 —>新建一个分支并且指向指定对象（切换到新建分支即可【时光机】） 2、git checkout 分支名 —>切换分支 (注意：切换分支的时候先git status 一下，看看是否打包好了) git checkout -b 分支名 —>新建一个分支并跳转过去 3、测试、合并分支 git merge 要合并的分支 —>这种合并称为快进合并 4、起别名 1、git config –global alias.别名 “命令（参数多的命令需要拿“括起来）” –> 然后 git 别名 就可以使用了 -

### 模拟实战

#### 离线版解bug

0、经理说，你把编号为#53的bug改一下 

1、git log –oneline —>打印简短日志 或者 使用git branch —>查看当前分支 

2、git checkout -b iss53 —>创建新分支，并跳转到该分支(有特殊字符需要用“”包起来) 

3、ll —>查看一下当前分支下有什么文件 

4、emacs(vim) iss53 —>创建文件,开始工作 0、此时老板给你打电话，让改bug 

5、git status —>查看当前分支内容是否提交 

6、git add ./ —>提交已完成的内容（跟踪一下） 

7、git commit -m “提交说明” —>打包压缩提交的文件 

8、git status —>再次擦看当前分支内容是否提交完成(不要嫌烦，安全第一) 

9、git checkout master —>切换到主分支 

10、git log –oneline —>打印简短日志 或者 使用git branch —>查看当前分支 

11、git checkout -b hotbug —>创建一个紧急bug分支，并跳转到该分支 

12、重复3、4、5、6、7、8、9、10的步骤 0、这里的合并使用的是快进合并 

13、git merge hotbug —>把修改后的分支合并到主分支 

14、git log –oneline —>打印简短日志 或者 使用git branch —>查看当前分支 

15、git branch -d hotbug —>删除合并的分支，节省内存 

16、git log –oneline —>打印简短日志 或者 使用git branch —>查看当前分支� 

17、提交到云端（这一步后面具体说） 

0、此时老板交代的完成了，可以接着干我们刚才的事了 

18、git status —>查看当前分支内容是否提交 

19、git checkout iss53 —>切回到我们未完成的分支 

20、重复16查看我们的完成情况（主要是看我们写的注释）

 21、按完成情况开始工作 

22、git status –>查看分支是否提交 

23、git commit -a -m “提交说明” —>打包压缩提交的文件（因为之前追踪过（add）所以可以加-a参数俭省操作流程） 

24、git log –oneline —>打印简短日志 或者 使用git branch —>查看当前分支 

25、修改源文件，然后add提交，最后commit打包压缩完整版（说明为谁打补丁） 

26、git status —>查看当前分支内容是否提交 0、这里采用经典合并（解决自己写代码的冲突）

 27、git checkout master —>切回到主分支 

28、重复14、13、14—> 他会提示文件有冲突，对有冲突的文件进行分析，修改，然后add提交，最后commit打包压缩完整版（合并时关系一定要理清，分支写对）

 29、git branch -d iss53 —>提交完创建的分支就没用了，为了俭省内存，对他进行删除操作 

30、重复24的操作查看最后的提交情况

### git储存

git stash list —>查看栈存储 git stash —>这个命令会将未完成的修改保存到一个栈上（栈的出入方式是：先进后出） 

git log –oneline –>查看是否有提交的操作（事实上有提交，只是不会打印在日志里） 

git status –>查看提交情况，然后就可以之间切换分支了 

git stash apply —>这个命令让你在任何时候重新应用这些改动（他只会调用，不会删除栈里的内容）

git stash drop 栈元素 —>就可以删除栈里的内容（栈元素就：前面的东西）【一般不用】 git stash pop —>应用栈里的数据，并从栈里删除它（栈存储一般不要搞得太复杂）

## 后悔药

### 撤回工作区

git checkout –修改的文件名

### 撤回暂存区

git cat-file -p 哈希码 —>查看哈希码对应的文本内容（黑魔法） git reset HEAD 提交的文件名

### 撤回版本库

git reflog –>查看完整的操作 

git log –oneline —>查看简短的操作 

git ls-files -s —>查看暂存区的内容（提交不会删除暂存区，只有add会覆盖暂存区的内容） 内容写错重新一步一步提交就可以 

git commit –amend —>提示你重新写注释（注释写错了） 当提交以后又进行修改，然后就进行了打包压缩，于是就会出现一绿一红的status结果，撤回方法是：先把第二个也提交了然后执行git commit –amend —>就可以起到撤回的视觉效果，其实它只是把注释覆盖了而已

## 打tag（版本标签）

git tag —>列出所有的tag git tag v1.0 —>给最新的提交打tag git show v1.0 —>查看特定标签的内容 git tag v1.0 指定哈希值 —>改指定哈希打标签 git tag -d v1.0 —>删除标签 git checkout v1.0 —>查看某个版本的对应的分支（会产生头部分离【当你回退到对应的tag上就会产生头部分离】） git checkout -b “v1.0”

## 远程协作的基本流程

### 项目经理

#### 上传仓库

1、创建一个空的新的git仓库，不点最后那个初始化 

2、新建一个本地仓库（就是新建一个文件） 

3、git init —>初始化项目仓库 

0、给类里加点醋

 4、配置用户/邮箱 

5、git remote -v —>显示远程仓库的git别名与其对应的url 

6、git remote add 仓库名 [https://ctf-mingwang.github.io](https://ctf-mingwang.github.io/) —>给仓库地址起一个别名 

7、win搜索凭据管理器 – 把不同凭据里关于github的凭据删除 

8、git push 别名 分支（默认是主分支，master） – 输入用户名 – 密码 等待即可 —>我们创建的是本地分支、他会额外创建一个远程跟踪分支、git上的是远程分支

##### 免密登录的方法

1、复制git仓库的ssh连接 

2、git remote -v —>查看配置别名的类型是https还是ssh 

3、使用 git remote rm origin 命令移除HTTPS的方式 

4、使用命令 git remote add origin git地址 （git地址是上面复制的内容），新添加上SSH方式 

5、还是使用 git remote -v 命令，再次查看clone的地址，会发现git使用的方式变成了SSH方式 

6、 还没完，如果现在就去push的话，它会出现警告 

7、 先使用 ssh -T git@github.com 测试一下，会有（publickey）的结果，可以明显地看出，是因为还没有设置公钥 

8、使用 ssh-keygen -t rsa -C “CTF-mingwang” 命令生成公钥，“CTF-mingwang”是我的GitHub用户名，每个人的都不一样 

9、一路回车后会看到，一个装有不规则符号的方框，表示生成成功（回车的时候可以自定义，也可以默认） 

10、使用 cat *c/Users/kivet*.ssh/id_rsa.pub 命令查看key（具体路径看上面的设置有） 

11、复制密钥，进去GitHub主页–点击用户头像选中Settings–选则ssh and GPG keys –new sshkey–想一个标题，把刚才复制的公钥复制进去 

12、点击“Add ssh key” 输入密码就可以回到本地上传了。

#### 下载仓库

1、git remote -v —>查看项目的别名 

2、git fetch 别名 —>就可以获取内容 

3、git log –oneline –>打印日志 或者使用 git log –pretty=oneline 

4、git checkout 跟踪分支 —>切换分支 

5、重复执行3命令查看结果，ll查看当前目录 

6、git status –>查看暂存区是否干净 

7、重复执行3的命令，再执行【git merge 远程跟踪分支名】进行分支合并，然后【git status】【ll】查看即可

### 成员

git config –global –unset user.name –>清空全局用户名 git config –global –unset user.email –>清空全局邮箱 1、git clone 仓库地址 —>下载仓库 

2、git branch -vv —> 查看是否有跟踪别人