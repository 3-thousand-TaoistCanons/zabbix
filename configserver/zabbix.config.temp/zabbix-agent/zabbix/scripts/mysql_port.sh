#!/bin/bash
DIR=/etc/mysql
discovery() {
            port=3306
            printf '{\n'
            printf '\t"data":[\n'
                   for key in ${!port[@]}
                       do
                           name=mysql-${port[${key}]}
                           printf "\t {\t\"{#MYSQLPORT}\":\"${port[${key}]}\",\t\"{#MYSQLNAME}\":\"${name}\"\t}"
                           if [[ "${#port[@]}" -gt 1 && "${key}" -ne "$((${#port[@]}-1))" ]];then
                                printf ","
                           fi
                           printf "\n"
                   done
                              printf '\t ]\n'
                              printf '}\n'
    }

    discovery
