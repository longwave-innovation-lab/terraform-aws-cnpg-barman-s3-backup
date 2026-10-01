# Longwave Terraform Template <!-- omit in toc -->

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Intro](#intro)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Intro

Simple example of this module usage.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_barman_s3_bucket"></a> [barman\_s3\_bucket](#module\_barman\_s3\_bucket) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | AWS profile to use | `string` | `"my-awscli-profile"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nome del cluster EKS | `string` | `"my-cluster-name"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"eu-south-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_barman_iam_role"></a> [barman\_iam\_role](#output\_barman\_iam\_role) | IAM role ARN for Barman Cloud |
| <a name="output_s3_bucket"></a> [s3\_bucket](#output\_s3\_bucket) | S3 bucket name for Barman Cloud backups |
<!-- END_TF_DOCS -->
