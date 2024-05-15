resource "azurerm_virtual_network" "vnet1" {
  name                = "${var.resource_group_name}-vnet-${lower(var.location_1)}"
  location            = var.location_1
  resource_group_name = var.resource_group
  address_space       = var.vnet_1
}

resource "azurerm_subnet" "subnet1" {
  for_each             = var.subnet_1
  name                 = "${var.resource_group_name}-subnet-${each.key}"
  virtual_network_name = azurerm_virtual_network.vnet1.name
  resource_group_name  = var.resource_group
  address_prefixes     = [each.value]
}