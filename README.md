# Terraform AWS IAM Wrapper Module

A flexible, beginner-friendly Terraform module for managing AWS IAM resources. Create multiple users, roles, policies, and groups in a single configuration.

## 🚀 Features

* **Multi-Resource Support** - Create 2+ users, 4+ policies, 2+ roles, and groups in one call
* **Simple Wrapper Pattern** - Clean, straightforward variable passing
* **Explicit Variables** - Easy-to-understand structure (no complex maps)
* **Policy Attachments** - Attach policies to multiple roles and users dynamically
* **Group Management** - Create groups and add users to them
* **Optional Resources** - Create only what you need
* **Beginner-Friendly** - Easy to understand and extend
* **Production-Ready** - Follows AWS and Terraform best practices

---

## 📦 Quick Start: Multi-Resource Example

Create 2 users, 2 roles, 4 policies with attachments and groups:

```hcl
provider "aws" {
  region = "us-east-1"
}

module "iam" {
  source = "aaditya-2905/iam/aws"

  # ========== Create 2 Users ==========
  users = {
    "dev-user-1" = {
      create_access_key   = true
      create_login_profile = true
    }
    "dev-user-2" = {
      create_access_key   = true
    }
  }

  # ========== Create 2 Roles ==========
  roles = {
    "app-role" = {
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect = "Allow"
          Principal = { Service = "ec2.amazonaws.com" }
          Action = "sts:AssumeRole"
        }]
      })
      description = "Role for EC2 instances"
    }
    "lambda-role" = {
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect = "Allow"
          Principal = { Service = "lambda.amazonaws.com" }
          Action = "sts:AssumeRole"
        }]
      })
      description = "Role for Lambda functions"
    }
  }

  # ========== Create 4 Policies ==========
  policies = {
    "s3-read-policy" = {
      policy_document = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect = "Allow"
          Action = ["s3:GetObject", "s3:ListBucket"]
          Resource = "*"
        }]
      })
    }
    "s3-write-policy" = {
      policy_document = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect = "Allow"
          Action = ["s3:PutObject", "s3:DeleteObject"]
          Resource = "*"
        }]
      })
    }
    "ec2-read-policy" = {
      policy_document = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect = "Allow"
          Action = ["ec2:DescribeInstances"]
          Resource = "*"
        }]
      })
    }
    "lambda-execution-policy" = {
      policy_document = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect = "Allow"
          Action = ["logs:CreateLogGroup", "logs:PutLogEvents"]
          Resource = "*"
        }]
      })
    }
  }

  # ========== Create 1 Group ==========
  groups = {
    "developers" = {
      path = "/development/"
    }
  }

  # ========== Attach Policies to Roles & Users ==========
  # Format: "role:role_name:policy_arn" or "user:user_name:policy_arn"
  policy_attachments = [
    "role:app-role:${aws_iam_policy.s3_read.arn}",
    "role:lambda-role:${aws_iam_policy.lambda_exec.arn}",
    "user:dev-user-1:${aws_iam_policy.s3_read.arn}",
    "user:dev-user-2:${aws_iam_policy.s3_write.arn}",
  ]

  # ========== Add Users to Groups ==========
  # Format: "group_name:user_name"
  group_memberships = [
    "developers:dev-user-1",
    "developers:dev-user-2",
  ]

  tags = {
    Project     = "my-app"
    Environment = "development"
  }
}

output "users" {
  value = module.iam.users
}

output "roles" {
  value = module.iam.roles
}

output "groups" {
  value = module.iam.groups
}
```

---

## ⚙️ Input Variables
```

## ⚙️ Input Variables

### Multi-Resource Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `users` | `map(object(...))` | `{}` | Map of IAM users to create |
| `roles` | `map(object(...))` | `{}` | Map of IAM roles to create |
| `policies` | `map(object(...))` | `{}` | Map of IAM policies to create |
| `groups` | `map(object(...))` | `{}` | Map of IAM groups to create |
| `policy_attachments` | `list(string)` | `[]` | Attach policies: `"role:role_name:arn"` or `"user:user_name:arn"` |
| `group_memberships` | `list(string)` | `[]` | Add users to groups: `"group_name:user_name"` |
| `tags` | `map(string)` | `{}` | Tags to apply to all resources |

### User Object Structure

```hcl
users = {
  "user_name" = {
    path                    = optional(string, "/")
    create_login_profile    = optional(bool, false)
    password_reset_required = optional(bool, true)
    create_access_key       = optional(bool, false)
    access_key_status       = optional(string, "Active")
    tags                    = optional(map(string), {})
  }
}
```

### Role Object Structure

```hcl
roles = {
  "role_name" = {
    assume_role_policy = string          # Required
    description        = optional(string, null)
    path               = optional(string, "/")
    tags               = optional(map(string), {})
  }
}
```

### Policy Object Structure

```hcl
policies = {
  "policy_name" = {
    policy_document = string             # Required (JSON)
    description     = optional(string, null)
    path            = optional(string, "/")
    tags            = optional(map(string), {})
  }
}
```

### Group Object Structure

```hcl
groups = {
  "group_name" = {
    path = optional(string, "/")
    tags = optional(map(string), {})
  }
}
```

---

## 📤 Outputs

| Name | Type | Description |
|------|------|-------------|
| `users` | `map` | Map of created users with ARNs and unique IDs |
| `roles` | `map` | Map of created roles with ARNs and IDs |
| `policies` | `map` | Map of created policies with ARNs and IDs |
| `groups` | `map` | Map of created groups with ARNs and IDs |
| `access_keys` | `map` | Access keys for users (sensitive) |

---

## 💡 Usage Patterns

### Pattern 1: Multiple Users

```hcl
module "iam" {
  source = "./modules/iam"
  
  users = {
    "dev-1" = { create_access_key = true }
    "dev-2" = { create_access_key = true }
  }
}
```

### Pattern 2: Multiple Roles with Assume Policy

```hcl
module "iam" {
  source = "./modules/iam"
  
  roles = {
    "ec2-role" = {
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect = "Allow"
          Principal = { Service = "ec2.amazonaws.com" }
          Action = "sts:AssumeRole"
        }]
      })
    }
    "lambda-role" = {
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect = "Allow"
          Principal = { Service = "lambda.amazonaws.com" }
          Action = "sts:AssumeRole"
        }]
      })
    }
  }
}
```

### Pattern 3: Multiple Policies

```hcl
module "iam" {
  source = "./modules/iam"
  
  policies = {
    "s3-read" = {
      policy_document = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect = "Allow"
          Action = ["s3:GetObject", "s3:ListBucket"]
          Resource = "*"
        }]
      })
    }
    "s3-write" = {
      policy_document = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect = "Allow"
          Action = ["s3:PutObject"]
          Resource = "*"
        }]
      })
    }
  }
}
```

### Pattern 4: Policy Attachments

```hcl
module "iam" {
  source = "./modules/iam"
  
  policy_attachments = [
    "role:app-role:${aws_iam_policy.s3_read.arn}",
    "role:app-role:${aws_iam_policy.ec2_read.arn}",
    "user:dev-1:${aws_iam_policy.s3_read.arn}",
    "user:dev-2:${aws_iam_policy.s3_write.arn}",
  ]
}
```

### Pattern 5: Groups and Memberships

```hcl
module "iam" {
  source = "./modules/iam"
  
  groups = {
    "developers" = {
      path = "/development/"
    }
    "admins" = {
      path = "/admin/"
    }
  }
  
  group_memberships = [
    "developers:dev-1",
    "developers:dev-2",
    "admins:admin-user",
  ]
}
```

---

## 📁 Module Structure

```
.
├── versions.tf              # AWS provider >= 5.0
├── variables.tf             # Input variables (multi-resource)
├── main.tf                  # Wrapper that calls internal module
├── outputs.tf               # Root outputs
├── modules/
│   └── iam/                 # Internal module with resource logic
│       ├── versions.tf
│       ├── variables.tf     # Same input variables
│       ├── main.tf          # AWS resources (for_each based)
│       └── outputs.tf       # Output maps
└── example/
    └── main.tf              # Comprehensive multi-resource example
```

---

## 🔄 How It Works

### Multi-Resource Pattern

The internal module uses `for_each` to create multiple resources dynamically:

```hcl
# modules/iam/main.tf

# Create multiple roles
resource "aws_iam_role" "this" {
  for_each = var.roles
  
  name               = each.key
  assume_role_policy = each.value.assume_role_policy
  # ...
}

# Create multiple users
resource "aws_iam_user" "this" {
  for_each = var.users
  
  name = each.key
  # ...
}

# Create multiple policies
resource "aws_iam_policy" "this" {
  for_each = var.policies
  
  name   = each.key
  policy = each.value.policy_document
  # ...
}

# Attach policies dynamically
resource "aws_iam_role_policy_attachment" "this" {
  for_each = local.role_policy_attachments
  
  role       = each.value.role
  policy_arn = each.value.policy_arn
}
```

---

## 🔐 Security Best Practices

* **Access Keys**: Returned as sensitive outputs. Store securely in AWS Secrets Manager
* **Login Profiles**: Rotate passwords regularly
* **Policies**: Use least-privilege principle
* **Paths**: Use paths (`/service/`, `/team/`) to organize resources
* **Tags**: Use tags for tracking and cost allocation
* **Policy Attachments**: Verify ARNs before attaching

---

## 🧪 Running Examples

```bash
cd example
terraform init
terraform plan
terraform apply
terraform destroy
```

---

## 📝 License

This module is provided as-is for educational and production use.

---

## 🤝 Contributing

Contributions and feedback are welcome!
