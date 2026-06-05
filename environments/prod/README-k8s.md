# Kubernetes Infrastructure on AWS using Terraform

## Overview

This project provisions a highly available AWS infrastructure for hosting a Kubernetes cluster using Terraform modules. The architecture follows a modular approach, enabling reusable and scalable infrastructure components.

The deployment includes:

* Custom VPC
* Public and Private Subnets across multiple Availability Zones
* Internet Gateway
* NAT Gateway
* Route Tables and Associations
* Security Groups
* EC2 Key Pair
* Bastion Host for administrative access
* Kubernetes Control Plane (Master Node)
* Kubernetes Worker Nodes
* Application Load Balancer (ALB)
* Target Group and Listener Configuration

---

## Architecture Components

### Networking Layer

#### VPC

A dedicated Virtual Private Cloud (VPC) is created as the foundational network layer. All infrastructure resources are deployed within this VPC.

#### Public Subnets

Public subnets are created across multiple Availability Zones and are used for:

* Bastion Host
* Application Load Balancer
* NAT Gateway

These subnets have direct internet access through the Internet Gateway.

#### Private Subnets

Private subnets are used for hosting Kubernetes nodes.

Resources inside these subnets do not have direct internet exposure and access external services through the NAT Gateway.

#### Internet Gateway (IGW)

An Internet Gateway is attached to the VPC to provide internet connectivity for public resources.

#### NAT Gateway

A NAT Gateway is deployed in the public subnet to allow outbound internet access for instances running in private subnets.

#### Route Tables

Separate route tables are configured:

* Public Route Table → Routes traffic through the Internet Gateway.
* Private Route Table → Routes outbound traffic through the NAT Gateway.

---

## Security Layer

### Security Groups

Security groups are dynamically created using Terraform's `for_each` capability.

Different security groups are provisioned for:

* Bastion Host
* Kubernetes Master Node
* Kubernetes Worker Nodes
* Application Load Balancer

Ingress rules are configurable through variables, allowing flexible access management.

---

## Access Layer

### Key Pair

A reusable EC2 Key Pair is created and attached to all EC2 instances for secure SSH access.

### Bastion Host

A Bastion Host is deployed in the public subnet and serves as the entry point for administrators to access resources inside private subnets.

Responsibilities:

* Secure SSH access
* Kubernetes administration
* Cluster troubleshooting

---

## Kubernetes Cluster

### Master Node

A dedicated Kubernetes Control Plane node is deployed in a private subnet.

Responsibilities:

* Cluster management
* Scheduling
* API Server
* Controller Manager
* ETCD

Features:

* Configurable instance type
* Custom bootstrap script
* Dedicated storage volume

### Worker Nodes

Multiple Kubernetes worker nodes are deployed in private subnets.

Responsibilities:

* Running application workloads
* Hosting Kubernetes Pods
* Processing cluster traffic

Features:

* Configurable instance types
* Automated node bootstrap
* Dedicated storage volumes

---

## Load Balancing Layer

### Application Load Balancer (ALB)

An internet-facing Application Load Balancer is deployed in public subnets.

Responsibilities:

* External traffic entry point
* HTTP request routing
* High availability across Availability Zones

### Target Group

A target group is created to forward traffic to Kubernetes worker nodes.

Configuration:

* Protocol: HTTP
* Port: 30080 (NodePort)

### Target Group Attachments

Worker nodes are automatically registered with the target group.

Benefits:

* Dynamic traffic distribution
* Health monitoring
* High availability

### Listener

An HTTP listener is configured on port 80.

Traffic Flow:

Internet → ALB → Target Group → Kubernetes Worker Nodes → NGINX Ingress Controller → Applications

---

## Deployment Flow

1. Create VPC.
2. Create Public and Private Subnets.
3. Attach Internet Gateway.
4. Deploy NAT Gateway.
5. Configure Route Tables.
6. Create Security Groups.
7. Generate EC2 Key Pair.
8. Deploy Bastion Host.
9. Deploy Kubernetes Master Node.
10. Deploy Kubernetes Worker Nodes.
11. Create Application Load Balancer.
12. Create Target Group.
13. Register Worker Nodes.
14. Create HTTP Listener.
15. Route external traffic to Kubernetes workloads.

---

## High-Level Architecture

```text
                    Internet
                        │
                        ▼
               Application Load Balancer
                        │
                        ▼
                Target Group (30080)
                        │
         ┌──────────────┴──────────────┐
         ▼                             ▼
    Worker Node 1                Worker Node 2
         │                             │
         └────────── Kubernetes ───────┘
                     Cluster
                         │
                         ▼
                    Master Node
                         │
                         ▼
                    Bastion Host
                         │
                         ▼
                      Admin

Public Subnets:
- ALB
- Bastion Host
- NAT Gateway

Private Subnets:
- Kubernetes Master
- Kubernetes Workers
```

## Key Design Principles

* Modular Terraform architecture
* Multi-AZ deployment
* Private Kubernetes cluster
* Secure administrative access through Bastion Host
* Internet-facing Application Load Balancer
* Reusable infrastructure modules
* Environment-based resource naming
* Centralized tagging strategy




# K8s-Installation
### Add master & worker node ip inside the /etc/hosts to resolve the dns
```bash
  sudo tee -a /etc/hosts << EOF
  <master-ip> master
  <worker1-ip> worker1
  <worker2-ip> worker2
  EOF
```

### Now run the kubedm init
```bash
    sudo kubeadm init --pod-network-cidr=192.168.0.0/16
```
### After initated kubeadm it will print the worner node join token like this
 ```bash
    kubeadm join 10.0.4.37:6443 --token 35n00v.1l7yzey03ydgdh6w \
        --discovery-token-ca-cert-hash sha256:b56784cd5f807e8238d8ea4e6371311cb52323b95f75ccc6aa342aa76554bbb5
 ```

### To start using your cluster, you need to run the following as a regular user,execute this below commands on master node:
```bash
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

  kubectl get nodes
    #Expected:
  output:- master   NotReady

```
Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf



# Install CNI
### Without CNI, workers will never become Ready.
I recommend Calico.
```bash
    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.3/manifests/calico.yaml
```

### Print token list
```bash
  sudo kubeadm token list
```
