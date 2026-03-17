#!/bin/bash

# Capstone Project - Azure Static Website Deployment
# Author: Oluwole
# This script provisions infrastructure on Azure
# VARIABLES

#!/bin/bash

RESOURCE_GROUP="capstone-rg"
LOCATION="eastus"
VM_NAME="capstone-vm"

echo "Creating Resource Group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "Creating VM..."
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --image Ubuntu2204 \
  --admin-username azureuser \
  --generate-ssh-keys

echo "Opening port 80..."
az vm open-port \
  --port 80 \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME

echo "Fetching Public IP..."
az vm show -d \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --query publicIps \
  --output tsv

echo "Deployment complete!"