if [ -z $1 ] || [ -z $2 ]
then
        echo "call is $0 {groupid} {artifact} [{version}]"
        exit 0
fi

groupid=$1
artifact=$2

root_deployables=~/deployables
deploy_path=$root_deployables/$groupid/$artifact

if [ -z $3 ]
then
	version=`ls -dv $deploy_path/*/ | tail -1 | xargs -n 1 basename`
else
	version=$3
fi


deploy_version_path=$deploy_path/$version

application_path=~/$artifact
log_file=$application_path/log
program=$deploy_version_path/$artifact-$version.jar
port="8080"


if [ ! -f $program ]
then
	echo "$program does not exist"
	exit 0
fi

script_path=$(dirname $(realpath -s $0))
bash $script_path/stop.sh $artifact


java -Dspring.profiles.active=prod -Dserver.port=$port -jar $program \
     --spring.config.location=classpath:/application.yml,$application_path/application.yml \
     >> $log_file 2>> $log_file &
