# Terraform Module Coding Conventions

Based on [Terraform Best Practices](https://www.terraform-best-practices.com/naming), these conventions ensure consistency and maintainability across all Terraform modules.

## General Naming Conventions

- Use `_` (underscore) instead of `-` (dash) everywhere (resource names, data source names, variable names, outputs)
- Prefer lowercase letters and numbers
- Always use singular nouns for resource names
- Use `-` inside argument values exposed to humans (e.g., DNS names, tags)

## main.tf Conventions

### Resource Naming
- **DO NOT** repeat resource type in resource name:
  ```hcl
  # ✅ Good
  resource "aws_route_table" "public" {}
  
  # ❌ Bad
  resource "aws_route_table" "public_route_table" {}
  resource "aws_route_table" "public_aws_route_table" {}
  ```

- Use `this` when there's no more descriptive name or when creating a single resource of that type
- Use descriptive names for multiple resources of the same type

### Resource Block Structure
1. `count` / `for_each` as first argument, followed by newline
2. Main configuration arguments
3. `tags` argument (if supported)
4. `depends_on` (if necessary)
5. `lifecycle` blocks (if necessary)

Each section separated by single empty line:

```hcl
resource "aws_nat_gateway" "this" {
  count = var.create_nat_gateway ? 1 : 0

  allocation_id = aws_eip.this[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-nat-gateway-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.this]

  lifecycle {
    create_before_destroy = true
  }
}
```

### Conditional Logic
- Prefer boolean values in `count` / `for_each` conditions:
  ```hcl
  # ✅ Good
  count = var.create_public_subnets ? 1 : 0
  
  # ❌ Avoid
  count = length(var.public_subnets) > 0 ? 1 : 0
  ```

## variables.tf Conventions

### Variable Block Structure
Order keys in this sequence:
1. `description`
2. `type`
3. `default`
4. `nullable` (when needed)
5. `validation` (when needed)

```hcl
variable "vpc_cidr" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
  nullable    = false

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid IPv4 CIDR block."
  }
}
```

### Variable Naming and Types
- Use plural form when type is `list(...)` or `map(...)`:
  ```hcl
  variable "availability_zones" {
    description = "List of availability zones"
    type        = list(string)
    default     = []
  }
  ```

- Use simple types (`string`, `number`, `list(...)`, `map(...)`, `any`) over complex `object()` types unless strict constraints needed
- Use specific types like `map(string)` when all elements have same type
- Use `type = any` to disable validation or support multiple types
- Set `nullable = false` for variables that should never be null

### Variable Descriptions
- Always include descriptions, even for "obvious" variables
- Use same wording as upstream AWS documentation when applicable
- Avoid double negatives - use positive names:
  ```hcl
  # ✅ Good
  variable "encryption_enabled" {
    description = "Enable encryption for the resource"
    type        = bool
    default     = true
  }
  
  # ❌ Bad
  variable "encryption_disabled" {
    description = "Disable encryption for the resource"
    type        = bool
    default     = false
  }
  ```

## outputs.tf Conventions

### Output Naming Structure
Follow pattern: `{name}_{type}_{attribute}`

- `{name}`: Resource or data source name
- `{type}`: Resource type without provider prefix
- `{attribute}`: Specific attribute being returned

```hcl
# For: data "aws_subnet" "private"
output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = data.aws_subnet.private.id
}

# For: resource "aws_vpc_endpoint" "s3"
output "s3_vpc_endpoint_id" {
  description = "ID of the S3 VPC endpoint"
  value       = aws_vpc_endpoint.s3.id
}
```

### Output Guidelines
- Always include `description` for all outputs
- Use plural names for list outputs:
  ```hcl
  output "private_subnet_ids" {
    description = "List of IDs of private subnets"
    value       = aws_subnet.private[*].id
  }
  ```

- Prefer `try()` over legacy `element(concat(...))`:
  ```hcl
  # ✅ Modern approach
  output "security_group_id" {
    description = "ID of the security group"
    value       = try(aws_security_group.this[0].id, "")
  }
  
  # ❌ Legacy approach
  output "security_group_id" {
    description = "ID of the security group"
    value       = element(concat(aws_security_group.this[*].id, [""]), 0)
  }
  ```

- Avoid `sensitive = true` unless you fully control output usage
- For multiple resources of same type, omit `this` in output names:
  ```hcl
  # Multiple route tables
  output "route_table_ids" {
    description = "List of route table IDs"
    value       = aws_route_table.main[*].id
  }
  ```

## File Organization

### Module Structure
Each module must contain:
- `main.tf` - Primary resource definitions
- `variables.tf` - Input variable declarations  
- `outputs.tf` - Output value definitions

### Resource Grouping in main.tf
Group related resources together with comments:
```hcl
#------------------------------------------------------------------------------
# VPC
#------------------------------------------------------------------------------
resource "aws_vpc" "this" {
  # configuration
}

#------------------------------------------------------------------------------
# Internet Gateway
#------------------------------------------------------------------------------
resource "aws_internet_gateway" "this" {
  # configuration
}

#------------------------------------------------------------------------------
# Subnets
#------------------------------------------------------------------------------
resource "aws_subnet" "public" {
  # configuration
}
```

These conventions ensure consistency across all modules and improve code maintainability and readability.