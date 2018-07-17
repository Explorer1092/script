#!/bin/sh
sipp_do(){
while :
do
  ./sipp -sf wys.xml -inf c-account.csv -p 5065 -i 192.168.78.239 -m 1 -l 128 192.168.78.239:5060
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
