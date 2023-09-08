data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "kv_rg" {
  count = var.create_rg != true ? 1 : 0
  name  = var.resource_group_name
}

data "azurerm_subnet" "default-subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg_name
}

resource "azurerm_resource_group" "kv_rg" {
  count    = var.create_rg ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  # tags     = var.tags
}

resource "time_sleep" "wait_10_seconds" {
  depends_on = [azurerm_resource_group.kv_rg]
  create_duration = "10s"
  destroy_duration = "10s"
}

##### This storage_account is for azurerm_monitor_diagnostic_setting ####

# resource "azurerm_storage_account" "storage_account" {
#   name                     = "storageaccounttestkv"
#   resource_group_name      = azurerm_resource_group.kv_rg.name
#   location                 = azurerm_resource_group.kv_rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

#   depends_on = [time_sleep.wait_10_seconds]
# }

resource "azurerm_key_vault" "keyvault" {
  name                        = format("%s-kv", lower(var.name))
  location            = var.create_rg ? tostring(azurerm_resource_group.kv_rg[0].location) : tostring(data.azurerm_resource_group.kv_rg[0].location)
  resource_group_name = var.create_rg ? tostring(azurerm_resource_group.kv_rg[0].name) : tostring(data.azurerm_resource_group.kv_rg[0].name)
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled    = true
  public_network_access_enabled = false

  sku_name = var.sku_name

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List"
    ]

    secret_permissions = [
      "Get",
      "List"
    ]

    storage_permissions = [
      "Get",
      "List"
    ]
  }

  dynamic "network_acls" {
    for_each = var.network_acls != null ? [true] : []
    content {
      bypass                     = var.network_acls.bypass
      default_action             = var.network_acls.default_action
      ip_rules                   = var.network_acls.ip_rules
      virtual_network_subnet_ids = var.network_acls.virtual_network_subnet_ids
    }
  
  # depends_on = [time_sleep.wait_10_seconds]
  }
}

resource "azurerm_private_endpoint" "key_vault_private_endpoint" {
  name                = var.key_vault_private_endpoint_name
  location            = var.create_rg ? tostring(azurerm_resource_group.kv_rg[0].location) : tostring(data.azurerm_resource_group.kv_rg[0].location)
  resource_group_name = var.create_rg ? tostring(azurerm_resource_group.kv_rg[0].name) : tostring(data.azurerm_resource_group.kv_rg[0].name)
  subnet_id           = data.azurerm_subnet.default-subnet.id

  private_service_connection {
    name                           = var.private_service_connection
    private_connection_resource_id = azurerm_key_vault.keyvault.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
  depends_on = [time_sleep.wait_10_seconds]
}

# resource "azurerm_monitor_diagnostic_setting" "monitor_diagnostic" {
#   name               = var.monitor_diagnostic_name
#   target_resource_id = azurerm_key_vault.keyvault.id
#   storage_account_id = azurerm_storage_account.storage_account.id

#   log {
#     category = var.log_category

#     retention_policy {
#       enabled = false
#     }
#   }

#   metric {
#     category = "AllMetrics"

#     retention_policy {
#       enabled = false
#     }
#   }
# }

