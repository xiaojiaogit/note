#!/bin/bash
tar -zxvf /opt/zookeeper-3.4.6.tar.gz -C /opt
mv /opt/zookeeper-3.4.6 /opt/zookeeper
echo "export ZOOKEEPER_HOME=/opt/zookeeper" >> /etc/profile
echo "export PATH=\$PATH:\$ZOOKEEPER_HOME/bin" >> /etc/profile
echo "export PATH=\$PATH:\$ZOOKEEPER_HOME/conf" >> /etc/profile
source /etc/profile
mkdir -p /opt/zookeeper/data
mkdir -p /opt/zookeeper/log
chmod 777 /opt/zookeeper/data
chmod 777 /opt/zookeeper/log
mv /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg
sed -i "12cdataDir=/opt/zookeeper/data" /opt/zookeeper/conf/zoo.cfg
sed -i "14cclientPort=2181" /opt/zookeeper/conf/zoo.cfg
echo "dataLogDir=/opt/zookeeper/log" >> /opt/zookeeper/conf/zoo.cfg
echo "server.1"=z1:2881:3881 >> /opt/zookeeper/conf/zoo.cfg
echo "server.2"=z2:2882:3882 >> /opt/zookeeper/conf/zoo.cfg
echo "server.3"=z3:2883:3883 >> /opt/zookeeper/conf/zoo.cfg
touch /opt/zookeeper/data/myid
echo 1 > /opt/zookeeper/data/myid
for i in {2..3}
do

        scp -r root@z1:/opt/zookeeper root@z$i:/opt/
        ssh z$i "
                echo 'export ZOOKEEPER_HOME=/opt/zookeeper' >> /etc/profile
                echo 'export PATH=\$PATH:\$ZOOKEEPER_HOME/bin' >> /etc/profile
                echo 'export PATH=\$PATH:\$ZOOKEEPER_HOME/conf' >> /etc/profile
                source /etc/profile
                sed -i '14cclientPort=218$i' /opt/zookeeper/conf/zoo.cfg
                touch /opt/zookeeper/data/myid
                echo $i > /opt/zookeeper/data/myid
    exit"
done