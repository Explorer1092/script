#!/bin/sh

#[global]
NORMAL_CACHE_LINE=2

#[log]
LOG_PREFIX="/var/mcu_conf_monit"
LOG_FILE_NEME=$LOG_PREFIX
LOG_LEVEL=2  # error:0, info:1, debug:2

#[parse_file]
CONF_CACHE_FILE_PREFIX="/tmp/.mcu_conf_"
CONF_CACHE_FILE="${CONF_CACHE_FILE_PREFIX}raw"
CONF_CACHE_FILE0="${CONF_CACHE_FILE_PREFIX}f0"
CONF_CACHE_FILE1="${CONF_CACHE_FILE_PREFIX}list"


#[state]
# mcu stat: 0:none, 1:init, 2:error
MCUSTAT=0
garr_conf_index=(a b c d e)
garr_conf_state=(0)
garr_conf_type=(0)
garr_conf_active_p=(0)
gi_conf_num=${#garr_conf_index[*]}
gi_max_conf_num=${#garr_conf_index[*]}


printConfList()
{
	echo ""
	echo "Conference Number: [$gi_conf_num]"
	index=0
	for v in ${garr_conf_index[@]}; do
		echo "Conference [$index]=============="
		echo "Index [${garr_conf_index[$index]}]"
		echo "Type  [${garr_conf_type[$index]}]"
		echo "State [${garr_conf_state[$index]}]"
		echo "Online [${garr_conf_active_p[$index]}]"
		echo ""

		let index=index+1
	done
}

findConfIndex()
{
	index=0
	for v in ${garr_conf_index[@]}; do
		if [ "$v" == "$1" ]; then
			echo $index && return
		fi
		let index=index+1
	done
	echo "-1"
}

delConfStat()
{
	index=`findConfIndex $1`
	printf "index %s",$index
	[ $index -lt 0 ]&&return
	[ $index -ge $gi_conf_num ]&&return

	printf "unset index %s\n",$index
	garr_conf_index[$index]=0
	let gi_conf_num=gi_conf_num-1
	gi_max_conf_num=${#garr_conf_index[*]}
}

#listLen=${#garr_conf_index[*]}
#echo "listLen:$listLen"
#printConfList
#delConfStat $1
#listLen=${#garr_conf_index[*]}
#echo "listLen:$listLen"
#printConfList
#exit

#refreshConfList()
#{
#	if [ $1=0 ]; then
#		
#	fi
#}

getConfList()
{
	rm -f ${CONF_CACHE_FILE_PREFIX}*

	conf_list=`clic "cs; conf list" 2>$CONF_CACHE_FILE>/dev/null;cat $CONF_CACHE_FILE `
	line_num=`wc $CONF_CACHE_FILE  -l | awk '{print $1}'`
printf "conflist:[%s]", $conf_list
	case $line_num in
		[0-2])
		[ $MCUSTAT=0 ]||{MCUSTAT=0;appendLog 0 "Mcu system no running!"}
		echo "0"
		;;
		3)
		[ $MCUSTAT=1 ]||{MCUSTAT=1;appendLog 2 "Mcu system is idle!"}
		echo "1"
		;;
		*)
		[ $MCUSTAT=2 ]||{MCUSTAT=2;appendLog 2 "Mcu system is active!"}
		tail -n +6 $CONF_CACHE_FILE > $CONF_CACHE_FILE0 
		awk '{if(NR%2==1s)print $0}' $CONF_CACHE_FILE0 >$CONF_CACHE_FILE1
		conf_num=`wc $CONF_CACHE_FILE1  -l | awk '{print $1}'`
		echo "2"
		;;
	esac
}

genLogFile()
{
	curDate=`date  +%Y%m%d-%H%M%S`
	LOG_FILE_NEME=${LOG_PREFIX}_${curDate}.log
	date >$LOG_FILE_NEME
	echo "Mcu conference monitor start.">>$LOG_FILE_NEME
	echo "=========================================" >>$LOG_FILE_NEME
	echo "" >>$LOG_FILE_NEME
}

appendLog()
{
	[[ $1 -gt $LOG_LEVEL ]]&&return

	case $1 in
		0)
		 log_tag="[error]"	
		;;
		1)
		 log_tag="[info]"	
		;;
		2)
		 log_tag="[debug]"	
		;;
		*)
		 log_tag="[unknown]"	
		;;
	esac

	curData=`date  +"%g%m%d %H%M:%S"`
	echo "$curDate $log_tag $2">>$LOG_FILE_NEME
	echo "" >>$LOG_FILE_NEME
}

rm ${LOG_PREFIX}*
genLogFile
while true
do
	conf_list=`getConfList`
	echo "conf_list:["$conf_list"]"
	sleep 1
done
