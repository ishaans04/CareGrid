variable "enable_evidence" {
  type        = bool
  default     = false
  description = "Enable the private command evidence broker after live storage/IAM/retention acceptance checks."
}

resource "google_project_iam_custom_role" "evidence" {
  count       = var.enable_evidence ? 1 : 0
  role_id     = "${replace(var.prefix, "-", "_")}_evidence"
  title       = "CareGrid private evidence objects"
  description = "Object operations only, bound to the private evidence bucket. No bucket administration or public ACL changes."
  permissions = ["storage.objects.create", "storage.objects.get", "storage.objects.list", "storage.objects.delete"]
  depends_on  = [google_project_service.api]
}

resource "google_storage_bucket_iam_member" "evidence_api" {
  count  = var.enable_evidence ? 1 : 0
  bucket = google_storage_bucket.evidence.name
  role   = google_project_iam_custom_role.evidence[0].name
  member = "serviceAccount:${google_service_account.runtime["api"].email}"
}
