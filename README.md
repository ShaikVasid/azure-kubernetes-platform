<div align="center">

# Azure Kubernetes Platform

### AKS · Terraform · Platform Engineering · Cloud Security

**A production-style Azure Kubernetes foundation designed around repeatable infrastructure, workload isolation and identity-based access.**

<p>
  <img src="https://img.shields.io/badge/Azure-AKS-0078D4?style=for-the-badge&logo=microsoftazure" alt="Azure AKS" />
  <img src="https://img.shields.io/badge/Terraform-IaC-7B42BC?style=for-the-badge&logo=terraform" alt="Terraform" />
  <img src="https://img.shields.io/badge/Kubernetes-Platform-326CE5?style=for-the-badge&logo=kubernetes" alt="Kubernetes" />
  <img src="https://img.shields.io/badge/Azure_RBAC-Security-0078D4?style=for-the-badge&logo=microsoft" alt="Azure RBAC" />
  <img src="https://img.shields.io/badge/GitHub_Actions-CI-2088FF?style=for-the-badge&logo=githubactions" alt="GitHub Actions" />
</p>

</div>

---

## 🎯 Project objective

This repository demonstrates how I approach **platform engineering on Azure**: provision the Kubernetes foundation with Terraform, isolate infrastructure concerns into reusable modules, use managed identity instead of long-lived credentials, and separate system workloads from application workloads.

The current implementation intentionally focuses on the **infrastructure/platform layer**. GitOps, observability, application deployment and advanced production controls are planned as separate layers rather than being mixed into one Terraform stack.

---

## 🏗️ Architecture

```text
                              Azure
                                │
                         Resource Group
                                │
                         ┌──────┴──────┐
                         │    VNet      │
                         │ 10.30.0.0/16 │
                         └──────┬──────┘
                                │
                         AKS Subnet
                                │
                    ┌───────────┴───────────┐
                    │          AKS           │
                    │                        │
                    │  Azure RBAC + Identity │
                    │                        │
                    └───────────┬────────────┘
                                │
                 ┌──────────────┴──────────────┐
                 │                             │
          System Node Pool              User Node Pool
          Kubernetes services           Application workloads
                 │                             │
                 └──────────────┬──────────────┘
                                │
                         Future platform layer
                                │
                    ┌───────────┴───────────┐
                    │                       │
                  GitOps              Observability
                Argo CD              Prometheus/Grafana
```

The Terraform implementation creates an Azure resource group, VNet, dedicated AKS subnet, security resources and AKS cluster through reusable modules. fileciteturn44file0L2-L2 fileciteturn46file0L2-L2

---

## ⭐ Platform capabilities

| Capability | Implementation |
|---|---|
| Infrastructure as Code | Terraform modules and environment configuration |
| Kubernetes | Azure Kubernetes Service (AKS) |
| Identity | System-assigned managed identity |
| Authorization | Azure RBAC integration |
| Workload isolation | Dedicated system and user node pools |
| Networking | Azure VNet + AKS subnet + Azure CNI overlay |
| Network security | Azure Network Security Group foundation |
| CI validation | GitHub Actions + Terraform format/validate |
| Environment design | Environment-specific Terraform root module |
| Cost awareness | Separate system/user pools and configurable VM sizes |

The AKS module explicitly enables Azure RBAC and uses separate system and user node pools. fileciteturn45file0L2-L2

---

## 📁 Repository structure

```text
azure-kubernetes-platform/
│
├── environments/
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── modules/
│   ├── aks/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── networking/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── security/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── .github/workflows/
│   └── terraform.yml
│
└── README.md
```

The environment root composes the networking, security and AKS modules instead of placing all resources in one large Terraform file. fileciteturn44file0L2-L2

---

## ☸️ AKS design

### System and user node pools

The cluster uses a dedicated system node pool for Kubernetes system components and a separate user node pool for application workloads. The user pool is labelled `workload-type=application`, creating a foundation for future workload scheduling policies. fileciteturn45file0L2-L2

### Identity

The AKS cluster uses a **system-assigned managed identity**, avoiding the need to place long-lived Azure credentials in Terraform configuration. fileciteturn45file0L2-L2

### Authorization

Azure RBAC integration is enabled at the AKS layer. The broader portfolio pairs this platform with the separate IAM automation project so identity policy can be validated independently from cluster provisioning. fileciteturn45file0L2-L2

### Networking

The platform uses an Azure VNet and dedicated AKS subnet. AKS is configured with Azure networking, overlay mode and Azure network policy. fileciteturn45file0L2-L2

---

## 🔄 Infrastructure delivery flow

```text
Developer change
      │
      ▼
GitHub Pull Request
      │
      ├── terraform fmt -check
      ├── terraform init -backend=false
      └── terraform validate
      │
      ▼
Code review
      │
      ▼
Approved infrastructure change
      │
      ▼
Terraform plan
      │
      ▼
Controlled apply
      │
      ▼
AKS platform
```

The current GitHub Actions workflow validates formatting and Terraform configuration on relevant pull requests and pushes to `main`. It does not automatically deploy infrastructure. fileciteturn43file0L2-L2

---

## 🧪 Local validation

Requirements:

- Terraform >= 1.6
- Azure CLI
- Azure subscription
- Appropriate Azure permissions

```bash
az login
az account set --subscription <subscription-id>

cd environments/dev
terraform init
terraform fmt -recursive
terraform validate
terraform plan
```

The development environment currently defaults to `canadacentral` and uses a `10.30.0.0/16` VNet with a `10.30.0.0/22` AKS subnet. fileciteturn50file0L2-L2

Never commit credentials, client secrets, kubeconfigs, Terraform state or other sensitive values.

---

## 🔐 Security model

The platform follows several security principles:

- **Identity-based authentication** instead of static credentials
- **Azure RBAC** for centralized authorization
- **Network boundaries** around the AKS platform
- **Workload separation** between system and application nodes
- **Infrastructure validation** before changes are applied
- **No automatic production mutation from pull requests**

The security module currently creates the Network Security Group foundation associated with the platform. fileciteturn47file0L2-L2

For a real production deployment, this foundation should be extended with explicit NSG rules, private cluster strategy, Key Vault integration, policy enforcement and workload-level network policies.

---

## 🧠 Architecture decisions

### Why Terraform modules?

Networking, security and AKS are separated so each concern can evolve independently and be reused across environments.

### Why separate system and user node pools?

Critical Kubernetes services should not compete directly with application workloads for the same scheduling capacity.

### Why managed identity?

Long-lived service credentials create unnecessary operational and security risk. Managed identity removes the need to distribute those credentials.

### Why validate but not auto-apply?

Infrastructure changes should be reviewable. The current CI pipeline intentionally stops at validation so deployment can be introduced later with explicit environment protection and approval.

### Why keep observability and GitOps separate?

The portfolio is designed as composable engineering layers: infrastructure first, then GitOps, then observability. This keeps responsibilities clear and makes each repository independently understandable.

---

## 📊 Production-readiness roadmap

### Current foundation

- [x] Modular Terraform architecture
- [x] AKS cluster provisioning
- [x] Managed identity
- [x] Azure RBAC integration
- [x] System/user node pool separation
- [x] Azure VNet and dedicated subnet
- [x] Terraform CI validation

### Next engineering layer

- [ ] Remote Terraform state with locking
- [ ] Terraform plan output in pull requests
- [ ] OIDC / workload identity federation for GitHub Actions
- [ ] Terraform security scanning with Checkov or tfsec
- [ ] Explicit NSG rules
- [ ] AKS private cluster design
- [ ] Azure Key Vault integration
- [ ] Network policies and workload security
- [ ] Cluster autoscaler / workload autoscaling
- [ ] Pod disruption budgets
- [ ] Azure Monitor / Container Insights
- [ ] Prometheus + Grafana
- [ ] Argo CD GitOps deployment
- [ ] Disaster recovery and backup strategy
- [ ] Cost and resource governance

---

## 🔗 Portfolio architecture

This repository is the **Kubernetes platform layer** in my broader Cloud / DevOps / SRE portfolio:

```text
┌───────────────────────────────────┐
│ Terraform Cloud Infrastructure    │
│ Cloud foundation + networking     │
└─────────────────┬─────────────────┘
                  │
                  ▼
┌───────────────────────────────────┐
│ Azure Kubernetes Platform         │
│ AKS + identity + networking       │
└─────────────────┬─────────────────┘
                  │
                  ▼
┌───────────────────────────────────┐
│ IAM / RBAC Automation             │
│ Security validation + audit       │
└─────────────────┬─────────────────┘
                  │
                  ▼
┌───────────────────────────────────┐
│ GitOps / CI/CD                    │
│ Argo CD + DevSecOps               │
└─────────────────┬─────────────────┘
                  │
                  ▼
┌───────────────────────────────────┐
│ SRE / Observability               │
│ Metrics + logs + traces + SLOs    │
└───────────────────────────────────┘
```

---

## 🛠️ Technology stack

**Azure · AKS · Terraform · Kubernetes · Azure RBAC · Managed Identity · Azure VNet · GitHub Actions · Helm · Linux · DevOps · SRE**

---

## 👨‍💻 Author

**Vasid Shaik**  
Cloud / DevOps / SRE Engineer

[GitHub](https://github.com/ShaikVasid)
