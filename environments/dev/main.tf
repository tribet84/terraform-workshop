variable "location" {
  default = "NorthEurope"
 }

provider "azurerm" {
  version         = "~> 1.1"
  tenant_id       = "4af8322c-80ee-4819-a9ce-863d5afbea1c"
  subscription_id = "d6f20e81-c8f9-4d3e-91ee-4ccf290b8e2b"
  client_id       = "ca07cef4-53b8-4dda-b851-3a3a39bfa4d2"
  client_secret   = "here goes your secret"
}

module "resourceGroup_workshop" {
  source              = "../../modules/resource_group"
  resource_group_name = "RG-Terraform-Workshop"
  location            = "${var.location}"
}

module "namespace_workshop" {
  source              = "../../modules/asb_namespace"
  asb_namespace       = "Terraform-Workshop"
  location            = "${var.location}"
  resource_group_name = "${module.resourceGroup_workshop.resource_group_name}"
  sku                 = "standard"
}

/* Here goes your topic */

/* Here goes your subscription */