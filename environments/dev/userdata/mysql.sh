#!/bin/bash
set -e

LOGFILE="/var/log/user-data.log"
exec > >(tee -a $LOGFILE) 2>&1

echo "===== Starting Ubuntu EC2 Bootstrap ====="

# Update system
apt-get update -y
apt-get upgrade -y

# Install required packages
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# ----------------------------
# Install Docker
# ----------------------------

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update -y

apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable docker
systemctl start docker

echo "Docker installed successfully"

# ----------------------------
# Setup application directory
# ----------------------------

mkdir -p /opt/keycloak
cd /opt/keycloak

# ----------------------------
# Create docker-compose.yml
# ----------------------------

cat > docker-compose.yml <<'EOF'
services:

  mysql:
    image: mysql:8.0
    container_name: mysql
    restart: unless-stopped

    environment:
      MYSQL_ROOT_PASSWORD: RootPassword123!
      MYSQL_DATABASE: keycloak
      MYSQL_USER: keycloak
      MYSQL_PASSWORD: KeycloakPassword123!

    ports:
      - "3306:3306"

    volumes:
      - mysql_data:/var/lib/mysql

    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-uroot", "-pRootPassword123!"]
      interval: 10s
      timeout: 5s
      retries: 10

  keycloak:
    image: quay.io/keycloak/keycloak:26.2.0
    container_name: keycloak
    restart: unless-stopped

    command: start

    depends_on:
      mysql:
        condition: service_healthy

    environment:
      KC_DB: mysql
      KC_DB_URL: jdbc:mysql://mysql:3306/keycloak
      KC_DB_USERNAME: keycloak
      KC_DB_PASSWORD: KeycloakPassword123!

      KEYCLOAK_ADMIN: admin
      KEYCLOAK_ADMIN_PASSWORD: AdminPassword123!

      KC_HTTP_ENABLED: "true"

    ports:
      - "8080:8080"

volumes:
  mysql_data:
EOF

# ----------------------------
# Start containers
# ----------------------------

docker compose up -d

echo "===== Deployment Completed ====="
echo "Keycloak URL: http://<EC2-PUBLIC-IP>:8080"