k3d cluster delete quarkus-poc
k3d cluster create quarkus-poc --switch-context

echo "import native image into k3d"
docker save quarkus-employee-native:0.0.1-SNAPSHOT -o quarkus-employee-native.tar.gz
k3d image import quarkus-employee-native.tar.gz  -c quarkus-poc

echo "import employee image into k3d"
docker save quarkus-employee-jvm:0.0.1-SNAPSHOT -o quarkus-employee-jvm.tar.gz
k3d image import quarkus-employee-jvm.tar.gz  -c quarkus-poc

echo "import spring-boot image into k3d"
docker save employee-sb:0.0.1-SNAPSHOT -o quarkus-employee-sb.tar.gz
k3d image import quarkus-employee-sb.tar.gz  -c quarkus-poc

rm -rf *.tar.gz

kubectl apply -f svc
kubectl apply -f deploy

echo "Wait for starting... 90s"
sleep 90

echo "create busybox pod to get connectivity checks"
kubectl create -f check

sleep 5

./killPod-slow.sh

kubectl logs curling-native-qk > curling-native-qk.log
kubectl logs curling-jvm-qk > curling-jvm-qk.log
kubectl logs curling-sb > curling-sb.log

kubectl delete --force po curling-jvm-qk curling-native-qk curling-sb

NB_QK_JVM_FAULTS=$(cat curling-jvm-qk.log | grep "Connection refused" | wc -l)
NB_SB_FAULTS=$(cat curling-sb.log | grep "Connection refused" | wc -l)
NB_QK_NATIVE_FAULTS=$(cat curling-native-qk.log | grep "Connection refused" | wc -l)

echo "Number of connection refused (i.e. probably the number of seconds in one minute the app has been available since we began to crash it): "
echo "   Spring-boot: $NB_SB_FAULTS"
echo "   Quarkus standard JVM: $NB_QK_JVM_FAULTS"
echo "   Quarkus GraalVM: $NB_QK_NATIVE_FAULTS"
