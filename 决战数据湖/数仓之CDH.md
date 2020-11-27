# CDH安装教程
## 运维工具
提前配置 Kick start 自动引导程序
使用无人值守的方式来安装，其他机器

### kick start服务器搭建

### 集群安装

1. 重启linux使用U盘启动

2. 到了启动界面后按 tab 键

3. 把最下面默认的删掉，然后指定ks服务器：ks=http:192.168.1.100/ks.cfg 回车就进入到自动引导程序了，现在就可以去安装下一台服务器了

### CHD6服务安装

#### 所有节点都需要弄
1. 修改主机

2. 修改ip地址

3. 修改ip地址与主句的映射关系

4. 配置ssh免密登录

5. 关闭防火墙

'''shell
# 关闭防火墙
systemctl stop firewalld
# 或者使用service firewalld stop

# 防火墙开机不启动
systemctl disable firewalld
# 或者使用chkconfig firewalld off
'''
6. 关闭SeLinux
'''shell
vi /etc/selinux/config
# 将enforcing改为disabled
'''

#### 主节点安装

1. 下载CM和CDH
[cm和cdh的资源网站](https://archive.cloudera.com/)

2. 下载cm6

[下载地址](https://archive.cloudera.com/cm6/6.2.1/redhat7/yum/RPMS/x86_64/)
全部下载

3. 下载cdh6

[下载地址](https://archive.cloudera.com/cdh6/6.2.1/parcels)
下载两个文件
把manifest.json里的内容放到一个自己创建的文件里
一共下载3个文件

4. 构建本地yum源
'''shell
yum install -y httpd

service httpd start

cd /var/www/html/

mkdir cm6
mkdir cdh6

cd /opt/
cp *.rpm /var/www/html/cm6/
cp CDH-6.3.1.p0.17....parcel* /var/www/html/cdh6/
cd manifest.json /var/www/html/cdh6/

yum install -y createrepo
cd /var/www/html/cm6/
createrepo .
'''

5. 在所有节点上添加yum源的配置文件
'''shell
for i in {1..10}
do
ssh mingwang-$i '

cat >> /etc/yum.repos.d/cm6.repo << EOF
[cm6-local]
name=cm6-local
baseurl=http://mingwang-1/cm6
enabled=1
gpgcheck=0
EOF

exit'
done


# 查看yum源是存在
ssh mingwang-10
more /etc/yum.repos.d/cm6.repo
# 查看yum源是否生效
# 看情况弄 yum clean all
yum repolist
'''

6. 安装cm6和其他依赖

- 在所有节点上安装依赖
'''shell
yum install -y bind-utils libxslt cyrus-sasl-plain cyrus-sasl-gssapi portmap fuse-libs /lib/lsb/init-functions httpd mod_ssl openssl-devel python-psycopg2 MySQL-python fuse
'''

- 安装在管理节点
'''shell
yum install -y oracle-j2sdk1.8-1.8.0+update181-1.x86_64
yum install -y cloudera-manager-daemons cloudera-manager-server cloudera-manager-server-db-2 postgresql-server
'''

7. 安装mysql

注意：CentOS7 yum源不再安装默认的mysql了，而是使用MariaDB

- 安装MariaDB
'''shell
yum install -y mysql mysql-devel

yum install -y mariadb mariadb-server
'''

- 初始化MariaDB并修改密码
'''shell
service mariadb start
chkconfig mariadb on
/usr/bin/mysql_secure_installation

# 第一个问你是数据库原密码，第一次可以直接回车
# 第二个问你是不是设置root密码，回车设置
# 第三个问你是不是删除匿名用户，是的
# 第四个问你是不是禁止root用户远程登录
# 第五个问你是不是删除测试数据库，是的
# 第六个问你是不是刷新旧配置
# 到此安装完成
# 高可用学玩再说
'''

- 注意：由于数据库存储的信息非常重要，所以生成环境建议配置成高可用的集群。


8. 初始化管理节点数据库（所有节点都分发一下mysql驱动）

- 拷贝mysql-connector到/usr/share/java目录，并且改名为mysql-connector-java.jar

'''shell
mkdir -p /usr/share/java/
cp /opt/mysql-connector-java-5.1.47.jar /usr/share/java/mysql-connector-java.jar
# 执行数据库初始脚本
/opt/cloudera/cm/schema/scm_prepare_database.sh mysql -h localhost -uroot -ptoor --scm-host localhost scm root toor
'''

9. 安装agent节点

- 在所有的子节点上安装
'''shell
yum install -y oracle-j2sdk1.8-1.8.0+update181-1.x86_64
yum install -y cloudera-manager-daemons cloudera-manager-agent
'''

- 修改所有节点的配置文件，让agent的地址指向cloudera-manager-server
'''shell
sed -i "s/server_host=localhost/server_host=mingwang-1/g" /etc/cloudera-scm-agent/config.ini
'''

10. 启动server

'''shell
# systemctl start cloudera-scm-server
# systemctl enable cloudera-scm-server

service cloudera-scm-server start
service cloudera-scm-server on
'''

11. 启动agent
'''shell
# 所有节点都启动
# systemctl start cloudera-scm-agent
# systemctl enable cloudera-scm-agent

service cloudera-scm-agent start
chkconfig cloudera-scm-agent on
'''

### 登录管理界面

1. 配置win上的host映射
2. 访问server服务：mingwang-1:7180
3. 使用admin登录后先改管理密码
4. 下一步，我们可以先使用60天试用版，60天后会自动降到免费版
5. 给集群起个名字
6. 选择我们事先准备好的parcel包，点击它后面的-更多选项-删除多有的链接-修改成我们自己的--http://mingwang-1/cdh6 -- 看到我们自己准备的后选择
7. 把出现的问题进行相应的修改
'''shell
# 修改Cloudera警告

for i in {1...10}
do
    ssh mingwang-$i '
        echo 10 > /proc/sys/vm/swappiness
    exit'
done

# 关闭透明大页

1. 修改警告
echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled

2. 添加到启动项
echo "echo never > /sys/kernel/mm/transparent_hugepage/defrag" >> /etc/rc.local
echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.local

## 批量修改(用这个)
for i in {1...10}
do
    ssh node-$i '
        echo never > /sys/kernel/mm/transparent_hugepage/defrag
        echo never > /sys/kernel/mm/transparent_hugepage/enabled
        echo "echo never > /sys/kernel/mm/transparent_hugepage/defrag" >> /etc/rc.local
        echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.local
    exit'
done

# 查看是否修改成功
more /sys/kernel/mm/transparent_hugepage/defrag
'''

### 安装服务

> 安装的时候需要注意先后顺序---把最下面的监控服务装上
> 监控服务装到第一台上

'''shell
# 创建普通用户
create user gz identified by 'gz';

# 建库
## 创建信息上报的数据库
create database reports default charset utf8;

## 创建活动监控的数据库
create database activity default charset utf8;

create database audit default charset utf8;

create database metadata default charset utf8;

# 允许mysql远程登录
## 赋予权限
grant all privileges on reports.* to gz@'%' identified by 'gz';
grant all privileges on activity.* to gz@'%' identified by 'gz';
grant all privileges on audit.* to gz@'%' identified by 'gz';
grant all privileges on metadata.* to gz@'%' identified by 'gz';
flush privileges;
'''
