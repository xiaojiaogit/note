# 数仓之hive笔记（技术都是简单的，业务才是最复杂的）
> hadoop-hbase-hive-日志分析-flume-sqoop-tez-zookeeper-redis-elasticsearch-kafka-storm-oozie---？

> 数据仓库是决策支持系统（dss）和联机分析应用数据源的结构化数据环境。数据仓库研究和解决从数据库中获取信息的问题。数据仓库的特征在于面向主题、集成性、稳定性和时变性。
## 未来的发展方向
> 数据库--->数据仓库--->数据湖--->数据中台[使用Go语言]（量变产生质变）
## hive的特性
> 面向主题(给决策支持，包含所有已知的主题相关指标)
> 集成性(将不同路径复杂的数据拿取过来的集合)
> 稳定性(数据不可更新)
> 时变性(批量)
## 数据仓库和数据库的区别
1. 数仓时面向主题、数据库是面向业务
2. 数仓是决策支持、数据库是业务支持
3. 数仓存储的是历史数据、数据库是实时数据
4. 数仓是面向决策人员、数据库是面向操作人员
## 数据分层
> 层级：（在hdfs上是对应的目录，在hive中对应的是表名）
### 为什么分层
- 清晰数据结构：每一个数据分层都有它的作用域，这样我们在使用表的时候能更方便地定位和理解。
- 数据血缘追踪：简单来讲可以这样理解，我们最终给业务诚信的是能直接使用的一张业务表，但是它的来源有很多，如果有一张来源表出现问题了，我们希望能够快速准确地定位到问题，并清楚它的危害范围。
- 减少重复开发：规模数据分层，开发一些通用的中间数据，能够极大的减少重复计算。
- 把重复问题简单化：将一个复杂的任务分解成多个步骤来完成，每一层只处理单一的步骤，比较简单和容易理解。而且便于维护数据的准确性，当数据出现问题之后，可以不用修复所有的数据，只需要从有问题的步骤开始修复。
- 屏蔽原始数据的异常。
- 屏蔽业务的影响，不必改一次业务就需要重新接入数据。
### 初始分层
- ODS全称是 Operational Data Store，操作数据存储：“面向主题的”，数据运营层，也叫ODS层，是最接近数据源中数据的一层，数据源中的数据，经过抽取、洗净、传输，也就是传说中的ETL之后，装入本层。本层的数据，总体上大多是按照源头业务系统的分类方式而分类的。但是，这一层面的数据却不等于同于原始数据。在源数据装入这一层时，要进行诸如去噪（例如有一条数据中人的年龄是300岁，这种属于异常数据，就需要提前做一些处理）、去重（例如在个人资料表中，同一ID却有两条重复数据，在接入的时候需要做一步去重）、字段名规范等一系列操作。
- 数据仓库（DW），是数据仓库的主体，在这里，从ODS层中获得的数据按照主题建立各种数据模型。这一层和维度建模会有比较深的联系，可以多参考一下前面的几篇文章。
- 数据产品层（app），这一层是提供为数据产品使用的结果数据。
### 业务分成
缓冲层（buffer）
明细层（ODS，Operational Data Store，DWD：data warehouse datail）
canal日志合成数据的方式待研究
轻度汇总层（MID或DWB，data wareshouse basis）
主题层（DM，data market或DWS，data warehouse service）
应用层（App）
### 银行数据分层
- RAW(缓冲层)
- ODS(原始数据全量表)
- MID(原始数据增量表)
- PRC(加工临时分区表)
- TMP(加工临时表)
- FCT(产品层)
## hive简介
> 基于MR处理数据，数据存储在hdfs上的一个数据仓库，使用sql来替代MR。
## hive搭建（多用户）
上传bin包，解压，修改配置文件（hive-site,core-site,profile,hdfs-sete.xml）,上传mysql驱动包，修改yarn的jline包，修改客户端的hive-sete文件。
客户化：根据环境的不同修改不同的代码。
### hive-site.xml
'''xml
<configuration>
    <!--元数据管理-->
    <property>
        <name>javax.jdo.option.ConnectionURL</name>
        <value>jdbc:mysql://mingwang1:3306/hive?createDatabaseIfNotExist=true</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionDriverName</name>
        <value>com.mysql.jdbc.Driver</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionUserName</name>
        <value>root</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionPassword</name>
        <value>root</value>
    </property>
    <!--默认为/user/hive/warehouse,用于配置Hive默认的数据文件存储路径，这是一个HDFS路径。可按需调整。-->
    <property>
        <name>hive.metastore.warehouse.dir</name>
        <value>/mingwang-hadoop/hive/metastore/warehouse</value>
    </property>
    <!--查询输出是是否打印名字和列，默认是false-->
    <property>
        <name>hive.cli.print.header</name>
        <value>true</value>
    </property>
    <!--hive的提示里是否包含当前的db，默认为false-->
    <property>
        <name>hive.cli.print.current.db</name>
        <value>true</value>
    </property>
    <!--强制metastore的schema一致性，开启的话会校验在metastore中储存的信息和hive的jar包中的版本一致性，并且关闭自动schema迁移，用户必须手动的升级hive并且迁移schema，关闭的话只会在版本不一致时给出警告，默认是false不开启-->
    <property>
        <name>hive.metastore.schema.verification</name>
        <value>false</value>
    </property>
    <!--在启动时创建必要的架构（如果不存在），创建一次后，将其设置为false-->
    <property>
        <name>datanucleus.schema.autoCreateAll</name>
        <value>true</value>
    </property>
    <property>
        <name>hive.server2.webui.host</name>
        <value>mingwang3</value>
    </property>
    <property>
        <name>hive.server2.webui.port</naem>
        <value>10002</value>
    </property>

</configuration>
'''
### /hadoop/core-site.xml追加如下内容(不配这个server2启动会有问题)
'''xml
<configuration>
    <!--该参数表示可以通过https接口hdfs的ip地址限制-->
    <property>
        <name>hadoop.proxyuser.root.hosts</name>
        <value>*</value>
    </property>
    <!--通过httpfs接口访问的用户获得的群组身份-->
    <property>
        <naem>hadoop.proxyuser.root.groups</name>
        <value>*</value>
    </property>
</configuration>
'''
### 添加hive的环境变量
### 往hive的lib目录下上传mysql的驱动包
### 修改hadoop/share/hadoop/yarn/lib/下的jline的版本，可以从hive中拷贝过来
### 分发hive
### 分发配置的其他文件
### hive-site.xml(在客户端上删除server2指定服务端)
'''xml
<configuration>
    <!--指定服务端-->
    <property>
        <name>hive.metastore.uris</name>
        <value>thrift://mingwang3:9083</value>
    </property>
</configuration>
'''
## 启动脚本(start-hive.sh)
'''shell
#!/bin/sh

echo "============START============="

zkServer.sh start

ssh root@mingwang1 "/opt/zookeeper/bin/zkServer.sh start"

ssh root@mingwang2 "/opt/zookeeper/bin/zkServer start"

echo "============休息一下，让zookeeper飞一会============="

sleep 10
jps

echo "============启动hadoop集群============="

ssh root@mingwang1 "/opt/hadoop/sbin/start-all.sh"

echo "============启动resourcemanager============="

echo "============hive============="

nohup hive --service metastore > /dev/null 2>&1 &

jps

echo "============休息一小会，再让metastore飞一会============="
sleep 10
jps

nohup hiveserver2 > /dev/null 2>&1 &

sleep 5
'''
## Hive操作
### 创建数据库
'''mysql
create database mingwang;
create database if not exists mingwang;
create database mingwang location '/mingwang-hadoop/hive/mingwang.db;
drop database mingwang;
desc database mingwang;
'''

### hive的数据类型
data_type
  : primitive_type
  | array_type
  | map_type
  | struct_type
  | union_type  -- (Note: Available in Hive 0.7.0 and later)

primitive_type
  : TINYINT
  | SMALLINT
  | INT
  | BIGINT
  | BOOLEAN
  | FLOAT
  | DOUBLE
  | DOUBLE PRECISION -- (Note: Available in Hive 2.2.0 and later)
  | STRING
  | BINARY      -- (Note: Available in Hive 0.8.0 and later)
  | TIMESTAMP   -- (Note: Available in Hive 0.8.0 and later)
  | DECIMAL     -- (Note: Available in Hive 0.11.0 and later)
  | DECIMAL(precision, scale)  -- (Note: Available in Hive 0.13.0 and later)
  | DATE        -- (Note: Available in Hive 0.12.0 and later)
  | VARCHAR     -- (Note: Available in Hive 0.12.0 and later)
  | CHAR        -- (Note: Available in Hive 0.13.0 and later)

array_type
  : ARRAY < data_type >

map_type
  : MAP < primitive_type, data_type >

struct_type
  : STRUCT < col_name : data_type [COMMENT col_comment], ...>

union_type
   : UNIONTYPE < data_type, data_type, ... >  -- (Note: Available in Hive 0.7.0 and later)

row_format
  : DELIMITED [FIELDS TERMINATED BY char [ESCAPED BY char]] [COLLECTION ITEMS TERMINATED BY char]
        [MAP KEYS TERMINATED BY char] [LINES TERMINATED BY char]
        [NULL DEFINED AS char]   -- (Note: Available in Hive 0.13 and later)
  | SERDE serde_name [WITH SERDEPROPERTIES (property_name=property_value, property_name=property_value, ...)]

整数型

字符型

浮点型

布尔型

复杂型

> Hive相比较传统数据库而言都有的数据类型：复杂型
>
> 在银行系统中，数据存储到hive中的时候都会将数据类型设置为varchar，并且位数是之前的3倍。（50k的字符串load到内存中一般就三倍左右的膨胀）

### 测试 --- 1
#### 准备数据
'''json
mingwang,xiaoliu_xiaozheng,xiao ming:18_xiaoxiao ming:21,shuo zhou shi_shanxi
wangming,liuxiao_zhengxiao,ming xiao:21_mingming xiao:22,shuo zhou shi_yingxian
'''
#### 访问hive的服务端
'''shell
beeline -u jdbc:hive2://mingwang3:10000 -n root
'''
#### 在hive创建数据库：mw
'''sql
create database mw;
'''
#### 创建表
先有数据再有表
'''sql
create table if not exists mw.mw_stu(
name string,
friends array<string>,
children map<string, int>,
address struct<street:string, city:string>
)
row format delimited fields terminated by ','
collection items terminated by '_'
map keys terminated by ':'
lines terminated by '\n'
location '/hive/ODS/';
'''
#### 上传数据文件
'''shell
hadoop fs -mkdir /datas/hive
hadoop fs -put mw_stu.txt /datas/hive
load data inpath '/datas/hive/mw_stu.txt' into table mw.mw_stu;
'''
### 三种交互方式
hive
最早的交互方式，直接和metastore进行连接，只有当服务器运行起Runjar时候才能用

beeline -u jdbc:hive2://mingwang3:10000 -n root

'''shell
beeline -u jdbc:hive2://mingwang1:10000,mingwang2:10000,mingwang3:10000 -hivevar YYYYMMDD='date +%Y%m%d' -hivevar YYYY='date +%Y' -hivevar MM='date +%m -hivevar DD='date +%d'
'''

'''sql
select * from mw_stu where date='$(YYYYMMDD)';
'''

hivebeeline -f|-e
'''shell
beeline -u jdbc:hive2://mingwang3:10000 -n root -f /opt/data/sql/hive/mw_stu.sql -e 'select * from mw.mw_stu'
'''

### 常用的交互命令
'''shell
# 查看帮助文档
hive -help

# 查看在hive中输入的所有历史命令
cat /home/mingwang/.hivehistory

## 以上都是在shell环境下的命令，下边是登录hive后的常用交互命令
# 搜索hive的最近历史命令
ctrl + i     ----->有点不确定，如果不能收的话试一下ctrl + r

# 查看hdfs上的文件
hive>dfs -ls /;

# 查看本地的文件
hive>! ls /opt/datas;

'''
### 创建表

#### 工作经验
如果你不知道企业如何建表，你可以使用如下方式,学习老员工是如何创建表的。
'''sql
show create table mw_test;
'''

#### 创建内表(如果删除内表，hdfs上的表也会被删除)
'''sql
create table if not exists mw.mw_test (name string);
'''

#### 创建外表（工作中使用最多的）
'''sql
create extenal table if not exists mw.mw_test2 (name string);
'''

#### hive内表和外表的区别
1. 建表时语句不一样
2. 删除时删除的东西不一样
   外表只删除元数据，但是保留数据；内表删除的时候会删除所有。
### hive加载数据
'''shell
# 使用hdfs上的文件
load data inpath '/datas/hive/mw_stu.txt' into table mw.mw_stu;

# 使用linux上的文件按
load data local inpath '/datas/hive/mw_stu.txt' into table mw.mw_stu;

# 使用hdfs上的文件，并放到指定的分区里
load data inpath '/datas/hive/mw_stu.txt' into table mw.mw_stu partition (day="YYYYMMDD");

# 插入数据（into是新增）
insert into table emp select * from emp_2;
# 常用(overwrite是覆盖)
insert overwrite table emp select * from emp_2;
insert overwrite table emp partition(day=YYYYMMDD) select * from emp_2;
'''
### 修改表结构 alter add paritition...
