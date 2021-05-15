kubectl delete -f svc
kubectl delete -f deploy
kubectl delete -f check

kubectl apply -f svc/postgres-qk-service.yaml
kubectl apply -f svc/postgres-springboot-service.yaml
kubectl apply -f deploy/pg-qk-deploy.yml
kubectl apply -f deploy/pg-sb-deploy.yml

echo "Wait for starting db... 15s"
sleep 15

kubectl apply -f svc
kubectl apply -f deploy

echo "Wait for starting... 15s"
sleep 15

echo "create busybox pod to get connectivity checks"
kubectl create -f check

sleep 10

./killPod.sh

kubectl logs curling-native-qk > curling-native-qk.log
kubectl logs curling-jvm-qk > curling-jvm-qk.log
kubectl logs curling-sb > curling-sb.log

kubectl delete --force po curling-jvm-qk curling-native-qk curling-sb

NB_QK_JVM_FAULTS=$(expr $(cat curling-jvm-qk.log | grep "Connection refused" | wc -l) + $(cat curling-jvm-qk.log | grep -i 'timed out' | wc -l) +  $(cat curling-jvm-qk.log | grep -i 'peer' | wc -l))
NB_SB_FAULTS=$(expr $(cat curling-sb.log | grep "Connection refused" | wc -l) + $(cat curling-sb.log | grep -i 'timed out' | wc -l) +  $(cat curling-sb.log | grep -i 'peer' | wc -l))
# +  cat curling-sb.log | grep -i 'timed out' | wc -l +  cat curling-sb.log | grep -i 'peer' | wc -l
NB_QK_NATIVE_FAULTS=$(expr $(cat curling-native-qk.log | grep "Connection refused" | wc -l) + $(cat curling-native-qk.log | grep -i 'timed out' | wc -l) +  $(cat curling-native-qk.log | grep -i 'peer' | wc -l))

REQUESTS_SB=$(cat curling-sb.log | grep requesting | wc -l)
REQUESTS_QK_JVM=$(cat curling-jvm-qk.log | grep requesting | wc -l)
REQUESTS_QK_NATIVE=$(cat curling-native-qk.log | grep requesting | wc -l)

echo "Number of connection refused (i.e. probably the number of seconds in three minute the app has been available since we began to crash it): "
echo "   Spring-boot: $NB_SB_FAULTS / $REQUESTS_SB"
echo "   Quarkus standard JVM: $NB_QK_JVM_FAULTS / $REQUESTS_QK_JVM"
echo "   Quarkus GraalVM: $NB_QK_NATIVE_FAULTS / $REQUESTS_QK_NATIVE"
