variable "iam_config" {
  description = "Unified IAM configuration"

  type = map(object({
    type = string

    # ROLE CONFIG
    role_name          = optional(string)
    assume_role_policy = optional(any)
    role_description   = optional(string)
    role_path          = optional(string)

    # USER CONFIG
    user_name               = optional(string)
    user_path               = optional(string)
    create_login_profile    = optional(bool)
    password_reset_required = optional(bool)
    create_access_key       = optional(bool)
    access_key_status       = optional(string)

    # POLICY CONFIG
    policy_name        = optional(string)
    policy_description = optional(string)
    policy_path        = optional(string)
    policy_json        = optional(any)

    # COMMON CONFIG
    policy_arns = optional(list(string))
    tags        = optional(map(string))
  }))

  default = {}

  validation {
    condition = alltrue([
      for k, v in var.iam_config :
      contains(["role", "user", "policy"], v.type)
    ])
    error_message = "Each iam_config object must have type = role, user, or policy."
  }
}
