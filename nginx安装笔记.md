# nginx安装笔记

## 软件安装

```shell
yum install gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel
```
## 下载源码包
[官网](https://nginx.org/en/download.html)
### 推荐下载命令
```shell
wget -c https://nginx.org/download/nginx-1.10.1.tar.gzwget -c https://nginx.org/download/nginx-1.10.1.tar.gz
```

### 减压
```shell
tar -zxvf nginx-1.10.1.tar.gz
cd nginx-1.10.1
```
### 使用默认配置即可
```shell
./configure
```
### 编译安装
```shell
make
make install
```
### 查找安装路径
```shell
whereis nginx
```
## 启动、关闭nginx
```shell
cd /usr/local/nginx/sbin/
./nginx 
./nginx -s stop
./nginx -s quit
./nginx -s reload
```
> ./nginx -s quit:此方式停止步骤是待nginx进程处理任务完毕进行停止。
> ./nginx -s stop:此方式相当于先查出nginx进程id再使用kill命令强制杀掉进程。

## 查询nginx进程：
```shell
ps aux|grep nginx
```
## 重启 nginx
### 1.先停止再启动（推荐）：
对 nginx 进行重启相当于先停止再启动，即先执行停止命令再执行启动命令。如下：
```shell
./nginx -s quit
./nginx
```
### 2.重新加载配置文件：
当 ngin x的配置文件 nginx.conf 修改后，要想让配置生效需要重启 nginx，使用-s reload不用先停止 ngin x再启动 nginx 即可将配置信息在 nginx 中生效，如下：
```shell
./nginx -s reload
```
启动成功后，在浏览器可以看到页面
## 开机自启动
即在rc.local增加启动代码就可以了。
```shell
vi /etc/rc.local
```
增加一行： `/usr/local/nginx/sbin/nginx`
设置执行权限：
```shell
chmod 755 rc.local
```

## 定时任务
```shell
/sbin/service crond start //启动服务

/sbin/service crond stop //关闭服务

/sbin/service crond restart //重启服务

/sbin/service crond reload //重新载入配置

/sbin/service crond status //启动服务
```