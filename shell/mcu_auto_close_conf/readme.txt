1、文件： 
	63ed87a44b6bbd8c21752b5b724e2394  ./usr/sbin/mcs/mcm.sh
	4b7f6261727bf2f34d560b3af1b997ac  ./etc/init.d/mcm
	a6745ee40a7869e374bd0b6470efef43  ./etc/monitrc
	4d2668477e7a6b334c74c282c9a9576e  ./lib/libsncli.so

2、说明:
	1、替换libsncli.so （关联问题：clic 没有cs的命令入口）
	2、新增cs 会议监控脚本，自启动。
	  2.1 调用顺序。
		/etc/monitrc
				|--> /etc/init.d/mcm
								|--> /etc/sbin/mcs/mcm.sh
								
	  2.1 脚本配置参数说明： 
							监听间隔：		1s（推荐配置） 太长可能导致监控不到会议激活,导致脚本功能无效（详细见测试报告）
														   从另一个角度分析：
														      这个值可以等同会议参会人员的最短参会时间，从sip报文有响应 invite开始计算）。
                            空闲结束超时:   300 s
                            日志等级:       info - 通知会议激活及断开会议相关信息。
							
							
附: md5sum 递归
	find ./ -type f -print0 | xargs -0 md5sum > ./my.md5  