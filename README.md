# 2-TIER CLOUD-BASED STUDENT MANAGEMENT SYSTEM USING TERRAFORM, FLASK & AZURE DEVOPS

---

## 📌 Overview
This project demonstrates the automated deployment of a scalable **Student Management System** using a **2-tier architecture on Microsoft Azure**, fully provisioned using **Terraform (Infrastructure as Code)** and deployed using an **Azure DevOps CI/CD pipeline with a self-hosted agent**.

The application layer is built using **Python Flask (Gunicorn)** and the database layer is hosted on **Azure Database for MySQL Flexible Server**.

---

## 🎯 Objective
- Automate infrastructure provisioning using Terraform  
- Deploy a 2-tier architecture (Application + Database)  
- Deploy Flask web application on Azure VM  
- Use Azure DevOps CI/CD pipeline for automation  
- Use self-hosted agent for execution control  
- Enable secure communication between VM and MySQL  

---

## 🏗️ Architecture

**Flow:**

User → Azure VM (Flask App) → Azure MySQL Flexible Server

### Components:
- Application Layer → Azure Linux VM  
- Database Layer → Azure MySQL Flexible Server  
- CI/CD Layer → Azure DevOps Pipeline + Self-hosted Agent  

---

## 🛠️ Technologies Used
- Python Flask  
- Gunicorn  
- PyMySQL  
- Terraform  
- Azure Virtual Machine  
- Azure MySQL Flexible Server  
- Azure DevOps  
- Ubuntu 22.04  
- Systemd  

---

## ☁️ Infrastructure (Terraform)

### Networking
- Virtual Network (VNet)  
- Subnet  
- Public IP  
- Network Interface  

### Compute
- Azure Linux VM (MyAppVM)  

### Database
- Azure MySQL Flexible Server  
- Database: `studentdb`  
- Firewall rules for VM access  

---

## 🔐 Security Configuration

### VM
- SSH (22) → Admin access  
- HTTP (5000) → Flask App  

### MySQL
- Port 3306 → Allowed only from VM  

---

## 🤖 Azure DevOps Self-Hosted Agent Setup

### 1. Install dependencies
```bash
sudo apt update -y
sudo apt install -y curl wget git unzip python3 python3-pip
2. Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az version
3. Download Agent
mkdir myagent && cd myagent

wget https://vstsagentpackage.azureedge.net/agent/3.238.0/vsts-agent-linux-x64-3.238.0.tar.gz

tar zxvf vsts-agent-linux-x64-3.238.0.tar.gz
4. Configure Agent
./config.sh

Provide:

Azure DevOps URL
PAT Token
Agent Pool: prasadpool
Agent Name: prasadagent
5. Run Agent as Service
sudo ./svc.sh install
sudo ./svc.sh start

⚙️ Terraform Installation
sudo apt update -y
sudo apt install -y unzip wget

wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
unzip terraform_1.6.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/

terraform -version

🚀 CI/CD Pipeline (Azure DevOps YAML)
azure-pipeline.yaml file

🌐 Application Execution
Run App
gunicorn -w 2 -b 0.0.0.0:5000 app:app
Access URL
http://<VM-PUBLIC-IP>:5000

📡 API Endpoints
Method	Endpoint	Description
GET	/api/students	Get all students
GET	/api/students/{id}	Get student
POST	/api/students	Add student
PUT	/api/students/{id}	Update student
DELETE	/api/students/{id}	Delete student

⚠️ Challenges Faced
Azure CLI missing in agent
Terraform authentication issues
Pipeline variable errors
Agent configuration issues
Flask deployment issues

✅ Solutions
Installed Azure CLI manually
Used service connection in pipeline
Fixed YAML and variable syntax
Configured self-hosted agent properly
Added systemd service for stability

🎉 Outcome
Fully automated CI/CD pipeline
Terraform-based infrastructure provisioning
Successful Flask deployment
Secure database connectivity
End-to-end DevOps automation achieved

📌 Conclusion

This project demonstrates real-world DevOps implementation using:

Terraform
Azure Cloud
Azure DevOps
Self-hosted Agent
Flask Application

It provides hands-on experience in cloud automation, CI/CD, and infrastructure provisioning.
