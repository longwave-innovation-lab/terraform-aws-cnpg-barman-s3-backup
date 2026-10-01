# Here there should be the terraform block with the required version for
# - Terraform
# - All the providers

terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
}
