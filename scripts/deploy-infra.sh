#!/bin/bash

# Capstone Project - Azure Static Website Deployment
# Author: Oluwole
# This script provisions infrastructure on Azure
# VARIABLES

RESOURCE_GROUP="capstone-rg"
LOCATION="eastus"
VNET_NAME="capstone-vnet"
SUBNET_NAME="web-subnet"
NSG_NAME="web-nsg"
PUBLIC_IP_NAME="web-public-ip"
NIC_NAME="web-nic"
VM_NAME="web-vm"
VM_SIZE="Standard_B1s"
IMAGE="Ubuntu2204"
ADMIN_USER="azureuser"