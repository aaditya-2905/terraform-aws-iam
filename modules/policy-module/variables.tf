variable "policy_name" {
  description = "Name of the policy"
  type        = string
}

variable "policy_description" {
  description = "Description of the policy"
  type        = string
  default     = ""
}

variable "policy_path" {
  description = "Path for the policy"
  type        = string
  default     = "/"
}

variable "policy_json" {
  description = "Policy document"
  type        = any
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

