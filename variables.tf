// Required Variables
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Container Registry"
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists"
}

variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Container Registry"
}

// Optional Variables
variable "admin_enabled" {
  type        = bool
  description = "(Optional) Specifies whether the admin user is enabled"
  default     = false
}
variable "sku" {
  type        = string
  description = "(Optional) The SKU name of the container registry"
  default     = "Premium"
}

# Add condition for Premium SKU
variable "georeplication_locations" {
  type        = list(string)
  description = "(Optional) A list of Azure locations where the container registry should be geo-replicated"
  default     = []
}

# Add condition for Premium SKU
variable "network_rule_default_action" {
  type        = string
  description = "The behaviour for requests matching no rules"
  default     = "Deny"
}

# Network/IP Rules
variable "ip_rule" {
  type = map(object({
    action   = string #(Required) The behaviour for requests matching this rule
    ip_range = string # (Required) The CIDR block from which requests will match the rule
  }))
  description = "(Optional) One or more ip_rule blocks"
  default     = {}
}
variable "virtual_network" {
  type = map(object({
    action    = string #(Required) The behaviour for requests matching this rule
    subnet_id = string #The subnet id from which requests will match the rule
  }))
  description = "(Optional) One or more virtual_network blocks"
  default     = {}
}

variable "acr_prefix" {
  type        = string
  description = "(Required) Prefix for Postgresql server name"
  default     = ""
}

variable "resource_tags" {
  type        = map(string)
  description = "(Optional) Tags for resources"
  default     = {}
}

variable "deployment_tags" {
  type        = map(string)
  description = "(Optional) Tags for deployment"
  default     = {}
}

variable "it_depends_on" {
  type        = any
  description = "(Optional) To define explicit dependencies if required"
  default     = null
}


// Local Values
locals {
  timeout_duration = "1h"
  acr_name         = "${var.acr_prefix}${var.name}${random_string.acr_suffix.result}"
}




 