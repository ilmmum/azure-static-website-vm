#!/bin/bash

# ===== SIMPLE SSH WAIT AND DEPLOY SCRIPT =====


# Settings
PUBLIC_IP="20.160.26.41"
USER="azureuser"
TIMEOUT=180

# STEP 1: WAIT FOR SSH TO BE READY
echo "Waiting for SSH to be ready on $PUBLIC_IP..."

# Counter to track time
ELAPSED=0

# Keep trying every 10 seconds until SSH works or timeout
while ! ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no $USER@$PUBLIC_IP exit 2>/dev/null; do
    # Check if we've waited too long (3 minutes)
    if [ $ELAPSED -ge $TIMEOUT ]; then
        echo "ERROR: Cannot connect to VM after $TIMEOUT seconds"
        exit 1
    fi
    
    # Show waiting message with time
    echo "SSH not ready yet... waiting 10 seconds (${ELAPSED}s/${TIMEOUT}s)"
    
    # Wait 10 seconds
    sleep 10
    
    # Add 10 to the elapsed time
    ELAPSED=$((ELAPSED + 10))
done

# STEP 2: SSH IS READY - NOW INSTALL NGINX
echo "SSH connection successful! Installing NGINX..."
ssh $USER@$PUBLIC_IP << 'EOF'
    sudo apt update
    sudo apt install nginx -y
    sudo systemctl start nginx
    sudo systemctl enable nginx
    sudo rm -f /var/www/html/index.nginx-debian.html
EOF

# STEP 3: COPY WEBSITE FILES
echo "Copying website files..."
scp -r ./website/* $USER@$PUBLIC_IP:/home/$USER/

# STEP 4: MOVE FILES TO WEB FOLDER
ssh $USER@$PUBLIC_IP << 'EOF'
    sudo mv /home/azureuser/* /var/www/html/
    sudo systemctl restart nginx
EOF

# STEP 5: DONE!
echo "=================================="
echo "Deployment complete!"
echo "Visit: http://$PUBLIC_IP"
echo "=================================="