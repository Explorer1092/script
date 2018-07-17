#!/bin/sh

echo "Check config ... "
check_ret=0
lan_device=`dbus-send --system --type=method_call --print-reply --dest=com.ctc.igd1 /com/ctc/igd1/Config/WLAN/STA com.ctc.igd1.ObjectManager.GetManagedObjects >.sta; wc -l .sta | awk '{ print $1 }`

echo -n "$LINENO "

if [ $lan_device -lt 4 ]; then
                echo "   STA is none! No wifi device! please check \"dbus-send --system --type=method_call --print-reply --dest=com.ctc.igd1 /com/ctc/igd1/Config/WLAN/STAcom.ctc.igd1.ObjectManager.GetManagedObjects\""
                check_ret=1
else
                echo "    STA OK"

fi

if [ -d /mnt/usb1_1 ]; then
                echo "    USB OK"
else
                echo "    No exist USB!"
                check_ret=1
fi

if [ $check_ret -gt 0 ]; then
        result="Failed"
else
        result="OK!"
fi

echo "Check config end! result: "$result
exit $check_ret