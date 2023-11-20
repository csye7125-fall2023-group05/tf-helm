# https://github.com/hashicorp/terraform-provider-helm/issues/467#issuecomment-617856419
resource "helm_release" "infra_dependencies" {
  name             = "infra-helm-release"
  namespace        = "deps"
  create_namespace = true
  repository       = "https://github.com/csye7125-fall2023-group05/infra-helm-chart.git"
  chart            = "${var.chart_path}/${var.infra_chart}"
  wait             = false # prevents "pending-install" helm install state
  values           = ["${file(var.infra_values_file)}"]
  timeout          = var.timeout
}
