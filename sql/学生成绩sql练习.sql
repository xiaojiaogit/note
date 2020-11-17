写sql语句之前有要求的：
	1> 一定要知道数据库里面有哪些张表
	2> 一定要知道每张表里有多少个字段，每个字段的含义要搞清楚
	3> 一定要知道每张表之间的关联关系.


mysql查询的时候有 11 个 关键步骤，有先后顺序: 

1> from 表中最高分学生的学号和课程号。
2> 两表笛卡尔积
3> on 根据指定的字段把两表的数据进一步过滤出来，第一次过滤
4> left join 左表是主表，把左表没有关联上的数据也查询出来 
             inner join / right join / where /
5> where 根据指定的字段把两表的数据进一步过滤出来，第二次过滤
6> group by 根据指定字段分组
7> having 分组之后的过滤，第三次过滤，对不满足条件的分组进行过滤
8> select 字段名, count() / avg() /sum() / max() / min()   
           字段名, 只有指定的分组字段才能在这里出现
9> distinct 去重
10> order by desc/asc  
11> limit 分页查询



写 sql 的建议

1> mysql 常用的关键字的用法
   select/distinct /from/as/join/left join/on/where/in/not in/like/not like/group by/having/order by/limit
   
2> mysql 常用的内置函数 count/max/min/avg/sum/year/month 

3> 前提条件是一定要对表数据理解, 每个字段每条记录代表的含义.

4> 首先确认从那张表查询, 尽量用最少的表
5> 牢记 11 个步骤 
6> 确定过滤条件 
7> 确定分组条件 
8> 拆解 sql  
9> 每写一个 拆解 的sql, 数据的变化也要了解.



函数映射:  y = f:(x)

mybatis 映射

1> mysql 里面的一张表对应 mybatis 里面的一个实体类
2> 表里的每个字段对应实体类的属性
3> 表里的每条记录对应实体类的每个实例




查询 学生编号在 1004 - 1007 范围内的学生记录

select * from student where sid in (1004,1007)

查询 学生编号在 1004 - 1007 范围内的学生记录， 不包含 1004 这个学生


select * from t_student where  sid > 1004 and sid <= 1007

select * from t_student where sid in (1007)  


<!-- 9、 统计各班的学生人数。高洁 -->

select c1.claid, count(*) from t_student as  s1 left join t_class as c1 
on s1.claid = c1.claid 
group by s1.claid
having cout(*) >= 2;


select c1.claid, c1.name, count(*) from t_student as  s1 left join t_class as c1 
on s1.claid = c1.claid 
group by s1.claid, c1.name;

<!-- 9、 统计各班的学生人数， 班级人数 2 人以上的查询  -->

select c1.claid, count(*) from t_student as  s1 left join t_class as c1 
on s1.claid = c1.claid 
group by s1.claid
having cout(*) >= 2;



查询 学生表的前 2 条记录
totalNums  总条数
pageCount  总页数 = totalNums / pageSize 
pageSize   每页显示多少条记录

   


select * from t_student limit 2


查询 学生表的 第 2 - 5 的记录
select * from t_student limit 1, 4



查询学校都有哪些班级


select name from t_class ;


查询所有的学生都在哪些班级里，查询不重复的班级名称

SELECT c.name FROM t_class c LEFT JOIN t_student s ON c.claid = s.claid;


SELECT c.name FROM t_class c 
LEFT JOIN t_student s 
ON c.claid = s.claid;

查询所有的学生都在哪些班级里，查询不重复的班级名称


查询所有的学生都在哪些班级里，查询不重复的班级编号

SELECT DISTINCT t1.claid
FROM t_student t1 

SELECT DISTINCT c.claid FROM t_class c LEFT JOIN t_student s ON c.`claid`=s.`claid`;

SELECT DISTINCT claid FROM t_class ;

SELECT DISTINCT t1.claid
FROM t_student t1 LEFT JOIN t_class c1 ON t1.claid=c1.claid;


查询所有的学生都在哪些班级里，查询不重复的班级名称

SELECT DISTINCT c1.name
FROM t_student t1 LEFT JOIN t_class c1 ON t1.claid=c1.claid;



查询所有的女学生都在哪些班级里，查询不重复的班级名称

select s.*,c.name from t_class c, (select distinct claid from t_student and sex='女') s where s.claid = c.claid


select s.*,c.name from t_class c, (select distinct claid from t_student) s where s.claid = c.claid and sex='女'


先去重后连表的效果是最高的

 select * from ( select distinct claid from t_student  and sex='女') as s1 left join t_class c1 on s1.claid = c1.claid












<!-- 1、 由于 曾华 同学 从 1839 班转到 1833 班，请更新相应的表信息。 -->

update t_student set claid=#{claid} where sid=#{sid}

更新学生记录的时候， 往往都是主键更新的


update t_student set claid=(select claid from t_class where name='1833') where sid=(select sid from t_student where name='曾华');


UPDATE t_student ts SET claid=(SELECT claid FROM t_class tc WHERE tc.name='1833') WHERE  ts.name='曾华';


update t_student set claid=(select claid from t_class where name='1833') where sid=(

select a.sid from
(select sid from t_student where name='曾华') as a

);







<!-- mysql 事务 -->

<!-- 1、 由于匡明同学天天旷课屡劝不改，经学校同意勒令其退学，请删除于其相关的记录信息。 -->



delete from t_student where name=#{name}

delete from t_score where sid={sid}

<!-- 脏数据 -->
<!-- mysql 事务控制 -->
<!-- mysql 回滚 -->


开启事务的方法

delete from t_score where sid=(select sid from t_student where name='匡明');


delete a, b from t_score a join t_student b on a.sid = b.sid where b.name = '匡明';





delete from t_student where name='匡明';

insert overwrite table t_student select * from t_student where name!='曾华';




提交确认的方法





<!-- 1、 查询与王昭君同姓的所有学生记录。 -->

select * from t_student where name like '王%';

<!-- 1、 查询student表中的所有记录的sname、ssex和class列。 -->

select * from t_student;

select name,sex,claid from t_student;
select * from t_student where name like '王%';

sql 语句的执行顺序
1> from t_student  t_student 全表查询，把学生表的所有记录所有字段查询出来
2> where name like '王%'     根据 条件进行数据的筛选过滤
3> select name,sex,claid      显示哪些列字段


<!-- 2、 查询教师所有的单位,即不重复的 depart 列。 -->

DISTINCT 关键字会触发 mr 任务的执行
SELECT DISTINCT depart FROM t_teacher;



<!-- 3、 查询student表的所有记录。 --> 


<!-- 4、 查询score表中成绩在60到80之间的所有记录。 -->


开区间闭区间的区别：

SELECT * FROM t_score WHERE degree>60 AND degree<80;

SELECT * FROM t_score WHERE degree BETWEEN 60 AND 80;



<!-- 5、 查询score表中成绩为85，86或88的记录。 -->

select * from t_score where degree in (85,86,88);


<!-- 6、 查询student表中“95031”班或性别为“女”的同学记录。潘雨 -->

select * from student where class="95031" or ssex="女"

<!-- 6、 查询 1839班 女同学的信息记录。潘雨 -->

select * from student where name="1839" and ssex="女"


<!-- 7、 t_student 学生表所有学生记录,以 班级编号 claid 降序查询 。 -->

order by 出触发 mr 任务
select * from student order by class desc

sql  语句的执行顺序：

1> from student
2> select *
3> order by class desc


<!-- 8、 以 cno 升序、degree降序, 查询score表的所有记录。王敏行 -->

select * from score order by cid ,degree desc

<!-- 8、 以 班级编号 claid 升序、成绩 degree 降序查询 所有的学生记录。王敏行 -->

二次排序：claid 先根据第一个字段排序，整体上有序
          再根据第二个字段排序， 保持整体上有序
		  
select * from t_score order by cid ,degree desc;

<!-- 9、 统计 1832 班的学生人数。高洁 -->






select count(*)  from t_student s1 left join t_class c1 on s1.claid=c1.claid
where c1.name='1832'


select * from t_student s1 left join 
(select * from t_class c1 where c1.name='1832') c2

on s1.claid=c2.claid
where c2.name='1832'


select count(*) from t_student  where claid=(select claid from t_classs  where name=1832);


笛卡尔积


select count(*) from t_student s1 left join t_class c1 on s1.claid=c1.claid


where c1.name=1832;



sql 语句的执行顺序：

1> from t_student s1  查询左表
2> t_class c1  查询右表
3> 左表右表笛卡尔积
4> on s1.claid=c1.claid
5> left join t_class c1
6> where c1.name=1832
7> count(*)



<!-- 9、 统计各班的学生人数。高洁 -->

select count(*) from t_student s1 right join t_class c1 on s1.claid=c1.claid
group by c1.claid;


sql 语句的执行顺序：
1> from t_student s1
2> from t_class c1
3> on s1.claid=c1.claid
4> group by c1.claid
5> select count(*)




<!-- 10、查询 score 表中最高分学生的学号和课程号。 -->

select sid,cid from t_score where degree=(select max(degree) from t_score);

select sid,cid from t_score order by degree desc limit 1;


select sno,cno from score order by degree desc limit 1;

sql 语句的执行顺序：

1> from score
2> select sno,cno
3> order by degree
4> desc limit 1



<!-- 10、查询高等数学课程最高分学生的学号和课程号。 -->

select sid,cid from t_score where  degree=(select max(degree) from t_score where cid=(select cid from t_course where name='高等数学'))



<!-- 10、查询每个学生成绩最高的课程。 -->








<!-- 11、查询‘3-105’号课程的平均分。 -->

select cid, avg(degree) from t_score where cid = '3-105';

sql 语句的执行顺序：
1> from t_score 
2> where cid = '3-105'
3> select cid, avg(degree)


<!-- 12、统计每门课程选修的学生人数 -->

SELECT cid,COUNT(*)  FROM score GROUP BY cid

<!-- 12、统计每门课程平均成绩 -->

select cid,avg(degree) from t_score group by cid


<!-- 12、查询 score表中至少有 2 名学生选修的并以3开头的课程的平均分数。 -->

group_concat(sid + '' + separator ',')


select cid,avg(degree), group_concat(sid + '' + separator ',') from t_score where cid like "3%"

group by cid having count(cid) >= 2



select cid,avg(degree),group_concat( sid separator ',') 
from t_score where cid like "3%"

group by cid having count(cid) >= 2



sql 语句的执行顺序：
1> from t_score
2> where cid like "3%"
3> group by cid
4> having count(cid) >= 5
5> select avg(degree)

group_concat 函数可以用来调试sql



<!-- 13、查询最低分大于70，最高分小于90的学生记录, 显示 sid 列。 -->
<!-- 13、查询每个学生的最低分和最高分,最低分大于70，最高分小于90的学生记录 -->


隐含的分组条件  ： 以学生进行分组， 因为每个学生考了很多门课程
如果这个学生有一门课程低于70分，就把这个学生过滤掉。

重点： 每个学生的最低分和最高分,不偏科的学生


select sid from t_score group by sid having min(degree)>70 and max(degree)<90;


<!-- 14、查询所有学生的sname、cno和 degree 列。 -->


<!-- 15、查询所有学生的sno、cname和degree列。 -->


<!-- 16、查询所有学生的sname、cname和degree列。 -->


<!-- 17、查询“95033”班所选课程的平均分。 -->


<!-- 17、查询“95033”班的平均分 -->


<!-- 18、查询所有同学的 sid、cid 和 rank 列。 -->


select a.sid, a.cid, b.rank from t_score a, t_grade b where a.degree between b.low and b.up order by a.sid;


<!-- 19、查询选修“3-105”课程的成绩高于“109”号同学成绩的所有同学的记录。 -->


select a.* from t_score a join t_score b on a.sid=b.sid where a.degree > b.degree and a.cid='3-105' and b.sid='1009';

select a.* from t_score a  where a.cid='3-105' and a.degree > all(select b.degree from t_score b where b.sid='1009' and b.cid='3-105');



<!-- 20、查询 score 中选学一门以上课程的同学，分数为非最高分成绩的学生记录。 -->

分数为非最高分 ： 每门课程里分数为非最高的
实际意义：
	1> 可以体现出学生的学习兴趣
	2> 每门课程的整体的教学质量


select t2.sid ,t2.cid ,t2.degree from (
 select cid,max(degree) as degree from t_score group by cid
) t1 
right join (
select * from t_score  where  sid in (
  select sid from t_score group by sid having count(cid)>1)
) t2 on t1.cid=t2.cid 
where t2.degree < t1.degree



<!-- 42、查询每门课程最高分同学的sno、cno和degree列。 -->

select * from (
    select cid, max(degree) as degree from t_score group by cid
) s1 left join t_score s2
on  s1.cid=s2.cid and s1.degree=s2.degree


<!-- 20、查询 score 中选学一门以上课程的同学，分数为非最高分成绩的学生记录。 -->

分数为非最高分 ： 每门课程里分数为非最高的
实际意义：
	1> 可以体现出学生的学习兴趣
	2> 每门课程的整体的教学质量



select * from  (
    select sid from t_score group by sid having count(cid) > 1
) as s1 

left join t_score sc on s1.sid=sc.sid 

left join ( 
    select cid,max(degree) as degree from t_score group by cid
) as s2 on sc.cid=s2.cid

where sc.degree < s2.degree

sql 语句执行顺序

1> from t_score
2> group by sid
3> having count(cid) > 1
4> select sid 
5> s1 sc 笛卡尔积
6> on s1.sid=sc.sid 
7> left join t_score
8> from t_score
9> group by cid
10> select cid,max(degree) as degree 
11> sc s2 笛卡尔积
12> on sc.cid=s2.cid
13> left join s2
14> where sc.degree < s2.degree
15> select *





1> 统计每个学生选修了几门课

select sno,count(cno) from score group by sno

2> 统计选修一门以上课程的学生记录
 
 select sno,count(cno) from score group by sno having count(cno)>1


3> 统计选修一门以上课程, 并且过滤掉分数是 92 的学生记录

select *from score where degree != 92 group by sno having count(cno)>1

3> 统计选修一门以上课程, 并且过滤掉每门课程的最高分 的学生记录

select * from score where degree not in (86, 92, 85,79) group by sno having count(cno)>1

4> 统计选修一门以上课程, 并且分数为非最高分的学生记录


统计非最高分的学生记录


<!-- 20、查询 score 中选学一门以上课程的同学，分数为非最高分成绩的记录。 -->

select * from score 
where degree != (select max(degree) from score)
group by sno
having count(cno)>1


统计每门课程的非最高分的学生记录


select * from score 
where degree not in (select max(degree) from score group by cno)
group by sno
having count(cno)>1



select * from score s where degree<(select max(degree) from score) group by sno having 
count(sno)>1 order by degree ;


<!-- 21、查询成绩高于学号为'109'、课程号为'3-105'的成绩的所有记录。 -->

1> 不区分课程, 76

select * from score where degree > 76

select * from score where degree > (select degree from score where sno='109' and cno='3-105 ')


1> 区分课程, 只查询高于 76 的 3-105 课程的记录 

select * from score where degree > 76  and cno = '3-105' 

select * from score where degree > (select degree from score where sno='109' and cno = '3-105') and cno = '3-105' 






<!-- 22、查询和学号为108的同学同年出生的所有学生的sno、sname和sbirthday列。 -->

select sno,sname,sbirthday from student where year(sbirthday)= year((select sbirthday from student where sno='108'))


<!-- 23、查询“张旭“教师带的课程,把该课程的学生成绩。 -->


<!-- 23、查询张旭老师所有学生的成绩。 -->


select a.sno,a.degree from score a join (teacher b,course c)
on a.cno=c.cno and b.tno=c.tno
where b.tname='张旭';


select a.sno,a.degree from score a
join course c
on a.cno=c.cno
join teacher b
on b.tno=c.tno
where b.tname='张旭';


<!-- 24、查询选修人数多于5人课程，查询该课程的代课教师的姓名。 -->


select * from (

	select count(*) as num

	from t_score

	group by cid

) a1

where a1.num >=5




select  e2.tno from score e1,course e2
where e1.cno=e2.cno
group by e1.cno
having count(sno)>5


select tname from  teacher
where tno in (select  e2.tno from score e1,course e2
where e1.cno=e2.cno
group by e1.cno
having count(sno)>5)



select * from (
	select e2.tno from score e1
	left join course e2
	on e1.cno=e2.cno
	group by e1.cno
	having count(sno) >5
) as e3 
left join teacher e4
on e3.tno = e4.tno




<!-- 25、查询95033班和95031班全体学生的记录。 -->


<!-- 26、查询存在有 85 分以上成绩的课程 cno. -->

select distinct(cno) from score where degree > 85;

select cno from score group by cno having max(degree)>85

<!-- 27、查询出“计算机系“教师所教课程的成绩。 -->


<!-- 28、查询“计算机系”与“电子工程系“不同职称的教师的tname和prof。 -->





<!-- 29、查询选修编号为“3-105“课程且成绩至少高于选修编号为“3-245”的同学的cno、sno和degree,并按degree从高到低次序排序。 -->


<!-- 30、查询选修编号为“3-105”且成绩高于选修编号为“3-245”课程的同学的cno、sno和degree. -->


<!-- 31、查询所有教师和同学的name、sex和birthday. -->


<!-- 32、查询所有“女”教师和“女”同学的name、sex和birthday. -->


<!-- 33、查询成绩比该课程平均成绩低的同学的成绩表。 -->


<!-- 34、查询所有任课教师的tname和depart. -->


<!-- 35  查询所有未讲课的教师的tname和depart.  -->


<!-- 36、查询至少有2名男生的班号。 -->

<!-- 37、查询student表中不姓“王”的同学记录。 -->

<!-- 38、查询student表中每个学生的姓名和年龄。 -->


<!-- 39、查询student表中最大和最小的sbirthday日期值。 -->


<!-- 40、以班号和年龄从大到小的顺序查询student表中的全部记录。 -->


<!-- 41、查询“男”教师及其所上的课程。 -->

<!-- 42、查询每门课程最高分同学的sno、cno和degree列。 -->


select * from (
    select cid, max(degree) as degree from t_score group by cid
) s1 left join t_score s2
on  s1.cid=s2.cid and s1.degree=s2.degree



<!-- 43、查询和“李军”同性别的所有同学的sname. -->

<!-- 44、查询和“李军”同性别并同班的同学sname. -->

<!-- 45、查询所有选修“计算机导论”课程的“男”同学的成绩表 -->






（51） 查询在 2017 年 4 月份缴费的学生及缴费次数


（52） 查询在 2017 年 4 月份缴费的学生及缴费总人数


（53） 查询在 2017 年 4 月份缴费的学生、缴费次数及缴费总人数


（54） 查询学生的缴费明细及缴费总额


（55） 查询学生的缴费明细及月缴费总额


（56） 查询学生的缴费明细、月缴费总额及缴费总额


（57） 统计缴费总金额，按照日期进行累加


（58） 统计每天的缴费总金额，按照日期进行相加


（59） 统计每天的缴费总金额，按照日期进行累加


（60） 统计每个学生的实际缴费总金额，按照日期，组内数据进行相加


（61） 统计每个学生的实际缴费总金额，按照日期，组内数据进行累加


（62） 查询学生上次的缴费时间


（63） 查询前 20% 时间缴费的学生记录


（64） 查询前 20% 时间的缴缴总金额


（65） 统计每个学生的总成绩


（66） 根据每门课程的考试成绩对学生进行名次排名


（67） 查询每门课程排名第二的考试记录


（68） 查询每门课程排名前三的考试记录
课程表 
根据课程分组 
组内降序 
取前三条记录
select * 
from 
(select * from t_score where cid = '3-245' order by degree desc) s1, 
(select * from t_score where cid = '6-166' order by degree desc) s2,
(select * from t_score where cid = '6-106' order by degree desc) s3,
(select * from t_score where cid = '3-105' order by degree desc) s4;

select sid, cid, degree, @curRank := @curRank +1 as rank from t_score s1, (select @curRank := 0) s2 order by degree desc; 

select sid, cid, degree, @curRank := @curRank +1 as rank from t_score s1, (select @curRank := 0) s2 group by cid order by degree desc; 

方发一：
select * from t_score s1
where (
    select count(*) from t_score
    where cid=s1.cid and degree>s1.degree ) < 3
  order by cid,degree desc;

方法二：
SELECT cid,degree,rank
FROM
(
SELECT *,
IF(@p=cid,
    CASE 
        WHEN @s=degree THEN @r
        WHEN @s:=degree THEN @r:=@r+1
    END,
  @r:=1 ) AS rank,
@p:=cid,
@s:=degree
FROM t_score,(SELECT @p:=NULL,@s:=NULL,@r:=0)r
ORDER BY cid,degree DESC 
)s
WHERE rank <=3;


--------------------------------------------------------------------------
#求没门课程的第二名成绩

SELECT cid,degree,rank
FROM
(
SELECT *,
IF(@p=cid,
    CASE 
        WHEN @s=degree THEN @r
        WHEN @s:=degree THEN @r:=@r+1
    END,
  @r:=1 ) AS rank,
@p:=cid,
@s:=degree
FROM t_score,(SELECT @p:=NULL,@s:=NULL,@r:=0)r
ORDER BY cid,degree DESC 
)s
WHERE rank =2;