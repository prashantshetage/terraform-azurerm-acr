// Generate a random string to use in ACR instance name
resource "random_string" "acr_suffix" {
  length  = 4
  special = false
  upper   = false
}


// Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = local.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  #georeplication_locations = var.sku == "Premium" ? var.georeplication_locations : null # Depricated

  dynamic "georeplications" {
    for_each = var.georeplications
    #for_each = var.georeplication_locations
    content {
      #location = georeplications.value
      #tags     = var.georeplication_tags
      location = georeplications.value.location
      tags     = georeplications.value.tags
    }
  }
  network_rule_set {
    default_action = var.sku == "Premium" ? var.network_rule_default_action : null

    ip_rule = flatten([
      for ip in var.ip_rule : {
        action   = ip.action
        ip_range = ip.ip_range
      }
    ])

    # Change to map input
    /* ip_rule = [
      for rule_key, ip in var.ip_rule : {
        action   = ip.action
        ip_range = ip.ip_range
      }
    ] */

    virtual_network = flatten([
      for subnet in var.virtual_network : {
        action    = subnet.action
        subnet_id = subnet.subnet_id
      }
    ])
  }

  tags = merge(var.resource_tags, var.deployment_tags)

  depends_on = [var.it_depends_on]

  lifecycle {
    ignore_changes = [
      tags,
      #  network_rule_set,
    ]
  }

  timeouts {
    create = local.timeout_duration
    delete = local.timeout_duration
  }
}
//**********************************************************************************************