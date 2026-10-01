data "aws_iam_policy_document" "cnpg_barman" {
  statement {
    sid    = "AllowBarmanCloudListBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    resources = [
      aws_s3_bucket.cnpg_barman_backups.arn,
    ]
  }

  statement {
    sid    = "AllowBarmanCloudObjects"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
      "s3:PutObjectTagging"
    ]
    resources = [
      "${aws_s3_bucket.cnpg_barman_backups.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "pod_identity_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_policy" "cnpg_barman" {
  name_prefix = "${var.cnpg_cluster_namespace}-cnpg-barman"
  policy      = data.aws_iam_policy_document.cnpg_barman.json
}

resource "aws_iam_role" "cnpg_barman" {
  name_prefix        = var.cnpg_cluster_namespace
  assume_role_policy = data.aws_iam_policy_document.pod_identity_trust.json
}

resource "aws_iam_role_policy_attachment" "cnpg_barman" {
  role       = aws_iam_role.cnpg_barman.name
  policy_arn = aws_iam_policy.cnpg_barman.arn
}

resource "aws_eks_pod_identity_association" "cnpg_barman" {
  cluster_name    = var.eks_cluster_name
  service_account = var.cnpg_cluster_service_account_name
  role_arn        = aws_iam_role.cnpg_barman.arn
  namespace       = var.cnpg_cluster_namespace
}
