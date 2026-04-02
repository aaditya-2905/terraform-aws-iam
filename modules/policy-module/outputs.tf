output "id" {
  description = "Id for iam policy"
  value       = aws_iam_policy.this.id
}

output "arn" {
  description = "Arn for iam policy"
  value       = aws_iam_policy.this.arn
}

output "name" {
  description = "Name for iam policy"
  value       = aws_iam_policy.this.name
}
