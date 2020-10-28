# MySQL数据库笔记 



## 编码配置

### 设置cmd编码：

```cmd
chcp 65001
```

### 查看数据库编码：

```cmd
show variables like ‘char%’;
```

### 设置数据库编码：

```cmd
set bariable_name 要设置的value(utf-8)
```



## root密码的修改方法

### 方法1：用SET PASSWORD命令

> 首先登录MySQL。
>
> 格式：set password for 用户名@localhost = password（’新密码’）;
>
> 例子：set password for root@localhost = password(‘123’);

### 方法2：用mysqladmin

> 格式：mysqladmin -u用户名 -p旧密码 password 新密码 
>
> 例子：mysqladmin -uroot -p123456 password 123

### 方法3：用UPDATE直接编辑user表

> 首先登录mysql。
>
> use mysql;update user set passw=password(‘123’) where user=’root’ and host=’localhost’; 
>
> flush privileges;

### 方法4：在忘记root密码的时候，可以这样做

**以windows为例：**

> 1. 关闭正在运行的MySQL服务。
> 2. 打开DOS窗口，转到mysql\bin目录。
> 3. 输入mysqld –skip-grant-tables 回车。 –skip-grant-tables 的意思是启动MySQL服务的时候跳过权限表认证。
> 4. 再打开一个DOS窗口（因为刚才那个DOS窗口已经不能动了），转到mysql\bin目录。
> 5. 输入mysql回车，如果成功，将出现MySQL提示符 >。
> 6. 连接权限数据库:use mysql; 。
> 7. 改密码： update user set password=password（“123”） where user=”root”; (别忘了最后加分号)
> 8. 刷新权限（必须步骤）： flush privileges; 。
> 9. 退出 quit。
> 10. 注销系统，再进入，使用用户名root和刚才设置的新密码123登录。



## MySQL数据库的语法（方言）

### 导入数据：

第一步：登录MySQL数据库管理系统 DOS命令窗口：`mysql -uroot -p` 

第二步：查看有那些数据库 `show databases;` (这个不是sql语句，属于MySQL的命令) 

第三步：创建属于我们自己的数据库 `create database school;` (这个不是sql语句，属于MySQL的命令) 

第四步：使用school数据库 `use school;` (这个不是sql语句，属于MySQL的命令) 

第五步：查看当前使用的数据库中有那些表 `show tables;` (这个不是sql语句，属于MySQL的命令) 

第六步：初始化数据 `source 把sql脚本文件拉进来` 注意：这是导入数据，练习的时候使用的数据

### 什么是sql脚本？

当一个文件的扩展名是 .sql ,并且该文件中编写了大量的sql语句，我们称这样的文件为sql脚本。

 **注意：**sql脚本中的数据量太大的时候，无法打开，请使用source命令完成初始化。

### SQL语句的分类：

DQL: （数据查询语言）查询语句，凡是select语句都是DQL。 

DML: （数据操作语言）insert delete update，对表当中的数据进行增删改。 

DDL: （数据定义语言）create drop alter， 对表结构的增删改。

TCL: （事务控制语言）commit提交事务， rollback回滚事务。 

DCL: （数据控制语言）grant授权、revoke撤销权限等。 root超管 —> 创建用户



## 增删改查，有一个专业术语：

### CRUD操作:

Create（增） Retrieve（检索） Update（修改） Delete（删除）



## 数据库操作

### 查看数据库:

```mysql
show databases;
```

### 创建数据库:

```mysql
create database school character set utf8 collate utf8_general_ci;
```

### 删除数据库:

```mysql
drop database school;
```

### 使用数据库:

```mysql
use school;
```

### 查看当前操作的数据库:

```mysql
select database();
```

### 查看数据库的建库语句：

```mysql
show create database school;
```



## 约束 (Constraint)

### 什么是约束？ 

在创建表的时候，可以给表的字段添加相应的约束，添加约束的目的是为了保证表中数据的：

 **合法性，有效性，完整性。**

### 常见的约束有那些？ 

非空约束 （not null） ： 约束的字段不能为NULL 

唯一约束 （unique） ： 约束的字段不能重复 

主键约束 （primary key） ： 约束的字段既不不能为NULL，也不能重复（简称PK） 

外键约束 （foreign key） ： … （简称FK） 

~~检查约束~~ （check） ： 注意Oracle数据库有check约束，但MySQL没有，目前MySQL不自持该约束。

### 注意：

**列级约束：**

字段 约束【直接写在字段后面的叫列级约束】

**多个字段联合起来添加约束的格式是：**

约束（字段1，字段2，…）另起一行写 【这种情况叫表级约束】

**表级约束：**

唯一约束可用、主键约束可用、非空约束不可用

### 主键的分类：

**根据主键字段的字段数量来划分：** 

单一主键 （推荐使用，常用的） 

复合主键 （多个字段联合起来添加一个主键约束，不推荐使用）（复合主键违背三范式） 

**根据主键性质来划分:** 

自然主键 （最好是一个和业务无关的自然数） 

业务主键 （主键值和系统的业务挂钩，例如：拿银行卡号、身份证号作为主键。）（不推荐使用）

**注意：**

一张表的主键约束只能有1个。（必须记住）

### MySQL提供主键自增：

(非常重要)语法：

在主键后加 auto_increment    — 自增 

案例： 

```mysql
drop table if exists t_user; 

create table t_user(
    id int primary key auto_increment comment '编号',
    username varchar(255) not null default 'admin' comment '用户名'
)ENGINE=INNODB DEFAULT CHARSET=utf8;

 insert into t_user(username) values('a');
 insert into t_user(username) values('b');
 insert into t_user(username) values('c');
 insert into t_user(username) values('d');
 insert into t_user(username) values('e');
 insert into t_user(username) values('f');

 select * from t_user; 
```



### 提示：

Oracle当中也提供了一个自增机制，叫做：序列（sequence）对象。

### 外键约束

表B中的字段c引用表A的字段a，此时表B叫做子表,表A叫做父表。

顺序要求：

删除数据的时候，先删子表，再删父表。 

添加数据的时候，先添加父表，在添加子表。 

创建表的时候，先创建父表，再创建子表。 

删除表的时候，先删除子表，再删除父表。 

语法格式： foreign key (classno) references t_class (cno) 

案例： drop table if exists t_student; drop table if exists t_class;

create table t_class ( cno int, cname varchar (255), primary key (cno) );

create table t_student ( sno int, sname varchar (255), classno int, foreign key (classno) references t_class (cno) — 重点，必须背会 );

### 注意：

外键可以为NULL。 

被引用的字段不一定是主键，但至少具有unique约束。



## 数据表操作

**<u>对于表结构的修改，使用工具完成即可，实际开发很少用。</u>**

### 创建表：

```mysql
-- 目标：创建一个school数据库
-- 创建学生表（列，字段） 使用SQL创建
-- 学号int 登陆密码varchar（20） 姓名(30)，性别varchar（2），出生日期（datatime），家庭地址，email

-- 注意点，使用英文（），表的名称 和 字段 尽量使用 '' 括起来
-- AUTO_INCREMENT自增
-- 字符串使用 单引号 括起来！
-- 所有的语句后面加 ,（英文半角的），最后一个不用加
-- PRIMARY KEY 主键，一般一个表只有一个唯一的主键!

CREATE TABLE IF NOT EXISTS `student` (
	`id` int(4) NOT NULL AUTO_INCREMENT COMMENT '学号',
	`gradeid` INT(10) NOT NULL COMMENT '学生的年级',
	`name` VARCHAR(30) NOT NULL DEFAULT '匿名' COMMENT '姓名',
	`pwd` VARCHAR(20) NOT NULL DEFAULT '123456' COMMENT '密码',
	`sex` VARCHAR(2) NOT NULL DEFAULT '密' COMMENT '性别',
	`birthday` DATETIME DEFAULT NULL COMMENT '出生日期',
	`address` VARCHAR(100) DEFAULT NULL COMMENT '家庭住址',
	`email` VARCHAR(50) DEFAULT NULL COMMENT '邮箱',
	PRIMARY KEY(`id`)
)ENGINE=INNODB DEFAULT CHARSET=utf8;
```

### 修改表名称：

```mysql
rename table student to stu;
```

### 删除表：

```mysql
drop table student;
```

### 查看表：

```mysql
show tables;
```

### 查看数据库中的表：

```mysql
show tables from test
```

### 查看表结构：

```mysql
desc student;
```

### 查看数据库的建表语句：

```mysql
show create table student;
```



## 数据操作

### 向表中插入数据：

```sql
insert into `student` values( 110,3,'小红','123321','女',1998.11.04:12:23:34,'山西省朔州市','10086.wc.com' );
```

### 向表中指定的地方插入数据:

```sql
insert into `student` (`name`,`pwd`) values('jiao','345');
```

### 一次插入多行数据:

```mysql
insert into t_student(no,name,sex,classno,birth) values(2,'wangsi','1','shiyeban','1995-02-23'),(3,'wanger','1','shiyeban','1985-02-23');    -- 需要用逗号隔开
```

### 删除表里的数据:

```sql
delete from `student`； -- 不会影响自增  存在内存中，断电即失
```

### 删除表里指定的数据:

```sql
delete from `student` where `id`=2;
```

### 删除大表数据（重点）：

**语句**：

```mysql
truncate table emp1;   -- 自增会归零 存在文件中
-- 表被截断，不可回滚。数据永久丢失。
```

### 修改表里的内容

```sql
update `student` set `name`='王二',sex='男' where `id`=3;
-- BETWEEN 表示在什么什么区间[]  例如：BETWEEN 2 and 3
-- CURRENT_TIME    数据库时间函数set `XX`=CURRENT_TIME  就会打印当前数据库时间
```

### 表的复制

**语法**：

create table 表名 as select语句; 

将查询结果当作表创建出来。

**案例**：

```mysql
create table emp1 as select ename,sal from emp;
```

### 将查询结果插入到一张表中

```mysql
insert into emp1 select * from emp1;
```

## 查询语句（正统血脉）

```sql
-- 查询系统版本
select version();
```

### 简单的查询语句（DQL）

**语法格式：**

```sql
 select 
 	字段1，字段2，字段3，… 
 from 
 	表名；
```

**提示：**

 1、任何一条sql语句以“;”结尾。 2、sql语句不区分大小写。

**查询员工的年薪：**(说明字段可以参与数学运算) 

```sql
select 
	ename,sal * 12 
from 
	emp;
```

**给查询结果的列重命名：** 

```sql
select 
	ename,sal * 12 
as 
	yearsal 
from 
	emp;
```

**别名中有中文：** 

```sql
select 
	ename,sal * 12 as '年薪' 
from 
	emp;  -- 用单引号括起来才正确
```

**注意：**

标准sql语句中要求字符串使用单引号括起来。虽然MySQL支持双引号，尽量别用。 as 关键字可以省略。

**查询所有字段：** 

```sql
select 
	* 
from 
	emp;   -- 实际开发中不建议使用*，效率较低。
```

**函数 concat(a,b)** 在所有查出来的 b 字段前添加 a 内容

```sql
select 
	concat('姓名:',studentName) as '姓名字' 
from 
	student;
```

### 条件查询

**语法格式：** 

```sql
select 
	字段，字段… 
from 
	表名 
where 
	条件;
```

**执行顺序：** 

先from，然后where，最后selsct;

**查询工资等于5000的员工姓名：** 

```sql
select 
	ename 
from 
	emp 
where 
	sal = 5000;
```

**查询SMITH的工资：** 

```sql
select 
	sal 
from 
	emp
where 
	ename = 'SMITH';  -- 字符串使用单引号括起来。
```

**找出工资高于3000的员工：** 

```sql
select ename,sal from emp where sal > 3000; 

select ename,sal from emp where sal < 3000;

select ename,sal from emp where sal >= 3000; 

select ename,sal from emp where sal <= 3000; 

select ename,sal from emp where sal = 3000; 

select ename,sal from emp where sal != 3000;    
-- != == <> 都是不等于的意思
```

**找出工资在1100~3000的员工(包括1100和3000)：** 

```sql
select ename,sal from emp where 1100 <= sal && sal <= 3000; 

select ename,sal from emp where 1100 <= sal and sal <= 3000; 

select ename,sal from emp where sal between 1000 and 3000; 

-- between…and… 是闭区间 【1100 ~ 3000】 
-- between…and… 在使用的时候必须左小右大。(在字符方面也可以应用)
```

**找出那些人没有津贴：** 

```sql
-- 在数据库当中NULL不是一个值，代表什么也没有，为空。 
-- 空不是一个值，不能用等号衡量。 
-- 必须用 is null 或者 is not null 

select ename,sal,comm from emp where comm is null or comm = 0; 
select ename,sal,comm from emp where COMM is null;  -- 津贴不null的员工
```

**找出工作岗位是MANAGER和SALESMAN的员工：**

```sql
select ename,job from emp where job = ‘manager’ or job = 'salesman';
```

**and和or联合起来用：**
**找出薪资大于3000的并且部门编号是20或30部门的员工。**

```sql
select ename,sal,deptno from emp where sal > 1000 and (deptno = 20 or deptno = 30);  
-- 注意 and 和 or 的优先级 

-- 注意：当运算符的优先级不确定的时候加小括号。
```

**in等同于or：**
**找出工作岗位是MANAGER和SALESMAN的员工。** 

```sql
select ename,job from emp where job in('manager' , 'salesman');
-- not in: 不是（这个，或这个）的数据
```

### 模糊查询 like：

**找出名字当中含有O的：**

```sql
--(在模糊查询中，必须掌握两个特殊符号： 一个是 %，一个是 _) % 代表任意多个字符， _ 代表任意一个字符。
select ename from emp where ename like '%O%';
```

**找出名字中第二个字母是A的：** 

```sql
select ename from emp where ename like '_A%';
```

### 排序：

**按照工资升序找到员工名称和薪资：** 

```sql
select ename,sal from emp order by sal; 
```

**注意:** 默认是升序, 用asc表示指定升序，desc表示降序。 

```sql
select ename,sal from emp order by sal;  -- 默认是升序 

select ename,sal from emp order by sal asc;   -- 指定升序 

select ename,sal from emp order by sal desc;  -- 指定降序
```

**按照工资的降序排列，当工资相同的时候再按照名字的升序排列:**

```sql
select ename,sal from emp order by sal desc,ename asc; 
```

**注意：** 越靠前的字段越能起到主导作用。只有当前面的字段无法完成排序的时候，才会启用后面的时段。

**找出工作岗位是SALESMAN的员工，并且要求按照工作降序排列：** 

```sql
select ename,job,sal from emp where job = ‘SALESMAN’ order by sal desc;
```

**执行顺序**： 

```sql
select 
	字段 3 
from 
	表名 1 
where 
	条件 2 
order by 
	… 4
-- order by 是最后执行的
```

### 分组函数

**count 计数		sum 求和		avg 平均值		max 最大值		min 最小值**

**记住：** 所有的分组函数都是对”某一组”数据进行操作的。

```mysql
找出工资总和： 
select sum(sal) from emp;

找出最大工资： 
select max(sal) from emp;

找出最小工资： 
select min(sal) from emp;

找出平均工资： 
select avg(sal) from emp;

找出总人数： 
select count(*) from emp; 
select count(ename) from emp;
```

分组函数一共5个。

**分组函数含有另一个名字：**

多行处理函数。 

**多行处理函数的特点：**

输入多行，最终输出的结果是一行。 分组函数自动忽略NULL。 

**找出工资高于平均工资的员工：** 

```mysql
select ename,sal from emp where sal > (select avg(sal) from emp); 
```

**注意：**

分组函数不能直接使用在where子句当中。

**why？** 

因为group by是在where执行之后才会执行的。

**count( * ) 和count(comm) 的区别：** 

> count( * ):不是统计某个字段中数据的个数，而是统计总记录条数。（和某个字段无关）
>
>  conur(comm): 表示统计comm字段中不为NULL的数据总量。

**分组函数也能组合起来用：** 

```mysql
select count( * ),sum(sal),avg(sal),max(sal),min(sal) from emp;
```

### 单行处理函数

- 特点： 输入一行，执行一行。

- 计算每个员工的年薪： 

  ```sql
  select ename,(sal+comm) * 12 as yeaesal from emp;
  ```

- 重点： 

  所有数据库都是这样规定的，只要有NULL参与的运算结果一定是NULL。

- 使用ifnull函数： 

  ```sql
  select ename,(sal+ifnull(comm,0)) * 12 as yearsal from emp;
  ```

- ifnull() 空处理函数： 

  ifnull (可能为NULL的数据，被当做什么处理) — 属于单行出路函数。 

  ```sql
  select ename,ifnull(comm,0) as comm from emp;
  ```

### group by 和 having

- group by : 

  按照某个字段或者某些字段进行分组。

- having ： 

  对分组之后的数据进行再次过滤。

- 案例： 找出每个工作岗位的最高薪资。

  ```sql
  select max(sal),job from emp group by job;
  ```

- 注意： 

  分组函数一般都会和 group by 联合使用，这也是为什么它被称为分组函数的原因。 

  并且任何一个分组函数（count sum avg max min） 都是在group by语句执行结束之后执行的。 

  当一条sql语句没有group by的话，整张表的数据会自成一组。

- 记住一个规则： 

  当一条语句中有group by的话，select后面只能跟分组函数和参与分组的字段。

- 每个工作岗位的平均薪资？ 

  ```sql
  select job,avg(sal) from emp group by job;
  ```

- 多个字段联合起来一起分组： 

  案例：找出每个部门不同工作岗位的最高薪资。 

  ```sql
  select deptno,job,max(sal) from emp group by deptno,job;
  ```

- 找出每个部门的最高薪资，要求显示薪资大于2900的数据。 

  ```sql
  select max(sal),deptno from emp where sal > 2900 group by deptno; — 效率高
  --能用where解决尽量使用where解决 
  select max(sal),deptno from emp group by deptno having sal > 2900; — 效率低
  ```

- 找出每个部门的平均薪资，要求显示薪资大于2000的数据。 

  ```sql
  select deptno,avg(sal) from emp group by deptno having avg(sal) > 2000;
  ```

### 总结一个完整的DQL语句怎么写：

```sql
select   5
	… 
from     1
	…
where    2
	…
group by 3
	…
having   4
	… 
order by 5
	…
```

### 

```sql
select distinct job from emp;  
-- distinct 关键字去除重复记录。只能出现在所有字段的最前面。 

-- 案例： 统计岗位数量 
select count(distinct job) from emp;
```



## 连接查询

![1592439757214](images/1592439757214.png)

### 什么是连接查询：

在实际开发中，大部分的情况下都不是从单表中查询数据，一般都是多张表联合查询取最终的结果。 

在实际开发中，一般一个业务都会对应多张表，比如：学生和班级，起码两张表。 

如果放在一组表，数据就会存在大量的重复，导致数据的冗余。

### 连接查询的分类

- 根据语法出现的年代来划分的话，包括： 

  SQL92（一些老的DBA可能还会使用这种语法。

  DBA：DataBase Administrator,数据库管理员） 

  SQL99（比较新的语法）

- 根据表的连接方式来划分，包括: 

  内连接： 等值连接 非等值连接 自连接 

  外连接: 左外连接（左连接） 右外连接（右连接） 全连接（这个很少用）

- 在表的连接查询方面有一种现象被称为：笛卡尔积现象。（笛卡尔乘积现象） 

  案例： 找出没一个员工的部门名称，要求显示员工名和部门名。 

  ```sql
  select e.ename,d.dname from emp e,dept d where e.deptno = d.deptno; 
  -- SQL92 的语法，我们不用。
  ```

   **笛卡尔积现象**：

  当两张表进行连接查询的时候，没有任何条件进行限制，最终的查询结果条数是两张表记录条数的乘积。 

  **关于表的别名：**

  ```sql
   select e.ename,d.dname from emp e,dept d; 
  ```

  **表的别名有什么好处？** 

  第一：执行效率高。 

  第二：可读性好。

- 怎么避免笛卡尔积现象？ 

  当然是加条件条件进行过滤。 

- 思考：避免了笛卡尔积现象，会减少记录的匹配次数吗？ 

  不会，次数还是那么多次，只不过显示的是有效记录。

### 内连接

- 内连接之等值连接：

  最大的特点是：条件是等量关系。 

  案例： 找出没一个员工的部门名称，要求显示员工名和部门名。 

  ```mysql
  -- SQL92：（不常用） 
  select e.ename,d.dname from emp e,dept d where e.deptno = d.deptno; 
  -- SQL92 的语法，我们不用。
  
  SQL99：（常用） 
  select e.ename,d.dname from emp e join dept d on e.deptno = d.deptno; 
  
  语法： 
  … 
  	A
  join 
  	B 
  on 
  	连接条件 
  where 
  	…; 
  
  全写：完整形式。 
  select 
  	e.ename,d.dname 
  from 
  	emp e 
  inner join   -- inner可以省略，带着inner可读性更好
  	dept d 
  on 
  	e.deptno = d.deptno; 
  -- SQL99语法结构更清晰一些：表的连接条件和后后来的where条件分离了。
  ```

- 内连接之非等值连接：

  最大的特点是：连接条件中的关系是非等量关系。 

  案例：找出每个员工的工资等级，要求显示员工，工资，工资等级。 

  ```mysql
  select 
  	e.ename,e.sal,s.grade 
  from 
  	emp e 
  inner join     -- inner 可以省略 
  	salgrade s 
  on 
  	e.sal 
  between 
  	s.losal and s.hisal;
  ```

- 自连接：

  最大的特点是：一张表看做两张表,自己连接自己 。

  案例：找出每个员工的上级领导，要求显示员工和对应的领导名。 

  ```mysql
  select 
  	a.ename as ‘员工’,b.ename as ‘领导’ 
  from 
  	emp a 
  inner join 
  	emp b on a.mgr = b.empno; 
  -- 注意：员工的领导编号 = 领导的员工编号
  ```

### 外连接

- 什么是外连接，和内连接有什么区别？

  - 内连接： 假设A和B进行连接，使用内连接的话，凡是A表和B表能够匹配上的记录都查询出来，这是内连接。 AB两张表没有主副之分，两张表是平等的。
  - 外连接： 假设A和B进行连接，使用外连接的话，AB两张表中有一张表是主表，一张表是副表，主要查询主表中的数据， 捎带着查询副表，当副表中的数据没有和主表中的数据匹配上，副表自动模拟出NULL与之匹配。

- 外连接的分类？ 

  左外连接 （左连接）：表示左边的这张表是主表。 

  右外连接 （右连接）：表示右边的这张表是主表。

  **左连接有右连接的写法，右连接也会有对应的左连接的写法。**

- 案例：找出每个员工的上级领导。（所有员工都必须全部查询出来） 

  ```mysql
  select 
  	a.ename as ‘员工’,b.ename as ‘领导’ 
  from 
  	emp a 
  left outer join  -- 左外连接/左连接 — outer可以省略 
  	emp b on a.mgr = b.empno;
  ——–上部分左外连接，下部分右外连接———— 
  select 
  	a.ename as ‘员工’,b.ename as ‘领导’ 
  from 
  	emp b 
  right outer join  -- 右外连接/右连接 — outer可以省略 
  	emp a on a.mgr = b.empno;
  ```

- 练习：找出那个部门没有员工？ 

  ```mysql
  select 
  	d.* 
  from 
  	emp e 
  right outer join 
  	dept d on e.deptno = d.deptno
  where 
  	e.deptno is null;
  ```

  三张表怎么连接查询？

- 案例：找出每个员工的部门名称和工资等级。 

  ```mysql
  select 
  	e.ename,d.dname,s.grade 
  from
  	emp e 
  inner join 
  	dept d 
  on 
  	e.deptno = d.deptno 
  inner join 
  	salgrade s 
  on 
  	e.sal 
  between 
  	s.losal and s.hisal;
  ```

  - 案例：找出每个员工的部门名称、工资等级和上级领导。 

    ```mysql
    select 
    	e.ename as ‘员工’,d.dname,s.grade,e1.ename as ‘领导’ 
    from 
    	emp e 
    inner join 
    	dept d 
    on 
    	e.deptno = d.deptno 
    inner join 
    	salgrade s 
    on 
    	e.sal 
    between 
    	s.losal and s.hisal 
    left outer join 
    	emp e1 
    on 
    	e.mgr = e1.empno;
    ```



**以那张表为基准，就用什么连接：**



![1592440179390](images/1592440179390.png)

## 子查询

### 什么是子查询？子查询都可以出现在哪里？

- select语句当中嵌套select语句，被嵌套的select语句是子查询。

- 子查询在哪里？ 

  ```mysql
  select 
  	..(select)
  from 
  	..(select)
  where 
  	..(select);
  ```

### where子句中使用子查询

案例：找出高于平均薪资的员工信息 

```mysql
select 
	* 
from 
	emp 
where
	sal > (select avg(sal) from emp);
```

### from后面嵌套子查询 (常见)

案例：找出每个部门平均薪水的薪资等级。 

```mysql
select 
	t.*,s.grade 
from 
	(select 
     	deptno,avg(sal) as avgsal 
     from 
     	emp 
     group by 
     	deptno) t 
inner join 
	salgrade s 
on 
	t.avgsal 
between 
	s.losal and s.hisal; 
```

案例：找出每个部门平均的薪水等级。 

```mysql
select 
	e.deptno,avg(s.grade) 
from 
	emp e 
inner join 
	salgrade s 
on
	e.sal 
between 
	s.losal and s.hisal 
group by 
	e.deptno;
```

## 数据加密：MD5

### 用户输入就加密，匹配加密后的内容：

![1592454133622](images/1592454133622.png)



## union

 <u>**可以将查询结果集相加**</u> 

### 案例：

找出工作岗位是SALESMAN和MANAGER的员工？ 

**方法一：**

```sql
select ename,job from emp where job = ‘SALESMAN’ or job = ‘MANAGER’; 
```

**方法二：**

```sql
select ename,job from emp where job in(‘SALESMAN’,’MANAGER’); 
```

**方法三：** 

```sql
--可以把俩个在不相干的表拼在一起，前提查询的列数要一样 
select ename,job from emp where job = ‘SALESMAN’ union select ename,job from emp where job = ‘MANAGER’;
```



## limit 

**<u>重点中的重点，以后分页查询全靠它。</u>**

**<u>limit 是MySQL特有的，其他数据库没有，不通用。（Oracle中有一个相同的机制，叫做rownum）</u>**

**<u>limit 取结果集中的部分数据，这是它的作用。</u>**

### 语法机制：

limit startIndex,length startindex 表示起始位置 length 表示取几个 

案例：取出工资前五名的员工（思路：降序取前5个） 

```sql
select ename,sal from emp order by sal desc; -- 排序 //取前5名 

select ename,sal from emp order by sal desc limit 0,5; 

select ename,sal from emp order by sal desc limit 5;
```

### limit 是sql语句中最后执行的一个环节

 

```sql
-- 命令  执行顺序  语义
select   5   -- 查询 
	… 
from     1   -- 来自那个表 
	… 
where    2   -- 条件 
	… 
group by 3   -- 分组 
	… 
having   4   -- 进一步分组 
	… 
order by 6   -- 排序 
	… 
limit    7   -- 分页查询 
	…; 
```

案例： 找出工资排名在第4到第9名的员工？ 

```sql
select 
	ename,sal 
from 
	emp 
order by 
	sal desc 
limit 
	3,6;
```

### 通用的标准分页sql:

**每页显示3条记录：** 

第一页：0，3 第二页：3，3 第三页：6，3 第四页：9，3 第五页：12，3 

**规律：** 

每页显示pageSize条数： 第pageNo页：（pageNo - 1）* pageSize，pageSize



## 事务

### 什么是事务?

> 一个事务是一个完整的业务逻辑单元，不可分割。 

例如：银行转账，从A账户向B账户转账10000，需要执行两条update语句：

```sql
 update t_act set balance = balance - 10000 where actno = ‘act-001’; 

update t_act set balance = balance + 10000 where actno = ‘act-002’;
```

以上两条DML语句必须同时成功，或者同时失败，不允许出现一条成功，一条失败。 要想保证以上的两条DML语句同时成功或者同时失败，那么就需要使用数据库的“事务机制”。

### 和事务相关的语句：

**只有DML语句（insert、delete、update）**

事务的存在是为了保证数据的完整性、安全性，所以事务只和DML语句相关。

### 事务的四大特征：

**A C I D**

A  :  原子性：事务是最小的工作单元，不可再分。

C  :  一致性：事务必须保证多条DML语句同时成功或者同时失败。

 I  :  隔离性：事务A与事务B之间具有隔离。

D  :  持久性：持久性说的是最终数据必须持久化到硬盘文件中，事务才算成功的结束。

### 相关命令：

MySQL默认开启了自动提交事务;

```mysql
set autocommit = 0;   -- 关闭
set autocommit = 1;   -- 开启 （默认的）

start transaction; -- 标志这一个事务的开始 
rollback;   -- 回滚事务 
commit;   -- 提交事务 
set autocommit = 1;    -- 开启事务自动提交，事务结束

savepoint 保存点;  --设置回滚点，方便回滚到指定点上。
rollback to savepoint 保存点名;     -- 回滚到保存点
release savepoint 保存点名;     -- 撤销保存点
```



## 索引

索引经常出现在where子句中，主键会自动创建索引，推荐使用索引。

- 主键索引 （PRIMARY KEY）
  - 唯一的标识，主键不可重复，只能有一个列作为主键
- 唯一索引 （UNIQUE KEY）
  - 避免重复的列出现，唯一索引可以重复，多个列都可以标识为 唯一索引
- 常规索引 （KEY/INDEX）
  - 默认的，index。key 关键字来设置
- 全文索引 （FullText）
  - 在特定的数据库引擎下才有，MyISAM
  - 快速定位数据

### 创建索引对象语法：

```mysql
create index 索引名称 on 表名 (字段名); 
```

### 删除索引对象：

```mysql
drop index 索引名 on 表名; 
```

### explain+查找语句：

可以查看某条sql语句的执行计划 ， 只有MySQL上有，别的数据库没有 索引底层采用的数据结构是： B + Tree

## 插入1000000条数据：

**<u>（下面的代码存在一些问题）：</u>**

```mysql
  -- 插入100万数据.
DELIMITER $$
-- 写函数之前必须要写，标志
CREATE FUNCTION mock_data ()
RETURNS INT
BEGIN
DECLARE num INT DEFAULT 1000000;
DECLARE i INT DEFAULT 0;
WHILE i<num DO
INSERT INTO `app_user`(`name`,`eamil`,`phone`,`gender`)VALUES(CONCAT('用户',i),'19224305@qq.com','123456789',FLOOR(RAND()*2));
SET i=i+1;
END WHILE;
RETURN i;
END;

SELECT mock_data() -- 执行此函数 生成一百万条数据  
```



## 数据库备份

### 拷贝数据库的方式：

- 直接拷贝物理文件

- 在sqlyog这种可视化工具中手动导出

- 使用命令行导出 mysqldump 命令行使用

  ```bash
  # 导出一张表
  mysqldump -hlocalhost -uroot -proot school student > D:/a.sql
  
  # 导出多张表
  mysqldump -hlocalhost -uroot -proot school student resurl > D:/a.sql
  
  # 导出整个库的所有表
  mysqldump -hlocalhost -uroot -proot school > D:/a.sql
  
  # 导入数据库 在登陆mysql的情况下执行
  source sql文件路径
  # 导入表 进入数据库执行就欧克了
  ```

  ![1592461400064](images/1592461400064.png)



## 视图

### 什么是视图？

站在不同的角度去看数据。（同一张表的数据，通过不同的角度去看待）

### 创建视图：

create view myview as select empno,ename from emp; 

### 删除视图：

drop view myview;

## DBA命令

### 将数据库的数据导出

导出整个库：

 cmd —> mysqldump 数据库名 > 导出的路经.sql -u用户名 -p密码 

导出数据库中的某张表： 

cmd —> mysqldump 数据库名 表名 > 导出的路经.sql -u用户名 -p密码

### 将数据库的数据导入

create database 数据库名; 

use 数据库名;

 source 直接把文件拉进来即可

## 数据库设计三范式

> 重点内容，面试经常问

### 第一范式：

任何一张表都应该有主键，并且每一个字段原子性不可拆分。

### 第二范式：

建立在第一范式的基础之上，所有非主键字段完全依赖主键，不能产生部分依赖。 多对多？两张表，关系表两个外键。

### 第三范式：

建立在第二范式的基础之上，所有非主键字段直接依赖主键，不能产生传递依赖。 一对多？两张表，多的表加外键。 一对一？主键共享 或者 外键唯一。












​	