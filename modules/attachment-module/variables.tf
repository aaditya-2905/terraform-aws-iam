variable "entity_name" {
  description = "Name of IAM entity (role, user, or group)"
  type        = string
}

variable "entity_type" {
  description = "Type of IAM entity: role, user, or group"
  type        = string

  validation {
    condition     = contains(["role", "user", "group"], var.entity_type)
    error_message = "entity_type must be one of: role, user, group."
  }
}

variable "policy_arns" {
  description = "List of IAM policy ARNs to attach"
  type        = list(string)
  default     = []
}
