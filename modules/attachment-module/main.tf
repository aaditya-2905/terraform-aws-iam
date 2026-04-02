resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.entity_type == "role" ? toset(var.policy_arns) : toset([])

  role       = var.entity_name
  policy_arn = each.value
}

resource "aws_iam_user_policy_attachment" "this" {
  for_each = var.entity_type == "user" ? toset(var.policy_arns) : toset([])

  user       = var.entity_name
  policy_arn = each.value
}

resource "aws_iam_group_policy_attachment" "this" {
  for_each = var.entity_type == "group" ? toset(var.policy_arns) : toset([])

  group      = var.entity_name
  policy_arn = each.value
}
