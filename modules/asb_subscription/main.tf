variable "subscription_name" {}
variable "resource_group_name" {}
variable "asb_namespace" {}
variable "topic_name" {}

resource "azurerm_servicebus_subscription" "subscription" {
  name                                 = "${var.subscription_name}"
  resource_group_name                  = "${var.resource_group_name}"
  namespace_name                       = "${var.asb_namespace}"
  topic_name                           = "${var.topic_name}"
  max_delivery_count                   = 10
  enable_batched_operations            = true
  dead_lettering_on_message_expiration = true
}

output "subscription_name" {
  value = "${azurerm_servicebus_subscription.subscription.name}"
}
