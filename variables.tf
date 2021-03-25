variable "location" {
  type        = string
  description = "Azure Region location"
}

variable "azurerm_resource_group_name" {
  type        = string
  description = "Azure Resource Group Name"
}

variable "sqlserver_name" {
  type        = string
  description = "The name of the Microsoft SQL Server. This needs to be globally unique within Azure."
}

variable "admin_login" {
  type        = string
  description = "The administrator login name for the new server."
}

variable "sqldb_name" {
  type        = string
  description = "The name of the database"
}

variable "keyvault_name" {
  type        = string
  description = "The name of thekeyvault"
}

variable "environment" {
  type        = string
  description = "Resource Tags ENVIRONMENT Value"
}

