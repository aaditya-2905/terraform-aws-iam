resource "aws_iam_role" "this" {
  name = var.role_name

  assume_role_policy = can(tostring(var.assume_role_policy)) ? var.assume_role_policy : jsonencode(var.assume_role_policy)

  description = var.role_description != null ? var.role_description : null
  path        = var.role_path != null ? var.role_path : "/"

  tags = merge(
    { Terraform = "true" },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}
