#!/bin/bash

sudo hostnamectl set-hostname sonar
sudo apt install net-tools
set -e
#!/bin/bash

# Update package manager repositories
sudo apt-get update

# Install necessary dependencies
sudo apt-get install -y ca-certificates curl

# Create directory for Docker GPG key
sudo install -m 0755 -d /etc/apt/keyrings

# Download Docker's GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

# Ensure proper permissions for the key
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository to Apt sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package manager repositories
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 

#last long term version 
sudo docker run -d \
  --name sonar \
  -p 9000:9000 \
  -m 2g \
  -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
  -e ES_JAVA_OPTS="-Xms512m -Xms512m" \
  -v sonar_data:/opt/sonarqube/data \
  -v sonar_extensions:/opt/sonarqube/extensions \
  -v sonar_logs:/opt/sonarqube/logs \
  sonarqube:lts-community


  

