# Azure Kubernetes Platform

Production-style Azure Kubernetes Service (AKS) platform project demonstrating how to provision, secure, and operate a Kubernetes platform with Terraform.

## Architecture

```text
                    Azure
                      |
              +-------+-------+
              | Resource Group |
              +-------+-------+
                      |
                Azure VNet
                      |
        +-------------+-------------+
        |                           |
   System Subnet              User Subnet
        |                           |
        +-------------+-------------+
                      |
                     AKS
              +-------+-------+
              |               |
        System Node Pool   User Node Pool
              |               |
              +-------+-------+
                      |
                Kubernetes Apps
```

## Goals

- Provision AKS using Terraform
- Use Azure managed identities instead of long-lived credentials
- Enable Azure RBAC for Kubernetes authorization
- Separate system and user workloads
- Use Azure networking rather than the default cluster network
- Keep infrastructure modular and environment-friendly
- Validate Terraform changes through CI
- Provide a foundation for the GitOps and observability repositories in this portfolio

## Repository structure

```text
.
├── environments/
│   └── dev/
├── modules/
│   ├── aks/
│   ├── networking/
│   └── security/
├── architecture/
│   └── architecture.md
├── .github/workflows/
│   └── terraform.yml
├── .gitignore
├── Makefile
└── README.md
```

## Platform design

### AKS

The cluster uses a dedicated system node pool for Kubernetes system components and a user node pool for application workloads. This prevents application scheduling from unnecessarily competing with critical cluster services.

### Identity

The design uses Azure managed identity. The goal is to avoid storing Azure client secrets in source control or CI/CD configuration.

### Authorization

Azure RBAC is used for Azure resource access and AKS RBAC integration. Kubernetes access should follow least-privilege principles and be scoped to the required namespace or resource set where practical.

### Networking

The cluster is placed inside an Azure VNet with dedicated subnets. Network security controls are kept separate from application deployment concerns.

## Deployment flow

```text
Terraform code
      ↓
GitHub Pull Request
      ↓
terraform fmt
      ↓
terraform validate
      ↓
terraform plan
      ↓
Code Review
      ↓
terraform apply
      ↓
AKS platform
```

## Local usage

Requirements:

- Terraform >= 1.6
- Azure CLI
- An Azure subscription
- Appropriate Azure permissions

Authenticate locally with Azure CLI, then run:

```bash
az login
az account set --subscription <subscription-id>

cd environments/dev
terraform init
terraform fmt -recursive
terraform validate
terraform plan
```

Do not commit subscription IDs that are intended to remain private, credentials, client secrets, kubeconfigs, Terraform state, or other sensitive values.

## CI/CD

GitHub Actions validates Terraform formatting and configuration. Infrastructure deployment should require an explicit reviewed change rather than automatically applying every pull request.

## Security considerations

- Managed identity instead of static Azure credentials
- Azure RBAC and least-privilege access
- Dedicated network boundaries
- Separate system and application workloads
- No secrets committed to Git
- Terraform state should be stored remotely with appropriate access controls for real deployments
- Production deployments should use protected environments and approvals

## Operational considerations

A real production implementation should additionally consider:

- Azure Monitor / Container Insights
- Prometheus and Grafana
- OpenTelemetry
- Cluster autoscaling
- Pod disruption budgets
- Network policies
- Private AKS/API endpoint strategy
- Azure Key Vault integration
- Backup and disaster recovery
- Cost controls and resource tagging

Those concerns are intentionally separated so this repository can serve as the infrastructure layer for the GitOps and SRE observability projects that follow.

## Portfolio connection

This project is the **platform layer** of the portfolio:

```text
Azure Terraform Infrastructure
          ↓
    AKS Platform
          ↓
   Argo CD / GitOps
          ↓
 SRE Observability
```

## Technologies

**Azure · AKS · Terraform · Kubernetes · Azure RBAC · Managed Identity · Azure VNet · GitHub Actions · Helm · Linux · DevOps · SRE**

## Author

Vasid Shaik  
Cloud / DevOps / SRE Engineer
