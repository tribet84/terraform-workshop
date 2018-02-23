variable "topic_name" {}
variable "resource_group_name" {}
variable "asb_namespace" {}

resource "azurerm_servicebus_topic" "topic" {
  name                      = "${var.topic_name}"
  resource_group_name       = "${var.resource_group_name}"
  namespace_name            = "${var.asb_namespace}"
  enable_partitioning       = false
  enable_batched_operations = true
  max_size_in_megabytes     = 1024 # per partition
}

output "topic_name" {
  value = "${azurerm_servicebus_topic.topic.name}"
}
