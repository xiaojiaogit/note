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
create external table if not exists mw.mw_test2 (name string);
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

### hive导出数据(导出数据一定要指定建表时的分割符，不然会又隐形的格式)
'''sql
# 数据导出到hdfs
insert overwrite directory '/datas/hive/output' select * from mw_stu;
# 数据导出到本地
insert overwrite local directory '/root/hive/output' select * from mw_stu;

'''

### 备份 （会保存数据和元数据）
'''sql
export table mw_stu to '/datas/hive/output/bak';
# 导入备份的文件
improt from '/datas/hive/output/bak';
'''
### hive查询
'''sql
SELECT [ALL | DISTINCT] select_expr, select_expr, ...
FROM table_reference
[WHERE where_condition]
[GROUP BY col_list [HAVING condition]]
[ CLUSTER BY col_list
| [DISTRIBUTE BY col_list] [SORT BY| ORDER BY col_list]
]
[LIMIT number]
'''

### hive分区(将一个大文件，拆分成多个小文件)

- 创建分区表

'''sql
create table if not exists mw_test3 (
    id int,
    name string,
    age int
)partitiones by (day string)
row format delimited fields terminated by '\t'
location '/datas/hive/input/ODS/01/nihao'
'''

- 创建一个表带多个分区

'''sql
create table if not exists mw_test3 (
    id int,
    name string,
    age int
)partitiones by (day string, clde string)
row format delimited fields terminated by '\t'
location '/datas/hive/input/ODS/01/nihao'
'''

注意：前后两个分区的关系为父子关系

#### 查看分区
'''sql
show partitions mw_stu;
'''
#### 添加分区
'''sql
alter table mw_stu add partition (day='20201125');
'''

#### 删除分区
'''sql
alter table mw_stu drop partition (day='20201125');
'''

#### 分区分类，两个维度（数量和精准度）:
(深度)数量>单分区和多分区
(维度)精确度>静态分区(我们给这个分区指定了一个值)和动态分区(文件里存在分区字段的值，我们就可以使用动态分区，直接指定分区名即可)
'''sql
# 静态分区插入数据案例
insert overwrite table mw_stu partition(day='20201124') select * from mw_stu;
# 动态分区插入数据案例
insert overwrite table mw_stu partition(day) select * from mw_stu;
'''
#### 注意:
hiv默认是没有开启动态分区的，我们可以通过以下命令手动开启。
'''shell
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrice;
'''

#### 有时我们为了对一些内容保密，那么我们会用到一下的方式，但一般情况不会用它。
'''sql
alter table mw_stu add partition (day='20201124') location 'mingwang';
'''

### hive函数
#### hive的内置函数
[官方文档](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+UDF)
**在hive里查看内置函数**
'''sql
# 查看系统自带函数
show functions;

# 显示自带函数的用法
desc function upper;

# 详细显示自带函数的用法
desc function extended year;

# 常用内置函数
## 字符串连接函数
select count('a','b','c');
select count('_','a','b','c')

## 类型转换（有去0的附带功能）
select cast(1.555 as int);

## 获取分区范围
a [NOT] BETWEEN b AND c
select * from mw_stu where day between 20201124 and 20201125;

## 获取时间戳(可以直接在函数后进行运算)
unix_timestamp()
selecr unix_timestamp() from mw_stu;

## 将YYYY-MM-DD的这种数据的格式转换为毫秒数
unix_timestamp(string data)
unix_timestamp('2009-03-20','yyyy-MM-dd')=1237532400;

## 获取当前时间的年月(可以直接在函数后进行运算)
year(string date)
month(string date)
day(string date) dayofmonth(date)...day("1970-11-01 00:00:00")=1,day("1970-11-01")=1.
hour(string date)hour('2009-07-30 12:58:59')=12,hour('12:58:59')=12.

## 当前时间加减
### 减时间
date_sub(date/timestamp/string startdate, tinyint/smallint/int days)

### 加时间
date_add(date/timestamp/string startdate, tinyint/smallint/int days)

### 最后一天
last_day(string date)

### 某个时间段内
months_between(date1, date2)-->months_between('1997-02-28 10:30:00', '1996-10-30')=3.94959677

## 判断
case a when b then c [when d then e] * from [else f] end
case
when a=b then c
when ...
end

## 拼接字符串
### 无缝拼接
concat(string|binary a, string|binary b,...)
### 指定分割符拼接
concat_ws(string SEP, string a,string b,...)

## 补0(在指点前补足位数)
lpad(string str, int len, string pad)

## 截取函数
substr(string|binary a, int start, int len) substring(string|binary a, int start, int len)
substr('foobar', 4, 1) results in 'b'

## 聚合函数
count()
sum()
min()
max()

## 连接函数
join
inner join   --内连接是最常见的一种连接，只连接匹配的行 inner join 与 join 相同

left join
right join

full join   --笛卡尔积

union       --将数据去重后将两张表进行整合
union all   --不去重，对两张表进行整合

## wordcount

'''
> left join 和union、union all 使用的较多

#### hive窗口函数(重点中的重点)
聚合函数 + over()
'''sql
# 语法如下：
<窗口函数> over(partition by <用于分组的列名> order by <用来排序的列名>)

# 分类
1.专用窗口函数，包括后面要提到的rank，dense_rank，row_number等专用窗口函数。
2.聚合函数，如sum，avg，count，max，min等因为窗口函数是对where或者group by 子句处理后的结果进行操作，所以窗口函数原则上只能写在select子句中。

'''

- 专用窗口函数

rank函数：如果有并列名次的行，会占用一下名次的位置。比如正常排名是1，2，3，4，5，但是现在前3名是并列的名次，结果是：1，1，1，4，5。

dense_rank函数：如果有并列名次的行，不占用下一名次的位置。比如正常排名是1，2，3，4，5，但是现在前三名是并列的名次，结果是：1，1，1，2，3。

row_number函数：不考虑并列名次的情况。比如前三名是并列的名次，排名是正常的1，2，3，4，5。

- 聚合函数

在窗口函数中，是对自身记录、及位于自身记录以上的数据进行求和的结果。不仅是sum求和，平均、计数、最大值、最小值，也是同理，都是针对自身记录、以及自身记录之上的所有数据进行计算，现在再结合刚才得到的结果。

聚合函数作为窗口函数，可以在每一行的数据里直观的看到，截至到本行数据，统计数据是多少（最大值、最小值等）。同时可以看出每一行数据，对整体统计数据的影响。

#### 开户日需求，思路
'''sql
set hive.support.quoted.identifiers=none;

--- 准备数据（kh.txt）
0001,20300101,1200
0002,20300101,140
0003,20300101,2000
0004,20300101,3000
0005,20300101,9999

--- 数据kh2.txt
0001,20300101,100
0006,20300102,140
0007,20300102,2000
0008,20300102,3000
0009,20300102,9999

--- 上传原文件到hdfs
hadoop fs -put /opt/datas/kh.txt /datas/hive

--- 字段说明
no id
opendate 开户日
bal 开户金额

-- 建表语句
create external table if not exists mw.A_Q(
no string,
opendate string,
bal string
) partitioned by(day string)
row format delimited fields terminated by ','
location '/hive/ODS/A_Q';

create external table if not exists mw.A_Z(
no string,
opendate string,
bal string
) partitioned by(day string)
row format delimited fields terminated by ','
location '/hive/ODS/A_Z';

-- 加载数据
load data inpath '/datas/hive/kh.txt' into table A_Q partition(bey='20300101');

load data inpath '/datas/hive/kh.txt' into table A_Z partition(bey='20300102');

-- 加工脚本
use mw;
insert overwrite table A_N_Q paritition(day='$(YYYYMMDD)')
select
no,opendate,bal,day
from
(
    select
    *,
    row_number() over(partition by no order by day desc) r
    from
    (
        select * from A_Q where day=from_unixtime(unix_timestamp('$(YYYYMMDD)','yyyyMMdd')-85400,'yyyyMMdd')
        union all
        select * from A_Z where day='$(YYYYMMDD)'
    ) t1
) t2 where t2.r = 1;

-----------------------------------------------------------------

use mw;
insert overwrite table A_N_Q paritition(day='20300102')
select
no,opendate,bal,day
from
(
    select
    *,
    row_number() over(partition by no order by day desc) r
    from
    (
        select * from A_Q where day=from_unixtime(unix_timestamp('20300102','yyyyMMdd')-85400,'yyyyMMdd')
        union all
        select * from A_Z where day='20300102'
    ) t1
) t2 where t2.r = 1;

-----------------------------------------------------------------
-- 加工脚本2(不怎么使用)
use mw;
insert overwrite table A_N_Q paritition(day='$(YYYYMMDD)')
select
\`(r)?+.+\`
from
(
    select
    *,
    row_number() over(partition by no order by day) r
    from
    (
        select * from A_Q where day=concat('$(YYYY)','$(MM)','$(DD)'-1)
        union all
        select * from A_Z where day='$(YYYYMMDD)'
    ) t1
) t2 where t2.r = 1;
'''

#### hive的自定义函数
UDF一进一出， 例如：unix_timestamp()
UDTF多进一出，例如：sum()
UDAF一进多出，例如：split()

> 为什么要使用自定义函数，有的时候Hive的内置函数并不能满足我们业务的要求

需要使用java编写：
pom文件里添加 hadoop-client(2.6.5)、hadoop-hdfs(2.6.5)、hive-exec(1.2.1)
新建一个HiveUDF的类，并继承UDF，并实现他的evaluate方法

新建一个HiveUDAF的类，并继承UDAF，并实现他的init，iterate,terminatePartial,merge,terminate方法。iterate可以重载，主要负责接受数据

新建一个ExplodeMap的类，并继承GenericUDTF,并实现其中的process、initialize、close方法。

> iteratehive的其他方式：beeline -u jdbc:hive2://mingwang3:10000 -n root -hivevar YYYYMMDD='20300103'

> 生成永久的自定义函数：create function mw_hello as 'com.mingwang.HiveUDF' using jar 'hdfs://mingwang1/hive/jar/udf_jar_1.jar';

> 使用自定义函数：select mw_hello('world',12345);

> 生成临时的自定义函数：create temporary function mw_hello as 'com.mingwang.HiveUDF' using jar 'hdfs://mingwang1/hive/jar/udf_jar_1.jar';

#### Hive案例
##### 天气
数据如下：

'''sql
2019-11-23 11:11:11 21c
2019-11-23 11:11:11 21c
2019-11-23 11:11:11 21c
2019-11-23 11:11:11 21c
2019-11-23 11:11:11 21c
2019-11-23 11:11:11 21c
2019-11-23 11:11:11 21c
2019-11-23 11:11:11 21c
2019-11-23 11:11:11 21c
2019-11-23 11:11:11 21c
2019-11-23 11:11:11 21c
'''

指标：

'''sql
表名：weather
字段：最高温度，最高温度的日期
批量：月
'''

分析：

'''sql
最高温度：select max(温度) from t_weather
最高温度日期：select data from t_weather where 温度=max(温度)
'''

先找到源数据表（应为没有，所以创建，并且导入数据）

'''sql
create external table inner_ods_01_weather(
wdate string,
temp string
)
row format delimited fields terminated by '\t'
lines terminated by '\n'
location '/datas/hive/inner/DDS/weather';

load data inpath '/datas/hive/weather.txt' into table inner_ods_01_weather;

# sql
select date_format(wdate,'yyyyMM'),max(temp) from weather group by date_format(wdate,'yyyyMM');

# 每月最高温度的日期
select
    tw.wdate,
    tw.temp
from
    weather tw,
    (select
        date_format(wdate,'yyyyMM')df,
        max(temp) maxtemp
    from weather t_weather
    group by date_format(wdate,'yyyyMM')
    ) tm
where tw.temp=tw.maxtemp and date_format(tw.wdate,'yyyyMM')=df'

# 统计直接好友，并用视图功能达到行转列的功能
select name,fc from t_friend lateral view explode(friends) friendtable as fc;

# 直接好友
select concat(name,':',fc) from t_friend lateral view explode(friends) friendtable as fc;

# 间接好友
select
    tj1.name,
    tj1.fc,
    tje.fc
from
    (select name,fc from t_friend view explode(friends) friendtable as fc) tj1,
    (select name,fc from t_friend view explode(friends) friendtable as fc) tj2
where tj1.name = tj2.name and tj1.fc <> tj2.fc;

select
    concat(tj1.fc,':',tj2.fc) cfc
from
    (select name,fc from t_friend view explode(friends) friendtable as fc) tj1,
    (select name,fc from t_friend view explode(friends) friendtable as fc) tj2
where tj1.name = tj2.name and tj1.fc <> tj2.fc;

# 间接好友推荐度
select
    concat(tj1.fc,':',tj2.fc),
    count(1)
from
    (select name,fc from t_friend view explode(friends) friendtable as fc) tj1,
    (select name,fc from t_friend view explode(friends) friendtable as fc) tj2
where tj1.name = tj2.name and tj1.fc <> tj2.fc
group by concat(tj1.fc,':',tj2.fc);
'''

#### hive分桶表
> 根据字段进行切割数据表，分桶是将数据集分解为更容易管理的若干部分的另一种技术。

> 原理：是将字段值hash去模分布到不用的桶里。

> 怎么取用：建表语句的时候指定那个字段作为分桶的依据，并且设置好数量。

'''sql
# 开启参数
set hive.enforce.bucketing=true;
set mapreduce.job.reduce=3;

create external table if not exists salgrade_cluster (
    grade int,
    losal int,
    hisal int
) clustered by(losal) into 3 buckets
row format delimited fields terminated by '\t'
location '/data/DDS/salgrade_cluster';
'''

> 分桶的表无法用load语句

通常我们会使用插入语句：

'''sql
insert overwrite table salgrade_cluster select * from salgrade cluster by (losal);

-- 数据取样
# 安照桶的个数取样
select * from salgrade_cluster tablesample(bucket 2 out of 2 on losal);

# 安照百分比进行取样
select count(1) from salgrade_cluster tablesample(bucket 1 out of 2 on rand());

'''

## 数据倾斜

### 引发数据倾斜的5种可能

**大数据文件不可切分**

map默认是128M进行切分，当碰到不可切分的大数据文件的时候可能会发生数据倾斜。

解决方案： 将数据存储格式改为orc或者sqence等列式存储，或者bzip2等可分割的压缩算法。

**多维表关联、数据膨胀**

笛卡尔积

'''sql
select * from a
    left join b on a.id=b.id=id
    left join c on c.name=d.name
    left joim d on d.no=c.no;
'''

解决方案：添加一张中间表

**中间数据无法消除**

**业务无关的数据引发的数据倾斜**

一堆字段全是空值

解决方案：将无用的字段加工处理掉

**无法消解中间结果的数据量引发的数据倾斜**

collect_list  聚合函数
'''aql
select s_age,collect_list(s_score) list_score from student_tb_txt group by s_age
'''

调整map的内存

**两个Hive数据表连接时引发的数据**

key分布不均

开启map端聚合

## Hive优化

### 本地模式

### 并行模式

### 严格模式

### JVM重用

### 表的优化（小表与大表、大表与小表）

### mapside聚合

### count(Distinct)

### 防止笛卡尔积

### 行列过滤（列裁剪）

### 运算符两边有一个为空，那么结果为空
处理方案：select nvl(bal1,0) + nvl('',0) from sxt;

nvl不识别空白

解决方案：select nvl(bal1,0) + nvl(cast(bal2 as int),0) from sxt;

## 尽量使用 orc 数据文件格式存储，为什么呢？

1. ORC是列式存储，有多种文件压缩方式，并且有着很高的压缩比。
2. 文件是可拆分（split）的，应为，在hive中使用ORC作为表的文件存储格式，不仅节省HDFS存储资源，查询任务的输入数据量减少，使用的maptask也就减少了。
3. 提供了多种索引，row group index、bloom filter index。
4. ORC可以支持复杂的数据结构（比如Map等）
