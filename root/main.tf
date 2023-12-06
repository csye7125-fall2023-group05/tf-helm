module "webapp_namespace" {
  source = "../modules/namespace"
}

module "istio_base" {
  depends_on = [module.webapp_namespace]
  source     = "../modules/istio_base"
  timeout    = var.timeout
}

resource "time_sleep" "istall_istio_crds" {
  depends_on      = [module.istio_base]
  create_duration = "20s"
}

module "istio_discovery" {
  depends_on = [time_sleep.istall_istio_crds]
  source     = "../modules/istiod"
  timeout    = var.timeout
}

resource "time_sleep" "istall_istio_discovery" {
  depends_on      = [module.istio_discovery]
  create_duration = "20s"
}

module "istio_gateway" {
  depends_on = [time_sleep.istall_istio_discovery]
  source     = "../modules/istio_gateway"
  timeout    = var.timeout
}


resource "time_sleep" "istall_istio_gateway" {
  depends_on      = [module.istio_gateway]
  create_duration = "20s"
}

module "infra_dependencies" {
  depends_on        = [time_sleep.istall_istio_gateway]
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
