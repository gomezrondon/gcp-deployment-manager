variable "project" { 
    default = "PROJECT-ID"
}

variable "region" {
  default = "us-west1"
}

variable "zone" {
  default = "us-west1-a"
}

variable "machine_type" {
  type = "map"
  default = {
    dev = "f1-micro"
    prod = "n1-standard-1"
  }
}

variable "image" {
  default = "debian-cloud/debian-9"
}

variable "name_count" {
  default = ["server1","server2","server3"]
}

// ------------- k8s

variable "cluster_name" {default = "my-gke-cluster"}
variable "admin_username" {default = ""}
variable "admin_password" {default = ""}
//-- node pool
variable "pool_name" {default = "my-node-pool"}
variable "gcp_node_count" {default = 1}
