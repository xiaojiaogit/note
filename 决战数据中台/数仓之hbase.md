# hbase 学习笔记
## 了解

行键 列族 列表 value

rangon 分区  ---多个列族

列族不一定要太多，尽量短一点

## 集群搭建

### hbase执行流程

        zookeeper  zookeeper  zookeeper
csent                                    master
      region server  rs2  rs3  rs4  rs5

### 搭建集群
