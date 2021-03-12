# spark 学习笔记

## spark standalone模式搭建

编辑conf 文件夹下的spark-env.sh

'''shell
## 使用 :r! $JAVA_HOME 可以获取jdk的家目录
export JAVA_HOME=/opt/jdk
export SPARK_MASTER_HOST=mingwang-1
'''

编辑 slaves 文件,指定work在那个节点启动

'''shell
mingwang-1
mingwang-2
mingwang-3
'''

分发到其他机器上

## spark启动

'''shell
sbin/start-all.sh

jps 查看启动的java进程

使用ip加端口访问web页面： mingwang:8080
'''

## sparkshell初体验

'''shell
## 直接使用spark-shell 他会只启动一个local模式（模拟），不会向集群提交申请
/opt/spark/bin/spark-shell
## 如果要启动动集群模式，就必须要指定--master,不指定内存和内核他会默认使用1个G内存、会使用集群上的所有核
/opt/spark/bin/spark-shell --master spark://mingwang-1:7077
## 启动spark-shell 并指定内存和cpu(至少要设置800k的内容，3个核) 7077采用长连接
/opt/spark/bin/spark-shell --master spark://mingwang-1:7077 --executor-memory 1g --total-executor-cores 3
## 启动spark-shell 启用多个master 可以更好的容错
/opt/spark/bin/spark-shell --master spark://mingwang-1:7077,mingwang-2:7077 --executor-memory 1g --total-executor-cores 3
'''

## spark-shell 简单使用

'''shell
# sc是spark-shell内置的一个类的实力，它已经默认给我们创建好了
sc
# textFile 是告诉我们从哪里读取数据，默认是从hdfs上读取数据
sc.textFile("hdfs://mingwang-1:8020/nihao.txt")
# 进行具体的处理
sc.textFile("hdfs://mingwang-1:8020/nihao.txt").flatMap(_.split(" ")).map((_, 1)).reduceByKey(_+_).sortBy(_._2, false).collect
sc.textFile("hdfs://mingwang-1:8020/nihao.txt").flatMap(_.split(" ")).map((_, 1)).reduceByKey(_+_).sortBy(_._2, false).saveAsTextFile("hdfs://mingwang:8020/out1 ").collect
'''

## idea 开发spark

maven配置文件
'''xml
# 创建一个空的maven项目
# 编辑pom文件
<!-- 定义一些常量 -->
<properties>
	<maven.compiler.source>1.8</maven.compiler.source>
	<maven.compiler.target>1.8</maven.compiler.target>
	<scala.version>2.11.8</scala.version>
	<spark.version>2.7.7</spark.version>
	<hadoop.version>2.7.7</hadoop.version>
	<encoding>UTF-8</encoding>
</properties>
<dependencies>
	<!-- 导入scala的依赖 -->
	<dependency>
		<groupId>org.scala-lang</groupId>
		<artifactId>scala-library</artifactId>
		<version>${scala.version}</version>
	</dependency>
	<!-- 导入spark的依赖,core指的是RDD编程API -->
	<dependency>
		<groupId>org.apache.spark</groupId>
		<artifactId>spark-core_2.11</artifactId>
		<version>${spark.version}</version>
	</dependency>
	<!-- 导入sparkSQL的依赖,sql指的是Dateset、DateFrame、SQL编程API -->
	<dependency>
		<groupId>org.apache.spark</groupId>
		<artifactId>spark-sql_2.11</artifactId>
		<version>${spark.version}</version>
	</dependency>
	<!-- 导入spark跟hive的整合 -->
	<dependency>
		<groupId>org.apache.spark</groupId>
		<artifactId>spark-hive_2.11</artifactId>
		<version>${spark.version}</version>
	</dependency>
	<!-- 读写HDFS中的数据 -->
	<dependency>
		<groupId>org.apache.hadoop</groupId>
		<artifactId>hadoop-client</artifactId>
		<version>2.7.7</version>
	</dependency>
	<!-- 导入fastjson，解析json数据的 -->
	<dependency>
		<groupId>com.alibaba</groupId>
		<artifactId>fastjson</artifactId>
		<version>1.2.51</version>
	</dependency>
	<!-- 通过http协议请求高德地图的API -->
	<dependency>
		<groupId>org.apache.httpcomponents</groupId>
		<artifactId>httpclient</artifactId>
		<version>4.5.7</version>
	</dependency>
	<!-- SQL驱动 -->
	<dependency>
		<groupId>mysql</groupId>
		<artifactId>mysql-connector-java</artifactId>
		<version>5.1.47</version>
	</dependency>
</dependencies>

<build>
    <pluginManagement>
      <plugins>
		<!-- 编译scala的插件 -->
        <plugin>
          <groupId>net.alchim31.maven</groupId>
          <artifactId>scala-maven-plugin</artifactId>
          <version>3.2.2</version>
        </plugin>
		<!-- 编译java的插件 -->
        <plugin>
          <groupId>org.apache.maven.plugins</groupId>
          <artifactId>maven-compiler-plugin</artifactId>
          <version>3.5.1</version>
        </plugin>
      </plugins>
    </pluginManagement>
    <plugins>
      <plugin>
        <groupId>net.alchim31.maven</groupId>
        <artifactId>scala-maven-plugin</artifactId>
        <executions>
          <execution>
            <id>scala-compile-first</id>
            <phase>process-resources</phase>
            <goals>
              <goal>add-source</goal>
              <goal>compile</goal>
            </goals>
          </execution>
          <execution>
            <id>scala-test-compile</id>
            <phase>process-test-resources</phase>
            <goals>
              <goal>testCompile</goal>
            </goals>
          </execution>
        </executions>
      </plugin>

      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <executions>
          <execution>
            <phase>compile</phase>
            <goals>
              <goal>compile</goal>
            </goals>
          </execution>
        </executions>
      </plugin>

		<!-- 打jar包 -->
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
		<artifactId>maven-shade-plugin</artifactId>
        <version>2.4.3</version>
		<executions>
			<execution>
				<phase>package</phase>
				<goals>
					<goal>shade</goal>
				</goals>
				<configuration>
				  <filters>
					<filter>
						<artifact>*:*</artifact>
						<excludes>
							<exclude>META-INF/*.SF</exclude>
							<exclude>META-INF/*.DSA</exclude>
							<exclude>META-INF/*.RSA</exclude>
						</excludes>
					<filter>
				  </filters>
				</configuration>
			</execution>
		</executions>
      </plugin>
    </plugins>
  </build>
  
  ----------------------下面的没尝试过------------------------
  <plugin>
        <artifactId>maven-assembly-plugin</artifactId>
        <version>2.6</version>
        <configuration>
          <descriptorRefs>
            <descriptorRef>jar-with-dependencies</descriptorRef>
          </descriptorRefs>
          <archive>
            <manifest>
              <mainClass></mainClass>
            </manifest>
          </archive>
        </configuration>
        <executions>
          <execution>
            <id>make-assembly</id>
            <phase>package</phase>
            <goals>
              <goal>single</goal>
            </goals>
          </execution>
        </executions>
      </plugin>
    </plugins>
  </build>
'''

scala代码
'''java
//创建一个scala文件夹，一个简单的WorCount代码
object WordCount {
	def main(args: Array[String]):Unit = {
		val conf: SparkConf = new SparkConf().setAppName("WordCount")
		// 创建SparkContext，使用SparkContext来创建建RDD
		val sc: SparkContext = new SparkContext(conf)
		
		//spark写Spark程序，就是抽象对象的神奇大集合【RDD】编程，调用它高度封装的API
		//创建一个RDD
		val lines = sc.textFile(args(0))
		
		//切分压平
		val words = lines.flatMap(_.split(" "))
		
		//将单词和1组合放在元组里
		val wordAndOne = woeds.map((_, 1))
		
		//分组聚合，reducerByKey 可以向局部聚合，再全局聚合
		val reduced = wordAndOne.reducerByKey(_+_)
		
		//排序
		val sorted = reduced.sortBy(_._2, false)
		
		//将计算结果保存到hdfs上
		sortBy.saveAsTextFile(args(1))
		
		//释放资源
		sc.stop()
	}
}
'''

运行开发好的jar
'''shell
/opt/spark/bin/spark-submit --master spark://mingwang-1:7077 --executor-memory 1g --total-executor-cores 3 --class com.mingwang.wc.WordCount /root/spark.jar hdfs://mingwang-1:8020/nihoa.txt hdfs://mingwang-1:8020/out2

/opt/spark/bin/spark-submit
--master spark://000.000.000.000:7077 指定spark集群的运行方式、IP、端口
--executor-memory 2G 指定该job每个核分配的内存
--total-executor-cores 10 指定该job所需的所有核数
--class kafka.bmkp.Main 指定主程序名（必须是完整路径）
Jar存放路径

'''

## spark本地运行 以 local模式运行
往HDFS中写入数据，将程序的所属用户设置成跟HDFS一样的用户
System.setProperty("HADOOP_USER","root")

val conf = new SparkConf().setAppName("WordCount").setMaster("local[*]") --本地运行*代表多个线程，1代表一个线程，本地模式方便我们做测试

开发流程   ----》 本地测试  ----》 集群测试  -----》 压力测试（代码应该会比mr运行快） ----》 上线

## RDD大集合是什么
RDD 是一个弹性、可复原的分布式数据集  是一种描述信息 ---》是一种基本的抽象，不可变、多个分区

rdd.partitions.length  ---> 查看rdd的分区数

val rdd = sc.textFile("hdfs://mingwang-1:8020/nihao", 6)  -----> 设置多个分区，如果修改rdd的分区切片小于他的数据切片的数量 ----》 由分区的个数由输入切片决定的

sc.parallelize(List(1,2,3,4,5,6,7,8,9))    ----> 以并行化的方式创建rdd ---》多用于做实验  ---> 由sparkshell默认的分区数决定

sc.parallelize(List(1,2,3,4,5,6,7,8,9)，1)   -----》 可以修改默认的并行度

## 算子（Transformation ，转换算子，lazy的，调用后生成一个新的RDD）
sc.parallelize   --->也可以写成makeRDD(Lish(1,2,3,4,5,6),3)  指定3个分区

=================》 不会产生shuffle

filter  ---> 过滤

flatMap ---》拆分压平 一条一条拿出来
mapPartitions  将RDD的每一个分区取出来，以分区为单位，一个分区就是一个迭代器，下标从0开始，一个分区对应一个task

MapPartitionsWithIndex()，就是将RDD的每一个分区遍历出来应为外部传入的函数，输入的是迭代器，返回的是迭代器，可以将分区对应的编号取出来

union ---》 两组数据求并集

zip ---》 做拉链，将俩个元素放到一个元组里

keys ----》 获取重复的key
values ---》 获取重复的value

=================》 会产生shuffle，特定情况下不会产生shuffle

fold  ---》 可以定义一个初始值[每个分区使用一次，全局聚合也会使用一次]，reduce不能，例如：rdd1.fold(0)(_+_)

foldByKey、reduceByKey、addregateByKey、combineByKey 底层调用的都是combineByKeyWithClassTag

sortBy(x=>x,true).collect  ----> 降序排序
sortByKey() -----> 蕴藏了很多的秘密

groupBy()  ---》 分组---》 会用到shuffle   hashcode
groupByKey()

reducerByKey  ---》 先局部集合，在全局聚合，可以减少shuffle网络传输，可以提高聚合效率。
distinct   ---》 去重

intersection ---》 两组数据求交集

subtract ---> 求两组数据的差集

join ---> 相当于sql中的内关联，必须是装有kay、value的才可以join
leftOuterJoin   ---> 以左表为主，右表和左表进行匹配
rightOuterJoin  ---> 以右表为主，左表和右表进行匹配
fullOuterJoin   ---> 将左表和右表join与没有join上的都显示出来，key需要相等【全关联】
cogroup ---》 协分组，有点跟fullOuterJoin类似，但是没有关联上的返回CompactBuffer(),可以写多个rdd，例如：cogroup(rdd1,rdd2).collect 最多支持4个rdd进行处理

aggregateByKey ---> 按照key进行聚合，跟 reducerByKey 类似，可以输入两个函数，第一个是局部聚合的函数，第二个是全局集合的函数,初始值只在局部聚合时使用，全局聚合不适用初始值，比reducerByKey更加灵活。案例：aggreateByKey(100)(_+_,_+_)
>>>>>>>>>>>>>>>>>>>> 关于key的RDD算子，都存在于PairRDDFunctions中[这里里面其实存在一个隐式转换]

combineByKey  ----》 需要输入三个参数，第一个参数分组后value的第一个元素，第二个函数为局部聚合函数，第三个函数为全局聚合函数


count    ---> 返回rdd元素的数量
top(2)   ---> 默认以数据的降序排序，取前两个
take(2)  ---> 返回由数据集前n个元素组成的数组