kubectl scale deploy --replicas=1 qk-jvm-employee
kubectl scale deploy --replicas=1 qk-native-employee
kubectl scale deploy --replicas=1 sb-employee

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml

kubectl create serviceaccount dashboard-admin-sa
kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=default:dashboard-admin-sa

kubectl describe secrets
kubectl proxy