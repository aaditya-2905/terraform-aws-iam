variable "user_name" {
  description = "Name of the IAM user"
  type        = string
}

variable "user_path" {
  description = "Path for the IAM user"
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "create_login_profile" {
  description = "Whether to create console login profile"
  type        = bool
  default     = false
}

variable "password_reset_required" {
  description = "Require password reset on first login"
  type        = bool
  default     = true
}

variable "create_access_key" {
  description = "Whether to create access key"
  type        = bool
  default     = false
}

variable "access_key_status" {
  description = "Access key status (Active/Inactive)"
  type        = string
  default     = "Active"
}
