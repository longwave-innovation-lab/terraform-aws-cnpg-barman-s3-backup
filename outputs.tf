# Define outputs here to expose values from your module
# Outputs can be used by other modules or displayed after terraform apply

output "barman_s3_bucket" {
  description = "S3 bucket name for Barman Cloud backups"
  value       = aws_s3_bucket.cnpg_barman_backups.bucket
}

output "barman_iam_role" {
  description = "IAM role ARN for Barman Cloud"
  value       = aws_iam_role.cnpg_barman.arn
}
