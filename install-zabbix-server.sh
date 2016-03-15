#!/bin/bash
# install zabbix of shurenyun
# Author : jyliu
# Date: 2016-03-11
export BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

./build_zabbix_config.sh
. ./config.cfg

check_http(){
  service=$1
  url=$2
  code=$3

  if [ -z "$code" ];then
	code=200
  fi

  for i in  `seq 1 61`
  do
    check_code=$(curl --connect-timeout 10 -sL -w "%{http_code}\\n" "$url" -o /dev/null)
    if [ "$check_code" = "$code" ]; then
	echo "Simple test $service success."
	break
    elif [ "$i" -gt "60" ];then
	echo "Simple test $service $url is error !!!" && exit 1
    fi

    echo "check $service $i"
    sleep 1
  done
}

check_mysql_health (){
  for i in  `seq 1 61`
  do
    mysql -uroot -p$ZBX_MYSQL_ROOT_PASS -h$ZBX_MYSQL_IP -e "show status;" >/dev/null 2>&1
    if [ $? -ne 0 ] ;then
       if [ "$i" -gt "60" ];then
		echo "check mysql is error !!!" && exit 1
       fi
       echo "check mysql $i "
    else
       echo "deploy mysql is ok !!!"
       break
    fi
    sleep 1
  done
}

check_sendmail(){
  for i in  `seq 1 61`
  do
	result=`curl http://$SENDMAIL_IP:$MAIL_PORT/sendmail/ --data "key=$MAIL_ORIGIN_KEY&mailto=$TEST_MAIL&sub=sendmail&content=sendmail" 2>/dev/null`
	if [ "$result" = "ok" ];then
        	echo "sendmail test success"
		break
	elif [ "$i" -gt "60" ];then
        	echo "sendmail test error!!!"
	fi
	echo "check sendmail $i"
	sleep 1
  done
}

cd app_deploy

echo "deploy configserver"
./configserver.sh
check_http configserver "http://$CONFIGSERVER_IP:$CONFIGSERVER_PORT/config/zabbix/zabbix-agent/install.sh"

if [ "$ISDEPLOY_SENDMAIL" = "true" ];then
	echo "deploy sendmail"
	./sendmail.sh
	check_sendmail
fi

echo 
echo "deploy zabbix-mysql"
./zabbix-mysql.sh
check_mysql_health

echo 
echo "init zabbix db"
./init_zabbix_db.sh && echo "init zabbix db ok" || (echo "init zabbix db error !!!" && exit 1)

echo 
echo "deplop zabbix-server"
./zabbix-server.sh
./zabbix-web.sh

check_http zabbix-server "http://$ZBX_SERVER_IP:9280/"


echo
echo "zabbix server addr: http://$ZBX_SERVER_IP:9280/"
echo "default user: admin"
echo "default pass: zabbix"
echo
echo "Add the zabbix agent for the need to monitor the host"
grep 'Usega:' $BASE_DIR/config/zabbix/zabbix-agent/install.sh
