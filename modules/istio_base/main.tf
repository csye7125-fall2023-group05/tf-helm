resource "helm_release" "istio_base_chart" {
  name             = "istio-base"
  namespace        = "istio-system"
  create_namespace = true
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  timeout          = var.timeout
  cleanup_on_fail  = true
  force_update     = false
  wait             = false
  # When performing a revisioned installation, the base chart requires the
  # `--defaultRevision` value to be set for resource validation to function.
  set {
    name  = "defaultRevision"
    value = "default"
  }
}
