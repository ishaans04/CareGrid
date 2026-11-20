locals {
  labels        = { app = "caregrid", team = "duality", environment = "staging" }
  sql_roles     = toset(["api", "watchdog", "migrate", "bootstrap"])
  deploy_jobs   = var.rollout_stage != "foundation"
  deploy_run    = var.rollout_stage == "services"
  artifact_path = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.images.repository_id}"
  # Google's deterministic URL avoids an API<->web resource dependency cycle.
  web_origin = "https://${var.prefix}-web-${data.google_project.target.number}.${var.region}.run.app"
  api_origin = "https://${var.prefix}-api-${data.google_project.target.number}.${var.region}.run.app"
}

resource "google_project_service" "api" {
  for_each = toset([
    "run.googleapis.com", "sqladmin.googleapis.com", "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com", "storage.googleapis.com", "iam.googleapis.com",
    "iamcredentials.googleapis.com", "cloudbuild.googleapis.com", "logging.googleapis.com",
    "monitoring.googleapis.com", "identitytoolkit.googleapis.com", "firebase.googleapis.com"
  ])
  service            = each.key
  disable_on_destroy = false
}

resource "google_service_account" "runtime" {
  for_each     = toset(["web", "api", "watchdog", "migrate", "bootstrap", "build"])
  account_id   = "${var.prefix}-${each.key}"
  display_name = "CareGrid staging ${each.key}"
  depends_on   = [google_project_service.api]
}

resource "google_artifact_registry_repository" "images" {
  location      = var.region
  repository_id = "${var.prefix}-images"
  format        = "DOCKER"
  labels        = local.labels
  depends_on    = [google_project_service.api]
}

resource "google_artifact_registry_repository_iam_member" "builder" {
  location   = google_artifact_registry_repository.images.location
  repository = google_artifact_registry_repository.images.repository_id
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.runtime["build"].email}"
}

resource "google_project_iam_member" "build_logs" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.runtime["build"].email}"
}

resource "google_sql_database_instance" "primary" {
  name                = "${var.prefix}-pg"
  region              = var.region
  database_version    = "POSTGRES_16"
  deletion_protection = var.deletion_protection
  settings {
    tier                        = var.database_tier
    edition                     = "ENTERPRISE"
    availability_type           = "ZONAL"
    disk_type                   = "PD_SSD"
    disk_size                   = 10
    disk_autoresize             = true
    disk_autoresize_limit       = 30
    deletion_protection_enabled = var.deletion_protection
    user_labels                 = local.labels
    ip_configuration {
      # Staging: public-IP connector transport, no direct-IP allowlist.
      # Cloud Run's Cloud SQL Auth Proxy encrypts/authenticates the connection.
      ipv4_enabled = true
      ssl_mode     = "ENCRYPTED_ONLY"
    }
    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      transaction_log_retention_days = 7
      start_time                     = "20:00"
      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }
    maintenance_window {
      day          = 7
      hour         = 21
      update_track = "stable"
    }
  }
  depends_on = [google_project_service.api]
}

resource "google_sql_database" "app" {
  name     = "caregrid"
  instance = google_sql_database_instance.primary.name
}

resource "google_sql_user" "app" {
  name                = "caregrid"
  instance            = google_sql_database_instance.primary.name
  password_wo         = var.database_password
  password_wo_version = var.secret_revision
  # Shared staging migration/runtime owner. Split SQL roles before a pilot.
  database_roles = ["cloudsqlsuperuser"]
}

resource "google_project_iam_member" "sql_connect" {
  for_each = local.sql_roles
  project  = var.project_id
  role     = "roles/cloudsql.client"
  member   = "serviceAccount:${google_service_account.runtime[each.key].email}"
}

resource "google_secret_manager_secret" "runtime" {
  for_each  = toset(["database-password", "service-secret"])
  secret_id = "${var.prefix}-${each.key}"
  labels    = local.labels
  replication {
    user_managed {
      replicas { location = var.region }
    }
  }
  depends_on = [google_project_service.api]
}

resource "google_secret_manager_secret_version" "database" {
  secret                 = google_secret_manager_secret.runtime["database-password"].id
  secret_data_wo         = var.database_password
  secret_data_wo_version = var.secret_revision
  deletion_policy        = "DISABLE"
}

resource "google_secret_manager_secret_version" "service" {
  secret                 = google_secret_manager_secret.runtime["service-secret"].id
  secret_data_wo         = var.service_secret
  secret_data_wo_version = var.secret_revision
  deletion_policy        = "DISABLE"
}

resource "google_secret_manager_secret_iam_member" "database" {
  for_each  = local.sql_roles
  secret_id = google_secret_manager_secret.runtime["database-password"].id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.runtime[each.key].email}"
}

resource "google_secret_manager_secret_iam_member" "service" {
  for_each  = local.sql_roles
  secret_id = google_secret_manager_secret.runtime["service-secret"].id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.runtime[each.key].email}"
}

resource "google_storage_bucket" "evidence" {
  name                        = "${var.project_id}-${var.prefix}-evidence"
  location                    = var.region
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false
  labels                      = local.labels
  versioning { enabled = true }
  # Staging fixtures only. Real evidence needs approved retention/legal holds.
  lifecycle_rule {
    condition { age = 30 }
    action { type = "Delete" }
  }
  depends_on = [google_project_service.api]
}

resource "google_storage_bucket" "build_source" {
  name                        = "${var.project_id}-${var.prefix}-build-source"
  location                    = var.region
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false
  labels                      = local.labels
  lifecycle_rule {
    condition { age = 7 }
    action { type = "Delete" }
  }
  depends_on = [google_project_service.api]
}

resource "google_storage_bucket_iam_member" "builder_source" {
  bucket = google_storage_bucket.build_source.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.runtime["build"].email}"
}
