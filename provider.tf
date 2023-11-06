terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.63.1"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
