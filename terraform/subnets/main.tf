resource "google_compute_network" "udemy-nt" {
  name = "udemy-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "sub-network" {
  name = "udemy-subnet"
  ip_cidr_range = "10.2.0.0/24"
  region = var.region
  network = google_compute_network.udemy-nt.self_link

}