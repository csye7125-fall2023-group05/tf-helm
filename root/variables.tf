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

variable "kube_prometheus_values_file" {
  type        = string
  description = "The path to the kube_prometheus_values.yaml file for the helm chart"
  default     = "./kube_prometheus_values.yaml"
}

variable "elasticsearch_values_file" {
  type        = string
  description = "The path to the elasticsearch_values.yaml file for the helm chart"
  default     = "./elasticsearch_values.yaml"
}

variable "kibana_values_file" {
  type        = string
  description = "The path to the kibana_values.yaml file for the helm chart"
  default     = "./kibana_values.yaml"
}

variable "fluentbit_values_file" {
  type        = string
  description = "The path to the fluentbit_values.yaml file for the helm chart"
  default     = "./fluentbit_values.yaml"
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
