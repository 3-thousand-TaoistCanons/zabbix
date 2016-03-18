shmmax=`sysctl -a |grep kernel.shmmax|awk '{print $3}'`
if [ $shmmax -lt 1073741824 ];then
	sysctl -w kernel.shmmax=4294964295
	sysctl -w kernel.shmall=268435456
fi