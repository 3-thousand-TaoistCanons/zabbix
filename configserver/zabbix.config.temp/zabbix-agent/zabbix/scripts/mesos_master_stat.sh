#!/bin/bash
key_name=$1
if [ "$key_name" == "activated" ];then
    echo `mesos state | jq '.activated_slaves'`
elif [ "$key_name" == "deactivated" ];then
    echo `mesos state | jq '.deactivated_slaves'`
else
    echo 0
fi
