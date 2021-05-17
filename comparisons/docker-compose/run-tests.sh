#!/bin/bash
# Bash Menu Script Example

PS3='Please enter your choice: '
options=("Generate a person list" "List persons from database" "Load test" "Reactive test" "Stop")
select opt in "${options[@]}"
do
    case $opt in
        "Generate a person list")
            echo "will call api  /hello/generate on each container: Quarkus (both native and JVM) and Spring (Boot and native)"
            curl "http://localhost:8092/hello/generate" &
            curl "http://localhost:8093/hello/generate" &
            curl "http://localhost:8081/hello/generate" &
            curl "http://localhost:8082/hello/generate" &
            ;;
        "List persons from database")
            echo "you chose to list persons in database"
            curl "http://localhost:8092/hello/listPersons" &
            curl "http://localhost:8093/hello/listPersons" &
            curl "http://localhost:8081/hello/listPersons" &
            curl "http://localhost:8082/hello/listPersons" &
            ;;
        "Reactive test")
            echo "you chose to stress system by simulating 100 users that request on a hard-computing values endpoint"
            for i in `seq 1 100`
            do
              curl "http://localhost:8092/reactive/randomflux/1000/30" &
              curl "http://localhost:8093/reactive/randomflux/1000/30" &
              curl "http://localhost:8081/reactive/randomflux/1000/30" &
              curl "http://localhost:8082/reactive/randomflux/1000/30" &
            done
            ;;
        "Load test")
            echo "will call api /hello/load on each container"
            curl "http://localhost:8092/hello/load" &
            curl "http://localhost:8093/hello/load" &
            curl "http://localhost:8081/hello/load" &
            curl "http://localhost:8082/hello/load" &
            ;;
        "Stop")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
