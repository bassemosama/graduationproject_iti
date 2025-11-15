# Quick Start Guide

## Prerequisites Checklist

- [ ] AWS CLI installed and configured
- [ ] Terraform v1.9+ installed
- [ ] kubectl installed
- [ ] Helm v3+ installed
- [ ] Git installed
- [ ] AWS account with admin permissions
- [ ] GitHub account

## 5-Minute Setup

### 1. Prepare AWS Backend (One-time setup)

```bash
# Create S3 bucket for Terraform state
aws s3api create-bucket --bucket iti-tf-state-remote-bucket --region us-east-1
aws s3api put-bucket-versioning --bucket iti-tf-state-remote-bucket --versioning-configuration Status=Enabled

# Create DynamoDB table for state locking
aws dynamodb create-table --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST --region us-east-1
```

### 2. Deploy Infrastructure

```bash
cd terraform
terraform init
terraform apply -auto-approve  # Takes ~15-20 minutes
```

### 3. Configure kubectl

```bash
aws eks update-kubeconfig --name my-eks-cluster --region us-east-1
kubectl get nodes
```

### 4. Setup Jenkins Pod Identity

```bash
JENKINS_ROLE_ARN=$(terraform output -raw jenkins_role_arn_exposed)
aws eks create-pod-identity-association \
  --cluster-name my-eks-cluster \
  --namespace default \
  --service-account jenkins \
  --role-arn $JENKINS_ROLE_ARN \
  --region us-east-1
```

### 5. Install MySQL Operator

```bash
helm repo add mysql-operator https://mysql.github.io/mysql-operator/
helm install mysql-operator mysql-operator/mysql-operator --namespace mysql-operator --create-namespace
kubectl apply -f mysql-values.yaml -n mysql-operator
```

### 6. Install ArgoCD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml

# Create Git credentials for ArgoCD Image Updater
kubectl create secret generic git-creds \
  --from-literal=username=YOUR_GITHUB_USERNAME \
  --from-literal=password=YOUR_GITHUB_TOKEN \
  -n argocd
```

### 7. Deploy Application

```bash
kubectl apply -f argocd.yaml
```

### 8. Access Services

```bash
# Jenkins
kubectl get svc | grep jenkins
# Username: admin, Password: password

# ArgoCD
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode
kubectl port-forward svc/argocd-server -n argocd 8080:443
# Access: https://localhost:8080

# Application
kubectl port-forward svc/app-service 3000:3000
curl http://localhost:3000/db
curl http://localhost:3000/redis
```

## Common Commands

### Check Status
```bash
kubectl get pods -A                          # All pods
kubectl get applications -n argocd           # ArgoCD apps
kubectl logs -f <pod-name>                   # Pod logs
```

### Troubleshooting
```bash
kubectl describe pod <pod-name>              # Pod details
kubectl get events --sort-by='.lastTimestamp' # Recent events
argocd app sync myapp                        # Force ArgoCD sync
```

### Cleanup
```bash
kubectl delete -f argocd.yaml
kubectl delete namespace argocd
helm uninstall mysql-operator -n mysql-operator
cd terraform && terraform destroy -auto-approve
```

## Important URLs

- **Jenkins**: `http://<JENKINS_LB_URL>`
- **ArgoCD**: `https://localhost:8080` (after port-forward)
- **Application**: `http://localhost:3000` (after port-forward)

## Next Steps

1. Configure GitHub webhook for Jenkins
2. Push code changes to trigger CI/CD
3. Monitor ArgoCD for automatic deployments
4. Check application logs and metrics

For detailed documentation, see [README.md](README.md)

