@echo off
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::设置相关配置::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::服务器地址端口
set url=192.168.88.16
set telnet_port=23
::远程登录的用户名，密码
set userid=root
set password=chzhdpl
::要执行的命令
set cmd=ps;killall -9 aimd.s
::执行命令等待时间
set watitimes=3000

echo set sh=WScript.CreateObject("WScript.Shell") >telnet_tmp.vbs
::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::登录::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::
::切换输入法为英文,如果cmd运行环境原本就是英文输入法，请使用“::”
echo sh.SendKeys "+" >>telnet_tmp.vbs

echo WScript.Sleep 300 >>telnet_tmp.vbs
echo sh.SendKeys "%userid%{ENTER}" >>telnet_tmp.vbs
echo WScript.Sleep 600 >>telnet_tmp.vbs
echo sh.SendKeys "%password%{ENTER}" >>telnet_tmp.vbs
echo WScript.Sleep 300 >>telnet_tmp.vbs
::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::进入自动脚本目录::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::
echo sh.SendKeys "%cmd%">>telnet_tmp.vbs
echo sh.SendKeys "{ENTER}" >>telnet_tmp.vbs
echo WScript.Sleep 300 >>telnet_tmp.vbs
::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::退出shell::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::
echo sh.SendKeys "exit{ENTER}" >>telnet_tmp.vbs
echo WScript.Sleep 300 >>telnet_tmp.vbs
::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::开始执行:::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::
start telnet %url% %telnet_port%
cscript telnet_tmp.vbs
del telnet_tmp.vbs