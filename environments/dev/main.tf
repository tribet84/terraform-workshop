variable "location" {
  default = "NorthEurope"
 }

provider "azurerm" {
  version         = "~> 1.1"
  tenant_id       = "4af8322c-80ee-4819-a9ce-863d5afbea1c"
  subscription_id = "d6f20e81-c8f9-4d3e-91ee-4ccf290b8e2b"
  client_id       = "4c8f2ef5-9686-463a-aa79-ffc7ffa0738e"
  client_secret   = "fe226316-064d-4996-abc0-0d325cdbfe69"
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

/* Ignore for now ;)

 module "blueprint_buyers_remorse_dev" {
   source                   = "../../../blueprints/workshop"
   location                 = "NorthEurope"
   orders_history_namespace = "dev-history-bus"
 }
*/
