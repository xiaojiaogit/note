zabbix(集群监控框架)-笔记

zabbix是一款能够监控各种网络参数以及服务器健康性和完整性的软件。

官网：
zabbix.com
上官网查找对应的版本安装方式，网站的下方可以看到相关的内容


软件安装：
主机名
ip映射
关闭防火墙
sudo service iptables stop
sudo chkconfig iptables off

关闭SELinux
sudo vim /etc/selinux/config
selinux=disabled

查看datanode的命令：
ps -ef | grep -E datanode | grep -v grep | wc -l