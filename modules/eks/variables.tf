variable "aws_region" {
  description = "AWS region where the EKS cluster will be deployed"
  type        = string
  default     = "ap-southeast-1"
  nullable    = false
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  nullable    = false
}

variable "environment" {
  description = "Environment name for resource tagging and naming"
  type        = string
  nullable    = false
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.31"
  nullable    = false
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs where EKS worker nodes will be deployed"
  type        = list(string)
  nullable    = false
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be created"
  type        = string
  nullable    = false
}

