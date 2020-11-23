#!/bin/bash
# mingwang
# 2020.11.5
# sshs.sh

# echo 
    # -n 不要在最后自动换行
    # -e 处理特殊字符

# expect是一个免费的编程工具语言，用来实现自动和交互式任务进行通信，而无需人的干预。
# expect是不断发展的，随着时间的流逝，其功能越来越强大，已经成为系统管理员的的一个强大助手。
# expect需要Tcl编程语言的支持，要在系统上运行expect必须首先安装Tcl。(源码安装要注意)

yum install expect -y  #安装expect
echo "按enter键3次即可"

# 生成秘钥（按enter键3次即可生成）
ssh-keygen -t rsa   

SERVERS="h1 h2 h3 h4 h5 h6 h7 h8 h9 h11 h12 h13 h14 h15"   #需要配置的主机名
PASSWORD=123456   #需要配置的主机登录密码
 
#将本机生成的公钥复制到其他机子上
#如果（yes/no）则自动选择yes继续下一步
#如果password:怎自动将PASSWORD写在后面继续下一步
auto_ssh_copy_id(){
        expect -c "set timeout -1;
        spawn ssh-copy-id $1;                                
        expect {
                *(yes/no)* {send -- yes\r;exp_continue;}
                *password:* {send -- $2\r;exp_continue;}  
                eof        {exit 0;}
        }";
}

ssh_copy_id_to_all(){
        for SERVER in $SERVERS #遍历要发送到各个主机的ip
        do
                auto_ssh_copy_id $SERVER $PASSWORD
        done
}
ssh_copy_id_to_all