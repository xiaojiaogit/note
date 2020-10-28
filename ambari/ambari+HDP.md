# Ambari+HDP(离线安装)

## 一、安装前文件准备

[HDP：](http://public-repo-1.hortonworks.com/HDP/centos7/2.x/updates/2.6.3.0/HDP-2.6.3.0-centos7-rpm.tar.gz)
[ambari：](http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.6.0.0/ambari-2.6.0.0-centos7.tar.gz)
[HDP-UTILS：](http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.21/repos/centos7/HDP-UTILS-1.1.0.21-centos7.tar.gz)

数据库（Linux版）

jdk（Linux版）

## 二、安装前集群配置步骤

### 注意：处理无法ping的问题

```shell
 # 修改配置文件
 vim /etc/sysconfig/network-scripts/ifcfg-ens33
 
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
# 静态
BOOTPROTO="static"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="ens33"
UUID="d13e6cc0-819d-453e-91c8-44719774f5c6"
DEVICE="ens33"
ONBOOT="yes"
# 配置自己的ip、子网掩码、DNS，114是中国的，用起来会快一点
IPADDR=192.168.249.11
GATEWAY=192.168.249.2
DNS1=114.114.114.114
DNS2=8.8.8.8
```

### 1、关闭防火墙

```shell
# centos6的关闭方式
service iptables stop  #关闭防火墙
chkconfig --list iptables #查看防火墙状态
chkconfig iptables off  #永久关闭防火墙
# centos的关闭方式
systemctl stop firewalld.service   #关闭防火墙
systemctl status firewalld.service  #查看防火墙状态
systemctl disable firewalld.service #永久关闭防火墙
```

### 2、关闭SELINUX

```shell
vim /etc/sysconfig/selinux
将SELINUX=enforcing改为SELINUX=disabled
执行该命令后重启机器生效---配置完全部内容后重启
```

### 3、配置ip映射

```shell
vim /etc/hosts
添加五台集群的IP与主机名，格式如下：
192.168.249.11 h1
192.168.249.12 h2
192.168.249.13 h3
192.168.249.14 h4
192.168.249.15 h5
```

### 4、修改yum源为阿里云镜像

```shell
# 备份
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup

# 下载阿里的镜像文件
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
# 或者
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo

# 生成缓存
yum makecache
```

### 5、安装ntp

```shell
# 安装
yum install -y ntp vim net-tools.x86_64

# 启动服务
systemctl stop ntp   #关闭ntp服务
systemctl status ntpd  #查看ntp服务的状态
systemctl enable ntpd #永久启动
systemctl disable ntpd #永久关闭ntp服务
systemctl start ntpd.service #启动ntp服务
```

### 6、关闭Linux的THP服务

如果不关闭transparent_hugepage,HDFS 会因为这个性能严重受影响。

关闭transparent_hugepage方法是：

```shell
# 编辑文件 /etc/transparent_hugepage
# 6的
vim /etc/grub.conf
# 7的
vim /etc/transparent_hugepage
# 添加如下内容
transparent_hugepage=never

# 编辑 /etc/rc.local
vim /etc/rc.local
# 添加如下内容
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi
if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi
# 保存退出，然后赋予rc.local文件执行权限：
chmod +x /etc/rc.d/rc.local 

# 重启电脑后，使用如下命令检查
cat /sys/kernel/mm/transparent_hugepage/defrag
cat /sys/kernel/mm/transparent_hugepage/enabled
# 表示处于启用状态
[always] madvise never
# 处于关闭状态
always madvise [never]
```

### 7、配置UMASK

设定用户所创建目录的初始权限

```shell
umask 0022
```

### 8、禁止离线更新

```shell
# centos6的
vim /etc/yum/pluginconf.d/refresh-packagekit.conf
#centos7的
vim /etc/yum/pluginconf.d/langpacks.conf
vim /etc/yum/pluginconf.d/fastestmirror.conf
# 修改下面的内容
enabled=0
```

## 三、安装MySQL

Ambari 使用的默认数据库是PostgreSQL,用于存储安装元数据，可以使用自己安装MySQL数据库作为Ambari元数据库。

### 注意：一定要用root用户操纵如下步骤：先卸载MySQL再安装

### 0、7安装MySQL(重要！)  

mysql 下载：官网5.7版本：https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.29-1.el7.x86_64.rpm-bundle.tar

	# 1.rpm 查看 mariadb，是否存在，如果存在必须卸载
		rpm -qa|grep mariadb
			#如: mariadb-libs-5.5.65-1.el7.x86_64
	# 2.卸载 mariadb
		rpm -e --nodeps	mariadb-libs-5.5.65-1.el7.x86_64
	# 3. 为了避免出现权限问题，给 mysql 解压文件所在目录赋予最大权限
		# 在 opt 下创建 mysql 解压目录
			mkdir mysql
		# 设置 mysql 解压目录的权限
			chmod -R 777 mysql
	
		# 安装 MySQL 需要的一些依赖程序
			yum -y install make gcc-c++ cmake bison-devel ncurses-devel libaio libaio-devel net-tools
	
	#4. 解压 mysql-5.7.29-1.el7.x86_64.rpm-bundle.tar 到/opt/mysql
		tar -xvf mysql-5.7.29-1.el7.x86_64.rpm-bundle.tar -C /opt/mysql/
	#5. 严格按照顺序安装：
		# mysql-community-common-5.7.29-1.el7.x86_64.rpm、
		# mysql-community-libs-5.7.29-1.el7.x86_64.rpm、
		# mysql-community-client-5.7.29-1.el7.x86_64.rpm、
		# mysql-community-server-5.7.29-1.el7.x86_64.rpm这四个包
		# cd 到 mysql 目录下，依次输入命令
			1. rpm -ivh mysql-community-common-5.7.29-1.el7.x86_64.rpm
			2. rpm -ivh mysql-community-libs-5.7.29-1.el7.x86_64.rpm
			3. rpm -ivh mysql-community-client-5.7.29-1.el7.x86_64.rpm
			4. rpm -ivh mysql-community-server-5.7.29-1.el7.x86_64.rpm
	#6. 配置数据库
		vim /etc/my.cnf
		# 在 [mysqld] 下添加这三行
			skip-grant-tables
			character_set_server=utf8
			init_connect='SET NAMES utf8'
		# skip-grant-tables：跳过登录验证
		# character_set_server=utf8：设置默认字符集UTF-8
		# init_connect='SET NAMES utf8'：设置默认字符集UTF-8
	#7. 启动服务
		systemctl start mysqld.service #启动服务
		systemctl disable mysql.service #关闭服务
	#8. 启动 mysql
		输入 mysql
	#9. 先设置一个简单的临时密码
		update mysql.user set authentication_string=password('root') where user='root';
		# 立即生效
			flush privileges;
	#10. 退出（exit）mysql 再次登录
		mysql -uroot -proot
		# 重设密码
			set password=password('root');
		# 立即生效
			flush privileges;
	#11. 进入 mysql
		mysql -uroot -proot
		# 赋值权限
			alter user user() identified by "root";
		# 刷新
			flush privileges;
	#12. 使用 MySQL 数据库
		use mysql;
		# 查询 user 表
			select User,Host from user;
	#13. 修改 user 表，把 Host 表内容修改为 %
		update user set host='%' where host='localhost';
	#14. 删除 root 用户的其他 host
		delete from user where Host='h1';
		delete from user where Host='127.0.0.1';
		delete from user where Host='::1';
		# 刷新
			flush privileges;
		# 查询 user 表修改之后的结果
			select User,Host from user;
		# 退出
### 1、6安装MySQL

1）查看MySQL是否安装

```shell
rpm -qa | grep mysql
```

2) 如果安装了MySQL，就先卸载

```shell
rpm -e --nodeps mysql-libs.zip

# 安装MySQL需要的一些依赖程序
yum -y install make gcc-c++ cmake bison-devel ncurses-devel libaio libaio-devel net-tools
```

3) 解压我们上传的文件到当前目录

```shell
# zip文件用以下命令
unzip mysql-libs.zip
```

4) 安装MySQL服务端

```shell
rpm -ivh MySQL-server-5.6.24-1.el6.x86_64.rpm
```

5) 查看产生的随机密码

```shell
cat /root/.mysql_secret
```

6） 服务操作

```shell
systemctl stop mysql   #关闭
systemctl status mysql  #查看状态
systemctl start mysql.service #启动服务
systemctl disable mysql.service #永久打开
```

7) 安装MySQL客户端

```shell
rpm -ivh MySQL-client-5.6.24-1.el6.x86_64.rpm
```

8) 连接MySQL

```shell
# 查看临时密码
cat /root/.mysql_secret
# 登录
mysql -uroot -p
```

8） 设置Mysql密码

```shell
SET PASSWORD=PASSWORD('root');
```

9) 退出MySQL

```shell
exit
```

### 2、使用 (允许所有主机以root身份登录)

1）进入MySQL

```shell
mysql -uroot -proot
```

2) 显示数据库

```mysql
show databases;
```

3) 使用MySQL数据库

```mysql
use mysql;
```

4) 展示MySQL数据库中的所有表

```mysql
show tables;
```

5) 展示user表的结构

```mysql
desc user；
```

6) 查询user表

```mysql
select User,Host,Password from user;
```

7) 修改user表，把Host表内容修改为%

```mysql
update user set host='%' where host='localhost';
```

8) 删除root用户的其他host

```mysql
delete from user where Host='h1';
delete from user where Host='127.0.0.1';
delete from user where Host='::1';
```

9) 刷新

```mysql
flush privileges;
```

10) 推出

```mysql
quit;
```

## 四、搭建Ambari集群本地源

### 注意：一下操作主节点即可

### 1、制作本地源

因为在线安装忒慢，所以选择制作本地源，而制作本地源只需在主节点上进行。

### 2、配置HTTPD服务

配置HTTPD服务到系统层使其随系统自动启动

```shell
# centos6 命令
chkconfig httpd on
service httpd start

# centos7 命令
yum install -y systemctl httpd #下载httpd服务

systemctl start httpd.service #启动
systemctl stop httpd.service #停止
systemctl restart httpd.service #重启

systemctl enable httpd.service #开机启动
systemctl disable httpd.service #开机不启动

systemctl status httpd.service  #查看状态
```

### 3、安装工具

安装本地源制作相关工具

```shell
# 下载相关工具
yum install yum-utils createrepo yum-plugin-priorities -y
# 修改该文件
vim /etc/yum/pluginconf.d/priorities.conf
# 添加如下内容
gpgcheck=0
```

### 4、将下载的3个tar包解压到指定目录

```shell
tar -zxvf ambari-2.6.0.0-centos7.tar.gz -C /var/www/html/

mkdir /var/www/html/hdp
tar -zxvf HDP-2.6.3.0-centos7-rpm.tar.gz -C /var/www/html/hdp/

tar -zxvf HDP-UTILS-1.1.0.21-centos7.tar.gz -C /var/www/html/hdp/
```

### 5、创建本地源

```shell
# 进入如下目录
cd /var/www/html/
# 执行如下命令
createrepo ./
```

### 6、将Ambari储存库文件下载到安装主机上的目录

```shell
curl -o /etc/yum.repos.d/ambari.repo http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.6.0.0/ambari.repo
```

### 7、修改配置文件，配置为本地源

```shell
# 修改文件ambari.repo，配置为本地源
vim /etc/yum.repos.d/ambari.repo

# 修改如下内容
baseurl=http://h1/ambari/centos7/2.6.0.0-267/
gpgcheck=0
gpgkey=http://h1/ambari/centos7/2.6.0.0-267/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins


# 修改文件hdp-util.repo，配置为本地源
vim /var/www/html/hdp/hdp-util.repo

# 修改如下内容
baseurl= http://h1/hdp/
gpgcheck=0


# 修改文件hdp.repo，配置为本地源
vim /var/www/html/hdp/HDP/centos7/2.6.3.0-235/hdp.repo

# 修改如下内容
baseurl=http://h1/hdp/HDP/centos7/2.6.3.0-235/
gpgcheck=0
gpgkey=http://h1/hdp/HDP/centos7/2.6.3.0-235/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins

baseurl=http://h1/hdp
gpgcheck=0
gpgkey=http://h1/hdp/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins


# 查看是否有Ambari
yum repolist

# 查看 Ambari 与 HDP 资源的资源库
# 也可以在浏览器查看
http://h1/ambari/centos7/
http://h1/hdp/HDP/centos7/
http://h1/hdp/
```

## 五、 配置时间服务器（hadoop11）

### 1、主机配置

#### 1）.安装ntp服务：

```shell
[mingwang@hadoop11 root]$ sudo yum -y install ntp
```

#### 2）. 设置时间配置文件

```shell
[mingwang@hadoop11 ~]$ sudo vim /etc/ntp.conf
#修改一（设置本地网络上的主机不受限制）
#restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap 为
restrict 192.168.239.0 mask 255.255.255.0 nomodify notrap
# 指明互联网和局域网中作为NTP服务器的IP
#server 210.72.145.44 perfer
#server 202.112.10.36
#server 59.124.196.83
#server 172.24.0.11
# 中国国家受时中心
# 1.cn.pool.ntp.org
# 0.esia.pool.ntp.org
# 局域网中NTP服务的IP

#修改二（添加默认的一个内部时钟数据，使用它为局域网用户提供服务）
server 127.127.1.0
fudge 127.127.1.0 stratum 10
#修改三（设置为不采用公共的服务器）
server 0.centos.pool.ntp.org iburst
server 1.centos.pool.ntp.org iburst
server 2.centos.pool.ntp.org iburst
server 3.centos.pool.ntp.org iburst 为
#server 0.centos.pool.ntp.org iburst
#server 1.centos.pool.ntp.org iburst
#server 2.centos.pool.ntp.org iburst
#server 3.centos.pool.ntp.org iburst
```

#### 3）. 设置BIOS与系统时间同步

```shell
[mingwang@hadoop11 ~]$ sudo vim /etc/sysconfig/ntpd
#增加如下内容（让硬件时间与系统时间一起同步）
OPTIONS="-u ntp:ntp -p /var/run/ntpd.pid -g"
SYNC_HWCLOCK=yes
```

#### 4）. 启动ntp服务并测试

```shell
[mingwang@hadoop11 ~]$ sudo systemctl start ntpd
[mingwang@hadoop11 ~]$ systemctl status ntpd
#设置ntp服务开机自启
[mingwang@hadoop11 ~]$ sudo systemctl enable ntpd.service

#测试
[mingwang@hadoop11 ~]$ netstat -tlunp | grep ntp  
[mingwang@hadoop11 ~]$ ntpstat
synchronised to local net (127.127.1.0) at stratum 11
   time correct to within 3948 ms
   polling server every 64 s
[mingwang@hadoop11 ~]$ sudo ntpq -p
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
*LOCAL(0)        .LOCL.          10 l   26   64    3    0.000    0.000   0.000
```

### 2、其它节点与时间服务器同步时间

**先关闭非时间服务器节点的ntpd服务sudo systemctl stop ntpd**

#### 1）. 手动同步

```shell
#设置时区为Asia/Shanghai
[mingwang@hadoop12 ~]$ sudo timedatectl set-timezone Asia/Shanghai

[mingwang@hadoop12 ~]$ date 
2020年 11月 24日 星期二 11:25:20 CST
```

#### 2）. 定时同步

在其他机器配置10分钟与时间服务器同步一次

```shell
#非时间服务器都安装crond服务
[mingwang@hadoop12 ~]$ sudo yum -y install vixie-cron crontabs
#非时间服务器节点都编写定时同步时间任务
[mingwang@hadoop12 ~]$ crontab -e
[mingwang@hadoop12 ~]$ sudo vim /etc/crontab
编写定时任务如下：
*/1 * * * * /usr/sbin/ntpdate hadoop11

#加载任务,使之生效
[mingwang@hadoop12 ~]$ sudo crontab /etc/crontab
```

修改时间服务器时间

```shell
[mingwang@hadoop12 ~]$ sudo date -s "2020-9-2 11:33:11"
```

十分钟后查看机器是否与时间服务器同步

```shell
[mingwang@hadoop12 ~]$ date
ps：测试的时候可以将10分钟调整为1分钟，节省时间
```

## 六、安装Ambari

### 1、安装ambari-server

```shell
yum install ambari-server -y
```

### 2、拷贝mysql驱动

1) 将mysql-connector-java-8.0.21.jar复制到user/share/java目录下并改名为mysql-connector-java.jar

```shell
# 新建目录
mkdir /usr/share/java

# 拷贝文件到指定位置
cp mysql-connector-java-8.0.21.jar /usr/share/java/mysql-connector-java.jar

```

2) 将mysql-connector-java.jar 复制到 /var/lib/ambari-server/resources 目录下并改名为 mysql-jdbc-driver.jar

```shell
cp /usr/share/java/mysql-connector-java.jar  /var/lib/ambari-server/resources/mysql-jdbc-driver.jar
```

3) 修改 ambari.properties 文件

```shell
vim /etc/ambari-server/conf/ambari.properties
# 添加如下内容

# 我添加的
server.jdbc.driver.path=/usr/share/java/mysql-connector-java.jar
```

### 3、在MySQL中创建数据库

1) 创建ambari库

```mysql
# 登录
mysql -uroot -p
# 创建
create database ambari;
```

2) 使用Ambari自带脚本创建表

```mysql
use ambari;
source /var/lib/ambari-server/resources/Ambari-DDL-MySQL-CREATE.sql
```

3) 赋予用户root权限

```mysql
grant all privileges on *.* to 'root'@'%' identified by 'root';
```

4) 刷新

```mysql
flush privileges;
```

5) 退出

```mysql
exit
```

### 4、JDK配置

```shell
# 解压
tar -zxvf jdk-8u261-linux-x64.tar.gz

#配置环境变量
vim /etc/profile

# 配置如下
export JAVA_HOME=/opt/jdk1.8.0_261
export JRE_HOME=$JAVA_HOME/jre
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH	

#刷新
source /etc/profile

# 测试
java
```

### 5、配置Ambari

1) 执行

```shell
ambari-server setup
```

2) 设置参数

```shell
Customize user account for ambari-server daemon [y/n] (n)? y
Enter choice (1): 3
Enter advanced database configuration [y/n] (n)? y
Enter choice (1): 3
Hostname (localhost): h1
Port (3306):
Database name (ambari):
Username (ambari): root
Enter Database Password (bigdata): # 输入看不到
Re-enter password: # 重复输入
Proceed with configuring remote database connection properties [y/n] (y)?
```

## 七、启动Ambari

1）启动命令

```shell
ambari-server start
```

2）停止命令

```shell
ambari-server stop
```

## 七、HDP集群部署

### 1、集群搭建

1）进入登陆页面

```shell
浏览器输入 http：//h1:8080
默认管理员密码：admin
```

## 问题解决

1. 
   vi /etc/ambari-agent/conf/ambari-agent.ini

   

   [security]

   force_https_protocol=PROTOCOL_TLSv1_2

    

2. vi /etc/python/cert-verification.cfg 

    

   [https] 

   verify=disable



# mysql问题

1.下载mysql安装包。
下载地址：[https://dev.mysql.com/downloads/mysql/](https://links.jianshu.com/go?to=https%3A%2F%2Fdev.mysql.com%2Fdownloads%2Fmysql%2F) 可以选择自己想要的类型。
2.解压安装及运行如下：

2.解压安装及运行如下：

```csharp
//解压
[root@VM_0_15_centos home]# tar -xf mysql-8.0.20-linux-glibc2.12-x86_64.tar.xz
[root@VM_0_15_centos home]# mv mysql-8.0.20-linux-glibc2.12-x86_64 /usr/local/mysql
[root@VM_0_15_centos home]# cd /usr/local/mysql
[root@VM_0_15_centos home]# mkdir data
```

```csharp
//创建mysql用户，并给对应的文件夹权限
[root@VM_0_15_centos home]# adduser mysql
[root@VM_0_15_centos home]# chown -R mysql:mysql /user/local/mysql/
[root@VM_0_15_centos home]# chmod -R 775 /usr/local/mysql
```

```csharp
[root@VM_0_15_centos home]# cd bin
//初始化mysql
[root@VM_0_15_centos bin]# ./mysqld --initalize --user=mysql --datadir=/usr/local/mysql/data --basedir=/usr/local/mysql
//出现错误
./mysqld: error while loading shared libraries: libnuma.so.1: cannot open shared object file: No such file or directory 
//解决方法
[root@VM_0_15_centos bin]# yum -y install numactl

//再初始化成功，并生成临时密码！
[root@VM_0_15_centos bin]# mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
2020-06-15T13:55:59.427118Z 0 [Warning] [MY-011070] [Server] 'Disabling symbolic links using --skip-symbolic-links (or equivalent) is the default. Consider not using this option as it' is deprecated and will be removed in a future release.
2020-06-15T13:55:59.427208Z 0 [System] [MY-013169] [Server] /usr/local/mysql/bin/mysqld (mysqld 8.0.20) initializing of server in progress as process 17608
2020-06-15T13:55:59.434082Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
2020-06-15T13:56:02.505867Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
2020-06-15T13:56:05.099467Z 6 [Note] [MY-010454] [Server] A temporary password is generated for root@localhost: ECUtpahf=8oe
```

```csharp
//编辑配置文件
[root@VM_0_15_centos bin]# vim /etc/my.cnf
[mysqld]
port=3306
user=mysql
datadir=/usr/local/mysql/data
socket=/var/lib/mysql/mysql.sock
symbolic-links=0
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

//配置开机启动项
[root@VM_0_15_centos bin]# cd ../support-files
[root@VM_0_15_centos support-files]# cp mysql.server /etc/init.d/mysqld
[root@VM_0_15_centos support-files]# chmod 755 /etc/init.d/mysqld
[root@VM_0_15_centos support-files]# chkconfig --add mysqld
[root@VM_0_15_centos support-files]# chkconfig --list mysqld
```

```tsx
//启动
[root@VM_0_15_centos support-files]# ./mysql.server start --user=mysql
Starting MySQL.Logging to '/usr/local/mysql/data/VM_0_15_centos.err'.
. SUCCESS! 

//查看进程
[root@VM_0_15_centos support-files]# ps -ef|grep mysql
root     19648     1  0 22:05 pts/1    00:00:00 /bin/sh /usr/local/mysql/bin/mysqld_safe --datadir=/usr/local/mysql/data --pid-file=/usr/local/mysql/data/VM_0_15_centos.pid --user=mysql
mysql    19826 19648 14 22:05 pts/1    00:00:01 /usr/local/mysql/bin/mysqld --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --plugin-dir=/usr/local/mysq/lib/plugin --user=mysql --log-error=VM_0_15_centos.err --pid-file=/usr/local/mysql/data/VM_0_15_centos.pid --socket=/var/lib/mysql/mysql.sock --port=3306
root     19900 12352  0 22:05 pts/1    00:00:00 grep --color=auto mysql

//修改sock的软连接，/var/lib/mysql/mysql.sock是my.cnf文件中配置的路径
[root@VM_0_15_centos support-files]# ln -s /var/lib/mysql/mysql.sock /tmp/mysql.sock
```

```bash
//配置环境变量
[root@VM_0_15_centos support-files]# vim /etc/profile
...
#配置mysql环境变量
MYSQL_HOME=/usr/local/mysql
PATH=$PATH:$MYSQL_HOME/bin
export PATH MYSQL_HOME
...
[root@VM_0_15_centos support-files]# source /etc/profile
```

登录mysql，修改默认root密码

```csharp
[root@VM_0_15_centos support-files]# mysql -uroot -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 13
Server version: 8.0.20
Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.
Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
mysql>  
//修改默认用户密码
mysql> alter user 'root'@'localhost' identified by 'yourpass';
Query OK, 0 rows affected (0.02 sec)
mysql> 
//查看用户host地址
mysql> select user,host from mysql.user;
+------------------+-----------+
| user             | host      |
+------------------+-----------+
| mysql.infoschema | localhost |
| mysql.session    | localhost |
| mysql.sys        | localhost |
| root             | localhost |
+------------------+-----------+
4 rows in set (0.01 sec)

mysql> 
mysql> use mysql;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A
Database changed
mysql> 
//修改root用户host为任何主机
mysql> update user set host='%' where user='root';
Query OK, 1 row affected (0.04 sec)
Rows matched: 1  Changed: 1  Warnings: 0
mysql> 
mysql> flush privileges;
Query OK, 0 rows affected (0.01 sec)
mysql> 
```

