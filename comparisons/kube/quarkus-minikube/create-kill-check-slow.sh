k3d cluster delete quarkus-poc
k3d cluster create quarkus-poc -p "8092:32318@loadbalancer" -p "8081:31450@loadbalancer" -p "8080:31524@loadbalancer" --agents 2

#echo "import postgres image into k3d -- when bad connection"
#k3d image import postgres:latest  -c quarkus-poc

echo "import native image into k3d"
k3d image import quarkus-employee-native:0.0.2-SNAPSHOT-scratch  -c quarkus-poc

echo "import employee image into k3d"
k3d image import quarkus-employee-jvm:0.0.2-SNAPSHOT  -c quarkus-poc

echo "import spring-boot image into k3d"
k3d image import employee-sb:0.0.1-SNAPSHOT -c quarkus-poc

#rm -rf *.tar.gz

kubectl apply -f svc/postgres-qk-service.yaml
kubectl apply -f svc/postgres-springboot-service.yaml
kubectl apply -f deploy/pg-qk-deploy.yml
kubectl apply -f deploy/pg-sb-deploy.yml

echo "Wait for starting db... 15s"
sleep 15

kubectl apply -f svc
kubectl apply -f deploy

echo "Wait for starting... 30s"
sleep 30

echo "create busybox pod to get connectivity checks"
kubectl create -f check

sleep 10

./killPod-slow.sh

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
