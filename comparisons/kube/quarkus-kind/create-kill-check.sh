kind delete cluster --name quarkus
kind create cluster --name quarkus --config kind-config.yaml

kind load docker-image quarkus-employee-native:0.0.2-SNAPSHOT-scratch --name=quarkus
kind load docker-image quarkus-employee-jvm:0.0.2-SNAPSHOT --name=quarkus
kind load docker-image employee-sb:0.0.1-SNAPSHOT --name=quarkus
kind load docker-image employee-sb:0.0.1-SNAPSHOT --name=quarkus
kind load docker-image sb-employee-native:0.0.1-SNAPSHOT --name=quarkus
kind load docker-image postgres --name=quarkus

kubectl apply -f svc/postgres-qk-service.yaml
kubectl apply -f svc/postgres-springboot-service.yaml
kubectl apply -f deploy/pg-qk-deploy.yml
kubectl apply -f deploy/pg-sb-deploy.yml

echo "Wait for starting db... 30s"
sleep 30

kubectl apply -f svc
kubectl apply -f deploy

echo "Wait for starting... 30s"
sleep 30

echo "create busybox pod to get connectivity checks"
kubectl create -f check

sleep 10

./killPod.sh

kubectl logs curling-native-qk > curling-native-qk.log
kubectl logs curling-native-sb > curling-native-sb.log
kubectl logs curling-jvm-qk > curling-jvm-qk.log
kubectl logs curling-sb > curling-sb.log

kubectl delete --force po curling-jvm-qk curling-native-qk curling-sb curling-native-sb

NB_QK_JVM_FAULTS=$(expr $(cat curling-jvm-qk.log | grep "Connection refused" | wc -l) + $(cat curling-jvm-qk.log | grep -i 'timed out' | wc -l) +  $(cat curling-jvm-qk.log | grep -i 'peer' | wc -l))
NB_SB_NATIVE_FAULTS=$(expr $(cat curling-native-sb.log | grep "Connection refused" | wc -l) + $(cat curling-native-sb.log | grep -i 'timed out' | wc -l) +  $(cat curling-native-sb.log | grep -i 'peer' | wc -l))
NB_SB_FAULTS=$(expr $(cat curling-sb.log | grep "Connection refused" | wc -l) + $(cat curling-sb.log | grep -i 'timed out' | wc -l) +  $(cat curling-sb.log | grep -i 'peer' | wc -l))
NB_QK_NATIVE_FAULTS=$(expr $(cat curling-native-qk.log | grep "Connection refused" | wc -l) + $(cat curling-native-qk.log | grep -i 'timed out' | wc -l) +  $(cat curling-native-qk.log | grep -i 'peer' | wc -l))

REQUESTS_SB=$(cat curling-sb.log | grep requesting | wc -l)
REQUESTS_SB_NATIVE=$(cat curling-native-sb.log | grep requesting | wc -l)
REQUESTS_QK_JVM=$(cat curling-jvm-qk.log | grep requesting | wc -l)
REQUESTS_QK_NATIVE=$(cat curling-native-qk.log | grep requesting | wc -l)

echo "Number of connection refused / Total number of requests "
echo "   Spring-boot: $NB_SB_FAULTS / $REQUESTS_SB"
echo "   Spring-boot native: $NB_SB_NATIVE_FAULTS / $REQUESTS_SB_NATIVE"
echo "   Quarkus standard JVM: $NB_QK_JVM_FAULTS / $REQUESTS_QK_JVM"
echo "   Quarkus GraalVM: $NB_QK_NATIVE_FAULTS / $REQUESTS_QK_NATIVE"
