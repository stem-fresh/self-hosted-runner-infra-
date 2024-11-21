resource "google_storage_bucket" "terraform_state_file" {
  name          = "self-runner-infra-statefile"  # Replace with your bucket name
  location      = var.region      # Ensure this matches the provider's region
  storage_class = "STANDARD"

  versioning {
    enabled = true
  }
}

# backend.tf
terraform {
  backend "gcs" {
    bucket = "self-runner-infra-statefile"  # Same bucket name as above
    prefix = "terraform/state"
  }
}