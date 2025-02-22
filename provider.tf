provider "azurerm" {
  features {}

  subscription_id = eb790b59-ab45-4869-82c5-7b06dcfd6184
  client_id       = 862c0add-851f-48ba-bbf8-d7be02ef6bec
  client_secret   = 573ecb50-cd22-4f19-abcd-8849c32073a4
  tenant_id       = 91a8fddf-7ed5-4867-b541-e85a402cf168
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "terraformstatestorage"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
