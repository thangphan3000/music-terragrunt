# Product Overview

This is a Terraform/Terragrunt infrastructure project for managing AWS resources in a structured, multi-environment setup. The project follows a hierarchical organization pattern: AWS account → AWS region → environment → common infrastructure (VPC) → specific projects.

The infrastructure includes:
- VPC with public, private, and trusted subnets
- EKS clusters with Karpenter for node management
- S3 backend for Terraform state management

The project is designed for a homelab environment ("music-homelab") managed by the SRE team, with support for multiple development environments (development1-12), staging, pre-production, and production.