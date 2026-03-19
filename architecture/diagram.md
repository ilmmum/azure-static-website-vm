# 🏗️ Azure Static Website Deployment - Architecture Diagram

## 📋 Complete Architecture Overview
─────────────────────────────────────────────────────────────────────────────┐
│ INTERNET / USERS │
│ (HTTP/HTTPS) │
└───────────────────────────────────────┬─────────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ ┌─────────────────────────────────┐ │
│ │ PUBLIC IP: 20.160.26.41 │ │
│ │ (Azure Public IP) │ │
│ └─────────────────────────────────┘ │
│ │ │
│ ▼ │
│ ┌─────────────────────────────────────────────────────────────────────┐ │
│ │ NETWORK SECURITY GROUP (NSG) │ │
│ │ static-website-nsg │ │
│ │ │ │
│ │ ┌──────────────────────────────────────────────────────────────┐ │ │
│ │ │ INBOUND SECURITY RULES │ │ │
│ │ ├──────────────┬──────────┬──────────────┬─────────────┬───────┤ │ │
│ │ │ RULE NAME │ PRIORITY │ PORT │ PROTOCOL │ ACCESS│ │ │
│ │ ├──────────────┼──────────┼──────────────┼─────────────┼───────┤ │ │
│ │ │ Allow-SSH │ 1000 │ 22 │ TCP │ ALLOW │ │ │
│ │ │ Allow-HTTP │ 1010 │ 80 │ TCP │ ALLOW │ │ │
│ │ │ Allow-HTTPS │ 1020 │ 443 │ TCP │ ALLOW │ │ │
│ │ └──────────────┴──────────┴──────────────┴─────────────┴───────┘ │ │
│ └─────────────────────────────────────────────────────────────────────┘ │
│ │ │
│ ▼ │
│ ┌─────────────────────────────────────────────────────────────────────┐ │
│ │ VIRTUAL NETWORK (VNet) │ │
│ │ static-website-vnet │ │
│ │ 10.0.0.0/16 │ │
│ │ │ │
│ │ ┌──────────────────────────────────────────────────────────────┐ │ │
│ │ │ SUBNET │ │ │
│ │ │ static-website-subnet │ │ │
│ │ │ 10.0.1.0/24 │ │ │
│ │ │ │ │ │
│ │ │ ┌──────────────────────────────────────────────────────┐ │ │ │
│ │ │ │ AZURE LINUX VIRTUAL MACHINE │ │ │ │
│ │ │ │ static-website-vm-v2 │ │ │ │
│ │ │ │ │ │ │ │
│ │ │ │ ┌──────────────────────────────────────────────┐ │ │ │ │
│ │ │ │ │ OPERATING SYSTEM │ │ │ │ │
│ │ │ │ │ Ubuntu 22.04 LTS │ │ │ │ │
│ │ │ │ │ Private IP: 10.0.1.4 │ │ │ │ │
│ │ │ │ └──────────────────────────────────────────────┘ │ │ │ │
│ │ │ │ │ │ │ │ │
│ │ │ │ ▼ │ │ │ │
│ │ │ │ ┌──────────────────────────────────────────────┐ │ │ │ │
│ │ │ │ │ WEB SERVER (NGINX) │ │ │ │ │
│ │ │ │ │ Version: 1.18.0 │ │ │ │ │
│ │ │ │ │ Status: ● Active │ │ │ │ │
│ │ │ │ └──────────────────────────────────────────────┘ │ │ │ │
│ │ │ │ │ │ │ │ │
│ │ │ │ ▼ │ │ │ │
│ │ │ │ ┌──────────────────────────────────────────────┐ │ │ │ │
│ │ │ │ │ WEBSITE FILES │ │ │ │ │
│ │ │ │ │ Location: /var/www/html/ │ │ │ │ │
│ │ │ │ │ index.html - Custom DevOps Theme │ │ │ │ │
│ │ │ │ └──────────────────────────────────────────────┘ │ │ │ │
│ │ │ └──────────────────────────────────────────────────────┘ │ │ │
│ │ └──────────────────────────────────────────────────────────────┘ │ │
│ └─────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘

text

## 🔄 Data Flow
┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐
│ USER │────▶│ PUBLIC │────▶│ NSG │────▶│ VM │
│ Browser │ │ IP │ │ Port 80 │ │ NGINX │
└────────────┘ └────────────┘ └────────────┘ └────────────┘
│ │ │ │
▼ ▼ ▼ ▼
HTTP Request 20.160.26.41 Rule: Allow Serves index.html

text

## 🚀 Deployment Pipeline (CI/CD)
┌─────────────────────────────────────────────────────────────────────────┐
│ GITHUB ACTIONS PIPELINE │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────┐
│ DEVELOPER │
│ git push │
└────────┬────────┘
│
▼
┌────────────────────────────────────────────────────────────────────┐
│ GITHUB REPOSITORY │
│ ┌──────────────────────────────────────────────────────────────┐ │
│ │ .github/workflows/deploy.yml triggers on push to main │ │
│ └──────────────────────────────────────────────────────────────┘ │
└────────────────────────────────┬───────────────────────────────────┘
│
▼
┌────────────────────────────────────────────────────────────────────┐
│ GITHUB ACTIONS RUNNER │
│ ┌──────────────────────────────────────────────────────────────┐ │
│ │ Step 1: Checkout code │ │
│ │ Step 2: Setup SSH with secrets │ │
│ │ Step 3: Copy website files (SCP) │ │
│ │ Step 4: Deploy to NGINX (SSH commands) │ │
│ └──────────────────────────────────────────────────────────────┘ │
└────────────────────────────────┬───────────────────────────────────┘
│
▼
┌────────────────────────────────────────────────────────────────────┐
│ AZURE VM │
│ ┌──────────────────────────────────────────────────────────────┐ │
│ │ SSH Connection using github-actions-key │ │
│ │ Files copied to /home/azureuser/ │ │
│ │ sudo mv to /var/www/html/ │ │
│ │ sudo systemctl restart nginx │ │
│ └──────────────────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────────────────┘

text

## 📦 Resource Hierarchy
┌─────────────────────────────────────────────────────────────────┐
│ SUBSCRIPTION │
│ /subscriptions/7a327e04-ddcf-4ce7-8d2a-78aa5320e3b9 │
└─────────────────┬───────────────────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────────────┐
│ RESOURCE GROUP │
│ static-website-rg-final │
├─────────────────────────────────────────────────────────────────┤
│ │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ VIRTUAL NETWORK │ │
│ │ static-website-vnet (10.0.0.0/16) │ │
│ └─────────────────────────────────────────────────────────┘ │
│ │ │
│ ▼ │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ SUBNET │ │
│ │ static-website-subnet (10.0.1.0/24) │ │
│ └─────────────────────────────────────────────────────────┘ │
│ │ │
│ ▼ │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ NETWORK SECURITY GROUP │ │
│ │ static-website-nsg │ │
│ │ ├── Allow-SSH (Port 22) │ │
│ │ ├── Allow-HTTP (Port 80) │ │
│ │ └── Allow-HTTPS (Port 443) │ │
│ └─────────────────────────────────────────────────────────┘ │
│ │ │
│ ▼ │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ PUBLIC IP ADDRESS │ │
│ │ 20.160.26.41 │ │
│ └─────────────────────────────────────────────────────────┘ │
│ │ │
│ ▼ │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ VIRTUAL MACHINE │ │
│ │ static-website-vm-v2 │ │
│ │ ├── OS: Ubuntu 22.04 LTS │ │
│ │ ├── Size: Standard_DS1_v2 │ │
│ │ └── Private IP: 10.0.1.4 │ │
│ └─────────────────────────────────────────────────────────┘ │
│ │ │
│ ▼ │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ NGINX WEB SERVER │ │
│ │ Version: 1.18.0 │ │
│ │ Status: ● Running │ │
│ └─────────────────────────────────────────────────────────┘ │
│ │ │
│ ▼ │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ STATIC WEBSITE │ │
│ │ Location: /var/www/html/index.html │ │
│ │ Content: DevOps-themed static site │ │
│ │ Author: Oluwole │ │
│ └─────────────────────────────────────────────────────────┘ │
│ │
└─────────────────────────────────────────────────────────────────┘

text

## 🔐 Security Rules Summary

| Direction | Protocol | Port | Source | Destination | Action | Purpose |
|-----------|----------|------|--------|-------------|--------|---------|
| Inbound | TCP | 22 | * | VM | ALLOW | SSH Access |
| Inbound | TCP | 80 | * | VM | ALLOW | HTTP Web Traffic |
| Inbound | TCP | 443 | * | VM | ALLOW | HTTPS Web Traffic |
| Outbound | All | * | VM | * | ALLOW | Internet Access |

## 📊 VM Specifications

| Component | Specification |
|-----------|--------------|
| VM Name | static-website-vm-v2 |
| OS | Ubuntu 22.04.5 LTS |
| VM Size | Standard_DS1_v2 |
| Public IP | 20.160.26.41 |
| Private IP | 10.0.1.4 |
| Location | westeurope |
| Resource Group | static-website-rg-final |
| VNet | static-website-vnet (10.0.0.0/16) |
| Subnet | static-website-subnet (10.0.1.0/24) |
| NSG | static-website-nsg |
| Web Server | NGINX 1.18.0 |
| Website Path | /var/www/html/index.html |

## 🔧 Automation Scripts
📁 scripts/
├── 📄 deploy-infra.sh
│ └── Creates: Resource Group, VNet, Subnet, NSG, VM
│
└── 📄 deploy-web.sh
└── Installs: NGINX, Copies website files, Configures server

📁 .github/workflows/
└── 📄 deploy.yml
└── CI/CD: Auto-deploys on git push to main branch

text

## ✅ Deployment Status

| Component | Status | Last Verified |
|-----------|--------|---------------|
| Resource Group | ✅ Active | March 19, 2026 |
| Virtual Network | ✅ Configured | March 19, 2026 |
| Subnet | ✅ Configured | March 19, 2026 |
| NSG Rules | ✅ All 3 rules active | March 19, 2026 |
| VM | ✅ Running | March 19, 2026 |
| NGINX | ✅ Active | March 19, 2026 |
| Website | ✅ Live | March 19, 2026 |
| GitHub Actions | ✅ Configured | March 19, 2026 |

---

---

**📅 Last Updated: March 19, 2026**
