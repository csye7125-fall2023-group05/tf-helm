module "infra_dependencies" {
  source       = "../modules/infra_helm"
  namespace    = var.namespace
  timeout      = var.timeout
  values_file  = var.values_file
  chart_path   = var.chart_path
  release_name = var.release_name
}
