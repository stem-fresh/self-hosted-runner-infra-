# backend.tf
terraform {
  backend "gcs" {
    bucket = "self-runner-infra-statefile"  # Same bucket name as above
    prefix = "terraform/state"
  }
}