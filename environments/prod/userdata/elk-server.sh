#!/bin/bash
hostnamectl set-hostname elk-server-1
set -e

apt install net-tools
echo "Updating system packages..."
sudo apt update

echo "Installing OpenJDK 17..."
sudo apt install -y openjdk-17-jdk

echo "Java version:"
java -version

echo "Adding Elasticsearch GPG key..."
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | \
sudo gpg --dearmor -o /usr/share/keyrings/elastic-keyring.gpg

echo "Adding Elasticsearch repository..."
echo "deb [signed-by=/usr/share/keyrings/elastic-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | \
sudo tee /etc/apt/sources.list.d/elastic-7.x.list > /dev/null

echo "Updating package list..."
sudo apt update

echo "Installing Elasticsearch..."
sudo apt install -y elasticsearch

echo "Configuring Elasticsearch network host..."
sudo sed -i '/^#\?network.host:/d' /etc/elasticsearch/elasticsearch.yml
echo "network.host: 0.0.0.0" | sudo tee -a /etc/elasticsearch/elasticsearch.yml > /dev/null

echo "Reloading systemd and enabling Elasticsearch..."
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

echo "Checking Elasticsearch service status..."
sudo systemctl status elasticsearch --no-pager

echo "Installation completed successfully."