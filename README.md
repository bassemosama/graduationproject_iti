# DevOps Final Hands-On Project

## 📋 Project Overview

This project demonstrates a complete end-to-end DevOps pipeline implementing Infrastructure as Code (IaC), Continuous Integration/Continuous Deployment (CI/CD), and GitOps practices on AWS. The application is a Node.js web service that connects to MySQL and Redis databases, deployed on Amazon EKS (Elastic Kubernetes Service).
![Description of image](https://drive.google.com/uc?export=view&id=1INkL2Hs1obu0YGARZS_wuJEmPo2o00uh)

### Key Features

- **Infrastructure as Code**: Complete AWS infrastructure provisioned using Terraform
- **Container Orchestration**: Kubernetes-based deployment on Amazon EKS
- **CI/CD Pipeline**: Automated build and deployment using Jenkins
- **GitOps**: ArgoCD for declarative continuous deployment
- **Database Management**: MySQL Operator for database provisioning
- **Caching Layer**: Redis for application caching
- **Package Management**: Helm charts for Kubernetes resource management
- **Container Registry**: Amazon ECR for Docker image storage
- **Secure Image Building**: Kaniko for building container images without Docker daemon

### Technology Stack

| Category | Technologies |
|----------|-------------|
| **Cloud Provider** | AWS (EKS, ECR, VPC, S3, DynamoDB) |
| **Infrastructure** | Terraform, AWS EKS, VPC, NAT Gateway, Internet Gateway |
| **Container Orchestration** | Kubernetes, Helm |
| **CI/CD** | Jenkins, Kaniko, ArgoCD, ArgoCD Image Updater |
| **Application** | Node.js, Express.js |
| **Databases** | MySQL (with MySQL Operator), Redis |
| **Version Control** | Git, GitHub |
| **Monitoring** | EKS Add-ons (VPC CNI, CoreDNS, Kube-proxy, EBS CSI Driver) |

---

## 🏗️ Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                   AWS Cloud                                  │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                              VPC (10.0.0.0/16)                         │ │
│  │                                                                        │ │
│  │  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐   │ │
│  │  │  Public Subnet   │  │  Public Subnet   │  │  Public Subnet   │   │ │
│  │  │   (us-east-1a)   │  │   (us-east-1b)   │  │   (us-east-1c)   │   │ │
│  │  │  10.0.0.0/24     │  │  10.0.2.0/24     │  │  10.0.4.0/24     │   │ │
│  │  │                  │  │                  │  │                  │   │ │
│  │  │  ┌────────────┐  │  │  ┌────────────┐  │  │  ┌────────────┐  │   │ │
│  │  │  │ NAT Gateway│  │  │  │ NAT Gateway│  │  │  │ NAT Gateway│  │   │ │
│  │  │  └────────────┘  │  │  └────────────┘  │  │  └────────────┘  │   │ │
│  │  └──────────────────┘  └──────────────────┘  └──────────────────┘   │ │
│  │           │                     │                     │              │ │
│  │  ┌────────▼─────────┐  ┌────────▼─────────┐  ┌────────▼─────────┐   │ │
│  │  │ Private Subnet   │  │ Private Subnet   │  │ Private Subnet   │   │ │
│  │  │  (us-east-1a)    │  │  (us-east-1b)    │  │  (us-east-1c)    │   │ │
│  │  │  10.0.1.0/24     │  │  10.0.3.0/24     │  │  10.0.5.0/24     │   │ │
│  │  │                  │  │                  │  │                  │   │ │
│  │  │ ┌──────────────┐ │  │ ┌──────────────┐ │  │ ┌──────────────┐ │   │ │
│  │  │ │  EKS Nodes   │ │  │ │  EKS Nodes   │ │  │ │  EKS Nodes   │ │   │ │
│  │  │ │              │ │  │ │              │ │  │ │              │ │   │ │
│  │  │ │ ┌──────────┐ │ │  │ │ ┌──────────┐ │ │  │ │ ┌──────────┐ │ │   │ │
│  │  │ │ │ Jenkins  │ │ │  │ │ │ Node App │ │ │  │ │ │  MySQL   │ │ │   │ │
│  │  │ │ │  Pods    │ │ │  │ │ │   Pods   │ │ │  │ │ │ Operator │ │ │   │ │
│  │  │ │ └──────────┘ │ │  │ │ └──────────┘ │ │  │ │ └──────────┘ │ │   │ │
│  │  │ │ ┌──────────┐ │ │  │ │ ┌──────────┐ │ │  │ │ ┌──────────┐ │ │   │ │
│  │  │ │ │  ArgoCD  │ │ │  │ │ │  Redis   │ │ │  │ │ │  MySQL   │ │ │   │ │
│  │  │ │ │   Pods   │ │ │  │ │ │   Pods   │ │ │  │ │ │   Pods   │ │ │   │ │
│  │  │ │ └──────────┘ │ │  │ │ └──────────┘ │ │  │ │ └──────────┘ │ │   │ │
│  │  │ └──────────────┘ │  │ └──────────────┘ │  │ └──────────────┘ │   │ │
│  │  └──────────────────┘  └──────────────────┘  └──────────────────┘   │ │
│  │                                                                        │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  ┌────────────────┐         ┌─────────────────┐                            │
│  │   Amazon ECR   │         │   Amazon S3     │                            │
│  │ (Image Repo)   │         │ (TF State)      │                            │
│  └────────────────┘         └─────────────────┘                            │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ GitHub Webhook
                                    ▼
                          ┌──────────────────┐
                          │  GitHub Repo     │
                          │  (Source Code)   │
                          └──────────────────┘
```

### Architecture Components

1. **VPC Infrastructure**: Multi-AZ deployment with public and private subnets across 3 availability zones
2. **EKS Cluster**: Managed Kubernetes cluster running in private subnets
3. **Jenkins**: CI/CD automation server running as pods in EKS
4. **ArgoCD**: GitOps continuous delivery tool for Kubernetes
5. **Application Pods**: Node.js application with MySQL and Redis connectivity
6. **Databases**: MySQL managed by MySQL Operator, Redis for caching
7. **ECR**: Private container registry for Docker images
8. **S3 + DynamoDB**: Terraform state management with locking

---

## 🚀 Setup Instructions

### Prerequisites

Before starting, ensure you have the following installed and configured:

- **AWS CLI** (v2.x or higher) - [Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- **Terraform** (v1.9 or higher) - [Installation Guide](https://developer.hashicorp.com/terraform/install)
- **kubectl** (v1.28 or higher) - [Installation Guide](https://kubernetes.io/docs/tasks/tools/)
- **Helm** (v3.x or higher) - [Installation Guide](https://helm.sh/docs/intro/install/)
- **Git** - [Installation Guide](https://git-scm.com/downloads)
- **AWS Account** with appropriate permissions
- **GitHub Account** for repository hosting

### AWS Credentials Configuration

```bash
# Configure AWS credentials
aws configure
# Enter your AWS Access Key ID, Secret Access Key, and default region (us-east-1)
```

### Step 1: Clone the Repository

```bash
git clone https://github.com/your-username/graduationproject_iti.git
cd graduationproject_iti
```

### Step 2: Prepare Terraform Backend

Before running Terraform, create the S3 bucket and DynamoDB table for state management:

```bash
# Create S3 bucket for Terraform state
aws s3api create-bucket \
  --bucket iti-tf-state-remote-bucket \
  --region us-east-1

# Enable versioning on the bucket
aws s3api put-bucket-versioning \
  --bucket iti-tf-state-remote-bucket \
  --versioning-configuration Status=Enabled

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

### Step 3: Deploy Infrastructure with Terraform

```bash
cd terraform

# Initialize Terraform
terraform init

# Review the execution plan
terraform plan

# Apply the configuration (this will take 15-20 minutes)
terraform apply -auto-approve
```

**What gets created:**
- VPC with public and private subnets across 3 AZs
- Internet Gateway and NAT Gateways
- EKS Cluster with managed node groups
- ECR repository for Docker images
- IAM roles and policies for EKS and Jenkins
- EKS add-ons (VPC CNI, CoreDNS, Kube-proxy, EBS CSI Driver, Pod Identity Agent)
- Jenkins installation via Helm

### Step 4: Configure kubectl for EKS

```bash
# Update kubeconfig to access the EKS cluster
aws eks update-kubeconfig --name my-eks-cluster --region us-east-1

# Verify cluster access
kubectl get nodes
kubectl get pods -A
```

### Step 5: Configure Jenkins Pod Identity

After Terraform completes, configure the Jenkins service account with Pod Identity:

```bash
# Get the Jenkins IAM role ARN from Terraform output
JENKINS_ROLE_ARN=$(terraform output -raw jenkins_role_arn_exposed)

# Create EKS Pod Identity Association
aws eks create-pod-identity-association \
  --cluster-name my-eks-cluster \
  --namespace default \
  --service-account jenkins \
  --role-arn $JENKINS_ROLE_ARN \
  --region us-east-1
```

### Step 6: Access Jenkins

```bash
# Get Jenkins LoadBalancer URL
kubectl get svc -n default | grep jenkins

# Get Jenkins admin password
kubectl get secret jenkins -n default -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
```

**Default Credentials:**
- Username: `admin`
- Password: `password` (or retrieve from secret above)

### Step 7: Install MySQL Operator

```bash
# Add MySQL Operator Helm repository
helm repo add mysql-operator https://mysql.github.io/mysql-operator/
helm repo update

# Install MySQL Operator
helm install mysql-operator mysql-operator/mysql-operator --namespace mysql-operator --create-namespace

# Deploy MySQL Cluster
kubectl apply -f mysql-values.yaml -n mysql-operator
```

### Step 8: Install ArgoCD

```bash
# Create ArgoCD namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Install ArgoCD Image Updater
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# Get ArgoCD admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode

# Port-forward to access ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Access ArgoCD at: `https://localhost:8080`
- Username: `admin`
- Password: (from command above)

### Step 9: Configure Git Credentials for ArgoCD

Create a secret for ArgoCD Image Updater to write back to Git:

```bash
# Create Git credentials secret
kubectl create secret generic git-creds \
  --from-literal=username=your-github-username \
  --from-literal=password=your-github-token \
  -n argocd
```

### Step 10: Deploy Application with ArgoCD

```bash
# Apply ArgoCD Application manifest
kubectl apply -f argocd.yaml

# Verify application deployment
kubectl get applications -n argocd
kubectl get pods -n default
```

### Step 11: Configure Jenkins Pipelines

1. Access Jenkins UI using the LoadBalancer URL
2. Create two Pipeline jobs:
   - **terraform-pipeline**: For infrastructure changes
   - **build-pipeline**: For application builds

3. Configure each pipeline:
   - **Source**: GitHub repository
   - **Script Path**:
     - `graduationproject_iti/jenkins/Jenkinsfile.terraform` (for terraform-pipeline)
     - `graduationproject_iti/jenkins/Jenkinsfile.build` (for build-pipeline)
   - **Trigger**: GitHub webhook (configure in GitHub repository settings)

### Step 12: Configure GitHub Webhook

1. Go to your GitHub repository → Settings → Webhooks
2. Add webhook:
   - **Payload URL**: `http://<JENKINS_URL>/github-webhook/`
   - **Content type**: `application/json`
   - **Events**: Just the push event
   - **Active**: ✓

---

## 🔄 CI/CD Flow Explanation

### Overview

This project implements a complete GitOps workflow with automated CI/CD pipelines:

```
Developer Push → GitHub → Jenkins (Build) → ECR → ArgoCD Image Updater → ArgoCD → EKS
```

### Detailed CI/CD Pipeline Flow

#### 1. **Code Commit & Trigger**
```
Developer commits code → Push to GitHub → Webhook triggers Jenkins
```

#### 2. **Jenkins Build Pipeline** (`Jenkinsfile.build`)

**Trigger Condition**: Changes in `nodeapp/**` directory

**Pipeline Steps:**

1. **Checkout**: Jenkins pulls the latest code from GitHub
2. **Kaniko Build**:
   - Runs in a Kubernetes pod (no Docker daemon needed)
   - Builds Docker image from `dockerfile`
   - Tags image with incremental version: `v{BUILD_NUMBER + 50}`
3. **Push to ECR**:
   - Authenticates to AWS ECR using Pod Identity
   - Pushes image to: `662930028566.dkr.ecr.us-east-1.amazonaws.com/ourrepo:v{VERSION}`

**Key Features:**
- **Serverless Build**: Uses Kaniko (no Docker daemon required)
- **Kubernetes-native**: Runs as ephemeral pods in EKS
- **Secure**: Uses AWS Pod Identity for ECR authentication
- **Reproducible**: `--reproducible` flag ensures consistent image layers

<augment_code_snippet path="graduationproject_iti/jenkins/Jenkinsfile.build" mode="EXCERPT">
````groovy
stage('Build & Push Image with Kaniko') {
  when {
    changeset "nodeapp/**"
  }
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
...
````
</augment_code_snippet>

#### 3. **Jenkins Terraform Pipeline** (`Jenkinsfile.terraform`)

**Trigger Condition**: Changes in `terraform/**` directory

**Pipeline Steps:**

1. **Checkout**: Pull latest Terraform code
2. **Terraform Init**: Initialize Terraform with S3 backend
3. **Terraform Plan**: Generate and display execution plan
4. **Manual Approval**: (Optional) Wait for approval before apply

**Key Features:**
- **Infrastructure as Code**: All infrastructure changes version-controlled
- **State Management**: Remote state in S3 with DynamoDB locking
- **Change Detection**: Only runs when Terraform files change

<augment_code_snippet path="graduationproject_iti/jenkins/Jenkinsfile.terraform" mode="EXCERPT">
````groovy
stage('Terraform Init & Apply') {
  when {
    changeset "terraform/**"
  }
  agent {
    kubernetes {
      yaml """
...
````
</augment_code_snippet>

#### 4. **ArgoCD Image Updater**

**Automatic Image Detection:**

ArgoCD Image Updater continuously monitors ECR for new image tags:

- **Polling Interval**: Every 30 seconds
- **Tag Pattern**: `regexp:^v[0-9]+$` (matches v1, v2, v100, etc.)
- **Update Strategy**: `newest-tag` (always deploys the latest version)

**When a new image is detected:**

1. Updates `helm-chart/.argocd-source-myapp.yaml` with new tag
2. Commits changes back to Git repository
3. Triggers ArgoCD sync

<augment_code_snippet path="graduationproject_iti/argocd.yaml" mode="EXCERPT">
````yaml
annotations:
  argocd-image-updater.argoproj.io/app.allow-tags: "regexp:^v[0-9]+$"
  argocd-image-updater.argoproj.io/app.update-strategy: "newest-tag"
  argocd-image-updater.argoproj.io/update-interval: "30s"
...
````
</augment_code_snippet>

#### 5. **ArgoCD Continuous Deployment**

**GitOps Principles:**

- **Declarative**: Desired state defined in Git
- **Automated**: Auto-sync enabled with self-healing
- **Auditable**: All changes tracked in Git history

**Sync Policy:**

```yaml
syncPolicy:
  automated:
    prune: true        # Remove resources not in Git
    selfHeal: true     # Revert manual changes
```

**Deployment Process:**

1. ArgoCD detects changes in Git (from Image Updater or manual commits)
2. Compares desired state (Git) vs actual state (Kubernetes)
3. Applies changes to EKS cluster
4. Monitors health of deployed resources
5. Reports sync status

<augment_code_snippet path="graduationproject_iti/argocd.yaml" mode="EXCERPT">
````yaml
spec:
  project: default
  source:
    repoURL: 'https://github.com/bassemosama/graduationproject_iti.git'
    targetRevision: HEAD
    path: 'helm-chart'
...
````
</augment_code_snippet>

#### 6. **Application Deployment**

**Helm Chart Structure:**

The application is deployed using Helm with the following components:

- **Node.js Application**: 2 replicas with resource limits
- **Redis**: Single replica for caching
- **ConfigMap**: Database and Redis connection details
- **Secret**: Database credentials
- **Service**: ClusterIP service for internal communication

**Environment Variables Injection:**

```yaml
envFrom:
  - configMapRef:
      name: mysql-config
  - secretRef:
      name: mysql-secret
```

### CI/CD Pipeline Diagram

```
┌──────────────┐
│  Developer   │
│  Git Push    │
└──────┬───────┘
       │
       ▼
┌──────────────────────────────────────────────────────────────┐
│                      GitHub Repository                        │
│  ┌────────────────┐              ┌────────────────┐          │
│  │  Application   │              │  Terraform     │          │
│  │  Code (nodeapp)│              │  Code          │          │
│  └────────────────┘              └────────────────┘          │
└───────┬──────────────────────────────────┬───────────────────┘
        │ Webhook                          │ Webhook
        ▼                                  ▼
┌────────────────────┐          ┌────────────────────┐
│  Jenkins Pipeline  │          │  Jenkins Pipeline  │
│  (Build)           │          │  (Terraform)       │
│                    │          │                    │
│  ┌──────────────┐  │          │  ┌──────────────┐  │
│  │ Kaniko Pod   │  │          │  │ Terraform    │  │
│  │ - Build Image│  │          │  │ - Init       │  │
│  │ - Tag Image  │  │          │  │ - Plan       │  │
│  │ - Push to ECR│  │          │  │ - Apply      │  │
│  └──────────────┘  │          │  └──────────────┘  │
└─────────┬──────────┘          └─────────┬──────────┘
          │                               │
          ▼                               ▼
    ┌──────────┐                   ┌──────────────┐
    │ AWS ECR  │                   │ AWS EKS      │
    │ (Images) │                   │ (Infra)      │
    └────┬─────┘                   └──────────────┘
         │
         │ Poll every 30s
         ▼
┌─────────────────────┐
│ ArgoCD Image        │
│ Updater             │
│ - Detect new image  │
│ - Update Git        │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────────────────┐
│  Git Repository (Updated)       │
│  helm-chart/.argocd-source-*.yaml│
└──────────┬──────────────────────┘
           │
           │ Detect change
           ▼
┌─────────────────────┐
│     ArgoCD          │
│  - Sync Git → K8s   │
│  - Deploy Helm      │
│  - Monitor Health   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────────────────┐
│      EKS Cluster                │
│  ┌────────────┐  ┌────────────┐ │
│  │  App Pods  │  │ Redis Pods │ │
│  └────────────┘  └────────────┘ │
│  ┌────────────┐                 │
│  │ MySQL Pods │                 │
│  └────────────┘                 │
└─────────────────────────────────┘
```

### Pipeline Execution Flow

1. **Developer Workflow:**
   ```bash
   git add .
   git commit -m "Update application"
   git push origin main
   ```

2. **Automated Build (if nodeapp changed):**
   - Jenkins detects changes via webhook
   - Spins up Kaniko pod in EKS
   - Builds image and pushes to ECR with new tag (e.g., v101)
   - Pod terminates after completion

3. **Automated Image Update:**
   - ArgoCD Image Updater polls ECR every 30 seconds
   - Detects new tag v101
   - Updates `helm-chart/.argocd-source-myapp.yaml`
   - Commits change to Git

4. **Automated Deployment:**
   - ArgoCD detects Git change
   - Syncs Helm chart with new image tag
   - Performs rolling update of application pods
   - Monitors deployment health

5. **Infrastructure Updates (if terraform changed):**
   - Jenkins Terraform pipeline triggers
   - Runs `terraform plan` to show changes
   - Applies infrastructure changes
   - Updates EKS cluster configuration

---

## 📁 Project Structure

```
graduationproject_iti/
├── nodeapp/                      # Node.js application source code
│   ├── app.js                    # Express.js application with MySQL & Redis
│   └── package.json              # Node.js dependencies
│
├── terraform/                    # Infrastructure as Code
│   ├── main.tf                   # Main Terraform configuration
│   ├── variables.tf              # Input variables
│   ├── terraform.tfvars          # Variable values
│   ├── provider.tf               # AWS provider & S3 backend config
│   ├── output.tf                 # Output values
│   ├── vpc/                      # VPC module
│   ├── publicsubnets/            # Public subnet module
│   ├── privatesubnets/           # Private subnet module
│   ├── igw/                      # Internet Gateway module
│   ├── natgw/                    # NAT Gateway module
│   ├── publicroutetable/         # Public route table module
│   ├── privateroutetable/        # Private route table module
│   ├── publictableasso/          # Public subnet associations
│   ├── privatetableasso/         # Private subnet associations
│   ├── ekscluster/               # EKS cluster module
│   ├── nodegrp/                  # EKS node group module
│   ├── ecr/                      # ECR repository module
│   ├── eks-addons/               # EKS add-ons module
│   ├── jenkins/                  # Jenkins IAM roles module
│   └── secretmanager/            # AWS Secrets Manager module
│
├── jenkins/                      # Jenkins pipeline definitions
│   ├── Jenkinsfile.build         # Build pipeline (Kaniko)
│   ├── Jenkinsfile.terraform     # Terraform pipeline
│   └── values.yaml               # Jenkins Helm values
│
├── helm-chart/                   # Helm chart for application
│   ├── Chart.yaml                # Chart metadata
│   ├── values.yaml               # Default values
│   ├── templates/                # Kubernetes manifests templates
│   │   ├── app.yaml              # Application deployment & service
│   │   ├── redis.yaml            # Redis deployment & service
│   │   ├── configmap.yaml        # Configuration data
│   │   ├── secret.yaml           # Sensitive data
│   │   └── _helpers.tpl          # Template helpers
│   └── .argocd-source-myapp.yaml # ArgoCD Image Updater state
│
├── k8s-manifests/                # Plain Kubernetes manifests (alternative)
│   ├── app.yaml                  # Application deployment
│   ├── redis.yaml                # Redis deployment
│   ├── cm.yaml                   # ConfigMap
│   ├── secrets.yaml              # Secrets
│   └── ingress-nginx.yaml        # Ingress controller
│
├── argocd.yaml                   # ArgoCD Application definition
├── mysql-values.yaml             # MySQL Operator configuration
├── dockerfile                    # Docker image definition
└── README.md                     # This file
```

---

## 🔧 Configuration Details

### Application Configuration

**Database Connection:**
- Host: `db-cluster.mysql-operator.svc.cluster.local`
- Port: `6450`
- User: `root`
- Password: `pass123`

**Redis Connection:**
- Host: `redis-service`
- Port: `6379`

### Resource Limits

**Application Pods:**
```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "500m"
    memory: "512Mi"
```

**Redis Pods:**
```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "200m"
    memory: "256Mi"
```

### Network Configuration

**VPC CIDR:** `10.0.0.0/16`

**Subnets:**
- Public Subnets: `10.0.0.0/24`, `10.0.2.0/24`, `10.0.4.0/24`
- Private Subnets: `10.0.1.0/24`, `10.0.3.0/24`, `10.0.5.0/24`

**Availability Zones:** `us-east-1a`, `us-east-1b`, `us-east-1c`

---

## 🧪 Testing the Application

### Test Database Connectivity

```bash
# Get application pod name
APP_POD=$(kubectl get pods -l app=app -o jsonpath='{.items[0].metadata.name}')

# Test MySQL connection
kubectl exec -it $APP_POD -- curl http://localhost:3000/db

# Expected output: "db connection successful"
```

### Test Redis Connectivity

```bash
# Test Redis connection
kubectl exec -it $APP_POD -- curl http://localhost:3000/redis

# Expected output: "redis is successfully connected"
```

### Access Application

```bash
# Port-forward to access application locally
kubectl port-forward svc/app-service 3000:3000

# Test endpoints
curl http://localhost:3000/db
curl http://localhost:3000/redis
```

---

## 🔍 Monitoring and Troubleshooting

### Check Pod Status

```bash
# View all pods
kubectl get pods -A

# Check application pods
kubectl get pods -l app=app

# View pod logs
kubectl logs -f <pod-name>
```

### Check ArgoCD Application Status

```bash
# List ArgoCD applications
kubectl get applications -n argocd

# Describe application
kubectl describe application myapp -n argocd

# View sync status
argocd app get myapp
```

### Check Jenkins Pipeline Status

```bash
# View Jenkins pods
kubectl get pods -l app.kubernetes.io/component=jenkins-controller

# View Jenkins logs
kubectl logs -f <jenkins-pod-name>
```

### Common Issues and Solutions

**Issue: Pods stuck in Pending state**
```bash
# Check node resources
kubectl describe nodes

# Check pod events
kubectl describe pod <pod-name>
```

**Issue: Image pull errors**
```bash
# Verify ECR authentication
aws ecr get-login-password --region us-east-1

# Check image exists in ECR
aws ecr describe-images --repository-name ourrepo --region us-east-1
```

**Issue: ArgoCD not syncing**
```bash
# Force sync
argocd app sync myapp

# Check ArgoCD Image Updater logs
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-image-updater
```

---

## 🧹 Cleanup

To destroy all resources and avoid AWS charges:

```bash
# Delete ArgoCD application
kubectl delete -f argocd.yaml

# Delete ArgoCD
kubectl delete namespace argocd

# Delete MySQL Operator
helm uninstall mysql-operator -n mysql-operator
kubectl delete namespace mysql-operator

# Destroy Terraform infrastructure
cd terraform
terraform destroy -auto-approve

# Delete S3 bucket (remove all objects first)
aws s3 rm s3://iti-tf-state-remote-bucket --recursive
aws s3api delete-bucket --bucket iti-tf-state-remote-bucket --region us-east-1

# Delete DynamoDB table
aws dynamodb delete-table --table-name terraform-locks --region us-east-1
```

---

## 📚 Additional Resources

- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Jenkins on Kubernetes](https://www.jenkins.io/doc/book/installing/kubernetes/)
- [Helm Documentation](https://helm.sh/docs/)
- [MySQL Operator](https://github.com/mysql/mysql-operator)
- [Kaniko Documentation](https://github.com/GoogleContainerTools/kaniko)

---

## 👥 Contributors

- **Project Team**: ITI DevOps Final Project

---

## 📄 License

This project is created for educational purposes as part of the ITI DevOps training program.

---

## 🎯 Key Takeaways

This project demonstrates:

✅ **Infrastructure as Code** - Complete AWS infrastructure managed with Terraform
✅ **Container Orchestration** - Kubernetes deployment on managed EKS
✅ **CI/CD Automation** - Jenkins pipelines for build and infrastructure
✅ **GitOps** - ArgoCD for declarative continuous deployment
✅ **Security Best Practices** - Pod Identity, private subnets, secrets management
✅ **High Availability** - Multi-AZ deployment with auto-scaling
✅ **Monitoring** - EKS add-ons and logging capabilities
✅ **Database Management** - MySQL Operator for stateful workloads

---

**Built with ❤️ for DevOps Excellence**


