include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  project_vars     = read_terragrunt_config(find_in_parent_folders("project.hcl"))

  environment = local.environment_vars.locals.environment
  project     = local.project_vars.locals.project
  region      = local.region_vars.locals.region
}

terraform {
  source = "../../../../../modules/eks"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id             = "mock-vpc-id"
    private_subnet_ids = ["mock-private-subnet-id-1", "mock-private-subnet-id-2"]
  }

  mock_outputs_allowed_terraform_commands = ["plan"]
}

inputs = {
  cluster_name       = "${local.environment}-main"
  kubernetes_version = "1.33"
  environment        = local.environment
  private_subnet_ids = dependency.vpc.outputs.private_subnet_ids
  vpc_id             = dependency.vpc.outputs.vpc_id
}
