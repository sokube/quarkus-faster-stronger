minikube start --extra-config=kubelet.sync-frequency="5s" --memory 8192
docker save employee-sb:0.0.1-SNAPSHOT | pv | (eval $(minikube docker-env) && docker load)
docker save quarkus-employee-native:0.0.2-SNAPSHOT-scratch | pv | (eval $(minikube docker-env) && docker load)
docker save quarkus-employee-jvm:0.0.2-SNAPSHOT | pv | (eval $(minikube docker-env) && docker load)

minikube addons enable metrics-server
