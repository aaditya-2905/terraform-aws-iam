locals {
  # Normalize iam_config to ensure all expected keys exist (using try for optional fields)
  # This avoids the "attribute types must all match" error by delaying type resolution
  iam_config = {
    for k, v in var.iam_config : k => {
      type = v.type

      # ROLE
      role_name          = try(v.role_name, k)
      assume_role_policy = try(v.assume_role_policy, null)
      role_description   = try(v.role_description, null)
      role_path          = try(v.role_path, "/")

      # USER
      user_name               = try(v.user_name, k)
      user_path               = try(v.user_path, "/")
      create_login_profile    = try(v.create_login_profile, false)
      password_reset_required = try(v.password_reset_required, true)
      create_access_key       = try(v.create_access_key, false)
      access_key_status       = try(v.access_key_status, "Active")

      # POLICY
      policy_name        = try(v.policy_name, k)
      policy_description = try(v.policy_description, null)
      policy_path        = try(v.policy_path, "/")
      policy_json        = try(v.policy_json, null)

      # COMMON
      policy_arns = try(v.policy_arns, [])
      tags        = try(v.tags, {})
    }
  }
}
