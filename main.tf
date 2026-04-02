# ROLE MODULE
module "role" {
  source = "./modules/role-module"

  for_each = {
    for k, v in var.iam_config : k => v
    if v.type == "role"
  }

  role_name          = try(each.value.role_name, each.key)
  assume_role_policy = each.value.assume_role_policy

  role_description = try(each.value.role_description, null)
  role_path        = try(each.value.role_path, null)
  tags             = try(each.value.tags, {})
}

# POLICY MODULE
module "policy" {
  source = "./modules/policy-module"

  for_each = {
    for k, v in var.iam_config : k => v
    if v.type == "policy"
  }

  policy_name        = try(each.value.policy_name, each.key)
  policy_description = try(each.value.policy_description, null)
  policy_path        = try(each.value.policy_path, null)
  policy_json        = each.value.policy_json
  tags               = try(each.value.tags, {})
}

# USER MODULE
module "user" {
  source = "./modules/user-module"

  for_each = {
    for k, v in var.iam_config : k => v
    if v.type == "user"
  }

  user_name               = try(each.value.user_name, each.key)
  user_path               = try(each.value.user_path, null)
  create_login_profile    = try(each.value.create_login_profile, false)
  password_reset_required = try(each.value.password_reset_required, true)
  create_access_key       = try(each.value.create_access_key, false)
  access_key_status       = try(each.value.access_key_status, "Active")
  tags                    = try(each.value.tags, {})
}

# ATTACHMENT MODULE
module "attachment" {
  source = "./modules/attachment-module"

  for_each = {
    for k, v in var.iam_config : k => v
    if length(try(v.policy_arns, [])) > 0 && contains(["role", "user"], v.type)
  }

  entity_type = each.value.type

  entity_name = (
    each.value.type == "role" ? module.role[each.key].name :
    each.value.type == "user" ? module.user[each.key].name :
    null
  )

  policy_arns = try(each.value.policy_arns, [])
}
