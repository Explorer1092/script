#!/bin/sh
sipp_do(){
while :
do
  sipp -sf wys.xml -inf 128-account.csv -p 5062 -i 192.168.78.214 -m 1 -l 1 192.168.78.251:5060
  sleep 1800
done;
}

sipp_do;

#-sf reg.xml������ű��ļ���ģ��ע������
#-inf reg_data�������˺����������ļ�
#-p 6060�����ض˿ڣ��ڽű�����[local_port]����
#-i 192.168.177.249��sipp���ڻ�����IP��ַ
#-m 50������50��
#192.168.177.229:5060��SIP���������ڻ�����IP��ַ�Ͷ˿�
