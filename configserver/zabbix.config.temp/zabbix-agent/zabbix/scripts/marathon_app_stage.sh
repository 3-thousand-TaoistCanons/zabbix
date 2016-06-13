#!/bin/bash
appid=$1
port=$(netstat -lntp|grep `ps aux|grep marathon.Main|grep -v grep|awk '{print $2}'`|grep -Eo '5098|8080')
marathon_leader=127.0.0.1:$port
instances=`curl $marathon_leader/v2/apps$appid 2>/dev/null|python -m json.tool|awk '/instances/'|awk -F: '{print $2}'|grep -o '[0-9]*'`
runnings=`curl $marathon_leader/v2/apps$appid 2>/dev/null|python -m json.tool|awk '/tasksRunning/'|awk -F: '{print $2}'|grep -o '[0-9]*'`
if [ "$instances" -ne "$runnings" ];then
        echo 1
else
        echo 0
fi