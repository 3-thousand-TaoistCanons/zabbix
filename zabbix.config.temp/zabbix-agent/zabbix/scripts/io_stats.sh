#!/bin/sh
diskname=$2
case "$1" in
          rps)
             iostat -m -x |grep "\b$2\b"|awk '{print $4}'
             ;;
          wps)
             iostat -m -x |grep "\b$2\b"|awk '{print $5}'
             ;;
          rMBps)
             iostat -m -x |grep "\b$2\b"|awk '{print $6}'
             ;;
          wMBps)
             iostat -m -x |grep "\b$2\b"|awk '{print $7}'
             ;;
          avgrq-sz)
             iostat -m -x |grep "\b$2\b"|awk '{print $8}'
             ;;
          avgqu-sz)
             iostat -m -x |grep "\b$2\b"|awk '{print $9}'
             ;;
          await)
             iostat -m -x |grep "\b$2\b"|awk '{print $10}'
             ;;
          svctm)
             iostat -m -x |grep "\b$2\b"|awk '{print $11}'
             ;;
          util)
             iostat -m -x |grep "\b$2\b"|awk '{print $12}'
             ;;
             *)
             exit 1
esac
