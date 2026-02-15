variable "environment" {
  description = "Environment name"
  type        = string
}

variable "instances" {
  description = "Map of EC2 instances to create"
  type = map(object({
    ami                         = string
    associate_public_ip_address = optional(bool)
    instance_type               = string
    key_name                    = optional(string)
    root_block_device = optional(object({
      delete_on_termination = optional(bool)
      encrypted             = optional(bool)
      volume_size           = optional(number)
      volume_type           = optional(string)
    }), {})
    security_group_ids = optional(list(string))
    subnet_id          = string
  }))
  default = {}
}
