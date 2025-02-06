if [ -z $1 ] 
then
        echo "call is $0 {artifact}"
        exit 0
fi


program=$1

kill -9 `ps x | grep java | grep $program | awk '{print $1}'` 2> /dev/null

