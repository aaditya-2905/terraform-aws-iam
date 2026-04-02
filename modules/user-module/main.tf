resource "aws_iam_user" "this" {
  name = var.user_name

  path = var.user_path != null ? var.user_path : "/"

  tags = merge(
    { Terraform = "true" },
    var.tags
  )
}

resource "aws_iam_user_login_profile" "this" {
  count = var.create_login_profile ? 1 : 0

  user                    = aws_iam_user.this.name
  password_reset_required = var.password_reset_required
}

resource "aws_iam_access_key" "this" {
  count = var.create_access_key ? 1 : 0

  user   = aws_iam_user.this.name
  status = var.access_key_status
}
