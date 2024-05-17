# Variables générales:
locals {
  subscription_id     = "c56aea2c-50de-4adc-9673-6a8008892c21"
  resource_group      = "Sebastien_K"
  location            = "francecentral" # data.azurerm_resource_group.main.location
  resource_group_name = lower(replace(local.resource_group, "_", ""))
}

# Network variables (only 2 networks)
locals {
  network_europe = ["10.1.0.0/16"]
  subnets_europe = {
    "test"  = "10.1.1.0/24"
    "aks"   = "10.1.2.0/24"
    "appgw" = "10.1.3.0/24"
  }
}

# Variables pour la machine virtuelle
locals {
  public_ip_allocation_method = "Static"
  vm_domain_name_label        = "${local.resource_group_name}-vm"
  public_ip_sku               = "Standard"

  vm_size = "Standard_D4_v4"

  os_disk_caching           = "ReadWrite"
  os_disk_create_option     = "FromImage"
  os_disk_managed_disk_type = "Standard_LRS"

  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_sku       = "22_04-lts-gen2"
  image_version   = "latest"

  ip_simplon = "82.126.234.200"

  admin_username = "adminuser"
  path           = "/home/${local.admin_username}/.ssh/authorized_keys"
  ssh_key        = tls_private_key.admin_rsa.public_key_openssh

  ssh_ip_filter = concat([for user_value in local.users : user_value.ip], [local.ip_simplon])
}

# Add users 
locals {
  users = {
    sebastien = {
      sshkey      = "sebastien"
      private_key = "sebastien"
      ip          = "83.195.211.184"
    }
  }
}

# Variables pour l'application Gateway
locals {
  app_domain_name_label = "${local.resource_group_name}-gateway"
  sku_name              = "Standard_v2"
  tier                  = "Standard_v2"
  cookie_based_affinity = "Disabled"
  backend_port          = 80
  backend_protocol      = "Http"
  frontend_port         = 80
  frontend_protocol     = "Http"
  rule_type             = "Basic"
  gateway_name          = "gateway"
}

# Variables pour le cluster AKS
locals {
  aks_name              = "aks"
  aks_domain_name_label = "${local.resource_group_name}-${local.aks_name}"
  pool_name             = "${local.aks_name}pool"
  aks_vm_size           = "Standard_A2_v2"
}

# Variables for helm module - google_ob, Ingress
locals {
  google_ob_name               = "onlineboutique"
  google_ob_chart              = "oci://us-docker.pkg.dev/online-boutique-ci/charts/onlineboutique"
  google_ob_namespace_creation = true
  google_ob_namespace          = "onlineboutique"
  google_ob_version            = "0.9.0"
  ingress_chart                = "ingress-azure"
  ingress_name                 = "ingress-azure"
  ingress_namespace_creation   = true
  ingress_namespace            = "ingress-azure"
  ingress_repository           = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/"
}