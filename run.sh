if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]
then
        echo "call is $0 {groupid} {artifact} {version}"
        exit 0
fi

groupid=$1
artifact=$2
version=$3


base_path=~/$artifact
log_path=$base_path/log
program=$artifact-$version.jar
port="8080"

base_deployables=~/deployables
deploy_path=$base_deployables/$groupid/$artifact/$version


if [ ! -f $deploy_path/$program ]
then
	echo "$deploy_path/$program does not exist"
	exit 0
fi

mkdir -p $log_path

script_path=$(dirname $(realpath -s $0))
bash $script_path/stop.sh $artifact


java -Dspring.profiles.active=prod -Dserver.port=$port -jar $deploy_path/$program \
     --spring.config.location=classpath:/application.yml,$base_path/application.yml \
     >> $log_path/$artifact-log 2>> $log_path/$artifact-log &
