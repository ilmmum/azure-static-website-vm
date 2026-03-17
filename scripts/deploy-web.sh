#!/bin/bash

PUBLIC_IP="40.67.195.14"
USER="azureuser"

echo "Connecting to VM and installing NGINX..."

ssh $USER@$PUBLIC_IP << EOF

sudo apt update
sudo apt install nginx -y

sudo systemctl start nginx
sudo systemctl enable nginx

# Remove default page
sudo rm -f /var/www/html/index.nginx-debian.html

EOF

echo "Copying website files..."

scp -r ../website/* $USER@$PUBLIC_IP:/home/$USER/

ssh $USER@$PUBLIC_IP << EOF

sudo mv /home/$USER/* /var/www/html/

sudo systemctl restart nginx

EOF

echo "Deployment complete! Visit http://$PUBLIC_IP"