variable "asb_namespace" {}
variable "location" {}
variable "resource_group_name" {}
variable "sku" {}

resource "azurerm_servicebus_namespace" "namespace" {
  name                = "${var.asb_namespace}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "${var.sku}"
}

output "asb_namespace" {
  value = "${azurerm_servicebus_namespace.namespace.name}"
}
