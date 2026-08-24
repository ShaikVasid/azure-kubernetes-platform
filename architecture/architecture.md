# Azure Kubernetes Platform Architecture

## Overview

This repository provisions an Azure Kubernetes Service platform with Terraform. The design separates cloud networking, security and AKS resources into reusable modules and composes them through an environment-specific root module.

## Logical architecture

```text
                              Azure
                                │
                         Resource Group
                                │
                         ┌──────┴──────┐
                         │     VNet     │
                         │ 10.30.0.0/16 │
                         └──────┬──────┘
                                │
                         AKS Subnet
                                │
                    ┌───────────┴───────────┐
                    │          AKS           │
                    │                        │
                    │ Azure RBAC + Identity  │
                    │ Azure overlay network  │
                    │ Azure network policy   │
                    └───────────┬────────────┘
                                │
                 ┌──────────────┴──────────────┐
                 │                             │
          System Node Pool              User Node Pool
          Cluster services              Application workloads
                 │                             │
                 └──────────────┬──────────────┘
                                │
                         Kubernetes workloads
```

## Terraform composition

```text
                    environments/dev
                           │
            ┌──────────────┼──────────────┐
            ▼              ▼              ▼
       networking       security         aks
            │              │              │
            ▼              ▼              ▼
          VNet            NSG            AKS
            │                             │
            └──────────────┬──────────────┘
                           ▼
                    Azure platform
```

## Security boundaries

1. Azure resource group provides the primary resource boundary.
2. The VNet and AKS subnet provide network isolation.
3. The AKS cluster uses a system-assigned managed identity.
4. Azure RBAC integration provides identity-based cluster authorization.
5. System and user node pools separate platform services from application workloads.
6. Terraform validation occurs before infrastructure changes are approved.

## Current implementation vs production extension

The repository intentionally provides a platform foundation. Production deployment would extend it with remote state, workload identity federation, private AKS/API access, explicit NSG rules, Key Vault, policy enforcement, autoscaling, observability, backup and disaster recovery.

## Design principle

The platform is designed as a sequence of composable layers:

```text
Cloud foundation
      ↓
AKS platform
      ↓
Identity / security
      ↓
GitOps
      ↓
Observability / SRE
```

Each layer should be independently testable, reviewable and replaceable.
