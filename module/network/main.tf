locals {
  network_name                   = var.project_id
  subnet_name                    = "${google_compute_network.vpc.name}-subnet"
  cluster_master_ip_cidr_range   = "10.100.100.0/28"
  cluster_pods_ip_cidr_range     = "10.101.0.0/16"
  cluster_services_ip_cidr_range = "10.102.0.0/16"
}


resource "google_compute_network" "vpc" {
  name                            = local.network_name
  auto_create_subnetworks         = false
  routing_mode                    = "GLOBAL"
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "subnet" {
  name                     = "${var.project_id}-subnet"
  ip_cidr_range            = "10.10.0.0/16"
  region                   = var.region
  network                  = google_compute_network.vpc.name
  private_ip_google_access = true
}

resource "google_compute_global_address" "private_ip_block" {
  name         = "db-ip-block"
  description  = "A block of private IP addresses that are accessible only from within the VPC."
  purpose      = "VPC_PEERING"
  address_type = "INTERNAL"
  ip_version   = "IPV4"
  # We don't specify a address range because Google will automatically assign one for us.
  prefix_length = 24 #
  network       = google_compute_network.vpc.self_link
}

# This enables private services access. This makes it possible for instances
# within the VPC and Google services to communicate exclusively using internal
# IP addresses. Details here:
#   https://cloud.google.com/sql/docs/postgres/configure-private-services-access
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_block.name]
}

resource "google_compute_route" "egress_internet" {
  name             = "egress-internet"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.vpc.name
  next_hop_gateway = "default-internet-gateway"
}

resource "google_compute_router" "router" {
  name    = "${local.network_name}-router"
  region  = google_compute_subnetwork.subnet.region
  network = google_compute_network.vpc.name
}

resource "google_compute_router_nat" "nat_router" {
  name                               = "${google_compute_subnetwork.subnet.name}-nat-router"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.subnet.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
