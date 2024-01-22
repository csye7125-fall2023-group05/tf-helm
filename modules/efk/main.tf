resource "helm_release" "elasticsearch" {
  name             = "elasticsearch"
  namespace        = "efk"
  create_namespace = true
  repository       = "https://helm.elastic.co"
  chart            = "elasticsearch"
  timeout          = var.timeout
  cleanup_on_fail  = true
  force_update     = false
  wait             = false
  values           = ["${file(var.elasticsearch_values_file)}"]
}
resource "helm_release" "kibana" {
  name             = "kibana"
  namespace        = "efk"
  create_namespace = true
  repository       = "https://helm.elastic.co"
  chart            = "kibana"
  timeout          = var.timeout
  cleanup_on_fail  = true
  force_update     = false
  wait             = false
  values           = ["${file(var.kibana_values_file)}"]
}
resource "helm_release" "fluentbit" {
  name             = "fluent-bit"
  namespace        = "efk"
  create_namespace = true
  repository       = "https://fluent.github.io/helm-charts"
  chart            = "fluent-bit"
  timeout          = var.timeout
  cleanup_on_fail  = true
  force_update     = false
  wait             = false
  values           = ["${file(var.fluentbit_values_file)}"]
}
