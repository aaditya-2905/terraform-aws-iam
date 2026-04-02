variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "assume_role_policy" {
  description = "Assume role policy document"
  type        = any
}

variable "role_description" {
  description = "Description of the role"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path for the role"
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
