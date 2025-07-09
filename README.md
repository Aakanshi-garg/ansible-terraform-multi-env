
# Multi-Environment Infrastructure with Terraform and Ansible

This DevOps project sets up a secure, scalable multi-environment infrastructure using Terraform for provisioning and Ansible for configuration management. It includes separate environments for development, staging, and production, following best practices in automation and modularity. A key feature is the use of a remote backend (S3 with DynamoDB locking) to securely manage Terraform state files, ensuring safe collaboration and preventing state conflicts. The setup also includes Nginx installation and static page deployment, showcasing a complete infrastructure-as-code workflow.

## Project overview
This Project involves:
- Installing Terraform and Ansible
- Setting up AWS infrastructure
- Creating dynamic inventories
- Configuring Nginx across multiple environments
- Automating infrastructure management
- Store Terraform state securely using remote-backend

## Project Diagram

![architecture](https://github.com/user-attachments/assets/cfc23cf7-1e4d-44f3-aae1-a59ca0a1275d)
## 1. Installing Terraform on Ubuntu

Follow the steps below to install the latest version of Terraform on an Ubuntu system:

### 1. Update the Package List

```bash
sudo apt-get update
```
2. Install Required Dependencies
```bash
sudo apt-get install -y gnupg software-properties-common
```
3. Add HashiCorp's GPG Key
```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg  
```
4. Add the HashiCorp Repository
```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg  
```
5. Install Terraform
```bash
sudo apt-get update && sudo apt-get install terraform
```
6. Verify the Installation
```bash
terraform --version
```

## 2. Setting Up Infrastructure Directory and Custom Terraform Modules

To ensure scalability, modularity, and environment isolation, this project follows a custom module structure using Terraform.

---

### 📁 Folder Structure

```bash
terraform-custom-modules/
├── infra-app/               # Custom reusable Terraform module
│   ├── s3.tf                # S3 bucket configuration per environment
│   ├── ec2.tf               # EC2 instance setup and security groups
│   ├── dynamodb.tf          # DynamoDB table for state locking
│   └── variables.tf         # Input variables for the module
├── main.tf                  # Root-level module calls for dev/staging/prod
├── terraform.tf             # Backend block for remote state management
├── providers.tf             # AWS provider and region configuration
├── .gitignore               # Ignored sensitive and generated files
├── remote-infra/            # One-time setup for remote backend infrastructure
│   ├── dynamodb.tf          # DynamoDB for state locking
│   ├── s3.tf                # S3 bucket for Terraform state files
│   ├── terraform.tf         # AWS provider & backend init
│   └── provider.tf          # Region configuration for backend
```
### Custom Module: infra-app/
This directory contains reusable Terraform modules used to provision cloud resources in each environment.

- [`s3.tf`](infra-app/s3.tf): Manages S3 bucket creation for each environment.

- [`ec2.tf`](infra-app/ec2.tf): Defines EC2 instances, root volumes, tags, and security groups.

- [`dynamodb.tf`](infra-app/dynamodb.tf): Creates DynamoDB table for state locking.

- [`variables.tf`](infra-app/variables.tf): Declares input variables used in the module.

### Root Configuration Files

At the root of `terraform-custom-modules`, create the following files:

- [`main.tf`](main.tf): Calls the `infra-app` module for `dev`, `staging`, and `prod` environments with appropriate variables.
- [`terraform.tf`](terraform.tf): Contains the backend configuration using **S3** and **DynamoDB** to securely store and lock Terraform state.
- [`providers.tf`](providers.tf): Specifies the AWS provider and region.

## Remote Backend Setup: `remote-infra/`

The `remote-infra` folder is responsible for provisioning the necessary resources for Terraform's **remote backend**. This ensures a centralized, secure, and collaborative way to manage state files across all environments.

Before deploying the main infrastructure modules, you must apply this setup **once** to initialize the backend.

### 📄 File Descriptions

- [`dynamodb.tf`](remote-infra/dynamodb.tf)  
  Provisions a **DynamoDB table** to handle state locking and consistency across multiple users and environments.

- [`s3.tf`](remote-infra/s3.tf)  
  Creates an **S3 bucket** to securely store the Terraform state file. This backend is shared across all environments (dev, staging, prod).

- [`terraform.tf`](remote-infra/terraform.tf)  
  Contains the **backend configuration** block for Terraform and the AWS provider setup required for backend deployment.

- [`provider.tf`](remote-infra/provider.tf)  
  Defines the **AWS region** where remote backend resources will be provisioned.

## How to Apply Remote Backend Setup

Run these commands inside the `remote-infra/` directory:

```bash
cd remote-infra/
``` 

### Initialize Terraform
```bash
terraform init
```

###  Review planned infrastructure
```bash
terraform plan
```

###  Apply changes to create backend resources
```bash
terraform apply
```

## Deploy Infrastructure Using Custom Modules

Once the remote backend is successfully set up, you can now deploy your environment-specific infrastructure using the `infra-app/` custom module.

This module encapsulates the provisioning logic for EC2 instances, S3 buckets, security groups, and DynamoDB tables across three separate environments: **Development**, **Staging**, and **Production**.

---

### 📄 Module Invocation in [`main.tf`](https://github.com/Aakanshi-garg/ansible-terraform-multi-env/blob/main/terraform-custom-modules/main.tf)


Each environment is declared using a separate `module` block in `main.tf`, enabling reusable and scalable infrastructure code.

Follow the steps below to deploy your infrastructure using Terraform:

#### 1. Navigate to the project root (where main.tf is located):
```bash
cd terraform-custom-modules/
```
#### 2. Initialize Terraform:
```bash
terraform init
```
#### 3. Preview the changes:
```bash
terraform plan
```
#### 4. Apply the configuration:
```bash
terraform apply
```
Confirm the apply when prompted to provision resources.

1. Instances

![instances](https://github.com/user-attachments/assets/3a977495-8e05-4859-a5a2-66f8d5f41c19)


2. Buckets
![buckets](https://github.com/user-attachments/assets/3bb7de5c-b179-4130-b201-481cbefcdceb)

   

3. DynamoDB tables

![tables](https://github.com/user-attachments/assets/8a2f2286-194f-45cc-884f-3a218081e2ec)


## 3. Secure the Private Key
Before using the private key, ensure that it is securely encrypted by setting proper permissions. This prevents other users from accessing it. Run the following command to restrict the access:
```bash
chmod 400 infra-key  # Set read-only permissions for the owner to ensure security
```
This command ensures that the private key (infra-key) is only readable by you, preventing others from accessing or modifying it.

## 4. Access EC2 Instances
After provisioning, you can SSH into the EC2 instances using the generated infra-key:
```bash
ssh -i infra-key ubuntu@<your-ec2-ip>
```
---
Terraform steps done ,now going to setup with ansible
---
## 5. 🔧 Setting Up Ansible for Configuration Management

Once your development EC2 instance is up and running, you can configure it as your **Ansible control node** to manage all environments (dev, staging, prod) from a central point.

---

###  Step 1: Create the Ansible Working Directory

SSH into the **Dev environment EC2 instance** and create a dedicated folder for Ansible:

```bash
mkdir ansible
cd ansible
```
### Step 2: Install Ansible on the Control Node
Install Ansible using the official PPA:
```bash
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible
```

### Step 3: Configure the Ansible Inventory
Open the Ansible inventory file located at /etc/ansible/hosts:
``` bash
sudo vim /etc/ansible/hosts
```
Add the following inventory configuration, replacing the IPs with your actual public IPs from each environment:
```bash
[devserver]
dev-infra-instance ansible_host=3.133.159.129

[prodserver]
prod-infra-instance ansible_host=18.191.200.113
prod-infra-instance ansible_host=3.139.70.252

[stageserver]
staging-infra-instance ansible_host=18.221.54.18

[all:vars]
ansible_ssh_private_key_file = /home/ubuntu/ansible/infra-key
ansible_python_interpreter = /usr/bin/python3
ansible_user = ubuntu
```
📌 Note: Ensure the private key (infra-key) used during EC2 creation is copied to /home/ubuntu/ansible/ with correct permissions:
```bash
chmod 400 infra-key
```
### Step 4: Test Ansible Connectivity
To verify Ansible is correctly configured and can reach your servers, run the following command (for example, testing production group):
```bash
ansible prodserver -m ping
```
You should receive a ping response from all instances under the prodserver group.

![check connection from inv](https://github.com/user-attachments/assets/fee28951-22e1-46c6-8320-d8420aa3126a)

##  Deploying Static Web Pages with Ansible Playbooks

This section demonstrates how to automate the installation of **Nginx** and deploy a **static HTML page** across all environments (Dev, Staging, Prod) using Ansible.

---

### Step 1: Create a Directory for Ansible Playbooks

```bash
mkdir ~/ansible/playbooks
cd ~/ansible/playbooks
```
### step 2: Create a Playbook to Install Nginx
Create a file named install_nginx_play.yaml:
```bash
vim install_nginx_play.yaml
```
Add the following content:
```bash
---
- name: Install Nginx
  hosts: all
  become: yes
  tasks:
    - name: Install Nginx
      apt:
        name: nginx
        state: latest

    - name: Start and Enable Nginx
      service:
        name: nginx
        state: started
        enabled: yes
```
### Step 3: Create a Playbook to Deploy a Static Page
Create the deployment playbook:
```bash
vim deploy_static_page_play.yaml
```
Add the following content:
```bash
---
- name: Deploy Static Page via Nginx
  hosts: all
  become: yes
  tasks:
    - name: Include Nginx Installation
      import_tasks: tasks/install_nginx.yaml

    - name: Deploy Web Page
      copy:
        src: index.html
        dest: /var/www/html/
```
### Step 4: Create a tasks/ Directory and Move Nginx Installation Logic
Organize your tasks to improve readability and reusability:
```bash
mkdir tasks
vim tasks/install_nginx.yaml
```
Add the Nginx installation content:
```bash
---
- name: Install Nginx
  apt:
    name: nginx
    state: latest

- name: Start and Enable Nginx
  service:
    name: nginx
    state: started
    enabled: yes
```
📌 Note: The above file contains only tasks (no hosts, become, or name at the play level) because it is imported inside another playbook.

### step 5: Create the HTML File
```bash
vim index.html
```
Add any HTML content to test Nginx deployment

### step 6: Run the Playbooks
Run the Nginx installation playbook:
```bash
ansible-playbook install_nginx_play.yaml
```
![nginx-install](https://github.com/user-attachments/assets/951b96ac-ab6b-4294-b5f7-aba7654f1ab6)


Then deploy the static page:
```bash
ansible-playbook deploy_static_page_play.yaml
```
![deployed](https://github.com/user-attachments/assets/16e35e73-350c-4bdc-9f88-d44cd9f49989)


### Step 7: Verify the Deployment
Open a browser and access the public IPs of your EC2 instances in each environment:
```bash
http://<ec2-public-ip>
```
You should see the static web page successfully served via Nginx.
![final](https://github.com/user-attachments/assets/36753f0f-93e9-4479-9607-6b1f1c725340)


