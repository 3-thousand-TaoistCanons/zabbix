#!/bin/bash
disklist=(`cat /proc/diskstats |grep -E "\xvd[a-z]\b|\bvd[a-z]\b|\bsd[a-z]\b"|awk '{print $3}'|sort|uniq 2>/dev/null`)
#diskarray=(`cat /proc/diskstats |grep -E "\xvd[abcdefg]\b|\bvd[abcdefg]\b"|awk '{print $3}'|sort|uniq   2>/dev/null`)
length=${#disklist[@]}
printf "{\n"
printf  '\t'"\"data\":["
for (( i = 0; i < $length; i++ ))
do
        printf '\n\t\t{'
        printf "\"{#DISK_NAME}\":\"${disklist[$i]}\"}"
        if [ $i -lt $[$length-1] ];then
                printf ','
        fi
done
printf  "\n\t]\n"
printf "}\n"
