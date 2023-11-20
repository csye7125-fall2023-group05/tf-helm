variable "timeout" {
  type        = number
  description = "The max time to run the helm release"
  default     = 30
}

variable "infra_values_file" {
  type        = string
  description = "The path to the infra_values.yaml file for the helm chart"
  default     = "./infra_values.yaml"
}

variable "webapp_values_file" {
  type        = string
  description = "The path to the webapp_values.yaml file for the helm chart"
  default     = "./webapp_values.yaml"
}

variable "chart_path" {
  type        = string
  description = "The path to the charts/ directory to install local charts"
  default     = "../modules/charts"
}

variable "webapp_chart" {
  type        = string
  description = "The exact name of the webapp-helm-chart"
  default     = "webapp-helm-chart.tar.gz"
}

variable "infra_chart" {
  type        = string
  description = "The exact name of the infra-helm-chart"
  default     = "infra-helm-chart.tar.gz"
}
