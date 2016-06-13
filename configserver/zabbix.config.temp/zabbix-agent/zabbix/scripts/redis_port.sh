#!/bin/bash
DIR=/etc/redis/*.conf
outname () {
        if [ -f "$filedir" ];then
            filedir=($(grep -rl "port[[:space:]]*${port[${key}]}" $DIR|egrep -v "default.conf.example|redis-cli|redis-benchmark" |awk -F : '{print $1}'))
            name=($(basename $filedir .conf|sort -u))
        else
            name=redis
        fi
        ip=($(ip addr show label '[^lo]*'|grep "inet.*brd"|grep -v ":"|awk -F / '{print $1}'|awk '{print $2}'|head -1))
        host_ip=($(netstat -natp|grep ${port[${key}]}|grep -v ':::'|awk -F '[ :]+' '/redis-server/&&/LISTEN/{print $4}'))
        if [ "$host_ip" = "0.0.0.0" ];then
           redis_ip=$ip
           else
               redis_ip=$host_ip
           fi
           }

discovery() {
            port=($(netstat -natp|awk -F: '/redis-server/&&/LISTEN/{print $2}'|awk '{print $1}'))
            printf '{\n'
            printf '\t"data":[\n'
                   for key in ${!port[@]}
                       do
                              outname
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