#!/bin/sh
dbus_file="dbus_cts dbus_cts.case.xml dbus_cts.xml dbus.sh bashtftp.sh env_check.sh"

if [ "$1" == "u" ]; then
        for i in $dbus_file;
        do   
                echo "i=[$i]"
                tftp -g -l $i 192.168.1.100; chmod +x $i
        done 
else
        for i in `find *.csv *.txt *.bak dbus_cts`;  
        do
                tftp -p -l $i -r db_test_result/$i 192.168.1.100 && rm $i
        done
		dbus-send --system --print-reply --dest=com.ctc.saf1 /com/ctc/saf1 com.ctc.saf1.framework.Pause uint32:"0"
fi