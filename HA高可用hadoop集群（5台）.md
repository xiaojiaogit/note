前言：

作为安装[Hadoop](https://www.linuxidc.com/topicnews.aspx?tid=13)的第一步，就是根据实际情况选择合适的Hadoop版本，这次我所用的CDH5.1.0，基于Hadoop2.3版本。那么什么是CDH呢，下面科普一下。

Cloudera是一家提供Hadoop支持、咨询和管理工具的公司，在Hadoop生态圈有着举足轻重的地位，它的拳头产品就是著名的Cloudera's Distribution for Hadoop，简称CDH。该软件同我们熟知的Apache Hadoop一样，都是完全开源，基于Apache软件许可证，免费为个人和商业使用。Coudera从一个稳定的Apache Hadoop版本开始，连续不断的发布新版本并为旧版本打上补丁，为各种不同的生产环境提供安装文件，在Cloudera的团队中有许多Apache Hadoop的代码贡献者，所以Cloudera的公司实力毋庸置疑。

一般用户安装Hadoop时，不仅仅只安装HDFS、MapReduce，还会根据需要安装Hive、HBase、Spark等。Cloudera将这些相关的项目都集成在一个CDH版本里面，目前CDH包括Hadoop、HBase、Hive、Pig、Sqood、Zooksspe、Spark、Flume、Oozie、Mahout等等，几乎覆盖了Hadoop生态圈，这样做的好处是保证了组件之间的兼容性，因为各个项目之间也存在完全独立的版本，其各个版本与Hadoop之间必然会存在兼容性的问题，如果选择CDH，那么同一个CDH版本内的各个组建将完全不存在兼容性问题。所以初学者使用CDH来搭建Hadoop是一个很好的选择。

规划：

机器：5台  OS：[CentOS](https://www.linuxidc.com/topicnews.aspx?tid=14) 6.5

| 主机名  | IP        | HDFS      | Yarn            | HBase         |
| ------- | --------- | --------- | --------------- | ------------- |
| master1 | 10.64.8.1 | Namenode1 | ResourceManager | HMaster       |
| master1 | 10.64.8.2 | Namenode2 |                 |               |
| slave1  | 10.64.8.3 | Datanode1 | NodeManager     | HRegionServer |
| slave2  | 10.64.8.4 | Datanode2 | NodeManager     | HRegionServer |
| slave3  | 10.64.8.5 | Datanode3 | NodeManager     | HRegionServer |

准备工作：

（1）关闭selinux和防火墙

master1、master2、slave1、slave2、slave3

\#setenforce 0&& service iptables stop &&chkconfig iptables off

（2）修改主机名

master1

\#hostname master1 && echo master1 >/etc/hostname

master2

\#hostname master1 && echo master1 >/etc/hostname

slave1

\#hostname slave1 && echo slave1 >/etc/hostname

slave2

\#hostname slave2 && echo slave2 >/etc/hostname

slave3

\#hostname slave3 && echo slave3 >/etc/hostname

master1、master2、slave1、slave2、slave3

1234567 #cat >> /etc/hosts << EOF

10.64.8.1 master1

10.64.8.2 master2

10.64.8.3 slave1

10.64.8.4 slave2

10.64.8.5 slave3

EOF

（3）主从节点ssh互信

生产中使用hadoop用户来运行，root用户会有风险，初学者可以使用root用户，避免权限问题的困扰。

master1、master2

\#ssh-keygen -t rsa

\#ssh-copy-id -i ~/.ssh/id_rsa.pub root@slave1

\#ssh-copy-id -i ~/.ssh/id_rsa.pub root@slave2

\#ssh-copy-id -i ~/.ssh/id_rsa.pub root@slave3

（4）安装jdk

master1、master2、slave1、slave2、slave3

\#rpm -e --nodeps [Java](https://www.linuxidc.com/Java)-1.6.0-openjdk  ---删除openjdk

\#yum install jdk1.8.0_60.x86_64

（5）格式化硬盘

master1、master2、slave1、slave2、slave3

\#mkfs.ext4 /dev/sdb

\#mkdir /data

\#mount /dev/sdb /data

\#echo "mount /dev/sdb /data" >>/etc/rc.local

（6）系统参数调优

master1、master2、slave1、slave2、slave3

12345678910 cat >>/etc/sysctl.conf <<EOF

net.ipv4.tcp_fin_timeout = 30

net.ipv4.tcp_keepalive_time = 1200 

net.ipv4.tcp_syncookies = 1 

net.ipv4.tcp_tw_reuse = 1 

net.ipv4.tcp_tw_recycle = 1 

net.ipv4.ip_local_port_range = 1024 65000

net.ipv4.tcp_max_syn_baklog = 8192

net.ipv4.tcp_max_tw_bukets = 5000

EOF

123 cat >> /etc/security/limits.conf <<EOF

\*            soft    nofile          65535*            hard    nofile          65535

EOF

重启

（7）下载需要的安装包

12 #cd /opt

\#wget hadoop-2.3.0-cdh5.1.0.tar.gz

附CDH5.1.0下载链接

hadoop-2.3.0-cdh5.1.0.tar.gz

<http://archive.cloudera.com/cdh5/cdh/5/hadoop-2.3.0-cdh5.1.0.tar.gz>

zookeeper-3.4.5-cdh5.1.0.tar.gz

<http://archive.cloudera.com/cdh5/cdh/5/zookeeper-3.4.5-cdh5.1.0.tar.gz>

hive-0.12.0-cdh5.1.0.tar.gz

<http://archive.cloudera.com/cdh5/cdh/5/hive-0.12.0-cdh5.1.0.tar.gz>

hbase-solr-1.5-cdh5.1.0.tar.gz

<http://archive.cloudera.com/cdh5/cdh/5/hbase-solr-1.5-cdh5.1.0.tar.gz>

hbase-0.98.1-cdh5.1.0.tar.gz

<http://archive.cloudera.com/cdh5/cdh/5/hbase-0.98.1-cdh5.1.0.tar.gz>

spark-1.0.0-cdh5.1.0.tar.gz

<http://archive.cloudera.com/cdh5/cdh/5/spark-1.0.0-cdh5.1.0.tar.gz>

flume-ng-1.5.0-cdh5.1.0.tar.gz

<http://archive.cloudera.com/cdh5/cdh/5/flume-ng-1.5.0-cdh5.1.0.tar.gz>

solr-4.4.0-cdh5.1.0.tar.gz

<http://archive.cloudera.com/cdh5/cdh/5/solr-4.4.0-cdh5.1.0.tar.gz>

mahout-0.9-cdh5.1.0.tar.gz

<http://archive.cloudera.com/cdh5/cdh/5/mahout-0.9-cdh5.1.0.tar.gz>

hue-3.6.0-cdh5.1.0.tar.gz

<http://archive.cloudera.com/cdh5/cdh/5/hue-3.6.0-cdh5.1.0.tar.gz>

oozie-4.0.0-cdh5.1.0.tar.gz

<http://archive.cloudera.com/cdh5/cdh/5/oozie-4.0.0-cdh5.1.0.tar.gz>

whirr-0.9.0-cdh5.1.0.tar.gz

<http://archive.cloudera.com/cdh5/cdh/5/whirr-0.9.0-cdh5.1.0.tar.gz>

pig-0.12.0-cdh5.1.0.tar.gz

<http://archive.cloudera.com/cdh5/cdh/5/pig-0.12.0-cdh5.1.0.tar.gz>

search-1.0.0-cdh5.1.0.tar.gz

<http://archive.cloudera.com/cdh5/cdh/5/search-1.0.0-cdh5.1.0.tar.gz>

parquet-1.2.5-cdh5.1.0.tar.gz

<http://archive.cloudera.com/cdh5/cdh/5/parquet-1.2.5-cdh5.1.0.tar.gz>

parquet-format-1.0.0-cdh5.1.0.tar.gz

<http://archive.cloudera.com/cdh5/cdh/5/parquet-format-1.0.0-cdh5.1.0.tar.gz>