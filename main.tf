# Providing the Azure account on which our resources will be created
provider "azurerm" {
  features {}
  subscription_id = "eb790b59-ab45-4869-82c5-7b06dcfd6184"  # Your Subscription ID
  tenant_id       = "91a8fddf-7ed5-4867-b541-e85a402cf168"
}

# Step 1: Creating a Resource Group in which our resources will be created
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

# Step 2: Create a SQL Server database engine in which different databases will be created
resource "azurerm_mssql_server" "server" {
  name                         = "sql-server-terr"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "adminuser"
  administrator_login_password = "adminpassword@_@23"
}

# Step 3: Create SQL Elastic Pool in which we will separately create our databases
resource "azurerm_mssql_elasticpool" "sql-elasticpool" {
  location            = azurerm_resource_group.example.location
  name                = "kavsql-elasticpool"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mssql_server.server.name

  # Set max_size_gb to a valid value (50 GB minimum)
  max_size_gb = 9.7656250

  sku {
    name     = "BasicPool"
    tier     = "Basic"
    capacity = 100
  }

  per_database_settings {
    min_capacity = 0  # Minimum capacity per database
    max_capacity = 5  # Maximum capacity per database
  }
}

# Step 4: Create Databases (5 in Elastic Pool, 1 separate)
resource "azurerm_mssql_database" "platform_db" {
  name            = "platformdb"
  server_id       = azurerm_mssql_server.server.id  # Use server_id here
  elastic_pool_id = azurerm_mssql_elasticpool.sql-elasticpool.id
}

resource "azurerm_mssql_database" "crm_db" {
  name            = "crmdb"
  server_id       = azurerm_mssql_server.server.id  # Use server_id here
  elastic_pool_id = azurerm_mssql_elasticpool.sql-elasticpool.id
}

resource "azurerm_mssql_database" "cfo_db" {
  name            = "cfodb"
  server_id       = azurerm_mssql_server.server.id  # Use server_id here
  elastic_pool_id = azurerm_mssql_elasticpool.sql-elasticpool.id
}

resource "azurerm_mssql_database" "background_db" {
  name            = "backgrounddb"
  server_id       = azurerm_mssql_server.server.id  # Use server_id here
  elastic_pool_id = azurerm_mssql_elasticpool.sql-elasticpool.id
}

resource "azurerm_mssql_database" "pfm_db" {
  name            = "pfmdb"
  server_id       = azurerm_mssql_server.server.id  # Use server_id here
  elastic_pool_id = azurerm_mssql_elasticpool.sql-elasticpool.id
}

# Step 5: Create Logs DB separately (outside of the Elastic Pool)
resource "azurerm_mssql_database" "logs_db" {
  name      = "logsdb"
  server_id = azurerm_mssql_server.server.id  # Use server_id here
}

# Step 6: Create Key Vaults for storing connection strings
resource "azurerm_key_vault" "kv_1" {
  name                = "example-kv-1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tenant_id           = "91a8fddf-7ed5-4867-b541-e85a402cf168"  # Replace with your actual tenant ID
  sku_name            = "standard"
}

# Step 7: Create Key Vault Secrets for storing connection strings

# Secret for platform_db connection string
resource "azurerm_key_vault_secret" "platform_db_connection_string" {
  name         = "platform-db-connection-string"
  value        = "Server=tcp:${azurerm_mssql_server.server.fully_qualified_domain_name},1433;Initial Catalog=platformdb;Persist Security Info=False;User ID=OwnerPlatform;Password=password123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = azurerm_key_vault.kv_1.id
}

# Secret for crm_db connection string
resource "azurerm_key_vault_secret" "crm_db_connection_string" {
  name         = "crm-db-connection-string"
  value        = "Server=tcp:${azurerm_mssql_server.server.fully_qualified_domain_name},1433;Initial Catalog=crmdb;Persist Security Info=False;User ID=OwnerCRM;Password=password123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = azurerm_key_vault.kv_1.id
}

# Secret for cfo_db connection string
resource "azurerm_key_vault_secret" "cfo_db_connection_string" {
  name         = "cfo-db-connection-string"
  value        = "Server=tcp:${azurerm_mssql_server.server.fully_qualified_domain_name},1433;Initial Catalog=cfodb;Persist Security Info=False;User ID=OwnerCFO;Password=password123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = azurerm_key_vault.kv_1.id
}

# Secret for background_db connection string
resource "azurerm_key_vault_secret" "background_db_connection_string" {
  name         = "background-db-connection-string"
  value        = "Server=tcp:${azurerm_mssql_server.server.fully_qualified_domain_name},1433;Initial Catalog=backgrounddb;Persist Security Info=False;User ID=OwnerBackground;Password=password123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = azurerm_key_vault.kv_1.id
}

# Secret for pfm_db connection string
resource "azurerm_key_vault_secret" "pfm_db_connection_string" {
  name         = "pfm-db-connection-string"
  value        = "Server=tcp:${azurerm_mssql_server.server.fully_qualified_domain_name},1433;Initial Catalog=pfmdb;Persist Security Info=False;User ID=OwnerPFM;Password=password123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = azurerm_key_vault.kv_1.id
}

# Secret for logs_db connection string
resource "azurerm_key_vault_secret" "logs_db_connection_string" {
  name         = "logs-db-connection-string"
  value        = "Server=tcp:${azurerm_mssql_server.server.fully_qualified_domain_name},1433;Initial Catalog=logsdb;Persist Security Info=False;User ID=OwnerLogs;Password=password123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = azurerm_key_vault.kv_1.id
}

# Step 8: Create SQL users after deployment using `null_resource` and `local-exec`
resource "null_resource" "create_sql_users" {
  depends_on = [
    azurerm_mssql_server.server,
    azurerm_mssql_database.platform_db,
    azurerm_mssql_database.crm_db,
    azurerm_mssql_database.cfo_db,
    azurerm_mssql_database.background_db,
    azurerm_mssql_database.pfm_db,
    azurerm_mssql_database.logs_db
  ]

  provisioner "local-exec" {
    command = <<EOT
      az sql db user create \
        --name "platformuser" \
        --server "${azurerm_mssql_server.server.name}" \
        --resource-group "${azurerm_resource_group.example.name}" \
        --database "platformdb" \
        --password "platformpassword123" \
        --admin-user "adminuser" \
        --admin-password "adminpassword@_@23"
      
      az sql db user create \
        --name "crmuser" \
        --server "${azurerm_mssql_server.server.name}" \
        --resource-group "${azurerm_resource_group.example.name}" \
        --database "crmdb" \
        --password "crmpassword123" \
        --admin-user "adminuser" \
        --admin-password "adminpassword@_@23"
    EOT
  }
}

# Outputs
output "platform_db_connection_string" {
  value = "Server=tcp:${azurerm_mssql_server.server.name}.database.windows.net,1433;Database=platformdb;User ID=OwnerPlatform;Password=password123;Encrypt=true;TrustServerCertificate=false;Connection Timeout=30;"
}

output "crm_db_connection_string" {
  value = "Server=tcp:${azurerm_mssql_server.server.name}.database.windows.net,1433;Database=crmdb;User ID=OwnerCRM;Password=password123;Encrypt=true;TrustServerCertificate=false;Connection Timeout=30;"
}

output "cfo_db_connection_string" {
  value = "Server=tcp:${azurerm_mssql_server.server.name}.database.windows.net,1433;Database=cfodb;User ID=OwnerCFO;Password=password123;Encrypt=true;TrustServerCertificate=false;Connection Timeout=30;"
}

output "background_db_connection_string" {
  value = "Server=tcp:${azurerm_mssql_server.server.name}.database.windows.net,1433;Database=backgrounddb;User ID=OwnerBackground;Password=password123;Encrypt=true;TrustServerCertificate=false;Connection Timeout=30;"
}

output "pfm_db_connection_string" {
  value = "Server=tcp:${azurerm_mssql_server.server.name}.database.windows.net,1433;Database=pfmdb;User ID=OwnerPFM;Password=password123;Encrypt=true;TrustServerCertificate=false;Connection Timeout=30;"
}

output "logs_db_connection_string" {
  value = "Server=tcp:${azurerm_mssql_server.server.name}.database.windows.net,1433;Database=logsdb;User ID=OwnerLogs;Password=password123;Encrypt=true;TrustServerCertificate=false;Connection Timeout=30;"
}
