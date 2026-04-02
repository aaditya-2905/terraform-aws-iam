output "id" {
  description = "IAM Role ID"
  value       = aws_iam_role.this.id
}

output "arn" {
  description = "IAM Role ARN"
  value       = aws_iam_role.this.arn
}

output "name" {
  description = "IAM Role Name"
  value       = aws_iam_role.this.name
}
