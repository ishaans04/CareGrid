output "artifact_path" { value = local.artifact_path }
output "web_origin" { value = local.web_origin }
output "api_origin" { value = local.api_origin }
output "sql_connection_name" { value = google_sql_database_instance.primary.connection_name }
output "evidence_bucket" { value = google_storage_bucket.evidence.name }
output "build_source_bucket" { value = google_storage_bucket.build_source.name }
output "build_service_account" { value = google_service_account.runtime["build"].email }
output "rollout_stage" { value = var.rollout_stage }
output "maintenance_jobs" {
  value = { for name, job in google_cloud_run_v2_job.maintenance : name => job.name }
}
output "runtime_identities" {
  value = { for name, account in google_service_account.runtime : name => account.email }
}
