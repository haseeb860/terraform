# App Service Plan
resource "azurerm_app_service_plan" "example" {
  name                = "example-app-service-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "Linux"  # You can change it to "Windows" if you're using a Windows-based App Service
  reserved            = true     # Set to true for Linux, false for Windows

  sku {
    tier = "Standard"          # You can adjust this to "Basic", "Premium", etc.
    size = "S1"                # Standard SKU, size S1 is one of the common options
  }

  tags = {
    environment = "production"
    purpose     = "app-service"
  }
}

# First App Service
resource "azurerm_app_service" "app_service_1" {
  name                = "app-service-1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  tags = {
    environment = "production"
    purpose     = "web-app-1"
  }
}

# Second App Service
resource "azurerm_app_service" "app_service_2" {
  name                = "app-service-2"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  tags = {
    environment = "production"
    purpose     = "web-app-2"
  }
}
