# AWS Transit Gateway (TGW) Project - Public Subnet Setup

## 📌 Overview

This project demonstrates how to connect two Amazon VPCs using an **AWS Transit Gateway (TGW)**. Both VPCs contain EC2 instances running in **public subnets**, allowing direct SSH access and ping testing over the TGW backbone.

---

## 🏗️ Architecture

| Component        | Details                                                                     |
| ---------------- | --------------------------------------------------------------------------- |
| VPC-A            | `10.0.0.0/16`                                                               |
| Public Subnet-A  | `10.0.1.0/24`                                                               |
| EC2 Instance     | EC2-A                                                                       |
| VPC-B            | `172.16.0.0/16`                                                             |
| Public Subnet-B  | `172.16.1.0/24`                                                             |
| EC2 Instance     | EC2-B                                                                       |
| Internet Gateway | Attached to both VPCs                                                       |
| Transit Gateway  | Central hub connecting both VPCs                                            |
| Routing          | VPC route tables forward traffic destined for the other VPC through the TGW |

---

## 🛠️ Step-by-Step Setup (AWS Console)

### Step 1: Create the VPCs and Public Subnets

1. Navigate to **VPC Dashboard → Your VPCs → Create VPC**.

2. Create **VPC-A**:

   * Name: `VPC-A`
   * CIDR: `10.0.0.0/16`

3. Create **VPC-B**:

   * Name: `VPC-B`
   * CIDR: `172.16.0.0/16`

4. Create one public subnet in each VPC:

| Subnet Name  | CIDR Block      |
| ------------ | --------------- |
| VPC-A-Public | `10.0.1.0/24`   |
| VPC-B-Public | `172.16.1.0/24` |

> **Note:** Ensure **Auto-assign Public IPv4 Address** is enabled for both subnets.

---

### Step 2: Configure Internet Access

#### Create Internet Gateways

Create and attach Internet Gateways to each VPC:

| Internet Gateway | Attached VPC |
| ---------------- | ------------ |
| IGW-A            | VPC-A        |
| IGW-B            | VPC-B        |

#### Create Public Route Tables

Create the following route tables:

| Route Table | VPC   |
| ----------- | ----- |
| RT-A-Public | VPC-A |
| RT-B-Public | VPC-B |

Add the following routes:

| Destination | Target |
| ----------- | ------ |
| `0.0.0.0/0` | IGW-A  |
| `0.0.0.0/0` | IGW-B  |

Associate the route tables with their respective public subnets.

---

### Step 3: Create the Transit Gateway

1. Navigate to **VPC Dashboard → Transit Gateways**.
2. Click **Create Transit Gateway**.
3. Configure:

| Parameter       | Value             |
| --------------- | ----------------- |
| Name            | `My-TGW`          |
| Amazon Side ASN | `64512` (Default) |

4. Leave all remaining settings as default.
5. Click **Create**.

---

### Step 4: Attach VPCs to the Transit Gateway

Navigate to **Transit Gateway Attachments → Create Attachment**.

#### Attachment 1

| Parameter | Value          |
| --------- | -------------- |
| Name      | `Attach-VPC-A` |
| VPC       | `VPC-A`        |
| Subnet    | `10.0.1.0/24`  |

#### Attachment 2

| Parameter | Value           |
| --------- | --------------- |
| Name      | `Attach-VPC-B`  |
| VPC       | `VPC-B`         |
| Subnet    | `172.16.1.0/24` |

---

### Step 5: Configure Routing

#### Transit Gateway Route Table

1. Open the Transit Gateway Route Table.
2. Navigate to **Propagations**.
3. Enable propagation for:

   * `Attach-VPC-A`
   * `Attach-VPC-B`

This automatically learns the CIDR blocks from both VPCs.

#### VPC-A Route Table

Add:

| Destination     | Target |
| --------------- | ------ |
| `172.16.0.0/16` | My-TGW |

#### VPC-B Route Table

Add:

| Destination   | Target |
| ------------- | ------ |
| `10.0.0.0/16` | My-TGW |

---

### Step 6: Launch EC2 Instances

#### EC2-A

| Setting        | Value        |
| -------------- | ------------ |
| Name           | EC2-A        |
| VPC            | VPC-A        |
| Subnet         | VPC-A-Public |
| Public IP      | Enabled      |
| Security Group | SG-A         |
| Key Pair       | tgw-key.pem  |

**Inbound Rules (SG-A)**

| Type            | Source                 |
| --------------- | ---------------------- |
| SSH (22)        | `0.0.0.0/0` or Your IP |
| All ICMP - IPv4 | `172.16.0.0/16`        |

---

#### EC2-B

| Setting        | Value        |
| -------------- | ------------ |
| Name           | EC2-B        |
| VPC            | VPC-B        |
| Subnet         | VPC-B-Public |
| Public IP      | Enabled      |
| Security Group | SG-B         |
| Key Pair       | tgw-key.pem  |

**Inbound Rules (SG-B)**

| Type            | Source                 |
| --------------- | ---------------------- |
| SSH (22)        | `0.0.0.0/0` or Your IP |
| All ICMP - IPv4 | `10.0.0.0/16`          |

---

## ✅ Testing Connectivity

### Obtain Public IP Addresses

Navigate to:

```text
EC2 Dashboard → Instances
```

Record the public IPv4 addresses of:

* EC2-A
* EC2-B

---

### SSH into EC2-A

```bash
chmod 400 tgw-key.pem

ssh -i tgw-key.pem ec2-user@<PUBLIC-IP-OF-EC2-A>
```

---

### Ping EC2-B from EC2-A

After connecting to EC2-A, obtain the private IP address of EC2-B and run:

```bash
ping <PRIVATE-IP-OF-EC2-B>
```

### Expected Result

```text
64 bytes from 172.16.1.x: icmp_seq=1 ttl=127 time=...
```

Successful ICMP replies confirm that the Transit Gateway is routing traffic between VPC-A and VPC-B.

---

## 🔍 Route Flow Verification

Traffic Path:

```text
EC2-A
  ↓
VPC-A Route Table
  ↓
Transit Gateway
  ↓
VPC-B Route Table
  ↓
EC2-B
```

Even though both instances have public IP addresses and internet access, communication between the two VPCs uses the Transit Gateway because the route tables explicitly direct traffic destined for the remote VPC CIDR through the TGW.

---

## 💡 Security Group Troubleshooting

If ping requests fail:

### Verify SG-B

Ensure the following inbound rule exists:

| Type            | Source        |
| --------------- | ------------- |
| All ICMP - IPv4 | `10.0.0.0/16` |

### Verify SG-A (for bidirectional testing)

Ensure the following inbound rule exists:

| Type            | Source          |
| --------------- | --------------- |
| All ICMP - IPv4 | `172.16.0.0/16` |

---

## 🧹 Cleanup (Avoid Unnecessary Charges)

Delete resources in the following order:

1. Terminate:

   * EC2-A
   * EC2-B

2. Delete TGW Attachments:

   * Attach-VPC-A
   * Attach-VPC-B

3. Delete Transit Gateway:

   * My-TGW

4. Delete VPCs:

   * VPC-A
   * VPC-B

   This automatically removes:

   * Subnets
   * Internet Gateways
   * Route Tables

5. Delete the EC2 Key Pair (Optional):

   * `tgw-key.pem`

---

## 📝 Key Takeaway

AWS Transit Gateway acts as a centralized router that simplifies connectivity between multiple VPCs. In this project:

* Two VPCs were connected using a single TGW.
* Public subnet EC2 instances communicated using private IP addresses.
* Route tables directed inter-VPC traffic through the TGW.
* Communication remained within the AWS network backbone and did not traverse the public internet.

This architecture is scalable and forms the foundation for hub-and-spoke network designs commonly used in enterprise AWS environments.
