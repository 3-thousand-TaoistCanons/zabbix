#!/bin/bash
# install zabbix of shurenyun
# Author : jyliu
# Date: 2016-06-12
export BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

./images/load_images.sh

./build_zabbix_config.sh
. ./config.cfg

check_http(){
  service=$1
  url=$2
  _code=$3

  if [ -z "$_code" ];then
	_code=200
  fi

  for i in  `seq 1 61`
  do
    check_code=$(curl --connect-timeout 10 -sL -w "%{http_code}\\n" "$url" -o /dev/null)
    if [ "$check_code" = "$_code" ]; then
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

sh configserver/run_configserver.sh
check_http configserver "http://$CONFIGSERVER_IP:$CONFIGSERVER_PORT/config/zabbix/zabbix-agent/install.sh"

sh mysql/run_mysql.sh

echo "install zabbix agent"
$BASE_DIR/configserver/config/zabbix/zabbix-agent/install.sh

check_mysql_health

echo 
echo "init zabbix db"
if [ "$ISINIT_MYSQL" = "true" ];then
  cd zabbix
  ./init_zabbix_db.sh && echo "init zabbix db ok"
  if [ $? -ne 0 ] ;then
	echo "init zabbix db error !!!" && exit 1
  fi
  cd ..
fi

sh zabbix/run_zabbix.sh
check_http zabbix-server "http://$ZBX_SERVER_IP:9280/"



echo
echo "zabbix server addr: http://$ZBX_SERVER_IP:9280/"|tee zabbix_addr.txt
echo "default user: admin"
echo "default pass: zabbix"
echo
echo "Add the zabbix agent for the need to monitor the host"
grep 'Usega:' $BASE_DIR/configserver/config/zabbix/zabbix-agent/install.sh|tee install_agent.txt
