@echo off
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::�����������::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::��������ַ�˿�
set url=192.168.88.16
set telnet_port=8123
::Զ�̵�¼���û���������
set userid=admin
set password=admin
::Ҫִ�е�����
set cmd=sys bootfile G96S.z.16M_V5
::ִ������ȴ�ʱ��
set watitimes=3000

echo set sh=WScript.CreateObject("WScript.Shell") >telnet_tmp.vbs
::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::��¼::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::
::�л����뷨ΪӢ��,���cmd���л���ԭ������Ӣ�����뷨����ʹ�á�::��
echo sh.SendKeys "+" >>telnet_tmp.vbs

echo WScript.Sleep 300 >>telnet_tmp.vbs
echo sh.SendKeys "%userid%{ENTER}" >>telnet_tmp.vbs
echo WScript.Sleep 600 >>telnet_tmp.vbs
echo sh.SendKeys "%password%{ENTER}" >>telnet_tmp.vbs
echo WScript.Sleep 300 >>telnet_tmp.vbs
::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::�����Զ��ű�Ŀ¼::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::
echo sh.SendKeys "%cmd%">>telnet_tmp.vbs
echo sh.SendKeys "{ENTER}" >>telnet_tmp.vbs
echo WScript.Sleep 300 >>telnet_tmp.vbs
echo sh.SendKeys "sys tffs">>telnet_tmp.vbs
echo sh.SendKeys "{ENTER}" >>telnet_tmp.vbs
echo WScript.Sleep 300 >>telnet_tmp.vbs
echo sh.SendKeys "copy G96S.z.16M G96S.z.16M_V5">>telnet_tmp.vbs
echo sh.SendKeys "{ENTER}" >>telnet_tmp.vbs
echo WScript.Sleep 300 >>telnet_tmp.vbs
echo sh.SendKeys "exit">>telnet_tmp.vbs
echo sh.SendKeys "{ENTER}" >>telnet_tmp.vbs
echo WScript.Sleep 300 >>telnet_tmp.vbs
::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::�˳�shell::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::
echo sh.SendKeys "exit{ENTER}" >>telnet_tmp.vbs
echo WScript.Sleep 300 >>telnet_tmp.vbs
::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::��ʼִ��:::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::
start telnet %url% %telnet_port%
cscript telnet_tmp.vbs
del telnet_tmp.vbs
