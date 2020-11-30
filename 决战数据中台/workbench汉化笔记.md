# 可视化下载

[官网](https://dev.mysql.com/downloads/workbench/)

# 汉化流程

> mysql workbench是oracle为mysql用户提供的一款原生GUI工具，使用起来功能非常强大，但是对于普通的用户来说，它的全英文界面使用起来还是稍有不便，因此可能会有一定的汉化需求。

1. 点击Edit，选择preference。在弹出来的窗口里选择appearence，在右边的configure fonts for里选择simple chinese,这个修改的只是SQL模型里的语言支持。

2. 打开workbench的安装数据目录，路径是：C:\Program Files\MySQL\MySQL Workbench 6.3 CE\data

    打开以后，可以看到下面有一堆的xml结尾的文件，而workbench的菜单就是 main_menu.xml (可以直接替换该文件)

3. 这个时候我们把caption后面对应的值从_File修改为_文件，然后重启workbench再看。可以看到对应的菜单栏就变成中文了
