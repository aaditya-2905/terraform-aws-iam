module "iam" {
  source = "./modules/iam"

  # Multi-resource configuration
  users              = var.users
  roles              = var.roles
  policies           = var.policies
  groups             = var.groups
  policy_attachments = var.policy_attachments
  group_memberships  = var.group_memberships

  # Common configuration
  tags = var.tags
}
