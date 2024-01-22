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

# The namespace the gateway is deployed in must not have a `istio-injection=disabled` label
resource "kubernetes_namespace" "istio_ingress" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = "istio-ingress"
  }
}

resource "kubernetes_namespace" "prometheus" {
  metadata {
    # labels = {
    #   istio-injection = "enabled"
    # }
    name = "prometheus"
  }
}

resource "kubernetes_namespace" "efk" {
  metadata {
    # labels = {
    #   istio-injection = "enabled"
    # }
    name = "efk"
  }
}
