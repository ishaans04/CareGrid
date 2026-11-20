# Supply an existing private, versioned GCS bucket via -backend-config.
# Offline validation/tests use terraform init -backend=false.
terraform {
  backend "gcs" {}
}
