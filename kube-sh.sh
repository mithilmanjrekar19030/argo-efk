# Namespace
kubectl create namespace logging

# EFK
kubectl create -f kubernetes/elastic.yaml -n logging
kubectl create -f kubernetes/kibana.yaml -n logging
kubectl create -f kubernetes/fluentd-rbac.yaml
kubectl create -f kubernetes/fluentd-daemonset.yaml

# Node Sample app
sudo docker build -t fluentd-node-sample:latest -f sample-app/Dockerfile sample-app
kubectl create -f kubernetes/node-deployment.yaml

# Disply Pods
kubectl get service -n logging
kubectl get pods -n logging
kubectl get pods -n kube-system

# Argo Setup
kubectl create namespace argo
kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo/stable/manifests/install.yaml

kubectl create clusterrolebinding mithil-cluster-admin-binding --clusterrole=cluster-admin --user=mithilmnjrkr@gmail.com
kubectl create rolebinding default-admin --clusterrole=admin --serviceaccount=default:default


# Submit workflows
argo submit https://raw.githubusercontent.com/argoproj/argo/master/examples/hello-world.yaml
argo submit https://raw.githubusercontent.com/argoproj/argo/master/examples/coinflip.yaml
argo submit https://raw.githubusercontent.com/argoproj/argo/master/examples/loops-maps.yaml
argo list


kubectl patch svc argo-ui -n argo -p '{"spec": {"type": "LoadBalancer"}}'
sudo minikube service -n argo --url argo-ui
