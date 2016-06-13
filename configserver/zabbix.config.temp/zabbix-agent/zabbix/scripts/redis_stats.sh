#!/bin/bash
      DIR=/etc/redis
      METRIC="$1"
      PORT="$2"
      name="$3"
      ip="$4"
      if [ -d "$DIR" ];then
      passwd=$(grep -r "requirepass" $DIR/$name.conf|awk '{print $2}')
      fi

      (echo -en "auth $passwd\r\nINFO\r\n"; sleep 1;) | nc $ip $PORT|grep "^$METRIC:"|awk -F':|,' '{print $2}'