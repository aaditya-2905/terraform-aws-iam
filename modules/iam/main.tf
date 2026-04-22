resource "aws_iam_role" "this" {
  for_each = var.roles

  name               = each.key
  path               = each.value.path
  assume_role_policy = each.value.assume_role_policy
  description        = each.value.description
  tags               = merge(var.tags, each.value.tags)
}

resource "aws_iam_policy" "this" {
  for_each = var.policies

  name        = each.key
  path        = each.value.path
  description = each.value.description
  policy      = each.value.policy_document
  tags        = merge(var.tags, each.value.tags)
}

resource "aws_iam_user" "this" {
  for_each = var.users

  name = each.key
  path = each.value.path
  tags = merge(var.tags, each.value.tags)
}

resource "aws_iam_user_login_profile" "this" {
  for_each = {
    for user, user_config in var.users :
    user => user_config
    if user_config.create_login_profile
  }

  user                    = aws_iam_user.this[each.key].name
  password_reset_required = each.value.password_reset_required
  password_length         = 20

  lifecycle {
    ignore_changes = [password_reset_required]
  }
}

resource "aws_iam_access_key" "this" {
  for_each = {
    for user_name, user_config in var.users :
    user_name => user_config
    if user_config.create_access_key
  }

  user   = aws_iam_user.this[each.key].name
  status = each.value.access_key_status
}

resource "aws_iam_group" "this" {
  for_each = var.groups

  name = each.key
  path = each.value.path
}

locals {
  # Parse policy attachments
  policy_attachment_list = [
    for attachment in var.policy_attachments :
    split(":", attachment)
  ]

  # Role policy attachments
  role_policy_attachments = {
    for idx, parts in local.policy_attachment_list :
    "role_${idx}" => {
      role       = parts[1]
      policy_arn = parts[2]
    }
    if parts[0] == "role"
  }

  # User policy attachments
  user_policy_attachments = {
    for idx, parts in local.policy_attachment_list :
    "user_${idx}" => {
      user       = parts[1]
      policy_arn = parts[2]
    }
    if parts[0] == "user"
  }

  # Parse group memberships: format "group_name:user_name"
  membership_list = [
    for membership in var.group_memberships :
    split(":", membership)
  ]

  group_memberships = {
    for idx, parts in local.membership_list :
    "${parts[0]}_${idx}" => {
      group = parts[0]
      user  = parts[1]
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = local.role_policy_attachments

  role       = each.value.role
  policy_arn = each.value.policy_arn
}

resource "aws_iam_user_policy_attachment" "this" {
  for_each = local.user_policy_attachments

  user       = each.value.user
  policy_arn = each.value.policy_arn
}

resource "aws_iam_user_group_membership" "this" {
  for_each = local.group_memberships

  user   = each.value.user
  groups = [each.value.group]

  depends_on = [aws_iam_group.this]
}
