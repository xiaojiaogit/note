--
--注：本套题，同学可以查阅任何参考资料，独立完成。

employee表说明：

employeeno（员工编号）
ename（员工名）
job（工种）
mgr（该员工的经理）
hiredate（入职时间）
sal（月收入）
comm（提成）
deptno（部门编号）

dept部门表说明：

deptno（部门编号）
dname（部门名称）
loc（部门所在地址）


salgrade薪酬级别表说明：

grade（薪酬级别）
losal（最低薪资）
hisal（最高薪资）



--1、查询dept表的结构
desc dept;

--2、检索dept表中的所有行、所有列的数据。
select * from dept;

--3、检索emp表中的员工姓名、月收入及部门编号
select ename, sal, deptno from employee;

--4、检索emp表中员工姓名、及雇佣时间 日期数据的默认显示格式为"dd-mm-yy"
hive
    select ename, date_format(hiredate, 'd-m-y') from employee;

mysql
    select ename, date_format(hiredate, '%d-%m-%y') from employee;

--5、使用distinct去掉重复行。
--检索emp表中的部门编号及工种，并去掉重复行。
select distinct deptno, job from employee;

--查询employees表中有多少个部门
select count(distinct deptno) from employee;

--6、使用表达式来显示列
--检索emp表中的员工姓名及全年的收入
select ename, (sal * 12) yearsal from employee;

--7、使用列别名
--用“姓名”显示员工姓名，用“年收入”显示全年收入。
select ename 姓名, (sal * 12) 年收入 from employee;

--8、连接字符串
--检索emp表，用isa这个字符串来连接员工姓名和工种两个字段
--结果示例：
    
--smithisaclerk	
--allenisasalesman	
--wardisasalesman	
select concat(ename, 'isa', job) from employee;

--9、使用where子句
--检索月收入大于2000的员工姓名及月收入。
select ename, sal from employee where sal > 2000;

--检索月收入在1000元到2000元的员工姓名、月收入及雇佣时间。
select ename, sal, hiredate from employee where sal >= 1000 and sal <= 2000;

--查询1998-4-24来公司的员工有哪些
select * from employee where hiredate = '1998-4-24';

--10、like的用法：
--检索以s开头的员工姓名及月收入。
select ename, sal from employee where ename like 's%';

--检索员工姓名中的第三个字符是a的员工姓名及月收入。
select ename, sal from employee where ename like '__a%';
　
--11、在where条件中使用in操作符
--检索emp表中月收入是800的或是1250的员工姓名及部门编号
select ename, deptno from employee where sal in(800, 1250);

--12、在where条件中使用逻辑操作符（and、or、not）
--显示在部门20中岗位clerk的所有雇员信息
select * from employee where deptno = 20 and job = 'clerk';

--显示工资高于2500或岗位为manager的所有雇员信息
select * from employee where sal > 2500 or job = 'manager';

--13、查询表中是空值的数据
--查询所有经理为空的所有员工信息
select * from employee where mgr is null;

--	检索emp表中有提成的员工姓名、月收入及提成。
select ename, sal, comm from employee where comm is not null and comm != 0;
    
--14、使用orderby子句，进行排序。
--检索emp表中部门编号是30的员工姓名、月收入及提成，并要求其结果按月收入升序、然后按提成降序显示。
select ename, sal, comm from employee where deptno = 30 order by sal, comm desc;

--15，显示系统时间(取别名为"date").
hive
select *, date_format(unix_timestamp(), 'y-m-d') date from employee;

mysql
select *, date_format(sysdate(), '%y-%m-%d') date from employee;

--16，查询员工号，姓名，工资(若为null则作为0处理)
hive
select employeeno, ename, nvl(sal, 0) from employee;

mysql
select employeeno, ename, ifnull(sal, 0) from employee;

--以及工资提高百分之20%（乘1.2）后四舍五入到整数的结果（取别名为newsalary）
select round(sal * 1.2) newsalary from employee;

--17，将员工的姓名（取别名为"name"）按字母表先后顺序排序，并写出姓名的长度（取别名为"length"）
select ename name, length(ename) length from employee order by ename;

--18，查询各员工的姓名，并显示出各员工在公司工作了多少个月份（起别名为"worked_month"）四舍五入到整数。
select ename,round(period_diff(date_format(sysdate(), '%Y%m'), date_format(hiredate, '%Y%m')) worked_month from employee ;

--19，查询员工的姓名和工资，按下面的形式显示结果(工资字段必须为15位,空位用$填充)
select ename, lpad(sal, 15, '$') from employee;

--20，查询员工的姓名，以及在公司工作满了多少个月（worked_month），并按月份数降序排列
select ename, period_diff(date_format(sysdate(), '%Y%m'), date_format(hiredate, '%Y%m')) worked_month from employee order by worked_month desc;

--20，--使用case-when-then-else-end
-- 请查询员工的姓名、job名称、级别
select 
    ename, job, (case job  when 'clerk' then 'a'  when 'salesman' then 'b' when 'manager' then 'c' when 'analyst' then 'd' when 'president' then 'e' when 'other' then 'd'  else 0 end)
from 
    employee;

--2）查询部门号为10,20,30的员工信息,若部门号为10,则打印其工资的1.1倍,20号部门,则打印其工资的1.2倍,30号部门打印其工资的1.3倍数
select ename, deptnp, (case deptno when 10 then sal * 1.1 when 20 then sal * 1.2 when 30 then sal * 1.3 else 0 end) from employee where deptno in(10, 20, 30);

--22，查询公司员工工资的最大值，最小值，平均值，总和
select max(sal), min(sal), avg(sal), sum(sal) from employee;

--23，查询各个不同job的员工工资的最大值，最小值，平均值，总和
select job, max(sal), min(sal), avg(sal), sum(sal) from employee group by job;

--24，查询员工最高工资和最低工资的工资差距
select (max(sal) - min(sal)) from employee;

--25，查询公司的人数，以及在80,81,82,87年，每年雇用的人数，结果类似下面的格式
select 
    count(*) total, 
    sum(case date_format(hiredate, '%y') when 80 then 1 else 0 end) '1980',
    sum(case date_format(hiredate, '%y') when 81 then 1 else 0 end) '1981',
    sum(case date_format(hiredate, '%y') when 82 then 1 else 0 end) '1982',
    sum(case date_format(hiredate, '%y') when 87 then 1 else 0 end) '1987'
from 
    employee;

select 
    deptno,
    count(*) total, 
    sum(case date_format(hiredate, '%y') when 80 then 1 else 0 end) '1980',
    sum(case date_format(hiredate, '%y') when 81 then 1 else 0 end) '1981',
    sum(case date_format(hiredate, '%y') when 82 then 1 else 0 end) '1982',
    sum(case date_format(hiredate, '%y') when 87 then 1 else 0 end) '1987'
from 
    employee
group by
    deptno
;


--26，显示所有员工的姓名，部门号和部门名称(dname)。联合查询emp,dept.
select e1.ename, d1.deptno, d1.dname  from employee e1 left join dept d1 on e1.deptno = d1.deptno;

--27，不重复地查询20号部门员工的job和20号部门的loc.
select e1.job, d1.loc  from employee e1 left join dept d1 on e1.deptno = d1.deptno where e1.deptno = 20;

--28，选择所有有提成的(提成非空并且大于0)员工的ename,dname,loc
select e1.ename,d1.dname,d1.loc from employee e1 left join dept d1 on e1.deptno = d1.deptno where e1.comm is not null and e1.comm > 0;

--29，选择在chicago(一个loc)工作的员工的ename,job,deptno,dname
select e1.ename,e1.job,d1.deptno,d1.dname from employee e1 left join dept d1 on e1.deptno = d1.deptno where d1.loc = 'chicago';

--30，查询所有员工的姓名，员工号，以及他的管理者的姓名和员工号，结果类似于下面的格式：
select e1.ename, e1.employeeno, e2.ename, e2.employeeno from employee e1, employee e2 where e1.mgr = e2.employeeno;

--31，查询各部门员工姓名和他们的同事(在同一个部门工作的其他人)姓名，结果类似于下面的格式：
select e1.deptno, e1.ename, d1.dname from employee e1, dept d1 where e1.deptno = d1.deptno order by e1.deptno;

--32，查询各个管理者的编号及其手下员工的最低工资，其中最低工资低于6000的排除在外，没有管理者的员工不计算在内
select e2.employeeno, min(e1.sal) 
from employee e1, employee e2 
where e1.mgr = e2.employeeno 
and e1.mgr is not null 
group by e2.employeeno 
having min(e1.sal) > 2000 ;

--33，查询所有部门的名称，loc，员工数量和工资平均值
select d1.dname, d1.loc, count(e1.deptno), avg(e1.sal) from employee e1 right join dept d1 on e1.deptno = d1.deptno group by e1.deptno;

--34，根据salgrade表和employee表，查询出所有员工的工资等级。
select e1.ename, e1.sal, s.grade from employee e1, salgrade s where e1.sal between losal and hisal;

--35，使用子查询，查询出ename为'miller'的manager的信息.
select e1.* from employee e1,  (select mgr from employee where ename = 'miller') e2 where employeeno = e2.mgr;

--36，查询chicago这个城市的员工的平均工资。
select avg(sal) from employee e1 join dept d1 on e1.deptno = d1.deptno where d1.loc = 'chicago';

--37，查询各个城市的平均工资。
select avg(sal) from employee e1 right join dept d1 on e1.deptno = d1.deptno group by d1.loc;

--38，查询平均工资高于8000的部门id和它的平均工资.
select deptno, avg(sal) from employee group by deptno having avg(sal) > 8000;

--39，查询平均工资高于6000的job有哪些？
select job from employee group by job having avg(sal) > 6000;

--40，谁的工资比scott高?
select e1.ename from employee e1, (select sal from employee where name = 'scott') e2 where e1.sal not in(e2.sal);

--41，查询公司中工资最低的员工的信息。
select e1.* from employee e1, (select min(sal) sal from employee) e2 where e1.sal = e2.sal;

--42，查询平均工资最低的部门名称
select d1.dname from dept d1 join employee e1 on d1.deptno = e1.deptno group by e1.deptno having avg(e1.sal);

--43，查询平均工资高于公司平均工资的部门有哪些?
select e2.deptno from (
    select avg(sal) avgsal from employee
) e1, (
    select *, avg(sal) avgsal from employee group by deptno
) e2 
where 
    e2.avgsal > e1.avgsal;

--44，查询出公司中所有manager的详细信息
select * from employee where job = 'manager';

--45，各个部门中都有最高的工资，这些“最高工资”中最低的那个部门的是哪个？再查该部门的最低工资是多少？
select e1.minsal, min(e2.sal) from (
    select deptno, min(maxsal) minsal from (
        select deptno, max(sal) maxsal from employee group by deptno
    ) a
)e1, employee e2 where e1.deptno = e2.deptno

--46，查询1999年来公司的人所有员工的最高工资的那个员工的信息.
select * from employee where date_format(hiredate,'%y') = 1999 having max(sal);

--47，
    select department_id
    from employees
    group by department_id
    having avg(salary) >= any(
        --所有部门的平均工资
        select avg(salary)
        from employees
        group by department_id
    )
会返回什么值，为什么？
    返回所有部门的id，因为对比的平均值和查询的任意平均值大于相等

--48，
    select department_id
    from employees
    group by department_id
    having avg(salary)>=all(
    --所有部门的平均工资
        select avg(salary)
        from employees
        group by department_id
    )
会返回什么值，为什么？
    返回一个部门的id，因为对比的平均值和查询的所有平均值的一个大于相等



--49，利用子查询创建表myemp,该表中包含employee表的employeeno,ename,job,sal字段
--	1).创建表的同时复制employee对应的记录	
drop table if not exists myemp;
create table myemp(select employeeno, ename, job, sal from employee);
    
--	2).创建表的同时不包含employee中的记录,即创建一个空表
drop table if not exists myemp1;
create table myemp1(select * from employee where employeeno is null);

--50，对现有的myemp表进行修改操作
--	1).添加一个新列ageint(3)	
alter table myemp add(age int(3));
--	2).修改现有列的类型modify(ename varchar(30));
alter table myemp modify ename varchar(30);
--	3).修改现有列的名字sal to salary	
alter table myemp change sal salary decimal;
--  4).删除现有的列column age;
alter table myemp drop age;

--51，清空myemp表,不能回滚!!	
truncate table myemp;

--52，创建一个表emp2,该表和employee有相同的表结构,但为空表
create table emp2(select * from employee where employeeno is null);

--53，把employee表中20号部门的所有数据复制到emp2表中
insert into emp2(select * from employee where deptno = 20);

--54，更改7369员工的信息:使其工资变为所在部门中的最高工资,job变为公司中平均工资最低的job
select max(e1.sal) from employee e1, (select deptno from employee where employeeno = 7369) e2 where e1.deptno = e2.deptno;
select avg(sal) from employee group by job;
update employee set sal = 3100 where employeeno = 7369;

--55，删除7369号员工所在部门中工资最低的那个员工.
delete from employee where employeeno = 7369;

--56，创建emp3表，结构与employee相同。创建时在job上添加非空约束，在ename上添加唯一约束，在deptno上添加外键约束，约束指向dept表的deptno。
create table emp3(
    employeeno decimal(4) not null, 
    ename varchar(10), 
    job varchar(9) not null,
    mgr decimal(4),
    hiredate date,
    sal decimal(7),
    comm decimal(7),
    deptno decimal(2),
    foreign key(deptno) references dept(deptno)
);

--57，同上创建emp4表，建表时建立在deptno上添加外键约束，约束指向dept表的deptno。同时，指定该约束在级联删除主键时，不级联删除外键的数据。
create table emp4(
    employeeno decimal(4) not null, 
    ename varchar(10), 
    job varchar(9),
    mgr decimal(4),
    hiredate date,
    sal decimal(7),
    comm decimal(7),
    deptno decimal(2),
    foreign key(deptno) references dept(deptno) on delete set null
);

--58，查询员工表中salary前10名的员工信息
select * from employee order by sal limit 10;

--59，查询员工表中salary在10-20名的员工信息。
select * from employee order by sal limit 10,10;

--60，对员工表内容根据salary排序后，进行分页查询，每页3条。
select * from employee order by sal limit 0 , 3;