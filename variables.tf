# Here there should be your variables

variable "cnpg_cluster_service_account_name" {
  type        = string
  description = "The name of the service account for the CNPG cluster, which will be used by barman"
}

variable "cnpg_cluster_namespace" {
  type        = string
  description = "The namespace of the CNPG cluster, which will be used to create IAM roles resource and the S3 bucket"
}

variable "eks_cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
}

variable "barman_retention_days" {
  description = "Number of days Barman retains backups. Used to configure S3 lifecycle rules and object lock retention."
  type        = number
  default     = 180
}

variable "additional_s3_retention_days_for_current_versions" {
  description = "Number of days after the Barman retention window to expire current S3 objects."
  type        = number
  default     = 7
}

variable "days_retention_multiplier_for_noncurrent_versions" {
  description = "Multiplier for the Barman retention window to determine how long noncurrent S3 versions are kept."
  type        = number
  default     = 2
}

variable "s3_aws_backup_tags" {
  type        = map(string)
  description = "A map of tags to apply to the S3 bucket so that AWS Backup can select them in backup plans"
  default     = {}
}
