output "name" {
  description = "IAM User Name"
  value       = aws_iam_user.this.name
}

output "id" {
  description = "IAM User ID"
  value       = aws_iam_user.this.id
}

output "arn" {
  description = "IAM User ARN"
  value       = aws_iam_user.this.arn
}

output "unique_id" {
  description = "IAM User Unique ID"
  value       = aws_iam_user.this.unique_id
}

output "access_key_id" {
  description = "Access Key ID"
  value       = try(aws_iam_access_key.this[0].id, null)
}

output "secret_access_key" {
  description = "Secret Access Key"
  value       = try(aws_iam_access_key.this[0].secret, null)
  sensitive   = true
}
