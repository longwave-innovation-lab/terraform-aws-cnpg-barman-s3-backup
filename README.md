# Terraform-aws-cnpg-barman-s3-backup <!-- omit in toc -->

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Intro](#intro)
- [General Architecture](#general-architecture)
- [Usage](#usage)
- [Requirements](#requirements)
- [Providers](#providers)
- [Modules](#modules)
- [Resources](#resources)
- [Inputs](#inputs)
- [Outputs](#outputs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Intro

This module creates the AWS infrastructure needed to let a CloudNativePG (CNPG) cluster back up its data to S3 using Barman Cloud.

It is designed for EKS environments where the PostgreSQL workload runs under a specific namespace and Kubernetes service account, and needs a secure, dedicated backup destination with the least possible operational friction.

## General Architecture

The module provisions a dedicated S3 bucket with versioning, object lock, and lifecycle policies for backup retention.

The default configuration keeps backups protected for a configurable retention window, expires current objects a few days later, and removes older noncurrent versions after a longer grace period.

The module also creates an IAM policy and role for the CNPG service account, then binds that role through EKS Pod Identity so the backup workload can authenticate to S3 without static credentials.

> Altough not officially supported the [Pod Identity funtionality works as documented here](https://github.com/cloudnative-pg/plugin-barman-cloud/issues/772).

The permissions are limited to the operations Barman needs: listing the bucket, reading and writing objects, and managing multipart uploads and tagging.

The module outputs the bucket name and IAM role ARN so they can be consumed directly by your CNPG backup configuration.

This is the AWS-side foundation for a reliable CNPG backup strategy: a dedicated, protected object store and the identity that allows the database pod to write backups there safely and consistently.

> If you use the AWS Backup service you can add custom tags (using the variable `s3_aws_backup_tags`) to enable the automatic selection of the created bucket to make an additional backup on top of the bucket versioning.

## Usage

You can see a general [simple implementation of this module in the examples](examples/standard/main.tf).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_pod_identity_association.cnpg_barman](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_iam_policy.cnpg_barman](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cnpg_barman](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cnpg_barman](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.cnpg_barman_backups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.cnpg_barman_backups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_object_lock_configuration.cnpg_barman_backups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_versioning.cnpg_barman_backups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_iam_policy_document.cnpg_barman](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.pod_identity_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cnpg_cluster_namespace"></a> [cnpg\_cluster\_namespace](#input\_cnpg\_cluster\_namespace) | The namespace of the CNPG cluster, which will be used to create IAM roles resource and the S3 bucket | `string` | n/a | yes |
| <a name="input_cnpg_cluster_service_account_name"></a> [cnpg\_cluster\_service\_account\_name](#input\_cnpg\_cluster\_service\_account\_name) | The name of the service account for the CNPG cluster, which will be used by barman | `string` | n/a | yes |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | The name of the EKS cluster | `string` | n/a | yes |
| <a name="input_additional_s3_retention_days_for_current_versions"></a> [additional\_s3\_retention\_days\_for\_current\_versions](#input\_additional\_s3\_retention\_days\_for\_current\_versions) | Number of days after the Barman retention window to expire current S3 objects. | `number` | `7` | no |
| <a name="input_barman_retention_days"></a> [barman\_retention\_days](#input\_barman\_retention\_days) | Number of days Barman retains backups. Used to configure S3 lifecycle rules and object lock retention. | `number` | `180` | no |
| <a name="input_days_retention_multiplier_for_noncurrent_versions"></a> [days\_retention\_multiplier\_for\_noncurrent\_versions](#input\_days\_retention\_multiplier\_for\_noncurrent\_versions) | Multiplier for the Barman retention window to determine how long noncurrent S3 versions are kept. | `number` | `2` | no |
| <a name="input_s3_aws_backup_tags"></a> [s3\_aws\_backup\_tags](#input\_s3\_aws\_backup\_tags) | A map of tags to apply to the S3 bucket so that AWS Backup can select them in backup plans | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_barman_iam_role"></a> [barman\_iam\_role](#output\_barman\_iam\_role) | IAM role ARN for Barman Cloud |
| <a name="output_barman_s3_bucket"></a> [barman\_s3\_bucket](#output\_barman\_s3\_bucket) | S3 bucket name for Barman Cloud backups |
<!-- END_TF_DOCS -->
