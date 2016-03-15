#!/bin/bash
#Author : Liu Jinye
key_name=$1
slaveid=$2
update_interval=$3
filename=/tmp/docker_stat.$slaveid

if [ "$key_name" == "count" ];then
    docker ps |grep -v '^CONTAINER[[:space:]]ID'|wc -l
    exit 0 
elif [ "$key_name" == "imagecount" ];then
    docker images |grep -v '^CONTAINER[[:space:]]ID'|wc -l
    exit 0
fi


get_mesos_ps(){
    while(true)
    do
        mesos ps $slaveid 1> $filename 2>/dev/null
	if [ $? -eq 0 ] && [ `ls  -l $filename |awk '{print $5}'` -gt 0 ];then
	    break
        fi
    done
}


update_interval=${update_interval:-60} 

if [ ! -f $filename ] || [ `ls  -l $filename |awk '{print $5}'` -eq 0 ]; then
    /usr/local/bin/mesos config master $(cat /etc/mesos/zk)
    get_mesos_ps
elif [ ! -z $slaveid ];then
    filetime=`/usr/bin/stat -c %Y $filename`
    now=`/bin/date +%s`
    if  [ $[$now-$filetime] -gt $update_interval ];then
        get_mesos_ps
    fi
else
    cat /dev/null > $filename
fi

chown zabbix:zabbix $filename

if [  -z $slaveid ];then
    echo "slaveid can't be empty!"
elif [ "$key_name" == "mem" ];then
    awk 'BEGIN{NR=2}END{print $3}' $filename 
elif [ "$key_name" == "cpu" ];then
    awk 'BEGIN{NR=2}END{print $5}' $filename
elif [ "$key_name" == "%mem" ];then
    awk 'BEGIN{NR=2}END{print $6}' $filename
fi

find /tmp/docker_stat.* -type f -name 'docker_stat.*' -mtime +1|xargs rm -f {}
