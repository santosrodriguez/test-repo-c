variable "prefix" {
  type        = string
  description = "(Optional) The prefix which should be used for all resources in this example. Defaults to taco."
  default     = "santos"
}

variable "location" {
  type        = string
  description = "(Optional) The Azure Region in which all resources in this example should be created. Defaults to East US."
  default     = "eastus"
}

variable "environment" {
  type        = string
  description = "(Required) The environment in which all resources in this example should be created."
}

variable "env_version" {
  type        = string
  description = "(Required) Update to force a change."
}
