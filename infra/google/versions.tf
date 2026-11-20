terraform {
  required_version = ">= 1.17.2, < 2.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "8.12.0"
    }
  }
}

# Use ADC/impersonation. No service-account keys belong in this module.
provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_project" "target" {
  project_id = var.project_id
}
