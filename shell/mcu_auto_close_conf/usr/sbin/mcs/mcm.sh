#!/bin/sh
############################################################
# MCU Conference monitoring shell, used to automatically stop 
# idle temporary meetings -- reserved or immediate conference.
# Configure item: 
# MONITOR_INTERVAL:			default 1   s
# IDLE_AUTO_CLOSE_EXPIRES:  default 300 s
# LOG_LEVEL:                default info
############################################################

#[global]
# 监控间隔时间 单位:秒
MONITOR_INTERVAL=1  
# 会议空闲自动关闭超时 单位：秒
if [ "$1" != "" ]; then
	IDLE_AUTO_CLOSE_EXPIRES=$1
else
	IDLE_AUTO_CLOSE_EXPIRES=300
fi
NORMAL_CACHE_LINE=2
PID_FILE="/var/run/mcm.pid"


#[log]
LOG_LEVEL=1  # error:0, info:1, debug:2
LOG_PREFIX="/var/mcu_conf_monit"
LOG_FILE_NEME=$LOG_PREFIX

#[parse_file]
CONF_CACHE_FILE_PREFIX="/tmp/.mcu_conf_"2
RAW_CACHE_FILE="${CONF_CACHE_FILE_PREFIX}raw"
FILTER_FILE0="${CONF_CACHE_FILE_PREFIX}f0"
FILTER_FILE1="${CONF_CACHE_FILE_PREFIX}f1"
CONF_LIST_FILE="${CONF_CACHE_FILE_PREFIX}list"

#[state]
# mcu stat: 0:none, 1:init, 2:error
garr_mcu_stat=3
garr_conf_index_n=()
garr_conf_state_n=(0)
garr_conf_type_n=(0)
# 参会人数，包括邀请中
garr_conf_attend_n=(0)
gi_conf_num_n=0 #${#garr_conf_index_n[*]}

garr_conf_index_s=(0)
garr_conf_state_s=(0)
garr_conf_type_s=(0)
garr_conf_attend_s=(0)
# 更新状态，上次刷新会议时是否存在本会议
garr_conf_update_s={0}
# 会议是否激活过
garr_conf_active_s={0}
# 会议自动关闭倒计时
garr_conf_starttime_s={0}

# 会议状态数组的会议数
gi_cs_num_s=0
# 会议状态数组最大的index
gi_max_cs_index=0
garr_cur_time=`cat /proc/uptime |awk -F'.' '{ print $1 }'`

func_log_init()
{
	garr_cur_date=`date  +%Y%m%d-%H%M%S`
	#LOG_FILE_NEME=${LOG_PREFIX}_${garr_cur_date}.log
	LOG_FILE_NEME=${LOG_PREFIX}.log
	echo "Log file: $LOG_FILE_NEME, level: $LOG_LEVEL"
	date >$LOG_FILE_NEME
	echo "Mcu conference monitor start.">>$LOG_FILE_NEME
	echo "=========================================" >>$LOG_FILE_NEME
	echo "" >>$LOG_FILE_NEME
}

# func_log_append $level $info
func_log_append()
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

	echo -e "$garr_cur_date $log_tag $2\n">>$LOG_FILE_NEME
}

func_conf_parse_from_file()
{
	conf_num=$1
	gi_conf_num_n=0  #reset conference number
	for i in $(seq 1 $conf_num)
	do
		func_log_append 2 "Parse conference [$i/$conf_num]";
		conf_line=`sed -n ${i}p $CONF_LIST_FILE`;
		func_conf_insert_to_new `echo $conf_line |\
							awk -F'|' '{print $2 $(NF-7) $(NF-4) $(NF-1)}' |\
							sed "s;,; ;g"`
	done
}

func_show_conference_list()
{
	echo ""

	for ((index=0; index<$gi_conf_num_n; index ++))
	do
		echo "Conference [$index]=============="
		echo "Index [${garr_conf_index_n[$index]}]"
		echo "Type  [${garr_conf_type_n[$index]}]"
		echo "State [${garr_conf_state_n[$index]}]"
		echo "Online [${garr_conf_attend_n[$index]}]"
		echo ""

	done
}

func_conf_insert_to_new()
{
	func_log_append 2 "Insert to new list $gi_conf_num_n:\
    index $1, type $2, statu $3, online $4|$5|$6|$7\n"

	garr_conf_index_n[$gi_conf_num_n]=$1
	garr_conf_type_n[$gi_conf_num_n]=$2
	garr_conf_state_n[$gi_conf_num_n]=$3
	garr_conf_attend_n[$gi_conf_num_n]=$5
	let gi_conf_num_n=gi_conf_num_n+1
}

func_conf_insert_to_status()
{
	index=0
	insert_index=$gi_max_cs_index
	for v in ${garr_conf_index_s[@]}; do
		if [ "$v" == "0" ]; then
			func_log_append 2 "Conference status list index $index is empty."
			insert_index=$index;
		elif [ "$v" == "$1" ]; then
			func_log_append 1 "Same conference index [$v]!"
			return
		fi
		let index=index+1
	done


	func_log_append 1 "Insert to status list $insert_index:\
	index $1, type $2, statu $3, online $4"

	garr_conf_index_s[$insert_index]=$1
	garr_conf_type_s[$insert_index]=$2
	garr_conf_state_s[$insert_index]=$3
	garr_conf_attend_s[$insert_index]=$4

	garr_conf_update_s[$insert_index]=1
	garr_conf_starttime_s[$insert_index]=0
	
	if [ ${garr_conf_attend_s[$insert_index]} -lt 0 ]; then
		garr_conf_active_s[$insert_index]=1
	else
		garr_conf_active_s[$insert_index]=0
	fi

	let gi_cs_num_s=gi_cs_num_s+1
	gi_max_cs_index=${#garr_conf_index_s[*]}
}

func_conf_del_from_status()
{
	index=$1

	[ $index -lt 0 ]&&return
	[ $index -ge $gi_max_cs_index ]&&return
	[ "${garr_conf_index_s[$index]}" == "0" ]&&return

	func_log_append 1 "del conference index $index from status."

	garr_conf_index_s[$index]=0
	let gi_cs_num_s=gi_cs_num_s-1
}


func_show_conference_stauts_list()
{
	echo ""
	index=0
	for v in ${garr_conf_index_s[@]}; do
		echo "Conf $index: $v"
		let index=index+1
	done

	for ((index=0; index<$gi_max_cs_index; index ++))
	do
		echo "Conference [$index]:[${garr_conf_index_s[$index]}]"
	done
}

```
func_find_conference_index()
{
	index=0
	for v in ${garr_conf_index_n[@]}; do
		if [ "$v" == "$1" ]; then
			echo $index && return
		fi
		let index=index+1
	done
}
```

func_conf_close()
{
	conf_index=`echo $1|awk -F'_' '{ print $1 }'`
	func_log_append 1 "close $conf_index ..."
	`clic "cs;conf close $conf_index" 2>/dev/null>/dev/null`
}

func_conf_refresh_conference_statue()
{
	# 遍历最新会议列表，刷新状态会议列表
	for ((new_index=0; new_index<$gi_conf_num_n; new_index ++))
	do
		bMatchS=0
		if [ "${garr_conf_type_n[$new_index]}" == "forever" ]; then
			continue;
		fi

		for ((index=0; index<$gi_max_cs_index; index ++))
		do
			if [ "${garr_conf_index_s[$index]}" == "${garr_conf_index_n[$new_index]}" ]; then
				func_log_append 2 "Match [${garr_conf_index_n[$new_index]}] New $new_index, index: $index"
				garr_conf_update_s[$index]=1
				garr_conf_attend_s[$index]=${garr_conf_attend_n[$new_index]}
				garr_conf_state_s[$index]=${garr_conf_state_n[$new_index]}
				bMatchS=1;
				break;
			fi
		done

		if [ $bMatchS -eq 0 ]; then
			func_log_append 2 "${garr_conf_index_n[$new_index]} is New conference"
			# insert it
			func_conf_insert_to_status ${garr_conf_index_n[$new_index]} \
						${garr_conf_type_n[$new_index]} \
						${garr_conf_state_n[$new_index]} \
						${garr_conf_attend_n[$new_index]}
			
		fi
	done
	
	# 遍历状态会议列表，更新状态
	for ((index=0; index<$gi_max_cs_index; index ++))
	do
		if [ "${garr_conf_index_s[$index]}" == "0" ]; then
			continue;
		fi

		func_log_append 2 "Checking ${garr_conf_index_s[$index]}, active:${garr_conf_active_s[$index]} attend：${garr_conf_attend_s[$index]}"

		if [ ${garr_conf_update_s[$index]} -eq 0 ]; then
			func_log_append 2 "${garr_conf_index_s[$index]} is be deleted."
			func_conf_del_from_status $index
			continue
		else
			garr_conf_update_s[$index]=0
		fi

		# 检查是否激活
		if [ ${garr_conf_attend_s[$index]} -gt 0 ] && [ ${garr_conf_active_s[$index]} -ne 1 ]; then
			func_log_append 1 "Conference ${garr_conf_index_s[$index]} active."
			garr_conf_active_s[$index]=1
		fi

		# 检查是否空闲
		if [ ${garr_conf_active_s[$index]} -eq 1 ]; then
			if [ ${garr_conf_attend_s[$index]} -gt 0 ]; then
				if [ ${garr_conf_starttime_s[$index]} -ne 0 ]; then
					garr_conf_starttime_s[$index]=0
					func_log_append 1 "Conference ${garr_conf_index_s[$index]} change state [idle -> active]."
				fi
			else
				if [ ${garr_conf_starttime_s[$index]} -eq 0 ]; then
					garr_conf_starttime_s[$index]=$garr_cur_time
					func_log_append 1 "Conference ${garr_conf_index_s[$index]}  change state [active -> idle]. will close after $IDLE_AUTO_CLOSE_EXPIRES s."
				fi
			fi
		
			if [ ${garr_conf_starttime_s[$index]} -gt 0 ]; then
				let tmp_arr=$garr_cur_time-${garr_conf_starttime_s[$index]}

				func_log_append 2 "Timeout: ${tmp_arr}/$IDLE_AUTO_CLOSE_EXPIRES"

				if [[ $tmp_arr -ge $IDLE_AUTO_CLOSE_EXPIRES ]]; then
					func_log_append 1 "Conference ${garr_conf_index_s[$index]} expires, close it."
					func_conf_close ${garr_conf_index_s[$index]}
				fi
			fi
		fi
	done
}

func_conf_load_conf_info()
{
	rm -f ${CONF_CACHE_FILE_PREFIX}*
	conf_list=`clic "cs; conf list" 2>$RAW_CACHE_FILE>/dev/null;cat $RAW_CACHE_FILE`
	line_num=`wc $RAW_CACHE_FILE  -l | awk '{print $1}'`

	case $line_num in
		[0-2])
			func_log_append 0 "Mcu system no running!"
			if [ $garr_mcu_stat -ne 0 ]; then
				garr_mcu_stat=0
			fi
		;;
		3)
			if [ $garr_mcu_stat -ne 1 ]; then
				garr_mcu_stat=1
				func_log_append 1 "Mcu system Active!"
			fi
		;;
		*)
			if [ $garr_mcu_stat -ne 2 ]; then
				garr_mcu_stat=2
				func_log_append 1 "Mcu system is active!"
			fi

			tail -n +6 $RAW_CACHE_FILE >$FILTER_FILE0 
			grep "\_" $FILTER_FILE0 >${CONF_LIST_FILE}

			conf_num=`wc $CONF_LIST_FILE  -l | awk '{print $1}'`
			if [ $conf_num -ge 0 ]; then
				return $conf_num
			else
				return 0
			fi
		;;
	esac
	
	return 0
}

do_start()
{
	loop_time=1
	lst_conf=0
	# init log
	func_log_init
	
	func_log_append 1 "\n Timeout: \t$IDLE_AUTO_CLOSE_EXPIRES s\n CheckInterval: $MONITOR_INTERVAL s\n LogFile:\t$LOG_FILE_NEME\n"

	echo $$>$PID_FILE
	while [ -f /tmp/mcu.pid ]
	do
		func_log_append 2 "=== loop time $loop_time:"
		garr_cur_time=`cat /proc/uptime |awk -F'.' '{ print $1 }'`
		garr_cur_date=`date  +%Y%m%d-%H%M%S`

		func_conf_load_conf_info
		conf_num=$?
		if [ $conf_num -gt 0 ]; then
			func_conf_parse_from_file $conf_num
			#func_show_conference_list
		else
			func_log_append 1 "No conference";
			gi_conf_num_n=0z
		fi

#		# 调试，保存cs命令查询结果的原始信息
#		if [[ $lst_conf -ne $conf_num ]]; then
#			`mv $RAW_CACHE_FILE "/tmp/.mcu_cache_lo${loop_time}_num${conf_num}"`
#			lst_conf=$conf_num
#		fi
#
		func_conf_refresh_conference_statue
		sleep $MONITOR_INTERVAL

		let loop_time=loop_time+1
		
		func_log_append 2 ""
		func_log_append 2 ""
	done
}


do_start