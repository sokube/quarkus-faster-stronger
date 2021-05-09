#export GRAALVM_HOME=/Library/Java/JavaVirtualMachines/graalvm-ce-lts-java11-19.3.3/Contents/Home
#export JAVA_HOME=$GRAALVM_HOME
#export PATH=/Library/Java/JavaVirtualMachines/graalvm-ce-lts-java11-19.3.3/Contents/Home/bin:"$PATH"

#jvm standard build
mvn clean install
docker build . -f src/main/docker/Dockerfile.jvm -t quarkus-employee-jvm:0.0.2-SNAPSHOT

# multi stage from scratch build
docker build . -f src/main/docker/Dockerfile.scratch.native -t quarkus-employee-native:0.0.2-SNAPSHOT-scratch
