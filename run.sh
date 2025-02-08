if [ -z $1 ] || [ -z $2 ]
then
        echo "MISSING ARGUMENTS: use $0 {groupid} {artifact} [{version}]"
        exit 0
fi

groupid=$1
artifact=$2

repository=~/repository
program_path=$repository/$groupid/$artifact

if [ -z $3 ]
then
	version=`ls -dv $program_path/*/ | tail -1 | xargs -n 1 basename`
else
	version=$3
fi


program_version_path=$program_path/$version

application_path=~/$artifact
log_file=$application_path/log
program=$program_version_path/$artifact-$version.jar
port="8080"


if [ ! -f $program ]
then
	echo "$program does not exist"
	exit 0
fi

script_path=$(dirname $(realpath -s $0))
bash $script_path/stop.sh $artifact

echo "Starting $artifact-$version on `hostname` ..."

java -Dspring.profiles.active=prod -Dserver.port=$port -jar $program \
     --spring.config.location=classpath:/application.yml,$application_path/application.yml \
     >> $log_file 2>> $log_file &
