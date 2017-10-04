az group create -n externaldns -l westcentralus



az network dns zone create -g externaldns -n example.com


# can be done from master or scp file and create secret
kubectl create secret generic azure-config-file --from-file=/etc/kubernetes/azure.json

kubectl apply -f externaldns.yaml