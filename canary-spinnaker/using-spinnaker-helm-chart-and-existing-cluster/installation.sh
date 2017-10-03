# provision the k8s cluster with custom subnet. Starting from current directory as working directory
cd ../../
./provision.sh


# From portal associate routing table to subnet 1

# change working directory
cd ./canary-spinnaker/using-spinnaker-helm-chart-and-existing-cluster/

# install eureka service and eureka service client using helm chart
helm install --name eureka-services ../../eur-helm


# Values file in config directory was copied from the spinnaker helm github repo : https://raw.githubusercontent.com/kubernetes/charts/master/stable/spinnaker/values.yaml . The only modification made to the file is that minio is disabled . Spinnaker chart repo : https://github.com/kubernetes/charts/tree/master/stable/spinnaker

# install spinnaker using chart
helm install stable/spinnaker --name spinnakerinst -f ./config/values.yaml --timeout 900

# create spinnaker port forwarding tunnels 
export DECK_POD=$(kubectl get pods --namespace default -l "component=deck,app=spinnakerinst-spinnaker" -o jsonpath="{.items[0].metadata.name}")

kubectl port-forward --namespace default $DECK_POD 9000
#  Visit the Spinnaker UI by opening your browser to: http://127.0.0.1:9000

