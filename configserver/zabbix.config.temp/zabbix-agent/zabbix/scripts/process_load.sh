#!/bin/bash
METRIC="$1"
PORT="$2"
NAME="$3"
USER="$4"

if [ "$NAME" != "null" ];then
   PID=($(ps aux|grep -v grep |grep "$NAME"|awk '{print $2}'))
   else
      PID=($(netstat -anp|grep LISTEN|grep $PORT|awk -F '[ /]+' '{print $7}'))
fi

if [ "$USER" != "null" ];then
   IOSTAT="sudo iotop -Pbk --iter=2 -u $USER"
   else
      IOSTAT="sudo iotop -Pbk --iter=2"
fi

case "$1" in
         %CPU)
             ps -p $PID -u 2>/dev/null|awk '$2~/'$PID'/ {print $3}'
             ;;
         %MEM)
             ps -p $PID -u 2>/dev/null|awk '$2~/'$PID'/ {print $4}'
             ;;
          VSZ)
             ps -p $PID -u 2>/dev/null|awk '$2~/'$PID'/ {print $5}'
             ;;
          RSS)
             ps -p $PID -u 2>/dev/null|awk '$2~/'$PID'/ {print $6}'
             ;;
         STAT)
             ps -p $PID -u 2>/dev/null|awk '$2~/'$PID'/ {print $8}'
             ;;
         TIME)
             ps -p $PID -u 2>/dev/null|awk '$2~/'$PID'/ {print $10}'
             ;;
    DISK_READ)
             $IOSTAT | awk '$1~/'$PID'/ {print $0}' | tail -n 1 | awk '$1~/'$PID'/ {print $4}'
             ;;
    DISK_WRITE)
             $IOSTAT | awk '$1~/'$PID'/ {print $0}' | tail -n 1 | awk '$1~/'$PID'/ {print $6}'
             ;;
           %IO)
             $IOSTAT | awk '$1~/'$PID'/ {print $0}' | tail -n 1 | awk '$1~/'$PID'/ {print $10}'
esac
