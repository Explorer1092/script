@echo off & setlocal
::fix bug

:::::::::::::::::::::::::::::::::::::::::::
rem FTP 获取设备上的文件脚本，登陆设备的ftp服务器并执行命令
rem 使用前请注意开启设备ftp:
set DEVICE_FTPD=192.168.88.17
:::::::::::::::::::::::::::::::::::::::::::
set LOG_NUM=64
set FTP_SC_TMP=mod_ftp.sc

::set /p LOG_NUM=请输入message.txt的最大后缀:

:LOOP
ECHO.
ECHO   请确认设备IP是否正确： %DEVICE_FTPD%
ECHO   正确请回车，不正确请修改脚本或输入正确ip
set /p a=:

if "%a%"=="" (
	ECHO .
) else (
	set DEVICE_FTPD=%a%
)

ECHO admin> %FTP_SC_TMP%
ECHO admin>> %FTP_SC_TMP%
ECHO get /log/message.txt >> %FTP_SC_TMP%
:: 循环获取64个message.txt.*，message文件最多64个
if %LOG_NUM% GEQ 0 (
	FOR /l %%i In (0,1,%LOG_NUM%) Do (
		ECHO get /log/message.txt.%%i >> %FTP_SC_TMP%
	)
)
ECHO bye >> %FTP_SC_TMP%

ftp -s:%FTP_SC_TMP% %DEVICE_FTPD%

ECHO Good-bye!

set SYSLOG_DIR=syslog-%DEVICE_FTPD%
del /Q %SYSLOG_DIR%
mkdir %SYSLOG_DIR%
move message* %SYSLOG_DIR%/

ECHO .
ECHO .
ECHO .
ECHO 获取设备%DEVICE_FTPD% syslog完成，存放在%SYSLOG_DIR%文件夹下
pause
del %FTP_SC_TMP%
endlocal & @echo on
