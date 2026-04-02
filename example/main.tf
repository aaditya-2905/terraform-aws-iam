provider "aws" {
  region = "ap-south-1"
}

module "iam" {
  source = "aaditya-2905/iam/aws"

  iam_config = {
    app_role = {
      type = "role"

      role_name = "app-role"

      assume_role_policy = {
        Version = "2012-10-17"
        Statement = [{
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        }]
      }

      policy_arns = [
        "arn:aws:iam::aws:policy/AmazonS3FullAccess"
      ]
    }

    dev_user = {
      type = "user"

      user_name         = "dev-user"
      create_access_key = true

      policy_arns = [
        "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
      ]
    }

    custom_policy = {
      type = "policy"

      policy_name = "custom-s3-policy"

      policy_json = {
        Version = "2012-10-17"
        Statement = [{
          Effect   = "Allow"
          Action   = ["s3:ListBucket"]
          Resource = "*"
        }]
      }
    }
  }
}
