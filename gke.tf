resource "google_container_cluster" "primary" {
  name                     = var.gke_cluster_name
  location                 = var.gke_location
  network                  = google_compute_network.vpc_network.name
  subnetwork               = google_compute_subnetwork.private_subnet.name
  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods
    services_secondary_range_name = var.services
  }

  private_cluster_config {
    enable_private_endpoint = var.bool_false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ipv4
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name     = var.node_pool_name
  cluster  = google_container_cluster.primary.name
  location = google_container_cluster.primary.location

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  node_config {
    machine_type = var.node_pool_machine_type
    disk_type    = "pd-ssd"
    disk_size_gb = var.node_disk_size

    oauth_scopes = var.oauth_scope_url

    metadata = {
      disable-legacy-endpoints = var.bool_true
    }

    tags = ["private-node"]

    service_account = var.service_account_email
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }
}