#!/bin/bash
apt install net-tools
sudo apt update
sudo apt upgrade -y
sudo apt install -y nginx
nginx -v
# Should show: nginx version: nginx/1.24.0 (or newer)
sudo systemctl enable nginx
