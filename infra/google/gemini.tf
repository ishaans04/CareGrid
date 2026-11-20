variable "enable_gemini" {
  type        = bool
  default     = false
  description = "Enable optional command handoff drafts after selecting/evaluating an available Google model."
}

variable "gemini_model" {
  type        = string
  default     = ""
  description = "Explicit Gemini model ID, verified in this project/region. No automatic model fallback."
  validation {
    condition     = !var.enable_gemini || can(regex("^gemini-[a-z0-9][a-z0-9.-]{0,95}$", var.gemini_model))
    error_message = "Enabling Gemini requires an explicit Google Gemini model ID."
  }
}

variable "gemini_location" {
  type        = string
  default     = ""
  description = "Explicit supported model location; may differ from app region. Global requires a deliberate residency decision."
  validation {
    condition     = !var.enable_gemini || var.gemini_location == "global" || can(regex("^[a-z]+-[a-z]+[0-9]$", var.gemini_location))
    error_message = "Enabling Gemini requires an explicit supported location."
  }
}

resource "google_project_service" "gemini" {
  count              = var.enable_gemini ? 1 : 0
  service            = "aiplatform.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_iam_custom_role" "briefing" {
  count       = var.enable_gemini ? 1 : 0
  role_id     = "${replace(var.prefix, "-", "_")}_briefing"
  title       = "CareGrid optional inference"
  description = "Inference only; no model deployment, tuning or administrative writes."
  permissions = ["aiplatform.endpoints.predict", "serviceusage.services.use"]
  depends_on  = [google_project_service.api, google_project_service.gemini]
}

resource "google_project_iam_member" "briefing" {
  count   = var.enable_gemini ? 1 : 0
  project = var.project_id
  role    = google_project_iam_custom_role.briefing[0].name
  member  = "serviceAccount:${google_service_account.runtime["api"].email}"
}
