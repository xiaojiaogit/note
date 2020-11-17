# oracle学习笔记

## 下载与安装：

### 下载
[oracle官网下载地址](https://www.oracle.com/database/technologies/oracle-database-software-downloads.html)
### 安装
#### win系统
> 以11g为例
1、下载完成后我们找到下载好的文件然后解压
（注意：这里建议将两个文件分别解压到两个文件夹中）
2、解压完成后将“2of2”中的“database”文件夹复制到“1of2”中（意思就是将“2of2”中的“database”与“1of2”的整合到一起）
3、整合完成后打开，点击图中所示的“setup.exe”应用程序
4、然后会出现cmd控制台
（注意：此时什么也不要操作，等待Oracle安装程序检测就好了）
#### linux系统
> 不同的操作系统对应不同的oracle版本
> Centos/Redhat6+Oracle 11g(11.2.0.4)
> Centos/Redhat7+Oracle 12c(12.2.0.1)
##### 配置本地yum源
> vm学习环境，可以在vm上设置镜像
1、df -h 查看磁盘挂载情况
2、mount /dev/cdrom /media 挂载光盘
3、umount /dev/分区名       卸载光盘
> 生产环境，可以直接把镜像文件上传到服务器上，进行挂载操作
mount -t iso9660 -o loop 镜像文件所在位置 /media    挂载镜像
> 配置yum源文件
'''shell
cd 到 /etc/yum.repos.d 目录下把所有的文件移动到新创建的bak目录下

vim /etc/yum.repos.d/myyum.repo        # 必须以.repo结尾,插入以下内容
[myyum]
name=oracle_install
baseurl=file:///meida
enable=1
gpgcheck=0

enabled=1   # 为1,表示启用yum源; 0为禁用
gpgcheck=0  # 为1,使用公钥检验rpm包的正确性,0为不校验


yum clean all     # 清空yum缓存
yum makecache     # 缓存

yum install -y vim  # 测试以下
'''
##### 修改ip/关闭selinux/关闭防火墙
'''shell
# ip
IPADDR=192.168.12.1
NETMASK=255.255.255.0
GATEWAY=192.168.12.2
DNS1=114.114.114.114
systemctl restart network

# selinux
vi /etc/selinux/config
SELINUX=disabled

# 关闭防火墙
systemctl stop firewalld.service
systemctl disable firewalld.service
iptables -L
# 重启后iptables依然从在策略
systemctl status libvirtd.service
systemctl stop libvirtd.service
systemctl disable libvirtd.service
iptables -L
'''
##### 查看内存的两个方法
'''shell
free
cat /proc/meminfo
'''
##### 关闭透明大页,启用标准大页
'''shell
关闭 Linux 的 THP（透明大页）服务:
查看是否启动 THP:
cat  /sys/kernel/mm/transparent_hugepage/enabled
# 表示处于启用状态
[always] madvise never
# 处于关闭状态
always madvise [never]
编辑文件 /etc/rc.local
vim /etc/rc.local
添加如下内容:
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi
if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi
保存退出，然后赋予 rc.local 文件执行权限：
chmod +x /etc/rc.d/rc.local
'''
##### 创建oracle用户和组
'''shell
groupadd oinstall
groupadd dba
useradd -g oinstall -G dba
'''
