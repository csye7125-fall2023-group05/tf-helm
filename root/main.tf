module "infra_dependencies" {
  source            = "../modules/infra_helm"
  timeout           = var.timeout
  infra_values_file = var.infra_values_file
  chart_path        = var.chart_path
  infra_chart       = var.infra_chart
}

module "webapp_dependencies" {
  depends_on         = [module.infra_dependencies]
  source             = "../modules/webapp_helm"
  timeout            = var.timeout
  webapp_values_file = var.webapp_values_file
  chart_path         = var.chart_path
  webapp_chart       = var.webapp_chart
}
