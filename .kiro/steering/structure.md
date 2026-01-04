# Project Structure

## Directory Organization

The project follows a hierarchical structure that mirrors AWS organizational patterns:

```
├── account/                        # Account-level configuration
│   ├── account.hcl                 # Account settings (team_owner, profile)
│   └── region/                     # Region-specific settings
│       ├── region.hcl              # Region configuration
│       └── environment/            # Environment-specific deployments
│           ├── environment.hcl     # Environment configuration
│           ├── common/             # Common infrastructure (VPC, EKS)
│           │   ├── project.hcl     # Common project configuration
│           │   ├── vpc/            # VPC deployment
│           │   └── eks/            # EKS cluster deployment
│           └── catalog/            # Application catalog/projects
│               └── project.hcl     # Catalog project configuration
├── modules/                        # Reusable Terraform modules
│   ├── eks/                        # EKS cluster module
│   └── vpc/                        # VPC networking module
├── root.hcl                        # Root Terragrunt configuration
└── prepare-backend.sh              # S3 backend setup script
```

## Configuration Hierarchy

1. **Account Level** (`account/account.hcl`)
   - Team ownership
   - AWS profile configuration

2. **Region Level** (`account/region/region.hcl`)
   - AWS region settings
   - Regional defaults

3. **Environment Level** (`account/region/environment/`)
   - Environment-specific configurations
   - Resource deployments

4. **Project Level** (`account/region/environment/common/` and `account/region/environment/catalog/`)
   - **Common**: Shared infrastructure (VPC, EKS clusters)
   - **Catalog**: Application-specific projects and services

## Module Structure

Each module follows standard Terraform conventions:
- `main.tf` - Primary resource definitions
- `variables.tf` - Input variable declarations
- `outputs.tf` - Output value definitions

## File Naming Conventions

- Use `.hcl` extension for Terragrunt configuration files
- Use `.tf` extension for Terraform module files
- Configuration files are named after their scope (account.hcl, region.hcl, etc.)

## Generated Files

Terragrunt automatically generates:
- `provider.tf` - AWS provider configuration with default tags
- `backend.tf` - S3 backend configuration
- `.terragrunt-cache/` - Terragrunt working directory (gitignored)