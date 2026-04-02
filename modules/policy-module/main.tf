resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description
  path        = var.policy_path
  policy      = jsonencode(var.policy_json)

  tags = merge(
    { Terraform = "true" },
    var.tags
  )
}
