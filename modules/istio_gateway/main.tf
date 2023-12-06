resource "helm_release" "istio_gateway_chart" {
  name             = "istio-ingress"
  namespace        = "istio-ingress"
  create_namespace = true
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  timeout          = var.timeout
  cleanup_on_fail  = true
  force_update     = false
  wait             = false
}
