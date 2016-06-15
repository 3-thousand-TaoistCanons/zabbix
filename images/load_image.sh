#!/bin/bash
base_dir=$(cd `dirname $0` && pwd)
cd $base_dir

images=`ls *.tar`

for i in $images
do
     echo "load $i"
     docker load < $i
done
