variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-south-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS profile to use"
  default     = "my-awscli-profile"
}

variable "cluster_name" {
  description = "Nome del cluster EKS"
  type        = string
  default     = "my-cluster-name"
}
