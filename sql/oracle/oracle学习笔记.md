# oracle学习笔记
## 下载与安装：

### 下载
[oracle官网下载地址](https://www.oracle.com/database/technologies/oracle-database-software-downloads.html)
### 安装
#### win系统
> 以11g为例
1、下载完成后我们找到下载好的文件然后解压
（注意：这里建议将两个文件分别解压到两个文件夹中）
2、解压完成后将“2of2”中的“database”文件夹复制到“1of2”中（意思就是将“2of2”中的“database”与“1of2”的整合到一起）
3、整合完成后打开，点击图中所示的“setup.exe”应用程序
4、然后会出现cmd控制台
（注意：此时什么也不要操作，等待Oracle安装程序检测就好了）
#### linux系统
> 不同的操作系统对应不同的oracle版本
> Centos/Redhat6+Oracle 11g(11.2.0.4)
> Centos/Redhat7+Oracle 12c(12.2.0.1)
##### 配置本地yum源
> vm学习环境，可以在vm上设置镜像
1、df -h 查看磁盘挂载情况
2、mount /dev/cdrom /media 挂载光盘
3、umount /dev/分区名       卸载光盘
> 生产环境，可以直接把镜像文件上传到服务器上，进行挂载操作
mount -t iso9660 -o loop 镜像文件所在位置 /media    挂载镜像
> 配置yum源文件
'''shell
cd 到 /etc/yum.repos.d 目录下把所有的文件移动到新创建的bak目录下

vim /etc/yum.repos.d/myyum.repo        # 必须以.repo结尾,插入以下内容
[myyum]
name=oracle_install
baseurl=file:///meida
enable=1
gpgcheck=0

enabled=1   # 为1,表示启用yum源; 0为禁用
gpgcheck=0  # 为1,使用公钥检验rpm包的正确性,0为不校验


yum clean all     # 清空yum缓存
yum makecache     # 缓存

yum install -y vim  # 测试以下
'''
##### 修改ip/关闭selinux/关闭防火墙
'''shell
# ip
IPADDR=192.168.12.1
NETMASK=255.255.255.0
GATEWAY=192.168.12.2
DNS1=114.114.114.114
systemctl restart network

# selinux
vi /etc/selinux/config
SELINUX=disabled

# 关闭防火墙
systemctl stop firewalld.service
systemctl disable firewalld.service
iptables -L
# 重启后iptables依然从在策略
systemctl status libvirtd.service
systemctl stop libvirtd.service
systemctl disable libvirtd.service
iptables -L
'''
##### 查看内存的两个方法
'''shell
free
cat /proc/meminfo
'''
##### 关闭透明大页,启用标准大页
'''shell
关闭 Linux 的 THP（透明大页）服务:
查看是否启动 THP:
cat  /sys/kernel/mm/transparent_hugepage/enabled
# 表示处于启用状态
[always] madvise never
# 处于关闭状态
always madvise [never]
编辑文件 /etc/rc.local
vim /etc/rc.local
添加如下内容:
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi
if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi
保存退出，然后赋予 rc.local 文件执行权限：
chmod +x /etc/rc.d/rc.local
'''
##### 安装依赖包-----1
yum install -y automake autotools-dev binutils bzip2 elfutils expat \
gawk gcc gcc-multilib g++-multilib lib32ncurses5 lib32z1 \
ksh less lib32z1 libaio1 libaio-dev libc6-dev libc6-dev-i386 \
libc6-i386 libelf-dev libltdl-dev libodbcinstq4-1 libodbcinstq4-1:i386 \
libpth-dev libpthread-stubs0-dev libstdc++5 make openssh-server rlwrap \
rpm sysstat unixodbc unixodbc-dev unzip x11-utils zlibc unzip cifs-utils \
libXext.x86_64  glibc.i686

yum -y install xz wget gcc-c++ ncurses ncurses-devel \
cmake make perl openssl openssl-devel gcc* libxml2 \
libxml2-devel curl-devel libjpeg* libpng* freetype* \
make gcc-c++ cmake bison perl perl-devel  perl perl-devel \
glibc-devel.i686 glibc-devel libaio readline-devel \
zlib.x86_64 zlib-devel.x86_64 libcurl-* net-tool*  \
sysstat lrzsz dos2unix telnet.x86_64 iotop unzip \
ftp.x86_64 xfs* expect vim psmisc openssh-client* \
libaio bzip2  epel-release automake binutils bzip2 \
elfutils expat gawk gcc  ksh less make openssh-server \
rpm sysstat unzip unzip cifs-utils libXext.x86_64  \
glibc.i686 binutils compat-libstdc++-33 \
elfutils-libelf elfutils-libelf-devel \
expat gcc gcc-c++ glibc glibc-common \
glibc-devel glibc-headers libaio \
libaio-devel libgcc libstdc++ libstdc++-devel \
make sysstat unixODBC unixODBC-devel libnsl

##### 更新依赖包
yum update

##### 创建oracle用户和组
'''shell
# 采用以下内容
groupadd -g 502 oinstall
groupadd -g 503 dba
groupadd -g 504 oper
groupadd -g 505 asmadmin
useradd -u 502 -g oinstall -G oinstall,dba,asmadmin,oper -s /bin/bash -m oracle
passwd oracle
'''

##### 解压安装包
操作用户：oracle
操作目录：/home/oracle

把下载好的两个文件上传到操作目录

unzip /home/oracle/linux.x64_11gR2_database_1of2.zip
unzip /home/oracle/linux.x64_11gR2_database_2of2.zip
##### 修改安全设置
操作用户：root
vi /etc/security/limits.conf
在文件最后追加如下内容（vi使用方法略）：
'''shell
oracle    soft    nproc    2047
oracle    hard    nproc    16384
oracle    soft    nofile    1024
oracle    hard    nofile    65536
oracle    soft    stack    10240
'''

##### 创建目录
操作用户：oracle
mkdir -p ~/tools/oracle11g
##### 修改环境变量
操作用户：oracle
操作目录：/home/oracle
vi ~/.bash_profile
在文件最后追加如下内容（vi使用方法略）：
export ORACLE_BASE=/home/oracle/tools/oracle11g
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/dbhome_1
export ORACLE_SID=orcl
export ORACLE_UNQNAME=orcl
export NLS_LANG=.AL32UTF8
export PATH=${PATH}:${ORACLE_HOME}/bin/:$ORACLE_HOME/lib64;
执行以下命令使其生效：
source ~/.bash_profile
##### 定义安装相应文件
操作用户：oracle
操作目录：/home/oracle
复制文件模板:
cp /home/oracle/database/response/db_install.rsp .
修改文件（vi使用方法略）:
vi db_install.rsp
模板内容修改如下（目录、用户等没有变化的情况下，可以直接使用），修改出使用粗体标出：
'''shell
####################################################################
## Copyright(c) Oracle Corporation 1998,2008. All rights reserved.##
##                                                                ##
## Specify values for the variables listed below to customize    ##
## your installation.                                            ##
##                                                                ##
## Each variable is associated with a comment. The comment        ##
## can help to populate the variables with the appropriate        ##
## values.   ##
##                                                                ##
## IMPORTANT NOTE: This file contains plain text passwords and    ##
## should be secured to have read permission only by oracle user  ##
## or db administrator who owns this installation.                ##
##                                                                ##
####################################################################

#------------------------------------------------------------------------------

# Do not change the following system generated value.

#------------------------------------------------------------------------------

oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v11_2_0

#------------------------------------------------------------------------------

# Specify the installation option.

# It can be one of the following:

# 1. INSTALL_DB_SWONLY

# 2. INSTALL_DB_AND_CONFIG

# 3. UPGRADE_DB

#-------------------------------------------------------------------------------

oracle.install.option=INSTALL_DB_AND_CONFIG

#-------------------------------------------------------------------------------

# Specify the hostname of the system as set during the install. It can be used

# to force the installation to use an alternative hostname rather than using the

# first hostname found on the system. (e.g., for systems with multiple hostnames

# and network interfaces)

#-------------------------------------------------------------------------------

ORACLE_HOSTNAME=localhost

#-------------------------------------------------------------------------------

# Specify the Unix group to be set for the inventory directory. 

#-------------------------------------------------------------------------------

UNIX_GROUP_NAME=oinstall

#-------------------------------------------------------------------------------

# Specify the location which holds the inventory files.

#-------------------------------------------------------------------------------

INVENTORY_LOCATION=/home/oracle/tools/oraInventory

#-------------------------------------------------------------------------------

# Specify the languages in which the components will be installed.           

#

# en  : English                  ja  : Japanese                 

# fr  : French                  ko  : Korean                   

# ar  : Arabic                  es  : Latin American Spanish   

# bn  : Bengali                  lv  : Latvian                 

# pt_BR: Brazilian Portuguese    lt  : Lithuanian               

# bg  : Bulgarian                ms  : Malay                   

# fr_CA: Canadian French          es_MX: Mexican Spanish         

# ca  : Catalan                  no  : Norwegian               

# hr  : Croatian                pl  : Polish                   

# cs  : Czech                    pt  : Portuguese               

# da  : Danish                  ro  : Romanian                 

# nl  : Dutch                    ru  : Russian                 

# ar_EG: Egyptian                zh_CN: Simplified Chinese       

# en_GB: English (Great Britain)  sk  : Slovak                   

# et  : Estonian                sl  : Slovenian               

# fi  : Finnish                  es_ES: Spanish                 

# de  : German                  sv  : Swedish                 

# el  : Greek                    th  : Thai                     

# iw  : Hebrew                  zh_TW: Traditional Chinese     

# hu  : Hungarian                tr  : Turkish                 

# is  : Icelandic                uk  : Ukrainian               

# in  : Indonesian              vi  : Vietnamese               

# it  : Italian                                                 

#

# Example : SELECTED_LANGUAGES=en,fr,ja

#------------------------------------------------------------------------------

SELECTED_LANGUAGES=en,zh_CN

#------------------------------------------------------------------------------

# Specify the complete path of the Oracle Home.

#------------------------------------------------------------------------------

ORACLE_HOME=/home/oracle/tools/oracle11g/product/11.2.0/dbhome_1

#------------------------------------------------------------------------------

# Specify the complete path of the Oracle Base.

#------------------------------------------------------------------------------

ORACLE_BASE=/home/oracle/tools/oracle11g

#------------------------------------------------------------------------------

# Specify the installation edition of the component.                       

#                                                           

# The value should contain only one of these choices.       

# EE    : Enterprise Edition                               

# SE    : Standard Edition                                 

# SEONE  : Standard Edition One

# PE    : Personal Edition (WINDOWS ONLY)

#------------------------------------------------------------------------------

oracle.install.db.InstallEdition=EE

#------------------------------------------------------------------------------

# This variable is used to enable or disable custom install.

#

# true  : Components mentioned as part of 'customComponents' property

#        are considered for install.

# false : Value for 'customComponents' is not considered.

#------------------------------------------------------------------------------

oracle.install.db.isCustomInstall=false

#------------------------------------------------------------------------------

# This variable is considered only if 'IsCustomInstall' is set to true.

#

# Description: List of Enterprise Edition Options you would like to install.

#

#              The following choices are available. You may specify any

#              combination of these choices.  The components you choose should

#              be specified in the form "internal-component-name:version"

#              Below is a list of components you may specify to install.

#       

#              oracle.rdbms.partitioning:11.2.0.1.0 - Oracle Partitioning

#              oracle.rdbms.dm:11.2.0.1.0 - Oracle Data Mining

#              oracle.rdbms.dv:11.2.0.1.0 - Oracle Database Vault

#              oracle.rdbms.lbac:11.2.0.1.0 - Oracle Label Security

#              oracle.rdbms.rat:11.2.0.1.0 - Oracle Real Application Testing

#              oracle.oraolap:11.2.0.1.0 - Oracle OLAP

#------------------------------------------------------------------------------

oracle.install.db.customComponents=oracle.server:11.2.0.1.0,oracle.sysman.ccr:10.2.7.0.0,oracle.xdk:11.2.0.1.0,oracle.rdbms.oci:11.2.0.1.0,oracle.network:11.2.0.1.0,oracle.network.listener:11.2.0.1.0,oracle.rdbms:11.2.0.1.0,oracle.options:11.2.0.1.0,oracle.rdbms.partitioning:11.2.0.1.0,oracle.oraolap:11.2.0.1.0,oracle.rdbms.dm:11.2.0.1.0,oracle.rdbms.dv:11.2.0.1.0,orcle.rdbms.lbac:11.2.0.1.0,oracle.rdbms.rat:11.2.0.1.0

###############################################################################

#                                                                            #

# PRIVILEGED OPERATING SYSTEM GROUPS                                        #

# ------------------------------------------                                  #

# Provide values for the OS groups to which OSDBA and OSOPER privileges      #

# needs to be granted. If the install is being performed as a member of the  #

# group "dba", then that will be used unless specified otherwise below.       #

#                                                                            #

###############################################################################

#------------------------------------------------------------------------------

# The DBA_GROUP is the OS group which is to be granted OSDBA privileges.

#------------------------------------------------------------------------------

oracle.install.db.DBA_GROUP=dba

#------------------------------------------------------------------------------

# The OPER_GROUP is the OS group which is to be granted OSOPER privileges.

#------------------------------------------------------------------------------

oracle.install.db.OPER_GROUP=oper

#------------------------------------------------------------------------------

# Specify the cluster node names selected during the installation.

#------------------------------------------------------------------------------

oracle.install.db.CLUSTER_NODES=

#------------------------------------------------------------------------------

# Specify the type of database to create.

# It can be one of the following:

# - GENERAL_PURPOSE/TRANSACTION_PROCESSING         

# - DATA_WAREHOUSE                               

#------------------------------------------------------------------------------

oracle.install.db.config.starterdb.type=GENERAL_PURPOSE

#------------------------------------------------------------------------------

# Specify the Starter Database Global Database Name.

#------------------------------------------------------------------------------

oracle.install.db.config.starterdb.globalDBName=orcl

#------------------------------------------------------------------------------

# Specify the Starter Database SID.

#------------------------------------------------------------------------------

oracle.install.db.config.starterdb.SID=orcl

#------------------------------------------------------------------------------

# Specify the Starter Database character set.

#                                             

# It can be one of the following:

# AL32UTF8, WE8ISO8859P15, WE8MSWIN1252, EE8ISO8859P2,

# EE8MSWIN1250, NE8ISO8859P10, NEE8ISO8859P4, BLT8MSWIN1257,

# BLT8ISO8859P13, CL8ISO8859P5, CL8MSWIN1251, AR8ISO8859P6,

# AR8MSWIN1256, EL8ISO8859P7, EL8MSWIN1253, IW8ISO8859P8,

# IW8MSWIN1255, JA16EUC, JA16EUCTILDE, JA16SJIS, JA16SJISTILDE,

# KO16MSWIN949, ZHS16GBK, TH8TISASCII, ZHT32EUC, ZHT16MSWIN950,

# ZHT16HKSCS, WE8ISO8859P9, TR8MSWIN1254, VN8MSWIN1258

#------------------------------------------------------------------------------

oracle.install.db.config.starterdb.characterSet=AL32UTF8

#------------------------------------------------------------------------------

# This variable should be set to true if Automatic Memory Management

# in Database is desired.

# If Automatic Memory Management is not desired, and memory allocation

# is to be done manually, then set it to false.

#------------------------------------------------------------------------------

oracle.install.db.config.starterdb.memoryOption=true

#------------------------------------------------------------------------------

# Specify the total memory allocation for the database. Value(in MB) should be

# at least 256 MB, and should not exceed the total physical memory available

# on the system.

# Example: oracle.install.db.config.starterdb.memoryLimit=512

#------------------------------------------------------------------------------

oracle.install.db.config.starterdb.memoryLimit=512

#------------------------------------------------------------------------------

# This variable controls whether to load Example Schemas onto the starter

# database or not.

#------------------------------------------------------------------------------

oracle.install.db.config.starterdb.installExampleSchemas=false

#------------------------------------------------------------------------------

# This variable includes enabling audit settings, configuring password profiles

# and revoking some grants to public. These settings are provided by default.

# These settings may also be disabled.   

#------------------------------------------------------------------------------

oracle.install.db.config.starterdb.enableSecuritySettings=true

###############################################################################

#                                                                            #

# Passwords can be supplied for the following four schemas in the       #

# starter database:            #

#  SYS                                                                      #

#  SYSTEM                                                                    #

#  SYSMAN (used by Enterprise Manager)                                      #

#  DBSNMP (used by Enterprise Manager)                                      #

#                                                                            #

# Same password can be used for all accounts (not recommended)       #

# or different passwords for each account can be provided (recommended)      #

#                                                                            #

###############################################################################

#------------------------------------------------------------------------------

# This variable holds the password that is to be used for all schemas in the

# starter database.

#-------------------------------------------------------------------------------

oracle.install.db.config.starterdb.password.ALL=Oracle#123456

#-------------------------------------------------------------------------------

# Specify the SYS password for the starter database.

#-------------------------------------------------------------------------------

oracle.install.db.config.starterdb.password.SYS=

#-------------------------------------------------------------------------------

# Specify the SYSTEM password for the starter database.

#-------------------------------------------------------------------------------

oracle.install.db.config.starterdb.password.SYSTEM=

#-------------------------------------------------------------------------------

# Specify the SYSMAN password for the starter database.

#-------------------------------------------------------------------------------

oracle.install.db.config.starterdb.password.SYSMAN=

#-------------------------------------------------------------------------------

# Specify the DBSNMP password for the starter database.

#-------------------------------------------------------------------------------

oracle.install.db.config.starterdb.password.DBSNMP=

#-------------------------------------------------------------------------------

# Specify the management option to be selected for the starter database.

# It can be one of the following:

# 1. GRID_CONTROL

# 2. DB_CONTROL

#-------------------------------------------------------------------------------

oracle.install.db.config.starterdb.control=DB_CONTROL

#-------------------------------------------------------------------------------

# Specify the Management Service to use if Grid Control is selected to manage

# the database.     

#-------------------------------------------------------------------------------

oracle.install.db.config.starterdb.gridcontrol.gridControlServiceURL=

#-------------------------------------------------------------------------------

# This variable indicates whether to receive email notification for critical

# alerts when using DB control. 

#-------------------------------------------------------------------------------

oracle.install.db.config.starterdb.dbcontrol.enableEmailNotification=false

#-------------------------------------------------------------------------------

# Specify the email address to which the notifications are to be sent.

#-------------------------------------------------------------------------------

oracle.install.db.config.starterdb.dbcontrol.emailAddress=test@163.com

#-------------------------------------------------------------------------------

# Specify the SMTP server used for email notifications.

#-------------------------------------------------------------------------------

oracle.install.db.config.starterdb.dbcontrol.SMTPServer=

###############################################################################

#                                                                            #

# SPECIFY BACKUP AND RECOVERY OPTIONS                                      #

# ------------------------------------                               #

# Out-of-box backup and recovery options for the database can be mentioned    #

# using the entries below.       #

#                                                                            #

###############################################################################

#------------------------------------------------------------------------------

# This variable is to be set to false if automated backup is not required. Else

# this can be set to true.

#------------------------------------------------------------------------------

oracle.install.db.config.starterdb.automatedBackup.enable=false

#------------------------------------------------------------------------------

# Regardless of the type of storage that is chosen for backup and recovery, if

# automated backups are enabled, a job will be scheduled to run daily at

# 2:00 AM to backup the database. This job will run as the operating system

# user that is specified in this variable.

#------------------------------------------------------------------------------

oracle.install.db.config.starterdb.automatedBackup.osuid=

#-------------------------------------------------------------------------------

# Regardless of the type of storage that is chosen for backup and recovery, if

# automated backups are enabled, a job will be scheduled to run daily at

# 2:00 AM to backup the database. This job will run as the operating system user

# specified by the above entry. The following entry stores the password for the

# above operating system user.

#-------------------------------------------------------------------------------

oracle.install.db.config.starterdb.automatedBackup.ospwd=

#-------------------------------------------------------------------------------

# Specify the type of storage to use for the database.

# It can be one of the following:

# - FILE_SYSTEM_STORAGE

# - ASM_STORAGE

#------------------------------------------------------------------------------

oracle.install.db.config.starterdb.storageType=FILE_SYSTEM_STORAGE

#-------------------------------------------------------------------------------

# Specify the database file location which is a directory for datafiles, control

# files, redo logs.       

#

# Applicable only when oracle.install.db.config.starterdb.storage=FILE_SYSTEM

#-------------------------------------------------------------------------------

oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=/home/oracle/tools/oracle11g/oradata

#-------------------------------------------------------------------------------

# Specify the backup and recovery location.

#

# Applicable only when oracle.install.db.config.starterdb.storage=FILE_SYSTEM

#-------------------------------------------------------------------------------

oracle.install.db.config.starterdb.fileSystemStorage.recoveryLocation=/home/oracle/tools/oracle11g/fast_recovery_area

#-------------------------------------------------------------------------------

# Specify the existing ASM disk groups to be used for storage.

#

# Applicable only when oracle.install.db.config.starterdb.storage=ASM

#-------------------------------------------------------------------------------

oracle.install.db.config.asm.diskGroup=

#-------------------------------------------------------------------------------

# Specify the password for ASMSNMP user of the ASM instance.                 

#

# Applicable only when oracle.install.db.config.starterdb.storage=ASM_SYSTEM

#-------------------------------------------------------------------------------

oracle.install.db.config.asm.ASMSNMPPassword=

#------------------------------------------------------------------------------

# Specify the My Oracle Support Account Username.

#

#  Example  : MYORACLESUPPORT_USERNAME=metalink

#------------------------------------------------------------------------------

MYORACLESUPPORT_USERNAME=

#------------------------------------------------------------------------------

# Specify the My Oracle Support Account Username password.

#

# Example    : MYORACLESUPPORT_PASSWORD=password

#------------------------------------------------------------------------------

MYORACLESUPPORT_PASSWORD=

#------------------------------------------------------------------------------

# Specify whether to enable the user to set the password for

# My Oracle Support credentials. The value can be either true or false.

# If left blank it will be assumed to be false.

#

# Example    : SECURITY_UPDATES_VIA_MYORACLESUPPORT=true

#------------------------------------------------------------------------------

SECURITY_UPDATES_VIA_MYORACLESUPPORT=

#------------------------------------------------------------------------------

# Specify whether user wants to give any proxy details for connection.

# The value can be either true or false. If left blank it will be assumed

# to be false.

#

# Example    : DECLINE_SECURITY_UPDATES=false

#------------------------------------------------------------------------------

DECLINE_SECURITY_UPDATES=true

#------------------------------------------------------------------------------

# Specify the Proxy server name. Length should be greater than zero.

#

# Example    : PROXY_HOST=proxy.domain.com

#------------------------------------------------------------------------------

PROXY_HOST=

#------------------------------------------------------------------------------

# Specify the proxy port number. Should be Numeric and atleast 2 chars.

#

# Example    : PROXY_PORT=25

#------------------------------------------------------------------------------

PROXY_PORT=

#------------------------------------------------------------------------------

# Specify the proxy user name. Leave PROXY_USER and PROXY_PWD

# blank if your proxy server requires no authentication.

#

# Example    : PROXY_USER=username

#------------------------------------------------------------------------------

PROXY_USER=

#------------------------------------------------------------------------------

# Specify the proxy password. Leave PROXY_USER and PROXY_PWD 

# blank if your proxy server requires no authentication.

#

# Example    : PROXY_PWD=password

#------------------------------------------------------------------------------

PROXY_PWD=
'''

##### 静默安装Oracle 11gR2
操作用户：oracle
操作目录：/home/oracle/database

./runInstaller -silent -ignoreSysPrereqs -responseFile /home/oracle/db_install.rsp
接下来，就是默默的等待Oracle自行安装了，等待一段时间后，如果输出如下信息，则表明Oracle数据库已经安装成功。

##### 完成安装
操作用户：root
根据上一步完成信息提示，执行以下两行命令，具体位置需要根据你的安装位置决定：
/home/oracle/tools/oraInventory/orainstRoot.sh
/home/oracle/tools/oracle11g/product/11.2.0/dbhome_1/root.sh
##### 验证安装
###### 启动已经安装的数据库orcl
操作用户：oracle
sqlplus /nolog

使用dba权限连接Oralce
connect / as sysdba

启动数据库
startup

接下来，执行如下命令。
alter user system identified by system;
alter user sys identified by sys;
创建连接用户:
create user SYNC identified by SYNC;
grant connect,resource,dba to SYNC;

验证安装结果--------->
1.启动数据库
启动已经安装的数据库orcl。
操作用户oracle

启动监听
lsnrctl  start
启动数据库过程如下：
sqlplus /nolog

使用dba权限连接Oralce
connect / as sysdba

启动数据库
startup

确认启动结果：1521 远程链接
ORACLE instance started.

Total System Global Area  534462464 bytes
Fixed Size                  2215064 bytes
Variable Size            373293928 bytes
Database Buffers          150994944 bytes
Redo Buffers                7958528 bytes
Database mounted.
Database opened.


确认启动结果：
ORACLE instance started.

Total System Global Area  534462464 bytes
Fixed Size                  2215064 bytes
Variable Size            373293928 bytes
Database Buffers          150994944 bytes
Redo Buffers                7958528 bytes
Database mounted.
Database opened.

##### 启动监听
操作用户：oracle

lsnrctl start

查看监听状态，可以确认各个数据库和实例监听服务的状态：

lsnrctl status

确认监听状态：

LSNRCTL for Linux: Version 11.2.0.1.0 - Production on 05-JAN-2018 12:52:45
Copyright (c) 1991, 2009, Oracle.  All rights reserved.
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC1521))
STATUS of the LISTENER
------------------------
Alias                    LISTENER
Version                  TNSLSNR for Linux: Version 11.2.0.1.0 - Production
Start Date                05-JAN-2018 12:49:29
Uptime                    0 days 0 hr. 3 min. 16 sec
Trace Level              off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File  /home/oracle/tools/oracle11g/product/11.2.0/dbhome_1/network/admin/listener.ora
Listener Log File        /home/oracle/tools/oracle11g/diag/tnslsnr/vmco0240/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=vmco0240)(PORT=1521)))
Services Summary...
Service "orcl" has 1 instance(s).
  Instance "orcl", status READY, has 1 handler(s) for this service...
Service "orclXDB" has 1 instance(s).
  Instance "orcl", status READY, has 1 handler(s) for this service...
The command completed successfully

##### 完成安装
数据库和监听成功启动之后，CentOS 7环境上的Oracle 11gR2就安装完成了。

----------------------------------------------------------------------------------

## 方法二：
### 安装
安装oracle 11g镜像到docker 2.1.1、搜索符合条件的镜像
docker search oracle

NAME                                  DESCRIPTION                                     STARS               OFFICIAL            AUTOMATED
oraclelinux                           Official Docker builds of Oracle Linux.         573                 [OK]
jaspeen/oracle-11g                    Docker image for Oracle 11g database            99                                      [OK]
oracle/openjdk                        Docker images containing OpenJDK Oracle Linux   55                                      [OK]

### 选择安装 jaspeen/oracle-11g，等待下载安装完成
docker pull jaspeen/oracle-11g

### 查看下载好的镜像
docker images

REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
jaspeen/oracle-11g         latest              0c8711fe4f0f        3 years ago         281MB
注意，这个镜像没有直接安装好oracle，他帮我们配置好了环境，提供了安装脚本，我们只需要按照要求把oracle的安装目录配置好，启动镜像，即可

### 准备oracle 11g安装文件
#### 下载oracle 11g安装文件
从oracle 官网 下载所需要的安装包，这里我们以[oracle 11g](https://www.oracle.com/technetwork/database/enterprise-edition/downloads/112010-linx8664soft-100572.html) 为例子，分别下载 linux.x64_11gR2_database_1of2.zip 和 linux.x64_11gR2_database_2of2.zip两个压缩包，下载完成后解压到D盘 (如下目录结构)
unzip linux.x64_11gR2_database_1of2.zip
unzip linux.x64_11gR2_database_2of2.zip


D:.
└─oracleinstall
    └─database
        ├─doc
        ├─install
        ├─response
        ├─rpm
        ├─sshsetup
        ├─stage
        ├─runInstaller
        └─welcome.html
### 安装oracle
### 注意事项
为什么要解压成上面的目录结构，我们先来看看jaspeen/oracle-11g镜像提供的安装脚本

'''shell
#!/usr/bin/env bash
set -e
source /assets/colorecho

trap "echo_red '******* ERROR: Something went wrong.'; exit 1" SIGTERM
trap "echo_red '******* Caught SIGINT signal. Stopping...'; exit 2" SIGINT

if [ ! -d "/install/database" ]; then
	echo_red "Installation files not found. Unzip installation files into mounted(/install) folder"
	exit 1
fi

echo_yellow "Installing Oracle Database 11g"

su oracle -c "/install/database/runInstaller -silent -ignorePrereq -waitforcompletion -responseFile /assets/db_install.rsp"
/opt/oracle/oraInventory/orainstRoot.sh
/opt/oracle/app/product/11.2.0/dbhome_1/root.sh
'''
从脚本里可以看到它会读取/install/database目录，如果不存在会给出提示Installation files not found. Unzip installation files into mounted(/install) folder

### 启动镜像（执行安装oracle）
命令的解释：

docker run 启动容器的命令
privileged 给这个容器特权，安装oracle可能需要操作需要root权限的文件或目录
name 给这个容器名一个名字
p 映射端口
v 挂在文件到容器指定目录 (d:/oracleinstall/database 对应容器 /install/database)
jaspeen/oracle-11g 代表启动指定的容器
docker run --privileged --name oracle11g -p 1521:1521 -v d:/oracleinstall:/install jaspeen/oracle-11g
or
docker run -d --privileged --name oracle11g -p 1521:1521 -e ORACLE_ALLOW_REMOTE=true -v /opt/oracleinstall:/install jaspeen/oracle-11g
------------(-v /data/kongchao/docker_volume/oracle_data:/data/oracle_data)-----------

Database is not installed. Installing...
Installing Oracle Database 11g
Starting Oracle Universal Installer...

Checking Temp space: must be greater than 120 MB.   Actual 47303 MB    Passed
Checking swap space: must be greater than 150 MB.   Actual 1023 MB    Passed
Preparing to launch Oracle Universal Installer from /tmp/OraInstall2019-04-17_08-14-23AM. Please wait ...
You can find the log of this install session at:
 /opt/oracle/oraInventory/logs/installActions2019-04-17_08-14-23AM.log

这个安装过程会很漫长，日志也很多，这里只提供部分。注意到日志里有 100% complete 打印，代表oracle安装成功

### 安装完成
再次查看运行状态，oracle已经启动完成

docker ps -a

CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS                      PORTS                                                                             NAMES
7f53f07c93e5        jaspeen/oracle-11g   "/assets/entrypoint.…"   About an hour ago   Up About an hour            0.0.0.0:1521->1521/tcp, 8080/tcp                                                  oracle11g
### 其他需要注意的，如果日志长时间没有更新，检查docker是否已经死掉
#### 查看docker的状态
docker ps -a
Error response from daemon: An invalid argument was supplied.
如果出现如上提示，表示docker已经死掉，我们只需要重新执行安装步骤，让oracle安装完成

### ps:根据我的猜测，我给docker分配的资源不够导致的，我重新把docker的内存和cpu调高一点后oracle顺利安装完成。

docker rm oracle11g
docker run --privileged --name oracle11g -p 1521:1521 -v oracleinstall:/install jaspeen/oracle-11g
#### 配置
默认scott用户是被锁定的，我们需要解锁，通过数据库工具即可成功连接到oracle

#### 连接到容器，
docker exec -it oracle11g /bin/bash
#### 切换到oracle用户，然后连接到sql控制台
 su - oracle
Last login: Wed Apr 17 08:29:31 UTC 2019

sqlplus / as sysdba

SQL*Plus: Release 11.2.0.1.0 Production on Wed Apr 17 09:29:49 2019

Copyright (c) 1982, 2009, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options

SQL>
3.3，解锁账户
SQL> alter user scott account unlock;
User altered.
SQL> commit;
Commit complete.
SQL> conn scott/tiger
ERROR:
ORA-28001: the password has expired
Changing password for scott
New password:
Retype new password:
Password changed
Connected.
SQL>
#### 使用dataGrip连接oracle数据库
数据库安装完成后，使用默认的sid为orcl，端口为1521，scott/tiger即可连接
