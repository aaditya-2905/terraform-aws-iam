# Terraform AWS IAM Wrapper Module

A flexible, reusable, and dynamic Terraform module to manage AWS IAM resources using a single unified configuration.

This module allows you to create and manage:

* IAM Roles
* IAM Users
* IAM Policies
* Policy Attachments

All through one input variable: `iam_config`.

---

## 🚀 Features

* Unified IAM configuration (`iam_config`)
* Supports Roles, Users, and Policies
* Dynamic resource creation using `for_each`
* Policy attachment automation
* Minimal required inputs
* Clean and scalable architecture
* Registry-ready module design

---

## 📦 Usage

```hcl
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

      user_name = "dev-user"
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
          Effect = "Allow"
          Action   = ["s3:ListBucket"]
          Resource = "*"
        }]
      }
    }
  }
}
```

---

## ⚙️ Input Variable

### `iam_config`

A map defining IAM resources.

```hcl
iam_config = {
  <resource_key> = {
    type = "role" | "user" | "policy"

    # Role specific
    role_name
    assume_role_policy
    role_description
    role_path

    # User specific
    user_name
    user_path
    create_login_profile
    create_access_key

    # Policy specific
    policy_name
    policy_json
    policy_description
    policy_path

    # Common
    policy_arns
    tags
  }
}
```

---

## 📊 Inputs

| Name       | Description                   | Type     | Default | Required |
| ---------- | ----------------------------- | -------- | ------- | -------- |
| iam_config | Unified IAM configuration map | map(any) | `{}`    | No       |

---

## 📤 Outputs

| Name     | Description                 |
| -------- | --------------------------- |
| roles    | Map of created IAM roles    |
| users    | Map of created IAM users    |
| policies | Map of created IAM policies |

---

## 🧠 Design Principles

* **Single Entry Point**
  All IAM resources are managed through `iam_config`.

* **Separation of Concerns**
  Each resource type is handled by its own module.

* **Dynamic Infrastructure**
  Uses `for_each` and `try()` for flexibility.

* **No Forced Inputs**
  Only required fields must be provided.

* **Clean Root Module**
  No conditional clutter in root.

---

## 📁 Module Structure

```
.
├── main.tf
├── variables.tf
├── providers.tf
├── outputs.tf
├── modules/
│   ├── role-module/
│   ├── user-module/
│   ├── policy-module/
│   └── attachment-module/
└── example/
```

---

## 🧪 Example

See the complete working example in:

```
example/
```

---

## 🔐 Security Notes

* Access keys are sensitive and only returned once.

* Store secrets securely using:

  * AWS Secrets Manager
  * HashiCorp Vault

* Avoid committing secrets to version control.

---

## ⚠️ Limitations

* IAM is a global service (not region-specific).
* Inline policies are not handled separately.
* Policy attachment assumes valid ARNs.

---

## 🧰 Requirements

| Name      | Version |
| --------- | ------- |
| Terraform | >= 1.3  |
| AWS       | >= 4.0  |

---

## 🔄 Future Enhancements

* OIDC Role Support (GitHub/GitLab CI)
* Instance Profiles
* Inline Policy Support
* Advanced Validation Layer

---

## ✨ Author

**Aadityasinh Zala**

---


## ⭐ Contributing

Contributions, issues, and feature requests are welcome!
Feel free to open a PR or raise an issue.

---

## 💡 Final Note

This module is designed to act as a **lightweight IAM abstraction layer**, making it easy to manage complex IAM configurations in a clean and scalable way.
