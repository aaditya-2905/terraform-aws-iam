output "users" {
  description = "Map of created IAM users with their ARNs"
  value       = module.iam.users
}

output "access_keys" {
  description = "Access keys created for users (sensitive)"
  value       = module.iam.access_keys
  sensitive   = true
}

# Roles
output "roles" {
  description = "Map of created IAM roles with their ARNs"
  value       = module.iam.roles
}

# Policies
output "policies" {
  description = "Map of created IAM policies with their ARNs"
  value       = module.iam.policies
}

# Groups
output "groups" {
  description = "Map of created IAM groups with their ARNs"
  value       = module.iam.groups
}
