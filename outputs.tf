output "roles" {
  description = "Created IAM Roles"
  value = {
    for k, v in module.role : k => {
      name = v.name
      arn  = v.arn
    }
  }
}

output "users" {
  description = "Created IAM Users"
  value = {
    for k, v in module.user : k => {
      name = v.name
      arn  = v.arn
    }
  }
}

output "policies" {
  description = "Created IAM Policies"
  value = {
    for k, v in module.policy : k => {
      name = v.name
      arn  = v.arn
    }
  }
}
