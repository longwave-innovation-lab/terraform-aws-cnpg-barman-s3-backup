# S3 bucket for CNPG barman cloud backups
# object_lock_enabled must be set at bucket creation time and cannot be changed later
resource "aws_s3_bucket" "cnpg_barman_backups" {
  bucket_prefix       = "${var.cnpg_cluster_namespace}-backups"
  object_lock_enabled = true
  tags                = var.s3_aws_backup_tags
}

# Enable versioning — required for object lock and noncurrent-version lifecycle rules
resource "aws_s3_bucket_versioning" "cnpg_barman_backups" {
  bucket = aws_s3_bucket.cnpg_barman_backups.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Object lock default retention: COMPLIANCE mode for the full retention window
# Prevents any user (including root) from deleting objects until the lock expires
resource "aws_s3_bucket_object_lock_configuration" "cnpg_barman_backups" {
  bucket = aws_s3_bucket.cnpg_barman_backups.id

  # Depends on versioning being enabled first
  depends_on = [aws_s3_bucket_versioning.cnpg_barman_backups]

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = var.barman_retention_days
    }
  }
}

# Lifecycle rules:
#   1. Expire current versions a few days after the retention window ends
#   2. Expire noncurrent versions after a longer grace period
resource "aws_s3_bucket_lifecycle_configuration" "cnpg_barman_backups" {
  bucket = aws_s3_bucket.cnpg_barman_backups.id

  # Must wait for versioning to be active before applying lifecycle rules
  depends_on = [aws_s3_bucket_versioning.cnpg_barman_backups]

  rule {
    id     = "barman-expire-current-versions"
    status = "Enabled"

    expiration {
      # Expire current objects a few days after the Barman retention window
      days = var.barman_retention_days + var.additional_s3_retention_days_for_current_versions
    }
  }

  rule {
    id     = "barman-expire-noncurrent-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      # Keep old versions for twice the retention window before permanent deletion
      noncurrent_days = var.barman_retention_days * var.days_retention_multiplier_for_noncurrent_versions
    }
  }
}
