# https://www.terraform.io/docs/providers/google/r/container_cluster.html
# https://compositecode.blog/2017/10/23/build-a-kubernetes-cluster-on-google-cloud-platform-with-terraform/
/* connect to the cluster:
 gcloud container clusters get-credentials var.cluster_name --region var.region --project var.project
*/
resource "google_container_cluster" "gcp_kubernetes" {
  name     = var.cluster_name
  location = var.region

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1


  master_auth {
    username = var.admin_username
    password = var.admin_password

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}


resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = var.pool_name
  location   = var.region
  cluster    = google_container_cluster.gcp_kubernetes.name
  node_count = var.gcp_node_count

  node_config {
    preemptible  = true
    machine_type = var.machine_type["dev"]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}