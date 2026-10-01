output "s3_bucket" {
  description = "S3 bucket name for Barman Cloud backups"
  value       = module.barman_s3_bucket.barman_s3_bucket
}

output "barman_iam_role" {
  description = "IAM role ARN for Barman Cloud"
  value       = module.barman_s3_bucket.barman_iam_role
}
