# Technology Stack

## Core Technologies
- **Terraform**: v1.14.3 - Infrastructure as Code
- **Terragrunt**: v0.96.1 - Terraform wrapper for DRY configurations
- **AWS Provider**: v6.27.0 - AWS resource management

## Build System & Tooling
- **asdf**: Version management (see `.tool-versions`)
- **S3 Backend**: State storage with encryption and versioning

## Common Commands

### Backend Setup
```bash
# Prepare S3 backend for state storage
./prepare-backend.sh
```

### Terragrunt Operations
```bash
# Plan infrastructure changes
terragrunt plan

# Apply infrastructure changes
terragrunt apply

# Destroy infrastructure
terragrunt destroy

# Format Terraform code
terragrunt fmt

# Validate configuration
terragrunt validate
```

### AWS Configuration
- Uses AWS profiles for authentication
- Default profile: `github-actions` (for CI/CD)
- Default region: `ap-southeast-1`
- Backend bucket: `music-homelab`

## Key Dependencies
- **terraform-aws-modules/eks/aws**: v21.10.1 - EKS cluster management
- **terraform-aws-modules/vpc/aws**: For VPC resources (implied)
- **Karpenter**: Node autoscaling for EKS