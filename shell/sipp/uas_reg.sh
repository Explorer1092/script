#!/bin/sh
sipp_do(){
while :
do
  ./sipp -sf uas_reg.xml -inf users.conf -infindex users.conf 0 -p 5065 -i 192.168.78.239 -set EXP 900
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
