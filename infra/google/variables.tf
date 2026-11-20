variable "project_id" {
  type        = string
  description = "Existing, billed Google project with Firebase enabled separately."
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "Use a Google project ID, not its display name or number."
  }
}

variable "region" {
  type        = string
  default     = "asia-south1"
  description = "Co-locate Run, SQL, secrets, artifacts and evidence; confirm project availability."
  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]$", var.region))
    error_message = "Use a Google Cloud region such as asia-south1."
  }
}

variable "prefix" {
  type    = string
  default = "caregrid-demo"
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,14}[a-z0-9]$", var.prefix))
    error_message = "Use a 4–16 character lowercase resource prefix."
  }
}

variable "rollout_stage" {
  type        = string
  default     = "foundation"
  description = "foundation -> jobs -> services; execute and verify migrations between jobs and services."
  validation {
    condition     = contains(["foundation", "jobs", "services"], var.rollout_stage)
    error_message = "Choose foundation, jobs or services."
  }
  validation {
    condition     = var.rollout_stage != "services" || var.migration_verified
    error_message = "Verify the migration job succeeded, then explicitly set migration_verified=true before serving revisions."
  }
}

variable "migration_verified" {
  type        = bool
  default     = false
  description = "Operator attestation after checking the successful migration execution for this release."
}

variable "maintenance_image" {
  type        = string
  default     = ""
  description = "Optional separate digest for jobs, allowing migration before updating a running API. Empty uses server_image."
  validation {
    condition     = var.maintenance_image == "" || can(regex("^[a-z0-9.-]+-docker.pkg.dev/.+@sha256:[a-f0-9]{64}$", var.maintenance_image))
    error_message = "Maintenance image must be an immutable Artifact Registry digest."
  }
}

variable "server_image" {
  type    = string
  default = ""
  validation {
    condition     = var.rollout_stage == "foundation" || can(regex("^[a-z0-9.-]+-docker.pkg.dev/.+@sha256:[a-f0-9]{64}$", var.server_image))
    error_message = "Jobs/services require an Artifact Registry server image pinned by sha256 digest."
  }
}

variable "web_image" {
  type    = string
  default = ""
  validation {
    condition     = var.rollout_stage != "services" || can(regex("^[a-z0-9.-]+-docker.pkg.dev/.+@sha256:[a-f0-9]{64}$", var.web_image))
    error_message = "Services require an Artifact Registry web image pinned by sha256 digest."
  }
}

variable "firebase_web_api_key" {
  type        = string
  default     = ""
  description = "Public Firebase web config, not an administrative credential."
}

variable "firebase_web_app_id" {
  type    = string
  default = ""
  validation {
    condition     = var.rollout_stage != "services" || (length(var.firebase_web_app_id) > 0 && length(var.firebase_web_api_key) > 0)
    error_message = "Services require Firebase web app ID and public API key."
  }
}

variable "public_web" {
  type        = bool
  default     = false
  description = "Explicitly grant unauthenticated web entry; application data still requires Firebase membership."
}

variable "deletion_protection" {
  type    = bool
  default = true
}

variable "database_tier" {
  type        = string
  default     = "db-g1-small"
  description = "Synthetic staging capacity, not HA/pilot sizing."
}

variable "database_password" {
  type        = string
  sensitive   = true
  ephemeral   = true
  description = "Supply through TF_VAR_database_password in the current process; never tfvars or command args."
  validation {
    condition     = length(var.database_password) >= 32
    error_message = "Use a generated database password of at least 32 characters."
  }
}

variable "service_secret" {
  type        = string
  sensitive   = true
  ephemeral   = true
  description = "Generated Serverpod service secret; ephemeral Terraform input."
  validation {
    condition     = length(var.service_secret) >= 32
    error_message = "Use a generated service secret of at least 32 characters."
  }
}

variable "secret_revision" {
  type        = number
  default     = 1
  description = "Increment when rotating BOTH ephemeral secret inputs. Coordinate DB rotation with revision rollout."
  validation {
    condition     = var.secret_revision >= 1 && floor(var.secret_revision) == var.secret_revision
    error_message = "Secret revision must be a positive integer."
  }
}
