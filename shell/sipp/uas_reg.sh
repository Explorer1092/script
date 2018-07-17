#!/bin/sh
sipp_do(){
while :
do
  ./sipp -sf uas_reg.xml -inf users.conf -infindex users.conf 0 -p 5065 -i 192.168.78.239 -set EXP 900
  sleep 1800
done;
}

sipp_do;

#-sf reg.xml：引入脚本文件，模拟注册流程
#-inf reg_data：引入账号数据配置文件
#-p 6060：本地端口（在脚本中用[local_port]引入
#-i 192.168.177.249：sipp所在机器的IP地址
#-m 50：运行50次
#192.168.177.229:5060：SIP服务器所在机器的IP地址和端口
