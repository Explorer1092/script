#!/bin/sh
sipp_do(){
while :
do
  ./sipp -sf reg.xml -inf account.csv -p 5065 -i 192.168.78.239 -m 1 -l 128 192.168.78.239:5060
  #./sipp -sf reg.xml -inf 128-account.csv -p 5065 -i 192.168.78.239 -m 128 -l 128 -r 10 -rp 5s 192.168.78.239:5060
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
