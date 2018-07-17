
#/bin/sh

echo 'type <CTRL-D> to terminate'

cat /proc/mp_slave/forward_table_txrx

while read OPTION
do
	cat /proc/mp_slave/forward_table_txrx
done


