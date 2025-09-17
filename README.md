# 4Sale DevOps Platform

A robust, secure, and observable DevOps setup for scaling to millions of users.

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│    Frontend     │    │     Backend     │    │   PostgreSQL    │
│   (NGINX)       │◄──►│   (Node.js)     │◄──►│   Database      │
│   Port: 80      │    │   Port: 3000    │    │   Port: 5432    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 📁 Project Structure

```
├── app/                    # Application source code
│   ├── backend/           # Node.js API service
│   ├── frontend/          # NGINX static files
│   └── docker-compose.yml # Local development
├── infrastructure/        # Terraform/Terragrunt IaC
│   ├── modules/          # Reusable Terraform modules
│   ├── environments/     # Dev/Prod configurations
│   └── scripts/          # Automation scripts
├── k8s/                  # Kubernetes manifests
│   ├── helm/            # Helm charts
│   ├── manifests/       # Raw K8s manifests
│   └── policies/        # Security policies
├── .github/             # CI/CD pipelines
│   └── workflows/       # GitHub Actions
├── monitoring/          # Observability stack
│   ├── prometheus/      # Metrics collection
│   ├── grafana/        # Dashboards
│   └── jaeger/         # Distributed tracing
├── security/           # Security configurations
├── tests/              # Testing scripts
│   └── locust/        # Load testing
└── docs/              # Additional documentation
```

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- kubectl & helm
- Terraform >= 1.0
- AWS CLI configured
- Node.js 18+

### Local Development
```bash
# Clone and setup
git clone <repo-url>
cd code-quest

# Start local environment
docker-compose up -d

# Test endpoints
curl http://localhost:3000/api/tasks
```

### Infrastructure Deployment
```bash
# Deploy infrastructure
cd infrastructure/environments/dev
terraform init
terraform plan
terraform apply

# Deploy application
cd ../../../k8s/helm
helm install foursale-app ./foursale-chartcd 
```

## 🔧 Technology Stack

| Component | Technology | Justification |
|-----------|------------|---------------|
| **Cloud** | AWS EKS | Managed Kubernetes, auto-scaling, AWS integration |
| **IaC** | Terraform | Declarative, state management, AWS provider maturity |
| **CI/CD** | GitHub Actions | Native Git integration, free for public repos |
| **Container** | Docker | Industry standard, lightweight |
| **Database** | PostgreSQL | ACID compliance, JSON support, performance |
| **Monitoring** | Prometheus/Grafana | Cloud-native, extensive ecosystem |
| **Security** | Trivy, RBAC, PSA | Multi-layer security approach |

## 🛡️ Security Implementation

### Access Control
- **RBAC**: Role-based access control for K8s resources
- **PSA**: Pod Security Admission standards (restricted profile)
- **Network Policies**: Database access restricted to app namespace only

### DDoS Protection & WAF
- **AWS WAF**: Layer 7 protection with rate limiting
- **CloudFront**: CDN with DDoS protection
- **Security Groups**: Network-level filtering

### Data Encryption
- **At Rest**: EBS encryption, RDS encryption
- **In Transit**: TLS 1.3 for all communications
- **Secrets**: AWS Secrets Manager integration

### Secrets Management
- **AWS Secrets Manager**: Centralized secret storage
- **External Secrets Operator**: K8s secret synchronization
- **Sealed Secrets**: GitOps-friendly secret management

## 📊 Monitoring & Observability

### Metrics Collection
- **Prometheus**: Application and infrastructure metrics
- **Node Exporter**: System metrics
- **PostgreSQL Exporter**: Database metrics

### Dashboards
- **Grafana**: Custom dashboards for app and DB metrics
- **Pre-built dashboards**: Node.js, PostgreSQL, Kubernetes

### Distributed Tracing
- **OpenTelemetry**: Instrumentation
- **Jaeger**: Trace collection and visualization

### Alerting Rules
- High CPU usage (>80% for 5 minutes)
- Pod crash/restart loops
- PostgreSQL unavailability
- High error rates (>5% for 2 minutes)

## 🧪 Testing

### Load Testing
```bash
# Run Locust tests
cd tests/locust
pip install -r requirements.txt
locust -f load_test.py --host=http://your-app-url
```

### Security Testing
```bash
# Container scanning
trivy image foursale/backend:latest

# Infrastructure scanning
checkov -d infrastructure/
```

## 🏗️ Infrastructure Details

### AWS Resources
- **VPC**: Multi-AZ setup with public/private subnets
- **EKS**: Managed Kubernetes with node groups
- **RDS**: PostgreSQL with Multi-AZ deployment
- **ALB**: Application Load Balancer with SSL termination
- **CloudFront**: CDN for static assets

### Scaling Configuration
- **HPA**: CPU and memory-based scaling (50-80% thresholds)
- **Cluster Autoscaler**: Node-level scaling
- **VPA**: Vertical Pod Autoscaler for right-sizing

## 💰 Cost Optimization

### FinOps Principles
- **Right-sizing**: VPA recommendations
- **Spot Instances**: For non-critical workloads
- **Reserved Instances**: For predictable workloads
- **Cost Monitoring**: AWS Cost Explorer integration

### Resource Limits
- CPU/Memory requests and limits on all pods
- Storage class optimization (gp3 vs gp2)
- Network optimization (VPC endpoints)

## 🌍 Multi-Environment Support

### Environments
- **Dev**: us-west-2, smaller instances, relaxed security
- **Prod**: us-east-1, production-grade, strict security

### Configuration Management
- **Terragrunt**: DRY infrastructure code
- **Helm Values**: Environment-specific configurations
- **GitOps**: ArgoCD for deployment automation

## 📋 Compliance & Governance

### Data Regulations
- **GDPR**: Data residency controls
- **SOC 2**: Audit logging and access controls
- **PCI DSS**: Payment data protection (if applicable)

### Vulnerability Management
- **Continuous Scanning**: Trivy in CI/CD
- **Runtime Security**: Falco for anomaly detection
- **Compliance Checks**: OPA Gatekeeper policies

## 🚀 Deployment Guide

### Step 1: Infrastructure
```bash
cd infrastructure/environments/dev
terraform init
terraform apply
```

### Step 2: Application
```bash
# Build and push images
docker build -t foursale/backend:v1.0.0 app/backend/
docker push foursale/backend:v1.0.0

# Deploy with Helm
helm install foursale k8s/helm/foursale-chart/
```

### Step 3: Monitoring
```bash
# Install monitoring stack
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack
```

## 🔍 Troubleshooting

### Common Issues
1. **Pod Security**: Ensure non-root user in Dockerfile
2. **Network Policies**: Check namespace labels
3. **HPA**: Verify metrics-server installation
4. **Database**: Check security group rules

### Debug Commands
```bash
# Check pod status
kubectl get pods -n foursale

# View logs
kubectl logs -f deployment/backend -n foursale

# Test connectivity
kubectl exec -it pod-name -- nc -zv postgres-service 5432
```

## 📹 Video Walkthrough

The video demonstration covers:
1. Project structure overview (2 mins)
2. Terraform architecture walkthrough (4 mins)
3. CI/CD pipeline demonstration (4 mins)
4. Security features showcase (3 mins)
5. Monitoring and alerting demo (2 mins)

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Run tests and security scans
4. Submit pull request

## 📄 License

MIT License - see LICENSE file for details.