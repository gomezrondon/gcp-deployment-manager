module "instance" {
  source = "../../virtual_machine"
  instance_count = 1
  zone = "us-west1-b"
}

module "bucket" {
  source = "../../bucket"
  bucket_name = "my-new-bucket-1"
  location = "us-central1" // overwrite
}