module "barman_s3_bucket" {
  source                            = "../.."
  eks_cluster_name                  = var.cluster_name
  cnpg_cluster_namespace            = "test-namespace"
  cnpg_cluster_service_account_name = "test-service-account"
}
