# This is the entrypoint of your Terraform code
# Define your main resources here - these are examples using null_resource and random providers
# Replace these with your actual infrastructure resources

resource "random_id" "example" {
  byte_length = 8
}

resource "random_string" "example_snake_case" {
  length  = 16
  special = false
}
