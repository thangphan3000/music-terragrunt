include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  region      = local.region_vars.locals.region
  environment = local.environment_vars.locals.environment
}

terraform {
  source = "../../../../../modules/ec2"
}

dependency "vpc" {
  config_path = "../../shared/vpc"

  mock_outputs = {
    public_subnet_ids = ["mock-public-subnet-id-1", "mock-public-subnet-id-2"]
  }

  mock_outputs_allowed_terraform_commands = ["plan"]
}

inputs = {
  environment = local.environment

  instances = {
    "${local.environment}-postgres" = {
      ami                         = "ami-054240677cb44ffac"
      associate_public_ip_address = true
      instance_type               = "t4g.micro"
      subnet_id                   = dependency.vpc.outputs.public_subnet_ids[0]
      root_block_device = {
        volume_size = 20
      }
    }
  }
}
