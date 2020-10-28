# IDEA 调试MapperReducer

## 1、创建Maven工程

## 2、导入pom.xml 文件依赖

```xml
<dependencies>
    <dependency>
        <groupId>org.apache.hadoop</groupId>
        <artifactId>hadoop-common</artifactId>
        <version>2.7.2</version>
    </dependency>

    <dependency>
        <groupId>org.apache.hadoop</groupId>
        <artifactId>hadoop-hdfs</artifactId>
        <version>2.7.2</version>
    </dependency>

    <dependency>
        <groupId>org.apache.hadoop</groupId>
        <artifactId>hadoop-client</artifactId>
        <version>2.7.2</version>
    </dependency>

    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.12</version>
    </dependency>
</dependencies>
```
## 3、在工程根目录下创建input目录，并在该目录下写入数据

## 4、连接Docker集群执行WordCount

>### 修改Hadoop配置
>
>在IDEA通过Docker集群执行MapReduce任务是会报一个异常，说本机的用户名没有权限访问Docker容器内的HDFS，此时需要修改容器内Hadoop的两个配置文件.

```shell
vim /usr/local/hadoop/etc/hadoop/core-site.xml
```

```xml
<!-- 增加如下内容 -->   
	<property>
        <name>hadoop.http.staticuser.user</name>
        <value>root</value>
    </property>

```

```shell
vim /usr/local/hadoop/etc/hadoop/hdfs-site.xml
```

```xml
<!-- 增加如下内容 -->   
	<property>
        <name>dfs.permissions</name>
        <value>false</value>
    </property>

```

## 5、配置log4j

> hadoop默认使用了log4j输出日志，如果没有自定义配置log4j，控制台不会输入mapreduce过程，所以需要在resources下配置日志信息，在IDEA中项目的src/main/resources下创建一个log4j.properties文件，将以下内容复制进去并保存

```properties
log4j.rootLogger = info,stdout

### 输出信息到控制抬 ###
log4j.appender.stdout = org.apache.log4j.ConsoleAppender
log4j.appender.stdout.Target = System.out
log4j.appender.stdout.layout = org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern = [%-5p] %d{yyyy-MM-dd HH:mm:ss,SSS} method:%l%n%m%n

### 输出DEBUG 级别以上的日志文件设置 ###
log4j.appender.D = org.apache.log4j.DailyRollingFileAppender
log4j.appender.D.File = vincent_player_debug.log
log4j.appender.D.Append = true
log4j.appender.D.Threshold = DEBUG
log4j.appender.D.layout = org.apache.log4j.PatternLayout
log4j.appender.D.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss}  [ %t:%r ] - [ %p ]  %m%n

### 输出ERROR 级别以上的日志文件设置 ###
log4j.appender.E = org.apache.log4j.DailyRollingFileAppender
log4j.appender.E.File = vincent_player_error.log
log4j.appender.E.Append = true
log4j.appender.E.Threshold = ERROR 
log4j.appender.E.layout = org.apache.log4j.PatternLayout
log4j.appender.E.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss}  [ %t:%r ] - [ %p ]  %m%n 

```

## 6、配置执行参数

> 将原来本地执行的参数/input /output改成Docker容器中的hdfs

```ide
修改如下内容：pragram arguments:
hdfs://localhost:9000/user/root/input 
hdfs://localhost:9000/user/root/output
```

## 7、hadoop常用端口

```
hadoop2.X
50070 HDFS web端口
9000 HDFS 服务器端口
19888 历史服务器端口
8088 YARN端口

hadoop3.x
9870 HDFS web端口
8020 HDFS 服务器端口
19888 历史服务器端口
8088 YARN端口
```

## *问题处理

```
直接说解决步骤：（针对 hadoop-2.9.0.tar ，其他的应该差不多，以下步骤亲测通过 ）
    1. 将已下载的 hadoop-2.9.0.tar 这个 linux 压缩文件解压，放到你想要的位置（任意位置）；
    2. 下载 windows 环境下所需的其他文件（必须）
    hadoop2.9.0对应的hadoop.dll,winutils.exe 等全网最新   
    可以下载相应版本的winutils.exe到hadoop\bin  地址: https://github.com/4ttty/winutils)
    3. 拿到上面下载的windows所需文件，执行以下步骤：
（1）：将文件解压到你解压的 hadoop-2.9.0.tar 的bin目录下
（2）：将hadoop.dll复制到C:\Window\System32下（这一步最重要，找了很多文章，都没说这个，然后就还是一直不成功）
（3）：添加环境变量HADOOP_HOME，指向hadoop目录
（4）：将%HADOOP_HOME%\bin加入到path里面
（5）：重启 IDE（我的没重启就出问题了，主要是因为环境变量修改了，需要重启启动idea进程读取环境变量）
（6）. 再次运行你的程序就不会在看到这个异常。
    问题解决。
```

```xml
<!-- 数据节点设置 -->
<property>
<name>dfs.namenode.name.dir</name>
<value>file://${hadoop.tmp.dir}/dfs/name</value>
</property>
<property>
<name>dfs.datanode.data.dir</name>
<value>file://${hadoop.tmp.dir}/dfs/data</value>
</property>
```















































