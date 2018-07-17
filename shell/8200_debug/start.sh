#/bin/sh

#insmod /lib/mp.ko netif_cmd="eth2.2" netif_data="eth2.2" master_enable=1
insmod /lib/modules/bcmdrivers/media_proxy/mp.ko netif_cmd="eth2.2" netif_data="eth2.2" master_enable=1
echo 3 > /sys/module/mp/parameters/debug
mna -l 5&
#mna &
