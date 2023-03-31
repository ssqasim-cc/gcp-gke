terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.51.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file_path)

  project = var.project_id
  region  = var.region
  zone    = var.main_zone
}

module "google_networks" {
  source = "../module/network"

  project_id = var.project_id
  region     = var.region
}

module "google_kubernetes_cluster" {
  source = "../module/kubernetes_cluster"

  project_id                 = var.project_id
  cluster_name               = var.cluster_name
  machine_type               = var.machine_type
  region                     = var.region
  node_zones                 = var.cluster_node_zones
  service_account            = var.service_account
  enable_monitoring          = var.enable_monitoring
  enable_logging             = var.enable_logging
  network_name               = module.google_networks.network.name
  subnet_name                = module.google_networks.subnet.name
  master_ipv4_cidr_block     = module.google_networks.cluster_master_ip_cidr_range
  pods_ipv4_cidr_block       = module.google_networks.cluster_pods_ip_cidr_range
  services_ipv4_cidr_block   = module.google_networks.cluster_services_ip_cidr_range
  authorized_ipv4_cidr_block = "${module.bastion.ip}/32"
  depends_on = [
    module.bastion,
    module.google_networks
  ]
}

module "bastion" {
  source = "../module/bastion"

  project_id   = var.project_id
  region       = var.region
  zone         = var.main_zone
  bastion_name = "app-cluster"
  network_name = module.google_networks.network.name
  subnet_name  = module.google_networks.subnet.name
  depends_on   = [module.google_networks]
}

module "cloudsql" {
  source = "../module/cloudsql"

  project_id        = var.project_id
  region            = var.region
  availability_zone = var.main_zone
  subnet_name       = module.google_networks.db_network.id
  database_name     = var.database_name
  db_tier           = var.db_tier
  multi_az          = var.multi_az
  root_password     = var.root_password
  instance_name     = var.instance_name
  depends_on        = [module.google_networks]
}
