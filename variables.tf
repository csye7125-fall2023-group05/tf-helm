variable "namespace" {
  default     = "default"
  type        = string
  description = "Namespace in which to deploy the chart"
}

variable "timeout" {
  type        = number
  description = "The max time to run the helm release"
}
