// Generate a random string to use in ACR instance name
/* resource "random_string" "acr_suffix" {
  length  = 4
  special = false
  upper   = false
} */


// Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                          = local.acr_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = var.sku
  admin_enabled                 = var.admin_enabled
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "georeplications" {
    for_each = var.sku == "Premium" ? var.georeplications : {}
    content {
      location = georeplications.value.location
      tags     = georeplications.value.tags
    }
  }
  dynamic "network_rule_set" {
    for_each = var.sku == "Premium" && var.enable_network_rule_set ? ["create_rule"] : []
    content {
      default_action  = var.default_action
      ip_rule         = local.ip_range
      virtual_network = local.subnet_id
    }
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