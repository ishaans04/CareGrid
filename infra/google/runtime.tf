locals {
  database_environment = {
    # postgres 3.5.20 connects to this path verbatim; it does not append a filename.
    SERVERPOD_DATABASE_HOST           = "/cloudsql/${google_sql_database_instance.primary.connection_name}/.s.PGSQL.5432"
    SERVERPOD_DATABASE_NAME           = google_sql_database.app.name
    SERVERPOD_DATABASE_USER           = google_sql_user.app.name
    SERVERPOD_DATABASE_PORT           = "5432"
    SERVERPOD_DATABASE_IS_UNIX_SOCKET = "true"
    # Local Unix socket is plaintext; managed connector encrypts its network hop.
    SERVERPOD_DATABASE_REQUIRE_SSL     = "false"
    FIREBASE_PROJECT_ID                = var.project_id
    SERVERPOD_API_SERVER_PUBLIC_HOST   = trimprefix(local.api_origin, "https://")
    SERVERPOD_API_SERVER_PUBLIC_PORT   = "443"
    SERVERPOD_API_SERVER_PUBLIC_SCHEME = "https"
  }
  runtime_secrets = {
    SERVERPOD_DATABASE_PASSWORD = {
      secret  = google_secret_manager_secret.runtime["database-password"].secret_id
      version = google_secret_manager_secret_version.database.version
    }
    SERVERPOD_SERVICE_SECRET = {
      secret  = google_secret_manager_secret.runtime["service-secret"].secret_id
      version = google_secret_manager_secret_version.service.version
    }
  }
  run_services = local.deploy_run ? {
    api      = { min = 0, max = 2, pool = "5", cpu_idle = true }
    watchdog = { min = 1, max = 1, pool = "4", cpu_idle = false }
  } : {}
}

resource "google_cloud_run_v2_service" "server" {
  for_each             = local.run_services
  name                 = "${var.prefix}-${each.key}"
  location             = var.region
  ingress              = "INGRESS_TRAFFIC_ALL"
  invoker_iam_disabled = false
  deletion_protection  = var.deletion_protection
  labels               = local.labels
  template {
    service_account                  = google_service_account.runtime[each.key].email
    execution_environment            = "EXECUTION_ENVIRONMENT_GEN2"
    max_instance_request_concurrency = each.key == "api" ? 20 : 1
    timeout                          = "60s"
    scaling {
      min_instance_count = each.value.min
      max_instance_count = each.value.max
    }
    volumes {
      name = "cloudsql"
      cloud_sql_instance { instances = [google_sql_database_instance.primary.connection_name] }
    }
    containers {
      image = var.server_image
      ports { container_port = 8080 }
      resources {
        limits            = { cpu = "1", memory = "512Mi" }
        cpu_idle          = each.value.cpu_idle
        startup_cpu_boost = true
      }
      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }
      dynamic "env" {
        for_each = merge(local.database_environment, {
          CAREGRID_PROCESS_ROLE                   = each.key
          SERVERPOD_DATABASE_MAX_CONNECTION_COUNT = each.value.pool
          CAREGRID_GEMINI_ENABLED                 = tostring(var.enable_gemini && each.key == "api")
          CAREGRID_GEMINI_MODEL                   = each.key == "api" ? var.gemini_model : ""
          CAREGRID_GEMINI_LOCATION                = each.key == "api" ? var.gemini_location : ""
          CAREGRID_EVIDENCE_ENABLED               = tostring(var.enable_evidence && each.key == "api")
          CAREGRID_EVIDENCE_BUCKET                = each.key == "api" && var.enable_evidence ? google_storage_bucket.evidence.name : ""
        })
        content {
          name  = env.key
          value = env.value
        }
      }
      dynamic "env" {
        for_each = local.runtime_secrets
        content {
          name = env.key
          value_source {
            secret_key_ref {
              secret  = env.value.secret
              version = env.value.version
            }
          }
        }
      }
      startup_probe {
        http_get { path = "/startupz" }
        period_seconds    = 5
        timeout_seconds   = 3
        failure_threshold = 30
      }
      liveness_probe {
        http_get { path = "/livez" }
        period_seconds    = 20
        timeout_seconds   = 3
        failure_threshold = 3
      }
    }
  }
  depends_on = [
    google_secret_manager_secret_iam_member.database,
    google_secret_manager_secret_iam_member.service,
    google_project_iam_member.sql_connect,
    google_project_iam_member.briefing
  ]
}

resource "google_cloud_run_v2_job" "maintenance" {
  for_each            = local.deploy_jobs ? toset(["migrate", "bootstrap"]) : toset([])
  name                = "${var.prefix}-${each.key}"
  location            = var.region
  deletion_protection = var.deletion_protection
  labels              = local.labels
  template {
    task_count  = 1
    parallelism = 1
    template {
      service_account = google_service_account.runtime[each.key].email
      timeout         = "600s"
      max_retries     = 0
      volumes {
        name = "cloudsql"
        cloud_sql_instance { instances = [google_sql_database_instance.primary.connection_name] }
      }
      containers {
        image = var.maintenance_image != "" ? var.maintenance_image : var.server_image
        # An un-overridden bootstrap invocation safely fails argument validation.
        args = each.key == "migrate" ? ["--mode=production", "--role=maintenance", "--apply-migrations"] : ["bootstrap"]
        resources { limits = { cpu = "1", memory = "512Mi" } }
        volume_mounts {
          name       = "cloudsql"
          mount_path = "/cloudsql"
        }
        dynamic "env" {
          for_each = merge(local.database_environment, { SERVERPOD_DATABASE_MAX_CONNECTION_COUNT = "2" })
          content {
            name  = env.key
            value = env.value
          }
        }
        dynamic "env" {
          for_each = local.runtime_secrets
          content {
            name = env.key
            value_source {
              secret_key_ref {
                secret  = env.value.secret
                version = env.value.version
              }
            }
          }
        }
      }
    }
  }
  depends_on = [
    google_secret_manager_secret_iam_member.database,
    google_secret_manager_secret_iam_member.service,
    google_project_iam_member.sql_connect
  ]
}

resource "google_cloud_run_v2_service" "web" {
  count                = local.deploy_run ? 1 : 0
  name                 = "${var.prefix}-web"
  location             = var.region
  ingress              = "INGRESS_TRAFFIC_ALL"
  invoker_iam_disabled = false
  deletion_protection  = var.deletion_protection
  labels               = local.labels
  template {
    service_account                  = google_service_account.runtime["web"].email
    execution_environment            = "EXECUTION_ENVIRONMENT_GEN2"
    max_instance_request_concurrency = 40
    timeout                          = "30s"
    scaling {
      min_instance_count = 0
      max_instance_count = 2
    }
    containers {
      image = var.web_image
      ports { container_port = 8080 }
      resources {
        # Cloud Run rejects gen2 revisions below 512 MiB; the first live apply failed at 256Mi.
        limits            = { cpu = "1", memory = "512Mi" }
        cpu_idle          = true
        startup_cpu_boost = true
      }
      dynamic "env" {
        for_each = {
          CAREGRID_WEB_ORIGIN  = local.web_origin
          CAREGRID_API_URL     = local.api_origin
          FIREBASE_PROJECT_ID  = var.project_id
          FIREBASE_WEB_API_KEY = var.firebase_web_api_key
          FIREBASE_WEB_APP_ID  = var.firebase_web_app_id
        }
        content {
          name  = env.key
          value = env.value
        }
      }
      startup_probe {
        http_get { path = "/healthz" }
        period_seconds    = 5
        failure_threshold = 12
      }
      liveness_probe {
        http_get { path = "/healthz" }
        period_seconds = 20
      }
    }
  }
  depends_on = [google_project_service.api]
}

resource "google_cloud_run_v2_service_iam_member" "web_to_api" {
  count    = local.deploy_run ? 1 : 0
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.server["api"].name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.runtime["web"].email}"
}

resource "google_cloud_run_v2_service_iam_member" "public_web" {
  count    = local.deploy_run && var.public_web ? 1 : 0
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.web[0].name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
