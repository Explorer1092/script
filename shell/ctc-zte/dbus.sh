ENV_PATH=/opt/upt/apps/dbus-test/
DBUS_TOOL=dbus_cts

cd $ENV_PATH
pwd
./env_check.sh
sleep 3

killall -9 dbus-monitor
dbus-monitor --system >monitor.txt&

if [ "$1" == "" ]; then
./$DBUS_TOOL
else
dbus-send --system --print-reply --dest=com.ctc.saf1 /com/ctc/saf1 com.ctc.saf1.framework.Pause uint32:"0"
fi