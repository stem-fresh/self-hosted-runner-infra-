provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = var.bool_false
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = var.public_subnet_name
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = var.public_subnet_ip_range
  region        = var.region
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = var.private_subnet_name
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = var.private_subnet_ip_range
  region        = var.region
  private_ip_google_access = var.bool_true

  secondary_ip_range {
    range_name    = var.pods
    ip_cidr_range = var.pod_ip_range
  }

  secondary_ip_range {
    range_name    = var.services
    ip_cidr_range = var.service_ip_range
  }
}

resource "google_compute_router" "nat_router" {
  name    = var.router_name
  network = google_compute_network.vpc_network.name
  region  = var.region
}

resource "google_compute_router_nat" "nat_gw" {
  name                               = var.nat_name
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = var.nat_source_ip_ranges
}

resource "google_compute_firewall" "allow_internal" {
  name    = var.allow_internal_firewall_name
  network = google_compute_network.vpc_network.name

  allow {
    protocol = var.icmp
  }

  allow {
    protocol = var.tcp
    ports    = var.tcp_port_range
  }

  allow {
    protocol = var.udp
    ports    = var.udp_port_range
  }

  source_ranges = var.internal_source_ranges
}


