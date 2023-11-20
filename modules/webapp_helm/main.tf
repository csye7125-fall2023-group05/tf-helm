# https://github.com/hashicorp/terraform-provider-helm/issues/467#issuecomment-617856419
resource "helm_release" "webapp_release" {
  name             = "webapp-helm-release"
  namespace        = "webapp"
  create_namespace = true
  repository       = "https://github.com/csye7125-fall2023-group05/webapp-helm-chart.git"
  chart            = "${var.chart_path}/${var.webapp_chart}"
  wait             = false # prevents "pending-install" helm install state
  values           = ["${file(var.webapp_values_file)}"]
  timeout          = var.timeout
}
