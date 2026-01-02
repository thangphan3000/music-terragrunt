variable "azs" {
  description = "Availability zones"
  type        = list(string)
}

variable "cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Environment name (development1–development12, staging, pre-production, production)"
  type        = string

  validation {
    condition = (
      can(regex("^development(1[0-2]|[1-9])$", var.environment)) ||
      var.environment == "staging" ||
      var.environment == "pre-production" ||
      var.environment == "production"
    )
    error_message = "Environment must be one of: development1–development12, staging, pre-production, production."
  }
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "trusted_subnets" {
  description = "Trusted subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnet_tags" {
  description = "Private subnet tags."
  type        = map(any)
}

variable "public_subnet_tags" {
  description = "Public subnet tags."
  type        = map(any)
}
