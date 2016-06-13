#!/bin/bash
base_dir=$(cd `dirname $0` && pwd)
cd $base_dir

createrepo --update 7/x86_64/ 
