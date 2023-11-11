variable "namespace" {
  default     = "default"
  type        = string
  description = "Namespace in which to deploy the chart"
}

variable "timeout" {
  type        = number
  description = "The max time to run the helm release"
  default     = 30
}

variable "values_file" {
  type        = string
  description = "The path to the values.yaml file for the helm chart"
  default     = "./values.yaml"
}

variable "chart_path" {
  type        = string
  description = "The path to the charts/ directory to install local charts"
  default     = "../modules/infra_helm/charts"
}

variable "release_name" {
  type        = string
  description = "The name of the helm chart release"
  default     = "infra-helm-release"
}
