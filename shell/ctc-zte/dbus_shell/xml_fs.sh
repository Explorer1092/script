#!/bin/sh

if [ "$#" != "2" ]; then
	echo "Paramter isn't 2! [bk|co] [module]"
	exit
fi

if [ "$1" == "bk" ]; then
	cp dbus_cts.xml  ./xml-dbus/dbus_cts.xml.$2 
	cp dbus_cts.case.xml  ./xml-dbus/dbus_cts.case.xml.$2 
fi
if [ "$1" == "co" ]; then
	cp ./xml-dbus/dbus_cts.xml.$2 dbus_cts.xml 
	cp ./xml-dbus/dbus_cts.case.xml.$2 dbus_cts.case.xml 
fi
