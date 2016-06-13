#!/bin/bash
# get shurenyun centos repo
# Author: Liujinye
# Date: 2015-3-9
#
set -e 

# Usage: curl -Ls http://ADDR/packages/centos/get_repo.sh|bash -s ADDR

export DEBIAN_FRONTEND=noninteractive
ADDR=$1

if [ -z "$ADDR" ];then
	echo "Usage: ./$0 ADDR"
	exit 1
fi

cat > /etc/yum.repos.d/offlineshurenyun.repo << EOF
[offlineshurenyunrepo]
name=Shurenyun CentOS Repo
baseurl=http://$ADDR/packages/centos/7/x86_64
gpgcheck=0
EOF


