#!/bin/bash
# get shurenyun ubuntu repo
# Author: Liujinye
# Date: 2015-3-9
#
set -e 

# Usage: curl -Ls http://ADDR/packages/ubuntu/get_repo.sh|bash -s ADDR

export DEBIAN_FRONTEND=noninteractive

ADDR=$1

if [ -z "$ADDR" ];then
        echo "Usage: ./$0 ADDR"
        exit 1
fi

curl -o - http://$ADDR/packages/ubuntu/key | sudo apt-key add -

echo "deb http://$ADDR/packages/ubuntu/trusty/main ./" > /etc/apt/sources.list.d/offlineshurenyun.list



