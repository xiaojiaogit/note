数仓可视化之Superset

Apache Superset 是一个开源的、现代的、轻量的BI分析工具，能够对接多种数据源、拥有丰富的图标展示形式、支持自定义仪表盘，拥有友好的用户界面。

Superset官网：
http://superset.apache.org/

需要事先安装python3.6的环境

安装Miniconda
conda是一个开源的包、环境管理器，可以用于在同一个机器上安装不同的python版本的软件及其依赖
下载地址：https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
执行安装脚本，安装：
bash Miniconda3-latest-Linux-x86_64.sh    直接回车-空格-yes-设置安装路径（如果出现删不了的问题，可以按住Ctrl删）-yes
source .bashrc(家目录里的)
conda config --set auto_activate_base false   ---关闭默认启动的选项
conda info -envs  ---查看所有环境
'''
更换清华镜像
conda config --add channels https://mirrors.tuna.tsinghua.cn/anaconda/pkgs/free
conda config --add channels https://mirrors.tuna.tsinghua.cn/anaconda/pkgs/main
conda config --set show_channel_urls yes
'''
conda create --name superset python=3.6
conda remone -n env_name --all ---删除一个环境
conda activate superset ---激活superset环境
conda deactivate   ---退出当前环境

Superset部署(这部分操作需要在superset下执行)：
下载依赖
yum -y install python-setuptools gcc gcc-c++ libffi-devel python-devel python-pip python-wheel openssl-devel cyrus-sasl-devel openldap-devel

安装（更新）setuptools和pip
pip install --upgrade setuptools pip -i https://pypi.douban.com/simple

安装Supetset
pip install apache-superset -i https://pypi.duban.com/simple/

初始化superset数据库：
superset db upgrade

创建管理员用户：
export FLASF_APP=superset
flask fab create-admin

初始化superset:
superset init

启动superset:
安装gunicorn
pip install gunicorn -i https://pip.duban.com/simple/

启动superset
gunicorn --workers 5 --timeout 120 --bind h1:8787 "superset.app:create_app()" --daemon

关闭gunicorn进程
ps -ef | awk '/superset/ && !/awk/{print $2}' | xargs kill -9

退出superset环境
conda deactivate

Superset的使用：
对接mysql数据源
conda install mysqlclient
说明：对接不同的数据源，需要安装不同的依赖，以下地址为官方说明
http://superset.apache.org/installation.html#database-dependencies