#!/bin/bash

# 判断是否输入参数
if [ $# -eq 0 ]
then
echo "please input param: start or status or stop"
else

# 判断输入的是否是start
if [ $1 = start ]
then
for i in {1..3}
do
echo "${1}ing z${i}"
ssh z${i} "source /etc/profile;/opt/zookeeper/bin/zkServer.sh start"
done
fi

# 判断输入的是否是status
if [ $1 = status ]
then
for i in {1..3}
do
echo "${1}ing z${i}"
ssh z${i} "source /etc/profile;/opt/zookeeper/bin/zkServer.sh status"
done
fi

# 判断输入的是否是stop
if [ $1 = stop ]
then
for i in {1..3}
do
echo "${1}ing z${i}"
ssh z${i} "source /etc/profile;/opt/zookeeper/bin/zkServer.sh stop"
done
fi