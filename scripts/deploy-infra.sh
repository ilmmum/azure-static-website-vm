#!/bin/bash

# Capstone Project - Azure Static Website Deployment
# Author: Oluwole
# This script provisions infrastructure on Azure

# Exit script if any command fails
set -e

# Variables
RESOURCE_GROUP="static-website-rg-final"
LOCATION="westeurope"
VNET_NAME="static-website-vnet"
SUBNET_NAME="static-website-subnet"
NSG_NAME="static-website-nsg"
VM_NAME="static-website-vm-v2"
ADMIN_USER="azureuser"

# Create resource group
echo "Creating Resource Group..."
az group create --name $RESOURCE_GROUP --location $LOCATION || true

# Create Virtual Network and Subnet
echo "Creating Virtual Network and Subnet..."
az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --name $VNET_NAME \
    --address-prefix 10.0.0.0/16 \
    --subnet-name $SUBNET_NAME \
    --subnet-prefix 10.0.1.0/24 || true

# Create Network Security Group
echo "Creating Network Security Group..."
az network nsg create \
    --resource-group $RESOURCE_GROUP \
    --name $NSG_NAME || true

# ---- PORT RULES ----
echo "Allowing SSH (Port 22)..."
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_NAME \
    --name Allow-SSH \
    --priority 1000 \
    --destination-port-ranges 22 || true

echo "Allowing HTTP (Port 80)..."
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_NAME \
    --name Allow-HTTP \
    --priority 1010 \
    --destination-port-ranges 80 || true

echo "Allowing HTTPS (Port 443)..."
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_NAME \
    --name Allow-HTTPS \
    --priority 1020 \
    --destination-port-ranges 443 || true

# Create Virtual Machine
echo "Creating Virtual Machine..."
az vm create \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME \
    --image Ubuntu2204 \
    --admin-username $ADMIN_USER \
    --generate-ssh-keys \
    --vnet-name $VNET_NAME \
    --subnet $SUBNET_NAME \
    --nsg $NSG_NAME \
    --public-ip-sku Standard \
    --size Standard_D2S_v5

# Get and display public IP
echo "Getting Public IP..."
PUBLIC_IP=$(az vm show -d -g $RESOURCE_GROUP -n $VM_NAME --query publicIps -o tsv)

echo "=========================================="
echo "VM successfully created!"
echo "Public IP: $PUBLIC_IP"
echo "SSH into your VM using: ssh $ADMIN_USER@$PUBLIC_IP"
echo "=========================================="

# Save IP to file for deploy-web.sh
echo $PUBLIC_IP > public_ip.txt



