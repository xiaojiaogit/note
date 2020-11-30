# hive学习笔记（hive只是改变了hdfs的数据呈现形式）：
## DDL(数据定义)：
### 库
#### 查看数据库
'''mysql
show databases;
show databases like 'db_hive*';
# 过滤显示查询的数据库，这里和mysql上的方法有一点不同，myslq里是%，hive是\*
desc database test;
# 查看数据库详情
desc database extended test;
# 查看详细的数据库详情
'''
#### 创建数据库
'''mysql
create database [if not exists] database_name [comment database_comment] [with dbproperties (property_name=property_value,...)];
# 创建数据库 【如果不存在】 数据库名 【数据库说明】 【设置数据库的字段值】
create database test；
# 如果所创建的数据库已经操作上面的命令会报错
create database if not exists test；
# 如果使用以上命令就不会报错
create database test2 location '/mytest'
# 使用以上命令会指定数据库在hdfs上创建的位置
'''
#### 使用数据库
'''mysql
use test;
alter database test set dbproperties('create_time'='2020');
# 修改数据库的字段属性，修改后可以使用：desc database extended test;查看详情
'''
#### 删除数据库
'''mysql
drop database test;
# 删除空数据库
drop database test cascade;
# 使用此命令可以删除数据库以及其下的表数据
'''
### 表
#### 查看表
'''mysql
show tables;
desc formatted student2;
# 查看表的的信息，其中Table Type: MANAGED_TABLE 是一个新的知识点，我们称其为内部表。
'''
#### 创建表
##### 管理表(内部表)
'''mysql
create table if not exists student(
id int, name string
)
row format delimited fields terminated by '\t'
# 属性之间用\t隔开（分割符）
stored as textfile
# 存储为什么
location '/user/hive/warehouse/student';
# 落盘的位置
'''

'''mysql
create table if not exists student3 as select id, name from student;
# 将从student表里查询出来的id和name放到新创建的student3里，他会走一遍mapreduce
'''

'''mysql
create table if not exists student4 like student;
# 创建一个和student表结构一样的student4表
'''

'''mysql
create table student5 (id int, name string) row format delimited fields terminated by '\t' location '/student';
# 使用场景：hdfs上存在一份数据，你想以表的形式对他进行处理，那么你可以用上面的方法做
# 但是这种方式存在严重的问题，管理表会把所有的内容认为是hive自己的，会对所有数据进行直接操作
'''
##### 外部表
'''mysql
create external table student5 (id int, name string) row format delimited fields terminated by '\t' location 'student';
'''

##### 管理表与外部表的转换
'''mysql
alter table student5 set tblproperties('EXTERNAL'='TRUE');
# 管理表转外部表
'''
#### 分区表(可以细化我们管理数据的粒度)
> 体现在分层，作用是减少了全表扫描的概率，一定程度上可以看作是索引
##### 创建分区
'''mysql
# 一级分区表
create table dept_partition(deptno int, dname string, loc string) partitioned by (month string) row format delimited fields terminated by '\t';
# 往一级分区表里导入本地数据
load data local inpath '/opt/module/datas/dept/txt' into table default.dept_partition partition(month='201709');
# 二级分区表
create table dept_partition2(deptno int, dname string, loc string) partitioned by (month string, day string) row format delimited fields terminated by '\t';
# 往二级分区表里导入本地数据
load data local inpath '/opt/module/datas/dept/txt' into table default.dept_partition partition(month='20170905');

# 有这么一种情况，首先我们在hive里创建一张分区表，当我们自己在hdfs创建目录的后，从本地上传一份数据，此时在hive里查寻表里数据时，你会发现查不到内容，对于这种问题，我们有很多解决的办法，具体如下：
# 方式1：（创建联系）
dfs -mkdir -p /dept/month=201709/day=10;
dfs -put /opt/module/datas/dept.txt /dept/month=201709/day=11;
msck repair table dept_partition2;      # 这是最长见的一种，此时查询就有了结果（建立联系）
select * from dept_partition2;
# 方式2：（添加分区）
dfs -mkdir -p /dept/month=201709/day=11;
dfs -put /opt/module/datas/dept.txt /dept/month=201709/day=11;
alter table dept_partition2 add partition(month='201709', day='11')
select * from dept_partition2;
# 方式3：通过hive的命令，从本地load数据，不使用hdfs上传
load data local inpath '/opt/module/datas/dept/txt' into table dept_partition2 partition(month='201709', day='12')
select * from dept_partition2;
'''
##### 按分区查询数据
###### 单分区查询
'''mysql
select * from dept_partition where month='201709';
'''
###### 多分区联合查询
'''mysql
select * from dept_partition where month='201709' union select * from dept_partition where month='201708';
'''
##### 增加分区
'''mysql
# 创建单个分区
alter table dept_partition add partition(month='201706');
# 同时创建多个分区
alter table dept_partition add partition(month='201707') partition(month='20178');
'''
##### 删除分区
'''mysql
# 删除单个分区
alter table dept_partition drop partition (month='201706');
# 同时删除多个分区
alter table dept_partition drop partition (month='201706'), partition (month='201707');
'''
##### 查询分区
###### 查询分区表有多少分区
'''mysql
show partitions dept_partition;
'''
###### 查询分区表结构
'''mysql
desc formatted dept_partition;
'''
#### 修改表
##### 重命名表
'''mysql
# 语法：
alter table table_name rename to new_table_name;
# 实操案例
alter table dept_partition2 rename to dept_partition3;
'''
##### 增加、修改、删除表分区（可以会看分区表的操作）
##### 增加、修改、替换列信息
'''mysql
# 实际案例
# 查询表结构：
desc dept_partition;
# 添加列：
alter table dept_partition add columen(deptdesc string);
# -查询列：
desc dept_partition;
# 更新列
alter table dept_partition change column deptdesc desc int;
# -查询列：
desc dept_partition;
# 替换列
alter table dept_partition replace columns(deptno string, dname string, loc string);
# -查询列：
desc dept_partition;
'''
#### 删除表
'''mysql
dept table dept_partition;
'''

## DML(数据操作)：
### 数据导入
'''mysql
# 从本地导入数据，他是一个上传的过程
load data local inpath '/opt/module/datas/nihao.txt' into table student;
# 从hdfs导入数据,他是一个移动的过程
load data inpath '/student/nihao.txt' into table student;
# 查看数据
select * from student;

# 覆盖表里的数据
load data local inpath '/opt/module/datas/nihao.txt' overwrite into table student;

# import数据到指定的Hive表中（注意：先用export导出数据后，再将数据导入）
import table student partition(month='201709') from '/user/hive/export/student';

# 分区可以看分区的操作

'''
### 数据插入
'''mysql
# 一条一条插入（不用）
insert into table student partition(month='201709') values(1, 'nihao'), (2, 'wohao');
# 通过查询插入（常用）
insert overwrite table student partition(month='201708') select id, name from student where month='201709';

# 一次性插入多条数据(hive里可以先些from)
from student insert overwrite table student partition(month='201707') select id, name where month='201709' insert overwrite table student partition(month='201706') select id, name where month='201709';

# 将查询结果插入到一张新表里(不要忘了 as 关键字)
create table if not exists student2 as select id, name, name nn from student;

# hdfs上有数据时，我们可以直接在hive里建立其元数据，数据会自动导入
'''
### 数据导出
'''mysql
# 将查询数据导出到本地磁盘(不限定格式)
insert overwrite local directory '/opt/module/datas/export/student' select * from student;

# 将查询数据导出到本地磁盘（规定分割符）
insert overwrite local directory '/opt/module/datas/export/student2' row format delimited fields terminated by '\t' select * from student;

# 将查询结果导出到hdfs上（不加local就可以）
insert overwrite directory '/export/student2' row format delimited fields terminated by '\t' select * from student;

# 通过hadoop下载命令导出到本地
dfs -get /student/month=201709/000000_0 /opt/module/datas/export/student3.txt;

# 通过hive命令导出到本地（如果遇到权限不够的情况，可根据实际情况赋予其相对的权限）
hive -e 'select * from default.student;' > /opt/module/datas/export/student4.txt;

# 通过Export导出到HDFS上
ecport table default.student to '/user/hive/export/student';

# 通过Sqoop导出-----------》》》重要的留到后面学了弄

'''
### 数据清除
'''mysql
# truncate 只能删除管理表中的数据，不能删除外部表中的数据
truncate table student;
'''
## 查询
### 基本查询（select...from）
#### 全表和特定列查询
'''mysql
# 创建部门表
'''
### where查询



### 分组查询
