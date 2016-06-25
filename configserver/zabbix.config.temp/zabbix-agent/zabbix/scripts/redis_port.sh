#!/bin/bash

discovery() {
            port=6379
            name=redis
            redis_ip=($(ip addr show label '[^lo]*'|grep "inet.*brd"|grep -v ":"|awk -F / '{print $1}'|awk '{print $2}'|head -1))
            printf '{\n'
            printf '\t"data":[\n'
                   for key in ${!port[@]}
                       do

                              if [ -z ${port[${key}]} ] || [ -z ${name} ] || [ -z ${redis_ip} ];then
                                continue
                              fi
                              printf "\t {\t\"{#REDISPORT}\":\"${port[${key}]}\",\t\"{#REDISNAME}\":\"${name}\",\t\"{#REDISIP}\":\"${redis_ip}\"\t}"
                              if [[ "${#port[@]}" -gt 1 && "${key}" -ne "$((${#port[@]}-1))" ]];then
                                echo ","
                              else
                                echo ""
                              fi
                   done
                              printf '\t ]\n'
                              printf '}\n'
    }

    discovery
