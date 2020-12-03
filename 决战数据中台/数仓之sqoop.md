# sqoop

## 配置
mv sqoop-env-template.sh sqoop-env.sh
vim sqoop-env.sh

export HADOOP_COMMON_HOME=/opt/hadoop
export HADOOP_MAPRED_HOME=/opt/hadoop
export HIVE_HOME=/opt/hive
export HIVE_CONF_DIR=/opt/hive/conf

如果报zookeeper的错误把他们注释了就可以了

--------------------测试连通性-----------------------
sqoop list-tables -connect jdbc:mysql://mingwang-1:3306/hive --username root --password root

--------------------问题解决-----------------------
将hive的lib里面的拷贝到sqoop的lib目录下
cp hive-exec-1.2.1.jar /opt/sqoop/lib/

----------------------报错解决-----------------------------
cp /opt/hive/lib/hive-shims-* /opt/sqoop/lib/

# ----------------------测试数据库到hive-----------------
## 脚本指定的方式编写脚本文件 vi conf1
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
-----------------------------------------------------------



-------------------hive到mysql------------------------
需要在mysql上把表创建好
导出数据：
sqoop export \
--connect jdbc:mysql://mingwang-1:3306/gz?characterEncoding=UTF-8 \
--username root \
--password root \
--table nihao \
--export-dir '/user/hive/warehouse/gz.db/nihao' \
--input-null-string 'NaN' \
--input-null-non-string 'NaN' \
--fields-terminated-by '\001'
--batch

# 增量导出
sqoop export \
--connect jdbc:mysql://mingwang-1:3306/gz?characterEncoding=UTF-8 \
--username root \
--password root \
--table nihao \
--export-dir '/user/hive/warehouse/gz.db/nihao' \
--input-null-string 'NaN' \
--input-null-non-string 'NaN' \
--fields-terminated-by '\001' \
--update-mode allowinsert \
--update-key id \
--batch