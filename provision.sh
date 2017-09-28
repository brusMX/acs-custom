#!/bin/bash
# Interactively create an Azure Container service with kubernetes and custom Agent pools
# Author: Bruno Medina (@brusmx)
# Requirements:
# - Azure Cli 2.0
# - jq
#
# Example of usage: 
# ./create-acs-k8s-custom-agent-pools.sh

# Making sure it's connected
DEFAULT_ACCOUNT=`az account show`
DEFAULT_ACCOUNT_ID=`echo $DEFAULT_ACCOUNT | jq -r '.id'`
if [ ! -z "$DEFAULT_ACCOUNT_ID" ]; then
# Create resource groups
RG_NAME=$(mktemp k8s-mixed-agents-rg-XXXXXXX)
# Supported regions for V2 are: 
# UK West, UK South, West Central US, West US 2,
# Canada, East Canada, Central West India, South India, Central India
LOC=centralindia
CLUSTER_NAME=mixed-k8s-cluster
VNET_NAME=kingdom
VNET_CIDR=10.1.0.0/16
SUBNET1_NAME=subnet1
SUBNET1_CIDR=10.1.0.0/22
SUBNET2_NAME=subnet2
SUBNET2_CIDR=10.1.5.0/24
SUBNET3_NAME=subnet3
SUBNET3_CIDR=10.1.6.0/24
FIRST_IP_MASTER=10.1.0.5
echo "Creating Resource Group"
az group create -n $RG_NAME -l $LOC -o table
echo "... RG created."
echo "Creating VNET:${VNET_NAME} . with subnet: ${SUBNET1_NAME} - CIDR: ${SUBNET1_CIDR}"
az network vnet create -g $RG_NAME -n $VNET_NAME --address-prefix $VNET_CIDR \
        --subnet-name $SUBNET1_NAME --subnet-prefix $SUBNET1_CIDR -o table
export SUBNET1_ID=`az network vnet subnet show --vnet-name $VNET_NAME -g $RG_NAME -n $SUBNET1_NAME | jq -r '.id'`
echo "Creating subnet: ${SUBNET2_NAME} - CIDR: ${SUBNET2_CIDR}"
az network vnet subnet create -g $RG_NAME --vnet-name $VNET_NAME  -n $SUBNET2_NAME --address-prefix $SUBNET2_CIDR -o table
SUBNET2_ID=`az network vnet subnet show --vnet-name $VNET_NAME -g $RG_NAME -n $SUBNET2_NAME | jq -r '.id'`
echo "Creating subnet: ${SUBNET3_NAME} - CIDR: ${SUBNET3_CIDR}"
az network vnet subnet create -g $RG_NAME --vnet-name $VNET_NAME  -n $SUBNET3_NAME --address-prefix $SUBNET3_CIDR -o table
echo "... Vnet created"
echo "Creating k8s cluster..."
echo "K8s cluster name: ${CLUSTER_NAME}"
echo "Resource group name: ${RG_NAME}"
echo "Location: ${RG_NAME}"
echo "CustomVNET: "
AGENT_POOLS="[{'name':'agentpool1','vmSize':'Standard_DS2_v2_Promo','count':1, 'vnetSubnetId': ${SUBNET1_ID} },{'name':'agentpool2','vmSize':'Standard_DS3_v2_Promo','count':1, 'vnetSubnetId': ${SUBNET1_ID}}]"
echo "Agent pools: ${AGENT_POOLS}"

az acs create -n $CLUSTER_NAME -g $RG_NAME -t kubernetes \
    -a "${AGENT_POOLS}" \
    --generate-ssh-keys \
    --agent-vnet-subnet-id $SUBNET1_ID \
    --master-vnet-subnet-id $SUBNET1_ID \
    --master-first-consecutive-static-ip $FIRST_IP_MASTER \
    -o table
echo ".... k8s deployed"
az acs kubernetes get-credentials -g $RG_NAME -n $CLUSTER_NAME
kubectl cluster-info
kubectl get nodes
else
    echo "Your subscription couldn't be found, make sure you have logged in:"
    echo "az login"
    exit 1
fi