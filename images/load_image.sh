#!/bin/bash
base_dir=$(cd `dirname $0` && pwd)
cd $base_dir

images=`ls *.tar`

for i in $images
do
     docker load < $i
done
