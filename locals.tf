locals {
  prefix_to_use = var.cnpg_custom_name != "" ? var.cnpg_custom_name : var.cnpg_cluster_namespace
}
