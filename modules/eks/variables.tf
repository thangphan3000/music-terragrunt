variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-learning-terraform"
}

variable "kubernetes_version" {
  description = "Version of the EKS cluster"
  type        = string
  default     = "1.33"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "sa-east-1"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

