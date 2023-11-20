# Terraform Helm Provider

This terraform code is to deploy Helm charts on GKE(GCP) cluster in prod OR minikube cluster locally using terraform [`Terraform Helm Provider`](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release)

The helm chart installation cluster depends on the `kubernetes` `config_path` in the `helm` provider.

```tf
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
```

Based on the `KUBECONFIG` value, the helm chart will be installed on that particular cluster.

> Due to an on-going issue with Terraform Helm Provider [[reference](https://github.com/hashicorp/terraform-provider-helm/issues/932)] which prevents the Terraform resource to pull a chart from a private GitHub repository (even after providing a GitHub PAT), we are forced to install the Helm chart locally.

## Configuring the chart values

For specific `values.yaml`, refer their specific charts and create their respective `values.yaml` files based on the dummy `values.yaml` file.