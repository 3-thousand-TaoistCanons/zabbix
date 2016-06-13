#!/bin/bash
# install zabbix agent
# Author: Liujinye
# Date: 2016-03-10
# Usega: curl -Ls http://--CONFIGSERVER_IP--:--CONFIGSERVER_PORT--/config/zabbix/zabbix-agent/install.sh|bash
#
set -e
export DEBIAN_FRONTEND=noninteractive

ADDR=$1
CONFIGSERVER_IP="--CONFIGSERVER_IP--"
CONFIGSERVER_PORT="--CONFIGSERVER_PORT--"
ADDR=${ADDR:-$CONFIGSERVER_IP\:$CONFIGSERVER_PORT}

if [ -z "$ADDR" ];then
    echo "Usage: ./$0 ADDR"
    exit 1
fi

get_distribution_type()
{
  local lsb_dist
  lsb_dist=''
  if command_exists lsb_release 2>/dev/null; then
    lsb_dist="$(lsb_release -si)"
  fi
  if [ -z "$lsb_dist" ] && [ -r /etc/lsb-release ]; then
    lsb_dist="$(. /etc/lsb-release && echo "$DISTRIB_ID")"
  fi
  if [ -z "$lsb_dist" ] && [ -r /etc/debian_version ]; then
    lsb_dist='debian'
  fi
  if [ -z "$lsb_dist" ] && [ -r /etc/fedora-release ]; then
    lsb_dist='fedora'
  fi
  if [ -z "$lsb_dist" ] && [ -r /etc/os-release ]; then
    lsb_dist="$(. /etc/os-release && echo "$ID")"
  fi
  if [ -z "$lsb_dist" ] && [ -r /etc/centos-release ]; then
    lsb_dist="$(cat /etc/*-release | head -n1 | cut -d " " -f1)"
  fi
  if [ -z "$lsb_dist" ] && [ -r /etc/redhat-release ]; then
    lsb_dist="$(cat /etc/*-release | head -n1 | cut -d " " -f1)"
  fi
  lsb_dist="$(echo $lsb_dist | cut -d " " -f1)"
  lsb_dist="$(echo "$lsb_dist" | tr '[:upper:]' '[:lower:]')"
  echo $lsb_dist
}

update_config(){
        rm -rf /etc/zabbix
        mkdir -p /var/run/zabbix
        chown zabbix:zabbix /var/run/zabbix
        curl -o - http://$ADDR/config/zabbix/zabbix-agent/zabbix_config.tar.gz | tar -zxf - -C /etc/
}

lsb_version=""
do_install()
{
  case "$(get_distribution_type)" in
    fedora|centos|rhel|redhatenterpriseserver)
    (
     if [ -r /etc/os-release ]; then
            lsb_version="$(. /etc/os-release && echo "$VERSION_ID")"
            if [ $lsb_version '<' 7 ]
            then
                    printf "\033[41mERROR:\033[0m CentOS version is Unsupported\n"
                    echo "Learn more: https://dataman.kf5.com/posts/view/110837/"
                    exit 1
            fi
     else
            printf "\033[41mERROR:\033[0m CentOS version is Unsupported\n"
            echo "Learn more: https://dataman.kf5.com/posts/view/110837/"
            exit 1
     fi
     echo "-> Installing zabbix-agent..."
     curl -Ls http://$ADDR/packages/centos/get_repo.sh|bash -s $ADDR
     yum --disablerepo=\* --enablerepo=offlineshurenyunrepo install -y zabbix-agent zabbix-sender jq sysstat nc net-tools mysql python-requests
    )
    ;;
    ubuntu)
    (
      echo "-> Installing zabbix-agent..."
      curl -Ls http://$ADDR/packages/ubuntu/get_repo.sh|bash -s $ADDR
      apt-get update
      apt-get install -y zabbix-agent zabbix-sender jq sysstat netcat net-tools mysql-client
    )
    ;;
    *)
      printf "\033[41mERROR\033[0m Unknown Operating System\n"
      echo "Learn more: https://dataman.kf5.com/posts/view/110837/"
      exit 1
    ;;
  esac

  chmod ug+s /bin/netstat
  update_config
  service zabbix-agent restart
  exit 0
}

# wrapped up in a function so that we have some protection against only getting
# half the file during "curl | sh"
do_install
