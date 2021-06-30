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
  default     = true
}
variable "sku" {
  type        = string
  description = "(Optional) The SKU name of the container registry"
  default     = "Premium"
}

# Add condition for Premium SKU
variable "georeplications" {
  type = map(object({
    location = string   #(Required) A location where the container registry should be geo-replicated.
    tags     = map(any) #(Optional) A mapping of tags to assign to this replication location.
  }))
  description = "(Optional) Azure locations where the container registry should be geo-replicated"
  default     = {}
}
variable "georeplication_locations" {
  type        = list(string)
  description = "(Optional) A list of Azure locations where the container registry should be geo-replicated"
  default     = []
}
variable "georeplication_tags" {
  type        = map(any)
  description = "(Optional) A mapping of tags to assign to this replication location"
  default     = {}
}

# Network/IP Rules
variable "enable_network_rule_set" {
  type        = bool
  description = "(Optional) Flag to enable/disable network rules"
  default     = true
}
variable "default_action" {
  type        = string
  description = "(Optional) The behaviour for requests matching no rules"
  default     = "Deny"
}
variable "ip_range" {
  type        = list(string)
  description = "(Optional) The CIDR block from which requests will match the rule"
  default     = []
}
variable "subnet_id" {
  type        = list(string)
  description = "(Optional) The subnet id from which requests will match the rule"
  default     = []
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
  ip_range = [for ip in var.ip_range : {
    action   = "Allow",
    ip_range = ip
    }
  ]
  subnet_id = [for id in var.subnet_id : {
    action    = "Allow",
    subnet_id = id
    }
  ]
}




 