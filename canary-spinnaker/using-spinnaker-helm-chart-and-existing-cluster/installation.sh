
# provision the k8s cluster with custom subnet. Starting from current directory as working directory
# cd ../../
# ./provision.sh


# From portal associate routing table to subnet 1

# change working directory
cd ./canary-spinnaker/using-spinnaker-helm-chart-and-existing-cluster/

# install eureka service and eureka service client using helm chart
# helm install --name eureka-services ../../eur-helm


# create Persistent volume

# create group
az group create -n acspvresgrp -l westcentralus

# create storage account
az storage account create -n pvstoaccpoc -l westcentralus -g acspvresgrp --sku Standard_LRS


# create persistent volume
export current_env_conn_string=$(az storage account show-connection-string -n pvstoaccpoc -g acspvresgrp --query 'connectionString' -o tsv)
# create secret
az storage share create --name pvfileshare --quota 2048 --connection-string $current_env_conn_string
# modify azure-secret.template.yaml to azure-secret.yaml, add name and key of your storage account
kubectl apply -f azure-secret.yaml
kubectl apply -f persistent-volume.yaml


# add pvclaim
kubectl apply -f minio-pv-claim.yaml

# Values file in config directory was copied from the spinnaker helm github repo : https://raw.githubusercontent.com/kubernetes/charts/master/stable/spinnaker/values.yaml . The only modification made to the file is that minio is disabled . Spinnaker chart repo : https://github.com/kubernetes/charts/tree/master/stable/spinnaker


# install spinnaker using chart
helm install stable/spinnaker --name instspinnaker -f ./config/values.yaml --timeout 900

# create spinnaker port forwarding tunnels 
export DECK_POD=$(kubectl get pods --namespace default -l "component=deck,app=spinnakerinst-spinnaker" -o jsonpath="{.items[0].metadata.name}")

kubectl port-forward --namespace default $DECK_POD 9000
#  Visit the Spinnaker UI by opening your browser to: http://127.0.0.1:9000

