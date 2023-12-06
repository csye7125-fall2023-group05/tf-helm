resource "kubernetes_namespace" "webapp_proxy_setup" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = "webapp"
  }
}

resource "kubernetes_namespace" "deps_proxy_setup" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = "deps"
  }
}

resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "kubernetes_namespace" "istio_ingress" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = "istio-ingress"
  }
}
