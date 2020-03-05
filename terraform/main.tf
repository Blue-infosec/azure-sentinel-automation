provider "azurerm" {
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = var.rg.name
  location = var.rg.location
}

# Deploy Log Analytics Workspace for Sentinel
resource "azurerm_log_analytics_workspace" "la_workspace" {
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  name                = var.law.name
  sku                 = var.law.sku
  retention_in_days   = var.law.retention
}

# Deploy Sentinel inside LA Workspace
resource "azurerm_log_analytics_solution" "la_solution_sentinel" {
  solution_name         = "SecurityInsights"
  location              = azurerm_resource_group.resource_group.location
  resource_group_name   = azurerm_resource_group.resource_group.name
  workspace_resource_id = azurerm_log_analytics_workspace.la_workspace.id
  workspace_name        = azurerm_log_analytics_workspace.la_workspace.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
}

# Configure RBAC for Azure built-in Sentinel roles
# Scope is set as Workspace, could also be Subscription or Resource Group
resource "azurerm_role_assignment" "rbac_sentinel_contributor" {
  scope                = azurerm_log_analytics_workspace.la_workspace.id
  role_definition_name = "Azure Sentinel Contributor"
  principal_id         = var.rbac.aad_group_id_sentinel_contributors
}

resource "azurerm_role_assignment" "rbac_sentinel_responder" {
  scope                = azurerm_log_analytics_workspace.la_workspace.id
  role_definition_name = "Azure Sentinel Responder"
  principal_id         = var.rbac.aad_group_id_sentinel_responders
}

resource "azurerm_role_assignment" "rbac_sentinel_reader" {
  scope                = azurerm_log_analytics_workspace.la_workspace.id
  role_definition_name = "Azure Sentinel Reader"
  principal_id         = var.rbac.aad_group_id_sentinel_readers
}
