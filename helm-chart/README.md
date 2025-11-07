# Node.js App Helm Chart

This Helm chart deploys a Node.js application with MySQL and Redis dependencies.

## Prerequisites

- Kubernetes cluster (EKS recommended)
- Helm 3.x
- nginx ingress controller installed in the cluster

## Installation

```bash
# Install the chart
helm install myapp ./helm-chart

# Install with custom values
helm install myapp ./helm-chart -f custom-values.yaml

# Install in a specific namespace
helm install myapp ./helm-chart --namespace myapp --create-namespace
```

## Uninstallation

```bash
helm uninstall myapp
```

## Configuration

Key configuration options in `values.yaml`:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `app.replicaCount` | Number of app replicas | `2` |
| `app.image.repository` | App container image | `662930028566.dkr.ecr.us-east-1.amazonaws.com/ourrepo` |
| `app.image.tag` | App image tag | `latest` |
| `redis.enabled` | Enable Redis deployment | `true` |
| `ingress.enabled` | Enable Ingress | `true` |
| `config.dbHostname` | MySQL hostname | `db-cluster.mysql-operator.svc.cluster.local` |
| `secrets.dbPassword` | MySQL password | `pass123` |

## Testing

After installation, test the endpoints:

```bash
# Get the Ingress address
kubectl get ingress -n default

# Test endpoints
curl http://<INGRESS-ADDRESS>/db
curl http://<INGRESS-ADDRESS>/redis
```

## Customization

Override values during installation:

```bash
helm install myapp ./helm-chart \
  --set app.replicaCount=3 \
  --set app.image.tag=v1.2.0 \
  --set secrets.dbPassword=newpassword
```
