environment              = "prod"
client_name              = "elk"
project_name             = "networking"
igw_name                 = "elk-prod-igw"
nat_name                 = "elk-prod-nat"
sg_name                  = "elk-prod-sg"
cidr_block               = "192.0.0.0/16"
vpc_name                 = "elk-prod-vpc"
public_route_table_name  = "public-rt"
private_route_table_name = "private-rt"
# Subnet CIDRs (ELK Server in Public, App Server in Private)
private_subnet_cidrs = ["192.0.4.0/24", "192.0.3.0/24"]
public_subnet_cidrs  = ["192.0.5.0/24", "192.0.2.0/24"]

# AMI IDs (Ubuntu 22.04 LTS)
ami_id               = "ami-07a00cf47dbbc844c"
worker_instance_type = "t3.small"
master_instance_type = "t3.small"

# ============================================
# PRODUCTION-GRADE SECURITY GROUPS
# ============================================

security_groups = {

  # 1. BASTION / JUMP HOST (Optional - for accessing private instances)
  web-bastion-sg = {
    description = "Bastion Host + Nginx Webserver Security Group"
    ingress_rules = [
      # SSH - ONLY from your office IP
      {
        description = "SSH from My Public IP ONLY"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["175.101.156.133/32"] # Your IP ONLY
      },
      # HTTP - For Nginx (Kibana Proxy)
      {
        description = "HTTP for Nginx Proxy"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # Or restrict to your IP for testing
      },
      # HTTPS - For Nginx Proxy (if you enable SSL)
      {
        description = "HTTPS for Nginx Proxy"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    egress_rules = [
      {
        description = "Allow all outbound"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  # 2. ELK SERVER (Public Subnet - Exposes Kibana & Logstash)
  elk-sg = {
    description = "ELK Stack Server Security Group"
    ingress_rules = [
      # SSH - Only from Bastion/Webserver (Public Subnet)
      {
        description = "SSH from Bastion/Webserver"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["192.0.5.0/24", "192.0.2.0/24"] # Bastion is in public subnet
      },
      # Kibana UI - Only from Bastion/Webserver (Nginx Proxy)
      {
        description = "Kibana Web UI from Bastion"
        from_port   = 5601
        to_port     = 5601
        protocol    = "tcp"
        cidr_blocks = ["192.0.5.0/24", "192.0.2.0/24"] # From Bastion's subnet
      },
      # Elasticsearch API - From App Server (Private) & Internal
      {
        description = "Elasticsearch API from App Server"
        from_port   = 9200
        to_port     = 9200
        protocol    = "tcp"
        cidr_blocks = ["192.0.4.0/24", "192.0.3.0/24"] # Private subnets
      },
      # Elasticsearch Transport - INTERNAL CLUSTER COMMUNICATION (FIXED)
      {
        description = "Elasticsearch Transport between ELK nodes"
        from_port   = 9300
        to_port     = 9300
        protocol    = "tcp"
        cidr_blocks = ["192.0.4.0/24", "192.0.3.0/24"] # Both ELK nodes are in PRIVATE subnets
      },
      # Logstash Beats Input - From Filebeat on App Server
      {
        description = "Logstash Beats Input from Filebeat"
        from_port   = 5044
        to_port     = 5044
        protocol    = "tcp"
        cidr_blocks = ["192.0.4.0/24", "192.0.3.0/24"] # App Server in private subnets
      },
      # Logstash Monitoring - Internal only
      {
        description = "Logstash Monitoring"
        from_port   = 9600
        to_port     = 9600
        protocol    = "tcp"
        cidr_blocks = ["192.0.4.0/24", "192.0.3.0/24"] # Only within private subnets
      }
    ]
    egress_rules = [
      {
        description = "Allow all outbound"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  # 3. APPLICATION SERVER (Private Subnet - No direct internet access)
  app-sg = {
    description = "Application Server Security Group"
    ingress_rules = [
      # SSH - ONLY from Bastion Host or ELK Server (Jump Host Pattern)
      {
        description = "SSH from Bastion/Webserver"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["192.0.5.0/24", "192.0.2.0/24"] # Bastion is in public subnet
      },
      # Keycloak Admin UI
      {
        description = "Keycloak Web UI"
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["192.0.5.0/24", "192.0.2.0/24"] # Only within VPC
      },
      # MySQL - Internal only
      {
        description = "MySQL Database"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["192.0.4.0/24", "192.0.3.0/24"] # Only within VPC
      },
    ]
    egress_rules = [
      {
        description = "Allow all outbound"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  # # 4. DATABASE / CACHE SERVERS (If you add MongoDB, Redis, etc.)
  # database = {
  #   description = "Database Server Security Group"
  #   ingress_rules = [
  #     # SSH from ELK Server only
  #     {
  #       description = "SSH from ELK Server"
  #       from_port   = 22
  #       to_port     = 22
  #       protocol    = "tcp"
  #       cidr_blocks = ["192.0.5.0/24", "192.0.2.0/24"]
  #     },
  #     # MongoDB
  #     {
  #       description = "MongoDB"
  #       from_port   = 27017
  #       to_port     = 27017
  #       protocol    = "tcp"
  #       cidr_blocks = ["192.0.5.0/24", "192.0.2.0/24"]
  #     },
  #     # Redis
  #     {
  #       description = "Redis"
  #       from_port   = 6379
  #       to_port     = 6379
  #       protocol    = "tcp"
  #       cidr_blocks = ["192.0.5.0/24", "192.0.2.0/24"]
  #     },
  #     # PostgreSQL
  #     {
  #       description = "PostgreSQL"
  #       from_port   = 5432
  #       to_port     = 5432
  #       protocol    = "tcp"
  #       cidr_blocks = ["192.0.5.0/24", "192.0.2.0/24"]
  #     }
  #   ]
  #   egress_rules = [
  #     {
  #       description = "Allow all outbound"
  #       from_port   = 0
  #       to_port     = 0
  #       protocol    = "-1"
  #       cidr_blocks = ["0.0.0.0/0"]
  #     }
  #   ]
  # }

  # # 5. MONITORING / LOGGING (Prometheus, Grafana)
  # monitoring = {
  #   description = "Monitoring Stack Security Group"
  #   ingress_rules = [
  #     # SSH from ELK Server
  #     {
  #       description = "SSH from ELK Server"
  #       from_port   = 22
  #       to_port     = 22
  #       protocol    = "tcp"
  #       cidr_blocks = ["192.0.5.0/24", "192.0.2.0/24"]
  #     },
  #     # Grafana Dashboard
  #     {
  #       description = "Grafana Web UI"
  #       from_port   = 3000
  #       to_port     = 3000
  #       protocol    = "tcp"
  #       cidr_blocks = ["175.101.156.133/32"] # Your IP ONLY (Production)
  #     },
  #     # Prometheus
  #     {
  #       description = "Prometheus"
  #       from_port   = 9090
  #       to_port     = 9090
  #       protocol    = "tcp"
  #       cidr_blocks = ["192.0.5.0/24", "192.0.2.0/24"] # Only within VPC
  #     },
  #     # Node Exporter
  #     {
  #       description = "Node Exporter"
  #       from_port   = 9100
  #       to_port     = 9100
  #       protocol    = "tcp"
  #       cidr_blocks = ["192.0.5.0/24", "192.0.2.0/24"]
  #     }
  #   ]
  #   egress_rules = [
  #     {
  #       description = "Allow all outbound"
  #       from_port   = 0
  #       to_port     = 0
  #       protocol    = "-1"
  #       cidr_blocks = ["0.0.0.0/0"]
  #     }
  #   ]
  # }
}