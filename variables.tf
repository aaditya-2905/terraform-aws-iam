variable "iam_config" {
  description = "Unified IAM configuration"

  type = map(object({
    type = string

    # ROLE
    role_name          = optional(string)
    assume_role_policy = optional(any)
    role_description   = optional(string)
    role_path          = optional(string)

    # USER
    user_name               = optional(string)
    user_path               = optional(string)
    create_login_profile    = optional(bool)
    password_reset_required = optional(bool)
    create_access_key       = optional(bool)
    access_key_status       = optional(string)

    # POLICY
    policy_name        = optional(string)
    policy_description = optional(string)
    policy_path        = optional(string)
    policy_json        = optional(any)

    # COMMON
    policy_arns = optional(list(string))
    tags        = optional(map(string))
  }))
}
