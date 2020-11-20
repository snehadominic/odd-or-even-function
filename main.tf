# Configure the Azure Provider; azure resource manager provider
provider "azurerm" {
    version = "=2.4.0"

    subscription_id = "a0477d96-fd28-4631-b1e5-a074125867a1"
    client_id       = "c6f21f9c-1a17-4e1a-b796-03acfeb5a944"
    client_secret   = "2_5F_DEu5B9bK4r__pw-tuD90MUR5OF34W"
    tenant_id       = "942f8e86-2cd9-438f-8fba-15fe3b9d1734"
    
    features { }
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
    name     = "rgfnapptest"
    location = "eastus"
}

# Create a storage account to use with function app. Use the location of resource group
resource "azurerm_storage_account" "storage-acct" {
    name = "stazzfnapptest"
    resource_group_name      = azurerm_resource_group.rg.name
    location                 = azurerm_resource_group.rg.location
    account_replication_type = "LRS"
    account_tier             = "Standard"
}

# Create an app service plan
resource "azurerm_app_service_plan" "asp" {
    name                = "fnapptest-asp"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    kind                = "FunctionApp"
    reserved            = true

    sku {
        tier = "Dynamic"
        size = "Y1"
    }
}

# Create function app
resource "azurerm_function_app" "functions" {
    name = "sampleoddorevenfunction"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    app_service_plan_id = azurerm_app_service_plan.asp.id
    storage_connection_string = azurerm_storage_account.storage-acct.primary_connection_string    
}
