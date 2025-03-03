# App Service Plan (Windows-based for .NET apps)
resource "azurerm_app_service_plan" "example" {
  name                = "example-appserviceplan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "Windows"  # Specify "Windows" for .NET apps, not Linux
  reserved            = false     # Set to false for Windows-based app services

  sku {
    tier = "Standard"  # Options like "Basic", "Premium", etc.
    size = "S1"        # This can be S1, P1v2, etc.
  }
}

# First App Service (using .NET Framework v4.0)
resource "azurerm_app_service" "app_service_1" {
  name                = "example-app-service-1"   # Unique name for the first app service
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"   # Specify the .NET framework version (can be v4.0, v5, or .NET 6, etc.)
    scm_type                 = "LocalGit" # Optionally configure Git deployment
  }

  app_settings = {
    "SOME_KEY"   = "some-value"
    "APP_ENV"    = "production"  # Example environment variable for app environment
    "LOG_LEVEL"  = "info"        # Example environment variable for log level
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}

# Second App Service (using .NET Framework v4.0)
resource "azurerm_app_service" "app_service_2" {
  name                = "example-app-service-2"   # Unique name for the second app service
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"   # Specify the .NET framework version (can be v4.0, v5, or .NET 6, etc.)
    scm_type                 = "LocalGit" # Optionally configure Git deployment
  }

  app_settings = {
    "SOME_KEY"   = "some-value"
    "APP_ENV"    = "development"  # Example environment variable for app environment
    "LOG_LEVEL"  = "debug"        # Example environment variable for log level
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}
