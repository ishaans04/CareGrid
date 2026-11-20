mock_provider "google" {
  mock_data "google_project" {
    defaults = { number = "123456789012" }
  }
}

variables {
  project_id        = "caregrid-test-project"
  database_password = "synthetic-test-only-32-characters-database"
  service_secret    = "synthetic-test-only-32-characters-service"
}

run "foundation_does_not_start_workloads" {
  command = plan
  assert {
    condition     = length(google_cloud_run_v2_service.server) == 0 && length(google_cloud_run_v2_service.web) == 0 && length(google_cloud_run_v2_job.maintenance) == 0
    error_message = "Foundation must not start unmigrated services or jobs."
  }
  assert {
    condition     = google_storage_bucket.evidence.public_access_prevention == "enforced" && !google_storage_bucket.evidence.force_destroy
    error_message = "Evidence must remain private and protected from force deletion."
  }
  assert {
    condition     = length(google_sql_database_instance.primary.settings[0].ip_configuration[0].authorized_networks) == 0
    error_message = "Direct database IP access must not be allowlisted."
  }
  assert {
    condition     = !contains(keys(google_project_iam_member.sql_connect), "web") && !contains(keys(google_secret_manager_secret_iam_member.database), "web")
    error_message = "Web identity must not receive database or secret access."
  }
  assert {
    condition     = length(google_project_iam_member.briefing) == 0 && length(google_project_service.gemini) == 0
    error_message = "Optional model access must remain disabled by default."
  }
}

run "jobs_before_services" {
  command = plan
  variables {
    rollout_stage = "jobs"
    server_image  = "asia-south1-docker.pkg.dev/caregrid-test-project/images/server@sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  }
  assert {
    condition     = length(google_cloud_run_v2_job.maintenance) == 2 && length(google_cloud_run_v2_service.server) == 0
    error_message = "Migrations/bootstrap must be deployable before serving any revision."
  }
  assert {
    condition     = alltrue([for job in google_cloud_run_v2_job.maintenance : job.template[0].template[0].max_retries == 0 && job.template[0].task_count == 1])
    error_message = "Privileged mutations must not run in parallel or retry implicitly."
  }
}

run "services_keep_iam_and_background_cpu" {
  command = plan
  variables {
    rollout_stage        = "services"
    migration_verified   = true
    server_image         = "asia-south1-docker.pkg.dev/caregrid-test-project/images/server@sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    web_image            = "asia-south1-docker.pkg.dev/caregrid-test-project/images/web@sha256:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
    firebase_web_api_key = "public-test-key"
    firebase_web_app_id  = "public-test-app"
  }
  assert {
    condition     = !google_cloud_run_v2_service.server["watchdog"].template[0].containers[0].resources[0].cpu_idle && google_cloud_run_v2_service.server["watchdog"].template[0].scaling[0].min_instance_count == 1
    error_message = "The watchdog needs continuously allocated CPU and a warm instance."
  }
  assert {
    condition     = alltrue([for service in google_cloud_run_v2_service.server : !service.invoker_iam_disabled]) && length(google_cloud_run_v2_service_iam_member.public_web) == 0
    error_message = "IAM must remain enabled and public web must be explicit opt-in."
  }
  assert {
    condition     = local.web_origin == "https://caregrid-demo-web-123456789012.asia-south1.run.app"
    error_message = "The configured origin must match Google's deterministic URL contract."
  }
  assert {
    condition = alltrue([
      for service in concat(values(google_cloud_run_v2_service.server), google_cloud_run_v2_service.web) :
      service.template[0].execution_environment != "EXECUTION_ENVIRONMENT_GEN2" || tonumber(trimsuffix(service.template[0].containers[0].resources[0].limits.memory, "Mi")) >= 512
    ])
    error_message = "Cloud Run gen2 services need at least 512Mi; the mocked provider does not enforce Google's limit."
  }
}

run "mutable_server_tag_is_rejected" {
  command = plan
  variables {
    rollout_stage = "jobs"
    server_image  = "asia-south1-docker.pkg.dev/caregrid-test-project/images/server:latest"
  }
  expect_failures = [var.server_image]
}

run "explicit_public_web_exposes_only_web" {
  command = plan
  variables {
    rollout_stage        = "services"
    migration_verified   = true
    public_web           = true
    server_image         = "asia-south1-docker.pkg.dev/caregrid-test-project/images/server@sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    web_image            = "asia-south1-docker.pkg.dev/caregrid-test-project/images/web@sha256:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
    firebase_web_api_key = "public-test-key"
    firebase_web_app_id  = "public-test-app"
  }
  assert {
    condition     = length(google_cloud_run_v2_service_iam_member.public_web) == 1 && google_cloud_run_v2_service_iam_member.public_web[0].member == "allUsers" && google_cloud_run_v2_service_iam_member.web_to_api[0].member != "allUsers"
    error_message = "Only the web entry may be explicitly public."
  }
}

run "serving_requires_migration_attestation" {
  command = plan
  variables {
    rollout_stage        = "services"
    server_image         = "asia-south1-docker.pkg.dev/caregrid-test-project/images/server@sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    web_image            = "asia-south1-docker.pkg.dev/caregrid-test-project/images/web@sha256:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
    firebase_web_api_key = "public-test-key"
    firebase_web_app_id  = "public-test-app"
  }
  expect_failures = [var.rollout_stage]
}

run "model_access_has_no_deployment_authority" {
  command = plan
  variables {
    enable_gemini   = true
    gemini_model    = "gemini-test-fixture"
    gemini_location = "asia-south1"
  }
  assert {
    condition     = length(google_project_iam_member.briefing) == 1 && toset(google_project_iam_custom_role.briefing[0].permissions) == toset(["aiplatform.endpoints.predict", "serviceusage.services.use"])
    error_message = "Only a single runtime identity may get inference access without admin/deployment permissions."
  }
}

run "model_enablement_requires_explicit_model_and_location" {
  command = plan
  variables { enable_gemini = true }
  expect_failures = [var.gemini_model, var.gemini_location]
}

run "evidence_access_is_disabled_by_default" {
  command = plan
  assert {
    condition     = length(google_storage_bucket_iam_member.evidence_api) == 0 && length(google_project_iam_custom_role.evidence) == 0
    error_message = "An empty evidence bucket must not silently grant runtime access."
  }
}

run "evidence_access_is_bucket_scoped_and_api_only" {
  command = plan
  variables { enable_evidence = true }
  override_resource {
    target          = google_service_account.runtime["api"]
    override_during = plan
    values          = { email = "caregrid-api@caregrid-test-project.iam.gserviceaccount.com" }
  }
  assert {
    condition     = length(google_storage_bucket_iam_member.evidence_api) == 1 && google_storage_bucket_iam_member.evidence_api[0].bucket == google_storage_bucket.evidence.name && google_storage_bucket_iam_member.evidence_api[0].member == "serviceAccount:${google_service_account.runtime["api"].email}" && toset(google_project_iam_custom_role.evidence[0].permissions) == toset(["storage.objects.create", "storage.objects.get", "storage.objects.list", "storage.objects.delete"])
    error_message = "Only API object operations on the private evidence bucket are allowed."
  }
}
