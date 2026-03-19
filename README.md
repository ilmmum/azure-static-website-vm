
## 📋 Project Overview

**Deployed URL:** http://20.160.26.41
**GitHub Repository:** [azure-static-website-vm](https://github.com/ilmmum/azure-static-website-vm)

This project demonstrates the complete automation of infrastructure provisioning and static website deployment on Microsoft Azure using Bash scripting. Every component is built from scratch using Azure CLI - **zero manual portal steps!**


# 🏗️ Architecture
┌─────────────────────────────────────┐
│ Internet Traffic │
└────────────┬────────────────────────┘
│
┌────────────▼────────────────────────┐
│ Network Security Group (NSG) │
│ ├── Port 22 (SSH) - Open │
│ ├── Port 80 (HTTP) - Open │
│ └── Port 443 (HTTPS) - Open │
└────────────┬────────────────────────┘
│
┌────────────▼────────────────────────┐
│ Azure Linux VM │
│ ├── Ubuntu 22.04 LTS │
│ ├── NGINX Web Server │
│ └── Custom Static Website │
└─────────────────────────────────────┘



###  What We Built

| Component | Technology | Status |
|-----------|------------|--------|
| Resource Group | Azure | ✅ Created |
| Virtual Network | Azure VNet | ✅ Configured |
| Subnet | Azure | ✅ Created |
| Network Security Group | Azure NSG | ✅ Rules Applied |
| Linux VM | Ubuntu 22.04 | ✅ Deployed |
| Web Server | NGINX | ✅ Installed |
| Static Website | HTML/CSS | ✅ Live |
| Automation | Bash Scripts | ✅ Complete |
| Version Control | GitHub | ✅ Pushed |

---

##  The Journey: Challenges & Solutions

### Challenge 1: SSH Connection Timeout
**Problem:** The script kept showing `"ssh: connect to host port 22: Connection timed out"`

**Solution:** 
- Added Network Security Group rules explicitly opening port 22
- Implemented SSH retry logic that waits up to 180 seconds for VM to be ready
- Used `nc -z` to test port connectivity before attempting SSH

### Challenge 2: NSG Rule Creation Failures
**Problem:** `unrecognized arguments` error with `--destination-port-range`

**Solution:** 
- Discovered Azure CLI uses plural `--destination-port-ranges` not singular
- Removed inline comments from multi-line commands (comments break bash line continuation)
- Each NSG rule needed unique priority numbers (1000, 1010, 1020)

### Challenge 3: VM Name Conflicts
**Problem:** `"The content for this response was already consumed"` error

**Solution:**
- Changed VM name from `static-website-vm` to `static-website-vm-v2`
- Azure retains resource metadata briefly after deletion
- Added timestamp function for future deployments

### Challenge 4: Bash Script Syntax Errors
**Problem:** Scripts failing with `command not found` for numbers

**Solution:**
- Fixed variable interpolation: `${ELAPSED}` instead of just variable names
- Separated SSH waiting logic from deployment commands
- Used proper heredoc `<< 'EOF'` syntax for multi-line remote commands

### Challenge 5: Default NGINX Page Showing
**Problem:** After deployment, still saw "Welcome to nginx" page

**Solution:**
- Removed default page: `sudo rm -f /var/www/html/index.nginx-debian.html`
- Copied files to `/home/azureuser/` first, then used `sudo mv` to web directory
- Set proper permissions with `sudo chown www-data:www-data`

### Challenge 6: GitHub Actions SSH Authentication
**Problem:** GitHub Actions couldn't connect to VM

**Solution:**
- Created dedicated SSH key for GitHub Actions
- Added public key to VM's `authorized_keys`
- Stored private key in GitHub Secrets
- Used `ssh-keyscan` to avoid host key verification

---

##  Repository Structure
azure-static-website-vm/
├──  README.md # You are here!
├──  scripts/
│ ├──  deploy-infra.sh # Creates ALL Azure infrastructure
│ └──  deploy-web.sh # Deploys website with SSH retry
├──  website/
│ └──  index.html # Custom static website
├──  architecture/
│ └──  diagram.md # Architecture diagram
└──  screenshots/
├── live-site.png
├── deployment-success.png
└── nsg-rules.png

##  How to Run This Project

### Prerequisites
```bash
# 1. Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# 2. Login to Azure
az login (With my Free Azure Account 200 dollars)

# 3. Clone this repository
git clone https://github.com/ilmmum/azure-static-website-vm.git
cd azure-static-website-vm

Step 1: Deploy Infrastructure
bash
# Make script executable
chmod +x scripts/deploy-infra.sh

# Run infrastructure deployment
./scripts/deploy-infra.sh
What happens:

Creates Resource Group

Sets up VNet and Subnet

Configures NSG with ports 22, 80, 443

Deploys Ubuntu VM

Outputs Public IP: 20.160.26.41

Step 2: Deploy Website
bash
# Make script executable
chmod +x scripts/deploy-web.sh

# Run website deployment (with automatic SSH retry)
./scripts/deploy-web.sh
What happens:

Waits up to 180s for SSH to be ready

Installs and configures NGINX

Copies custom website files

Restarts web server

Website goes live!

## Step 3: View Your Live Site 
With this link https://20.160.26.41

### GitHub Actions CI/CD Pipeline
How It Works
Every time you push to the main branch, GitHub Actions automatically:

> Connects to your Azure VM via SSH

>> Copies the latest website files

>>> Deploys them to NGINX

>>>> Your site updates automatically!

Pipeline Status
https://github.com/ilmmum/azure-static-website-vm/actions/workflows/deploy.yml/badge.svg

Secrets Configured
Secret Name	Purpose
SSH_PRIVATE_KEY	Private key for VM access
VM_IP	Your VM's public IP (20.160.26.41)
VM_USER	VM username (azureuser)


Static Website
The website features a modern DevOps-themed design with:

Gradient background animation

Technology stack badges

Deployment status cards

Responsive layout

Professional styling

 Project Deliverables
#	Task	Status
1	Resource Group, VNet, Subnet, NSG via CLI	✅
2	Linux VM deployment with shell script	✅
3	NGINX installed and configured	✅
4	Static website files ready	✅
5	Web server serving custom content	✅
6	Inbound rules for ports 80/443	✅
7	All scripts in GitHub	✅
8	GitHub Actions CI/CD	✅
9	Bonus: Automated deployment on push	✅

Troubleshooting Guide
Common Issues & Solutions
Issue	Solution
SSH Connection Timeout	Check NSG rules: az network nsg rule list -g static-website-rg-final --nsg-name static-website-nsg -o table
Default NGINX Page	Run: sudo rm /var/www/html/index.nginx-debian.html
Permission Denied	Fix ownership: sudo chown -R www-data:www-data /var/www/html/
VM Not Running	Check status: az vm show -d -g static-website-rg-final -n static-website-vm-v2 --query powerState
GitHub Actions Fails	Verify secrets are correctly set in GitHub repository


Screenshots
Component	Description
Live Website	Modern DevOps-themed static site
Deployment Success	Terminal output showing successful deployment
NSG Rules	Port 22, 80, 443 configured
VM Running	VM status verification
GitHub Actions	Successful workflow run


Author
Oluwole - Cloud & DevOps Engineer

GitHub: @ilmmum

LinkedIn: Oluwole Olajide Ojo

 License
This project is part of a DevOps Capstone Project - Group 5

 Acknowledgments
Microsoft Azure Documentation

Ubuntu Documentation

GitHub Actions Documentation

NGINX Documentation