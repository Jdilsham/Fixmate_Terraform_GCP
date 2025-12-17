# FixMate – GCP Infrastructure with Terraform

This repository contains the **Infrastructure as Code (IaC)** setup for **FixMate**, an on-demand home services platform.  
The infrastructure is provisioned on **Google Cloud Platform (GCP)** using **Terraform** and follows **production-style best practices**.

---

## 🏗️ Architecture Overview

The infrastructure includes:

- **Custom VPC** with secondary IP ranges
- **Google Kubernetes Engine (GKE)** cluster
- **Managed node pool with autoscaling**
- **Cloud SQL (PostgreSQL)** with **private IP**
- **Artifact Registry** for Docker images
- **IAM separation** for runtime and CI/CD
- Fully destroyable using `terraform destroy`

---

## 🧩 Components

### 1️⃣ Networking
- Custom VPC
- Private subnet
- Secondary ranges for:
  - Kubernetes Pods
  - Kubernetes Services
- Private Google Access enabled

### 2️⃣ GKE (Kubernetes)
- GKE cluster without default node pool
- Custom node pool:
  - `e2-medium` nodes
  - Autoscaling (min: 1, max: 2)
  - Custom service account
- Uses VPC-native (alias IP) networking

### 3️⃣ Cloud SQL
- PostgreSQL 15
- **Private IP only** (no public exposure)
- Connected via Service Networking
- Deletion protection disabled for clean teardown

### 4️⃣ IAM
- **GKE runtime service account**
  - Cloud SQL Client
  - Artifact Registry Reader
  - Logging & Monitoring
- **CI/CD service account**
  - Artifact Registry Writer
  - GKE deploy permissions

### 5️⃣ Artifact Registry
- Docker repository for container images
- Used by CI/CD pipelines (GitHub Actions / Jenkins)

---

## 📁 Project Structure

```text
.
├── versions.tf            # Terraform & provider versions
├── provider.tf            # GCP provider configuration
├── variables.tf           # Input variables
├── terraform.tfvars       # Environment values
├── servises.tf            # GCP APIs enablement
├── vpc.tf                 # VPC & subnet configuration
├── iam.tf                 # Service accounts & IAM roles
├── gke.tf                 # GKE cluster & node pool
├── cloudsql.tf            # Cloud SQL (PostgreSQL)
├── outputs.tf             # Useful outputs
└── README.md

```


## ⚙️ Prerequisites

- Terraform **>= 1.5**
- Google Cloud SDK (**gcloud**)
- A GCP project with **billing enabled**
- Required permissions:
  - **Project Owner**  
    **OR**
  - **IAM Admin + GKE Admin + Compute Admin**

---

## 🔐 Authentication

Authenticate Terraform with Google Cloud:

```bash
gcloud auth application-default login
```

---

## 🚀 How to Deploy

### 1️⃣ Initialize Terraform
```bash
terraform init
```
### 2️⃣ Validate configuration
```bash
terraform validate
```

### 3️⃣ Review the plan
```bash
terraform plan
```

### 4️⃣ Apply infrastructure
```bash
terraform apply
```

## 🧨 Destroy Infrastructure

### To delete all resources:
```bash
terraform destroy
```

---

### 📜 License

This project is for educational and academic purposes.