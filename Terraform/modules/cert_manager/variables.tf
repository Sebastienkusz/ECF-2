variable "name" {
  description = "The name of the Helm release."
  type        = string
  default     = "cert-manager"
}

variable "namespace" {
  description = "The namespace in which to install the Helm release."
  type        = string
  default     = "cert-manager"
}

variable "create_namespace" {
  description = "Whether to create the namespace if it does not yet exist."
  type        = bool
  default     = true
}

variable "chart_version" {
  description = "The version of the Helm chart to install. If omitted, the latest version is installed."
  type        = string
  default     = null
}

variable "deploy_letsencrypt_issuer" {
  description = "Whether to deploy a Let's Encrypt ClusterIssuer."
  type        = bool
  default     = true
}

variable "letsencrypt_email" {
  description = "The email address to use for Let's Encrypt registration."
  type        = string
  default     = null
}
