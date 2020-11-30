# sqoop配置
mv sqoop-env-template.sh sqoop-env.sh
vim sqoop-env.sh

export HADOOP_COMMON_HOME=/opt/hadoop
export HADOOP_MAPRED_HOME=/opt/hadoop
export HIVE_HOME=/opt/cdh-5.3.6/hive
export HIVE_CONF_DIR=/opt/hive/conf

如果报zookeeper的错误把他们注释了就可以了

--------------------测试连通性-----------------------
sqoop list-tables -connect jdbc:mysql://mingwang-1:3306/gz --username root --password root

--------------------问题解决-----------------------
将hive的lib里面的拷贝到sqoop的lib目录下
cp hive-exec-1.2.1.jar /usr/local/sqoop-1.4.7.bin__hadoop-2.6.0/lib/

----------------------报错解决-----------------------------
cp /opt/hive/lib/hive-shims-* /opt/sqoop/lib/

----------------------测试数据库到hive-----------------
编写脚本文件 vi conf1

import
--connect
jdbc:mysql://mingwang-1:3306/gz
--username
root
--password
root
--table
city
--columns
cid,cname,pid
--where
id>0
--target-dir
hdfs://mycluster/sqoop
--delete-target-dir
-m
1
--as-textfile

--hive-import
--hive-overwrite
--create-hive-table
--hive-table
city

---------------执行sqoop脚本--------------------
sqoop --options-file conf1

-------------------hive到mysql------------------------
需要在mysql上把表创建好

sqoop export \
--driver com.mysql.jdbc.Driver \
--connect jdbc:mysql://mingwang-1:3306/gz?characterEncoding=UTF-8 \
--table nihao \
--username root \
--password root \
--fields-terminated-by '\001' \
--export-dir /user/hive/warehouse/gz.db/nihao
