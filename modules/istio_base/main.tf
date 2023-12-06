resource "helm_release" "istio_base_chart" {
  name             = "istio-base"
  namespace        = "istio-system"
  create_namespace = true
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  timeout          = 120
  cleanup_on_fail  = true
  force_update     = false
  wait             = false
  set {
    name  = "defaultRevision"
    value = "default"
  }
}
