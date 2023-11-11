# https://github.com/hashicorp/terraform-provider-helm/issues/467#issuecomment-617856419
resource "helm_release" "infra_dependencies" {
  name             = var.release_name
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://github.com/csye7125-fall2023-group05/infra-helm-chart.git"
  chart            = "${var.chart_path}/infra-helm-chart-1.1.0.tar.gz"
  wait             = false # prevents "pending-install" helm install state
  version          = "1.1.0"
  values           = ["${file(var.values_file)}"]
  timeout          = var.timeout
}
