前提：
1、将本目录所有文件放到tftp根目录下
2、tftp根目录新建 db_test_result 目录用于存放测试结果

初始化步骤：
1、将 bashtftp.sh 下到板子上
2、xml_fs.sh co XXX 从xml-dbus选择要测试的xml模板（xxx为模板名称，目标名称如xml-dbus文件 dbus_cts.xml.noVsie， 目标名称为noVsie）
3、修改bashtftp.sh 的tftp服务器ip， 将bashtftp.sh下载到设备目录（要运行xml的目录）
4、运行"bashtftp.sh u"将运行需要的脚本文件下载到设备
5、运行 dbus.sh 开始测试，测试前会运行 env_check.sh校验环境，校验后打印校验结果并等待一段时间后开始正式运行dbus_cts
6、测试完成后，运行 bashtftp.sh 会自动把测试结果文件上传到tftp服务器的 db_test_result 目录下

正常操作步骤：
1、运行 dbus.sh 开始测试；
2、运行 bashtftp.sh 上传并删除本地的测试结果。