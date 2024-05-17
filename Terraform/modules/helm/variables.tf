variable "resource_group" {
  type        = string
  description = "(Required) The name of the resource group."
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group."
  nullable    = false
}

variable "subscription_id" {
  type        = string
  description = "(Required) The subscription id."
  nullable    = false
}

variable "server_domain" {
  type        = string
  description = "(Required) The fqdn of the server"
  nullable    = false
}

# ---------------------------------------------------------------------------------
# OnlineBoutique Google App

variable "google_ob_chart" {
  type        = string
  description = "(Required) The chart of google_ob."
  nullable    = false
}

variable "google_ob_name" {
  type        = string
  description = "(Required) The name of google_ob in resource helm."
  nullable    = false
}

variable "google_ob_namespace_creation" {
  type        = bool
  description = "(Required) Creation of the namaspace for ingress."
  nullable    = false
  default     = true
}

variable "google_ob_namespace" {
  type        = string
  description = "(Required) The namespace of google_ob in resource helm."
  nullable    = false
}

variable "google_ob_version" {
  type        = string
  description = "(Required) The repository of google_ob in resource helm."
  nullable    = false
}

# ---------------------------------------------------------------------------------
# Ingress
variable "ingress_chart" {
  type        = string
  description = "(Required) The chart of ingress."
  nullable    = false
}

variable "ingress_name" {
  type        = string
  description = "(Required) The name of ingress in resource helm."
  nullable    = false
}

variable "ingress_namespace_creation" {
  type        = bool
  description = "(Required) Creation of the namaspace for ingress."
  nullable    = false
  default     = true
}

variable "ingress_namespace" {
  type        = string
  description = "(Required) The namespace of ingress in resource helm."
  nullable    = false
}

variable "ingress_repository" {
  type        = string
  description = "(Required) The repository of ingress in resource helm."
  nullable    = false
}

variable "gateway_name" {
  type        = string
  description = "(Required) The name of the gateway."
  nullable    = false
}
