variable "project" { 
    default = "clear-gantry-123"
}

variable "region" {
  default = "us-west1"
}

variable "zone" {
  default = "us-west1-a"
}

variable "machine_type" {
  default = "f1-micro"
}

variable "image" {
  default = "debian-cloud/debian-9"
}

variable "name_count" {
  default = ["server1","server2","server3"]
}