resource "helm_release" "istiod_chart" {
  name             = "istiod"
  namespace        = "istio-system"
  create_namespace = true
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  timeout          = var.timeout
  cleanup_on_fail  = true
  force_update     = false
  wait             = true
}
