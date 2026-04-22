variable "users" {
  description = "Map of IAM users to create"
  type = map(object({
    path                    = optional(string, "/")
    create_login_profile    = optional(bool, false)
    password_reset_required = optional(bool, true)
    create_access_key       = optional(bool, false)
    access_key_status       = optional(string, "Active")
    tags                    = optional(map(string), {})
  }))
  default = {}
}

variable "roles" {
  description = "Map of IAM roles to create"
  type = map(object({
    assume_role_policy = string
    description        = optional(string, null)
    path               = optional(string, "/")
    tags               = optional(map(string), {})
  }))
  default = {}
}

variable "policies" {
  description = "Map of IAM policies to create"
  type = map(object({
    policy_document = string
    description     = optional(string, null)
    path            = optional(string, "/")
    tags            = optional(map(string), {})
  }))
  default = {}
}

variable "groups" {
  description = "Map of IAM groups to create"
  type = map(object({
    path = optional(string, "/")
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "policy_attachments" {
  description = "Attach policies to roles and users. Format: 'role:role_name:policy_arn' or 'user:user_name:policy_arn'"
  type        = list(string)
  default     = []
}

variable "group_memberships" {
  description = "Add users to groups. Format: 'group_name:user_name'"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
