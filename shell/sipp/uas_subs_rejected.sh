#!/bin/sh
sipp_do(){
while :
do
  ./sipp -sf uas_subs_rejected.xml -inf account.csv -p 5065 -i 192.168.78.239 -m 100 -l 128 192.168.78.209:5060
  #./sipp -trace_logs -sf uas_subs.xml -inf account.csv -p 5065 -i 192.168.78.239 -m 100 -l 128 192.168.78.209:5060
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
