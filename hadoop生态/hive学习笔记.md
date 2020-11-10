# hive学习笔记（hive只是改变了hdfs的数据呈现形式）：
## DDL：
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
'''mysql

'''
#### 删除表
'''mysql

'''
## DML：
