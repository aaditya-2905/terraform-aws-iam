variable "iam_config" {
  description = "Unified IAM configuration"
  type        = any

  validation {
    condition = alltrue([
      for k, v in var.iam_config : contains(["user", "role", "policy"], try(v.type, ""))
    ])
    error_message = "Each entry in 'iam_config' must have a 'type' attribute set to: user, role, or policy."
  }
}
