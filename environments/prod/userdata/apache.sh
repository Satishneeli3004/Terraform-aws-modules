#!/bin/bash

set -e

echo "Updating system packages..."
sudo apt update -y
sudo apt upgrade -y

echo "Installing Apache2..."
sudo apt install apache2 -y

echo "Starting Apache service..."
sudo systemctl start apache2

echo "Enabling Apache at boot..."
sudo systemctl enable apache2

echo "Configuring firewall (if UFW is installed)..."
if command -v ufw >/dev/null 2>&1; then
    sudo ufw allow 'Apache'
fi

echo "Creating a custom index page..."
cat <<EOF | sudo tee /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Apache on EC2</title>
</head>
<body>
    <h1>Apache Successfully Installed!</h1>
    <p>This web server is running on an Ubuntu EC2 instance.</p>
</body>
</html>
EOF

echo "Testing Apache configuration..."
sudo apache2ctl configtest

echo "Restarting Apache..."
sudo systemctl restart apache2

echo "Apache installation and configuration completed."

echo "Apache status:"
sudo systemctl status apache2 --no-pager