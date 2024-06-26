variable "resource_group" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}

variable "location_1" {
  type        = string
  description = "(Required) The location/region where the virtual network is created. Changing this forces a new resource to be created."
  nullable    = false
  default     = "westeurope"
}

variable "vnet_1" {
  type        = list(string)
  description = "(Required) The address space that is used by the virtual network. You can supply more than one address space."
  nullable    = false
}

variable "subnet_1" {
  type        = map(any)
  description = "(Required) A list of address prefixes to use for the subnets."
  default     = {}
}
