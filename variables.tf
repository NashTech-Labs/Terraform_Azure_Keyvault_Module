//====================================================================
#                          VARIABLES
//=====================================================================

variable "create_rg" {
  type        = bool
  default     = false
  description = "Optional Input - Create a new resource group for this deployment. (Set to false to use existing resource group)"
}

variable "resource_group_name" {
  description = "Name of resource group to deploy resources in."
  default     = "kv-rg-test"
}

# ======================= VNET & SUBNET ===============================
variable "subnet_name" {
  description = "Name of the subnet required for azurerm_private_endpoint "
  default     = "default"
}
variable "vnet_name" {
  description = "Name of the vnet required for subnet "
  default     = "test-vnet"
}
variable "vnet_rg_name" {
  description = "Name of resource group to deploy vnet in."
  default     = "kv-rg-test"
}

# ============================ KEY- VAULT ===============================

variable "name" {
  description = "Name of key vault account."
  default     = "DCT-test"
}

variable "location" {
  description = "Azure location where resources should be deployed."
  default     = "West Europe"
}

variable "sku_name" {
  description = "The Name of the SKU used for this Key Vault. Possible values are `standard` and `premium`."
  default     = "standard"
}

variable "enabled_for_deployment" {
  description = "Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. Defaults to `false`."
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to `true`."
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft-deleted."
  type        = number
  default     = 90
}

variable "access_policies" {
  description = "Map of access policies for an object_id (user, service principal, security group) to backend."
  type = list(object({
    object_id               = string,
    # certificate_permissions = list(string),
    key_permissions         = list(string),
    secret_permissions      = list(string),
    storage_permissions     = list(string),
  }))
  default = []
}

variable "network_acls" {
  description = "Network rules to apply to key vault."
  type = object({
    bypass                     = string,
    default_action             = string,
    ip_rules                   = list(string),
    virtual_network_subnet_ids = list(string),
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}

# ============================= PRIVATE ENDPOINT =============================

variable "key_vault_private_endpoint_name" {
  description = "Name of key_vault_private_endpoint_name."
  default     = "example-keyvault-endpoint"
}

variable "private_service_connection" {
  description = "Name of private_service_connection."
  default     = "example-keyvault-connection"
}

# =========================== MONITOR DIAGNOSTIC SETTING =========================

################### only needed while monitor diagnostic setting ##################

# variable "monitor_diagnostic_name" {
#   description = "Name of monitor_diagnostic_name."
#   default     = "example"
# }

# variable "log_category" {
#   default     = "AuditEvent"
# }


