


helm install stable/nginx-ingress --name nginx-ingress -f ./values.yaml

kl apply -f eurekaservice-ingress.yaml