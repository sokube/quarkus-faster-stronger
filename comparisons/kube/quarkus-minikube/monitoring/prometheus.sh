kubectl create ns monitoring

kubectl apply -f clusterRole.yaml
kubectl apply -f https://raw.githubusercontent.com/bibinwilson/kubernetes-prometheus/master/config-map.yaml
kubectl apply -f prometheus-deployment.yaml

kubectl apply -f deploy -n kube-system

kubectl expose deploy -n monitoring prometheus-deployment --type=NodePort --port=9090 --target-port=9090


# grafanouille: 10000, 10856