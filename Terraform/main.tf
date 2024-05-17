# Vnet, Subnets and Peering
module "vnet" {
  source              = "./modules/network"
  resource_group      = local.resource_group
  resource_group_name = local.resource_group_name
  location_1          = local.location
  vnet_1              = local.network_europe
  subnet_1            = local.subnets_europe
}

module "vm" {
  source              = "./modules/vm"
  resource_group      = local.resource_group
  resource_group_name = local.resource_group_name
  location            = local.location
  vm_size             = local.vm_size

  os_disk_caching           = local.os_disk_caching
  os_disk_create_option     = local.os_disk_create_option
  os_disk_managed_disk_type = local.os_disk_managed_disk_type

  image_publisher = local.image_publisher
  image_offer     = local.image_offer
  image_sku       = local.image_sku
  image_version   = local.image_version

  admin_username = local.admin_username
  path           = local.path
  ssh_key        = local.ssh_key
  ssh_ip_filter  = local.ssh_ip_filter

  public_ip_allocation_method = local.public_ip_allocation_method
  domain_name_label           = local.vm_domain_name_label
  public_ip_sku               = local.public_ip_sku
  subnet_id                   = values(module.vnet.subnet_1_ids)[2]
}

module "gateway" {
  source                      = "./modules/gateway"
  resource_group              = local.resource_group
  resource_group_name         = local.resource_group_name
  location                    = local.location
  public_ip_allocation_method = local.public_ip_allocation_method
  domain_name_label           = local.app_domain_name_label
  public_ip_sku               = local.public_ip_sku
  subnet_id                   = values(module.vnet.subnet_1_ids)[0]
  name                        = local.gateway_name
  sku_name                    = local.sku_name
  cookie_based_affinity       = local.cookie_based_affinity
  backend_port                = local.backend_port
  backend_protocol            = local.backend_protocol
  frontend_protocol           = local.frontend_protocol
  frontend_port               = local.frontend_port
  rule_type                   = local.rule_type
  tier                        = local.tier
}

module "aks" {
  source                      = "./modules/cluster"
  cluster_name                = local.aks_name
  resource_group              = local.resource_group
  resource_group_name         = local.resource_group_name
  location                    = local.location
  public_ip_allocation_method = local.public_ip_allocation_method
  domain_name_label           = local.aks_domain_name_label
  public_ip_sku               = local.public_ip_sku
  subnet_id                   = values(module.vnet.subnet_1_ids)[1]
  vm_size                     = local.aks_vm_size
  pool_name                   = local.pool_name
}

module "cert_manager" {
  source            = "./modules/cert_manager"
  letsencrypt_email = "skusz@simplonformations.onmicrosoft.com"
}

module "helm" {
  depends_on                 = [module.aks, module.gateway]
  resource_group             = local.resource_group
  resource_group_name        = local.resource_group_name
  subscription_id            = local.subscription_id
  server_domain              = module.gateway.gateway_fqdn
  source                     = "./modules/helm"
  google_ob_name             = local.google_ob_name
  google_ob_chart            = local.google_ob_chart
  google_ob_namespace        = local.google_ob_namespace
  google_ob_version          = local.google_ob_version
  ingress_chart              = local.ingress_chart
  ingress_name               = local.ingress_name
  ingress_namespace_creation = local.ingress_namespace_creation
  ingress_namespace          = local.ingress_namespace
  ingress_repository         = local.ingress_repository
  gateway_name               = module.gateway.gateway_name
}