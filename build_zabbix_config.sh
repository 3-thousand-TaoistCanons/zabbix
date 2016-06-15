#!/bin/bash

set -eu

. ./config.cfg

export LC_CTYPE=C 

replace_var(){
    files=$@
    echo $files | xargs sed -i '' 's#--CONFIGSERVER_IP--#'$CONFIGSERVER_IP'#g'
    echo $files | xargs sed -i '' 's#--CONFIGSERVER_PORT--#'$CONFIGSERVER_PORT'#g'
    echo $files | xargs sed -i '' 's#--ZBX_MYSQL_IP--#'$ZBX_MYSQL_IP'#g'
    echo $files | xargs sed -i '' 's#--ZBX_MYSQL_DATABASE--#'$ZBX_MYSQL_DATABASE'#g'
    echo $files | xargs sed -i '' 's#--ZBX_MYSQL_ROOT_PASS--#'$ZBX_MYSQL_ROOT_PASS'#g'
    echo $files | xargs sed -i '' 's#--ZBX_MYSQL_USER--#'$ZBX_MYSQL_USER'#g'
    echo $files | xargs sed -i '' 's#--ZBX_MYSQL_PASS--#'$ZBX_MYSQL_PASS'#g'
    echo $files | xargs sed -i '' 's#--ZBX_MYSQL_CHECK_USER--#'$ZBX_MYSQL_CHECK_USER'#g'
    echo $files | xargs sed -i '' 's#--ZBX_MYSQL_CHECK_PASS--#'$ZBX_MYSQL_CHECK_PASS'#g'
    echo $files | xargs sed -i '' 's#--ZBX_SERVER_IP--#'$ZBX_SERVER_IP'#g'
    
    echo $files | xargs sed -i '' 's#--MYSQL_IMAGE_URI--#'$MYSQL_IMAGE_URI'#g'
    echo $files | xargs sed -i '' 's#--MYSQL_IMAGE_VERSION--#'$MYSQL_IMAGE_VERSION'#g'
    echo $files | xargs sed -i '' 's#--NGINX_IMAGE_URI--#'$NGINX_IMAGE_URI'#g'
    echo $files | xargs sed -i '' 's#--NGINX_IMAGE_VERSION--#'$NGINX_IMAGE_VERSION'#g'
    echo $files | xargs sed -i '' 's#--ZBX_SERVER_IMAGE_URI--#'$ZBX_SERVER_IMAGE_URI'#g'
    echo $files | xargs sed -i '' 's#--ZBX_SERVER_IMAGE_VERSION--#'$ZBX_SERVER_IMAGE_VERSION'#g'
    echo $files | xargs sed -i '' 's#--ZBX_WEB_IMAGE_URI--#'$ZBX_WEB_IMAGE_URI'#g'
    echo $files | xargs sed -i '' 's#--ZBX_WEB_IMAGE_VERSION--#'$ZBX_WEB_IMAGE_VERSION'#g'

}

pre_conf(){
    cd $1
    rm -f docker-compose.yml
    cp docker-compose.yml.temp docker-compose.yml
    files="docker-compose.yml"
    replace_var $files
    cd ..
}

preconfigserver_conf(){
    cd configserver
    rm -f docker-compose.yml
    cp docker-compose.yml.temp docker-compose.yml
    
    rm -rf zabbix_tmp
    cp -fR zabbix.config.temp zabbix_tmp

    rm -rf conf_d_tmp
    cp -rf conf_d.temp conf_d_tmp
    
    files=`grep -rl '' docker-compose.yml zabbix_tmp/* conf_d_tmp/*`
    replace_var $files
    
    sed -i '' 's/Server=127.0.0.1/Server='$ZBX_SERVER_IP'/g' zabbix_tmp/zabbix-agent/zabbix/zabbix_agentd.conf
    sed -i '' 's/ServerActive=127.0.0.1/ServerActive='$ZBX_SERVER_IP'/g' zabbix_tmp/zabbix-agent/zabbix/zabbix_agentd.conf
    
    cd zabbix_tmp/zabbix-agent
    tar czf zabbix_config.tar.gz logrotate.d zabbix
    rm -rf logrotate.d zabbix
    cd ../../

    mkdir -p config
    rm -rf config/zabbix
    mv zabbix_tmp config/zabbix
    rm -rf conf.d
    mv conf_d_tmp conf.d
    cd ..
}

preconfigserver_conf
pre_conf mysql
pre_conf zabbix
