terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# ============================================================================
# Example: Multiple Users, Policies, Roles, and Groups
# ============================================================================
# This example creates:
# - 2 IAM Users (dev-user-1, dev-user-2)
# - 2 IAM Roles (app-role, lambda-role)
# - 4 IAM Policies (s3-read, s3-write, ec2-read, lambda-execution)
# - 1 IAM Group (developers)
# - Policy attachments to roles and users
# - Users added to group

locals {
  assume_role_policy_ec2 = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  assume_role_policy_lambda = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  policy_s3_read = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      }
    ]
  })

  policy_s3_write = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      }
    ]
  })

  policy_ec2_read = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups"
        ]
        Resource = "*"
      }
    ]
  })

  policy_lambda_execution = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

module "iam" {
  source = "../"

  # ========== Create 2 Users ==========
  users = {
    "dev-user-1" = {
      path                 = "/"
      create_access_key    = true
      create_login_profile = true
      tags = {
        Team        = "development"
        Environment = "dev"
      }
    }
    "dev-user-2" = {
      path                 = "/"
      create_access_key    = true
      create_login_profile = true
      tags = {
        Team        = "development"
        Environment = "dev"
      }
    }
  }

  # ========== Create 2 Roles ==========
  roles = {
    "app-role" = {
      assume_role_policy = local.assume_role_policy_ec2
      description        = "Role for EC2 instances running applications"
      path               = "/"
      tags = {
        Team = "application"
      }
    }
    "lambda-role" = {
      assume_role_policy = local.assume_role_policy_lambda
      description        = "Role for Lambda functions"
      path               = "/"
      tags = {
        Team = "serverless"
      }
    }
  }

  # ========== Create 4 Policies ==========
  policies = {
    "s3-read-policy" = {
      policy_document = local.policy_s3_read
      description     = "Allows reading from S3 buckets"
      path            = "/"
      tags = {
        Service = "storage"
      }
    }
    "s3-write-policy" = {
      policy_document = local.policy_s3_write
      description     = "Allows reading and writing to S3 buckets"
      path            = "/"
      tags = {
        Service = "storage"
      }
    }
    "ec2-read-policy" = {
      policy_document = local.policy_ec2_read
      description     = "Allows reading EC2 resources"
      path            = "/"
      tags = {
        Service = "compute"
      }
    }
    "lambda-execution-policy" = {
      policy_document = local.policy_lambda_execution
      description     = "Allows Lambda functions to write logs"
      path            = "/"
      tags = {
        Service = "serverless"
      }
    }
  }

  # ========== Create 1 Group ==========
  groups = {
    "developers" = {
      path = "/development/"
      tags = {
        Team = "development"
      }
    }
  }

  # ========== Attach Policies to Roles and Users ==========
  policy_attachments = [
    # Attach policies to app-role
    "role:app-role:${aws_iam_policy.s3_read.arn}",
    "role:app-role:${aws_iam_policy.ec2_read.arn}",

    # Attach policies to lambda-role
    "role:lambda-role:${aws_iam_policy.lambda_execution.arn}",

    # Attach policies to dev-user-1
    "user:dev-user-1:${aws_iam_policy.s3_read.arn}",
    "user:dev-user-1:${aws_iam_policy.ec2_read.arn}",

    # Attach policies to dev-user-2
    "user:dev-user-2:${aws_iam_policy.s3_write.arn}",
  ]

  # ========== Add Users to Groups ==========
  group_memberships = [
    "developers:dev-user-1",
    "developers:dev-user-2",
  ]

  tags = {
    Project     = "infrastructure"
    Environment = "development"
    Managed     = "terraform"
  }
}

# ========== Create Additional Policy Resources for Reference ==========
resource "aws_iam_policy" "s3_read" {
  name        = "example-s3-read-policy"
  description = "S3 read policy for attachment example"
  policy      = local.policy_s3_read
}

resource "aws_iam_policy" "s3_write" {
  name        = "example-s3-write-policy"
  description = "S3 write policy for attachment example"
  policy      = local.policy_s3_write
}

resource "aws_iam_policy" "ec2_read" {
  name        = "example-ec2-read-policy"
  description = "EC2 read policy for attachment example"
  policy      = local.policy_ec2_read
}

resource "aws_iam_policy" "lambda_execution" {
  name        = "example-lambda-execution-policy"
  description = "Lambda execution policy for attachment example"
  policy      = local.policy_lambda_execution
}

# ========== Outputs ==========
output "users" {
  description = "Created users"
  value       = module.iam.users
}

output "roles" {
  description = "Created roles"
  value       = module.iam.roles
}

output "policies" {
  description = "Created policies"
  value       = module.iam.policies
}

output "groups" {
  description = "Created groups"
  value       = module.iam.groups
}

output "access_keys" {
  description = "Access keys for users (sensitive)"
  value       = module.iam.access_keys
  sensitive   = true
}
