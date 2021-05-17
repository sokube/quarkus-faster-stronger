NODE_NAME="k3d-quarkus-poc-agent-0";
curl -sSL "http://localhost:8001/api/v1/nodes/${NODE_NAME}/proxy/configz" | jq '.kubeletconfig|.kind="KubeletConfiguration"|.apiVersion="kubelet.config.k8s.io/v1beta1"' > kubelet_configz_${NODE_NAME}
#sudo snap install yq
yq eval '.syncFrequency |= "5s"' kubelet_configz_${NODE_NAME} | jq >  kubelet_configz_${NODE_NAME}-updated
# now we set it on nodes
kubectl -n kube-system create configmap ${NODE_NAME}-kubelet-config --from-file=kubelet=kubelet_configz_${NODE_NAME}-updated --append-hash -o yaml

NODE_NAME="k3d-quarkus-poc-agent-1";
curl -sSL "http://localhost:8001/api/v1/nodes/${NODE_NAME}/proxy/configz" | jq '.kubeletconfig|.kind="KubeletConfiguration"|.apiVersion="kubelet.config.k8s.io/v1beta1"' > kubelet_configz_${NODE_NAME}

yq eval '.syncFrequency |= "5s"' kubelet_configz_${NODE_NAME} | jq >  kubelet_configz_${NODE_NAME}-updated
kubectl -n kube-system create configmap ${NODE_NAME}-kubelet-config --from-file=kubelet=kubelet_configz_${NODE_NAME}-updated --append-hash -o yaml

