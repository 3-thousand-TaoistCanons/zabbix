export base_dir=$(cd `dirname $0` && pwd)
cd $base_dir
docker-compose -p zbx up -d
