#!/bin/bash

# Capstone Project - Azure Static Website Deployment
# Author: Oluwole
# This script provisions infrastructure on Azure
# VARIABLES


# Exit script if any command fails
set -e

# =========================
# VARIABLES (Reusable values)
# =========================
RESOURCE_GROUP="static-website-rg-final"
LOCATION="WestEurope"
VNET_NAME="static-website-vnet"
SUBNET_NAME="static-website-subnet"
NSG_NAME="static-website-nsg"
VM_NAME="static-website-vm"
ADMIN_USER="azureuser"
IMAGE="Ubuntu2204"
VM_SIZE="Standard_B2s_v2"

echo "Creating Resource Group..."
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

echo "Creating Virtual Network and Subnet..."
az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_NAME \
  --address-prefix 10.0.0.0/16 \
  --subnet-name $SUBNET_NAME \
  --subnet-prefix 10.0.1.0/24

echo "Creating Network Security Group..."
az network nsg create \
  --resource-group $RESOURCE_GROUP \
  --name $NSG_NAME

echo "Allowing HTTP (Port 80)..."
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME \
  --name Allow-HTTP \
  --priority 100 \
  --protocol Tcp \
  --direction Inbound \
  --source-address-prefixes '*' \
  --source-port-ranges '*' \
  --destination-port-ranges 80 \
  --access Allow

echo "Allowing HTTPS (Port 443)..."
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME \
  --name Allow-HTTPS \
  --priority 101 \
  --protocol Tcp \
  --direction Inbound \
  --source-address-prefixes '*' \
  --source-port-ranges '*' \
  --destination-port-ranges 443 \
  --access Allow

echo "Creating Virtual Machine..."
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --image $IMAGE \
  --size $VM_SIZE \
  --admin-username $ADMIN_USER \
  --generate-ssh-keys \
  --vnet-name $VNET_NAME \
  --subnet $SUBNET_NAME \
  --nsg $NSG_NAME

echo "Getting Public IP..."
PUBLIC_IP=$(az vm show \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  -d \
  --query publicIps \
  -o tsv)

echo "======================================"
echo "VM successfully created!"
echo "Public IP: $PUBLIC_IP"
echo "SSH into your VM using:"
echo "ssh $ADMIN_USER@$PUBLIC_IP"
echo "======================================"


