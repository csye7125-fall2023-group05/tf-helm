resource "helm_release" "kube_prometheus_chart" {
  name             = "kube-prometheus-stack"
  namespace        = "prometheus"
  create_namespace = true
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  timeout          = var.timeout
  cleanup_on_fail  = true
  force_update     = false
  wait             = false
  values           = ["${file(var.kube_prometheus_values_file)}"]
}
