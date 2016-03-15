#!/bin/bash
mesos_master_addr=`netstat -lntp|grep mesos-master|awk '{print $4}'`
elected=`curl http://$mesos_master_addr/metrics/snapshot 2>/dev/null|python -m json.tool|awk -F '[[:space:]]*|,' '/\"master\/elected\"/{print $3}'`

if [ "$elected" -eq 1 ];then
    echo '{"data":[{"{#LEADER}":"'$mesos_master_addr'"}]}'
else
    echo '{"data":[]}'
fi
