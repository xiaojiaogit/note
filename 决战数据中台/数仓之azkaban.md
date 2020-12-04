# Azkaban

## 了解

> Azkaban是LinkedIn开源的任务调度框架，采用java编写
> Azkaban功能和特点：
> 任务的依赖处理
> 任务监控，失败告警
> 任务流的可视化
> 任务权限管理
> Azkaban具有轻量可插拔、友好的WebUI、SLA告警、完善的权限控制、易于二次开发等优点，也得到了广泛应用，主要由三部分组成
> 关系数据库（目前仅支持mysql），用于存储作业/作业流的执行状态信息
> AzkabanWebServer，web管理服务器，主要负责权限验证、项目管理、作业流下发等工作
> AzkabanExecutorServer，执行服务器，主要负责作业流/作业的具体执行以及搜集执行日志等工作

## 准备

1. 服务分布
Multiple Executor模式，各机器组件分配如下：
机器	组件
azkaban1	azkaban-exec-server、mysql-server
azkaban2	azkaban-exec-server
azkaban3	azkaban-exec-server、azkaban-web-server
2. 安装 jdk
此处使用的是jdk1.8
3. 配置 mysql
此处使用的是mysql5.7

# 创建并使用数据库
CREATE DATABASE azkaban;
use azkaban;
# 创建用户并授权
CREATE USER 'azkaban'@'%' IDENTIFIED BY 'azkaban'; 
GRANT ALL ON azkaban.* to 'azkaban'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
# 导入建表语句
source azkaban/azkaban-db/create-all-sql-0.1.0-SNAPSHOT.sql;

## 集群部署
1. 下载源码 & 解压
下载
wget https://github.com/azkaban/azkaban/archive/3.73.1.tar.gz
重命名
mv 3.73.1.tar.gz azkaban-3.73.1.tar.gz
解压：
tar xvf azkaban-3.73.1.tar.gz
2. 安装所需依赖：
yum install -y gcc-c++ git
3. 执行编译：
cd azkaban-3.73.1/
编译 第一次运行时，此过程时间会比较长 -x test 表示跳过测试
./gradlew build installDist -x test

-------------官方编译
# Build Azkaban
./gradlew build

# Clean the build
./gradlew clean

# Build and install distributions
./gradlew installDist

# Run tests
./gradlew test

# Build without running tests
./gradlew build -x test
--------

---------
-----------------------------如果报这个错，解决方法如下------------------------------
FAILURE: Build failed with an exception.
-------------------因为内存不足导致的
./gradlew build --no-daemon
----------------------------------------------------------
4. 编译后的主要目录：
目录	说明
azkaban-common	常用工具类
azkaban-db	对应的sql脚本
azkaban-exec-server	azkaban的executor-server单独模块
azkaban-hadoop-secutity-plugin	hadoop有关kerberos插件
azkaban-solo-server	web和executor运行在同一进程的项目
azkaban-spi	azkaban存储接口以及exception类
azkaban-web-server	azkaban的web-server单独模块
5. 拷贝我们所需的文件并解压
# 所需位置新建azkaban目录
mkdir azkaban
# copy
cp azkaban-3.73.1/azkaban-exec-server/build/distributions/azkaban-exec-server-0.1.0-SNAPSHOT.tar.gz azkaban/
cp azkaban-3.73.1/azkaban-web-server/build/distributions/azkaban-web-server-0.1.0-SNAPSHOT.tar.gz azkaban/
cp azkaban-3.73.1/azkaban-db/build/distributions/azkaban-db-0.1.0-SNAPSHOT.tar.gz azkaban/
cd azkaban/
# 解压
tar xvf azkaban-db-0.1.0-SNAPSHOT.tar.gz
tar xvf azkaban-exec-server-0.1.0-SNAPSHOT.tar.gz
tar xvf azkaban-web-server-0.1.0-SNAPSHOT.tar.gz
# 软链
ln -s azkaban-db-0.1.0-SNAPSHOT azkaban-db
ln -s azkaban-exec-server-0.1.0-SNAPSHOT azkaban-exec
ln -s azkaban-web-server-0.1.0-SNAPSHOT azkaban-web

## 设置时区（如果一样就不用弄了）
1、先生成时区的配置文件Asia/Shanghai，用交互命令 tzselect 即可
2、考贝该时区文件，覆盖系统本地时区配置
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
Asia  china  baidujing time  1
验证：date 看时区

## 创建SSL配置
命令：keytool -keystore keystore -alias jetty -genkey -keyalg RSA
运行此命令后会提示输入当前生成keystor的密码及相应信息，输入的密码要记住
密码 - - - - - - CN yes 
将生成 keystore 拷贝到 /azkaban-web-server-3.73.1/ 的根目录下面

## 集群配置
1. 配置 WebServer
1.1 配置 jetty SSL
cd azkaban-web

生成keystore
# 注意开始和结束的时候输入的密码，其他按提示输入即可
keytool -keystore keystore -alias jetty -genkey -keyalg RSA

1.2 修改conf/azkaban.properties
'''shell
# Azkaban Personalization Settings
azkaban.name=Test					服务器UI名称
azkaban.label=My Local Azkaban			描述
azkaban.color=#FF3601				
azkaban.default.servlet.path=/index
web.resource.dir=web/				默认根web目录

default.timezone.id=Asia/Shanghai			时区默认是美国，需要我们后期进行处理

# Azkaban UserManager class
user.manager.class=azkaban.user.XmlUserManager
user.manager.xml.file=conf/azkaban-users.xml
# Loader for projects
executor.global.properties=conf/global.properties
azkaban.project.dir=projects
# Velocity dev mode
velocity.dev.mode=false
# Azkaban Jetty server properties.
#jetty.use.ssl=false
jetty.maxThreads=25
jetty.ssl.port=8443
jetty.port=8081
jetty.keystore=keystore

# 修改为我们设置的
jetty.password=hadoop
jetty.keypassword=hadoop

jetty.truststore=keystore
jetty.trustpassword=123456
# Azkaban Executor settings
executor.port=12321
# mail settings(可以根据实际情况进行匹配）可以去邮箱的官网看帮助-用户配置-找到SMTP服务器
mail.sender=
mail.host=
job.failure.email=
job.success.email=
lockdown.create.projects=false
cache.directory=cache
# JMX stats
jetty.connector.stats=true
executor.connector.stats=true

# 需要我们自己匹配
database.type=mysql
mysql.port=3306
mysql.host=mingwang-1
mysql.database=azkaban
mysql.user=root
mysql.password=root
mysql.numconnections=100

#Multiple Executor
azkaban.use.multiple.executors=true
azkaban.executorselector.filters=StaticRemainingFlowSize,MinimumFreeMemory,CpuStatus
azkaban.executorselector.comparator.NumberOfAssignedFlowComparator=1
azkaban.executorselector.comparator.Memory=1
azkaban.executorselector.comparator.LastDispatched=1
azkaban.executorselector.comparator.CpuUsage=1
'''
1.3 配置conf/azkaban-users.xml
我这里新增加了一条admin，具有所有权限
'''xml
<user username="admin" password="admin" roles="admin,metrics"/>
'''

2. 配置 ExecutorsServer
所有的ExecutorsServer服务器均按如下配置即可
2.1 修改conf/azkaban.properties
'''shell
# 同理需要设置成我们自己的时区
default.timezone.id=Asia/Shanghai

# Loader for projects
executor.global.properties=conf/global.properties
azkaban.project.dir=projects
# Velocity dev mode
velocity.dev.mode=false
# Azkaban Jetty server properties.
jetty.use.ssl=false
jetty.maxThreads=25
jetty.port=8081
azkaban.jobtype.plugin.dir=plugins/jobtypes

# 设置成我们自己的mysql
database.type=mysql
mysql.port=3306
mysql.host=mingwang-1
mysql.database=azkaban
mysql.user=root
mysql.password=root
mysql.numconnections=100

# Azkaban Executor settings
executor.maxThreads=50
executor.flow.threads=30
executor.connector.stats=true
executor.port=12321

azkaban.use.multiple.executors=true
azkaban.executorselector.filters=StaticRemainingFlowSize,MinimumFreeMemory,CpuStatus
azkaban.executorselector.comparator.NumberOfAssignedFlowComparator=1
azkaban.executorselector.comparator.Memory=1
azkaban.executorselector.comparator.LastDispatched=1
azkaban.executorselector.comparator.CpuUsage=1
'''

3.1启动
注意：执行命令时的目录，否则会找不到某些文件
cd azkaban-exec
# 启动
bin/start-exec.sh

3.2 启动 WebServer
注意：执行命令时的目录，否则会找不到某些文件
cd azkaban-web
# 启动
bin/start-web.sh


## 查看 netstat -nltp   ----可以看到8443端口已经被监听

## 报错解决
解决方式：登录azkaban使用的mysql数据库，查看executors表中是否存在active=1的executor，如果没有，修改active字段，而后再次启动即可
update executors set active = 1 where id = 1;

将azkaban.properties
web.resource.dir=/usr/liuwunan/Azkaban/azkaban-web-server-3.73.1/web    修改为全路径即可，登录用户名密码，在
/usr/liuwunan/Azkaban/azkaban-web-server-3.73.1/conf/azkaban-users.xml 配置文件中，可以自己填写

## 后台启动方式
nohup azkaban-web-start.sh 1>/home/hadoop/azwebstd.out 2>/home/hadoop/azweberr.out &

## 实战

### 单个命令的job
1、创建job描述文件
vi command.job
'''job
# connand.job
type=command
command=echo 'hello'
'''
2、将job资源文件打包成zip文件
command.zip
3、登录webui界面--创建工程--上传zip包--执行job任务

### 单个shell脚本的job
1、创建一个脚本文件 xxx.sh
'''shell
#!/bin/bash
for i in (1..1000)
do
echo $1 >> /opt/datas/number.log
done
'''
2、创建一个job文件
'''job
# number.job
type=command=sh xxx.sh
'''
3、将job与脚本一起打包成zip文件
number.zip
4、登录webui界面--创建工程--上传zip包--执行job任务

### 多个job工作流flow（命令）
1、创建有依赖关系的多个job描述
第一个job：one.job
'''job
# one.job
type=command
command=echo 'one..............................'
'''
第二个job：two.job
'''job
# two.job
type=command
command=echo 'two..............................'
'''
第三个job：three.job
'''job
# three.job
type=command
dependencies=one,two
command=echo 'three................................'
'''

## hadoop脚本编写个人规范
'''shell
HADOOP_HOME=/opt/hadoop/
${HADOOP_HOME}/bin/hdfs dfs -mkdir -p /nihao/wohao/tahao/dajiahao
'''
'''shell
HADOOP_HOME=/opt/hadoop/
${HADOOP_HOME}/bin/hadoop jar hadoop-mapreduce-examples-2.9.2.jar wordcount /wordcount/input /wordcount/output
'''