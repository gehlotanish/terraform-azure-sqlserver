provider azurerm {
  features {}
}

resource "random_string" "password" {
  length           = 32
  special          = true
  override_special = "/@\" "
}

resource "azurerm_mssql_server" "example" {
  name                          = var.sqlserver_name
  resource_group_name           = var.azurerm_resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.admin_login
  administrator_login_password  = random_string.password.result
  public_network_access_enabled = false

  tags = {
    environment = var.environment
  }
}

resource "azurerm_sql_database" "example" {
  name                = var.sqldb_name
  resource_group_name = azurerm_mssql_server.example.resource_group_name
  location            = azurerm_mssql_server.example.location
  server_name         = azurerm_mssql_server.example.name

  tags = {
    environment = var.environment
  }
}


### Key vault

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "example" {
  name                       = var.keyvault_name
  location                   = var.location
  resource_group_name        = var.azurerm_resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
      "purge",
      "recover"
    ]
  }
}

resource "azurerm_key_vault_secret" "example" {
  name         = "${var.sqlserver_name}-sqladmin"
  value        = azurerm_mssql_server.example.administrator_login_password
  key_vault_id = azurerm_key_vault.example.id
}
