variable "notification_channels" {
  type        = list(string)
  default     = []
  description = "Existing verified Cloud Monitoring channel resource names. Empty means console incidents only."
}

resource "google_logging_metric" "watchdog_failures" {
  name   = "${var.prefix}/watchdog_failures"
  filter = "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"${var.prefix}-watchdog\" AND (jsonPayload.message=\"watchdog_pass_failed\" OR jsonPayload.message=\"watchdog_cleanup_failed\")"
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
  }
  depends_on = [google_project_service.api]
}

resource "google_monitoring_alert_policy" "watchdog_failures" {
  display_name          = "CareGrid staging watchdog failures"
  combiner              = "OR"
  notification_channels = var.notification_channels
  user_labels           = local.labels
  documentation {
    content   = "Inspect watchdog structured errors and SQL connectivity. A running container is not evidence of completed deadline scans. This alert does not detect every stalled worker; durable pass-heartbeat/oldest-overdue monitors remain a pilot gate."
    mime_type = "text/markdown"
  }
  conditions {
    display_name = "Watchdog error observed"
    condition_threshold {
      filter          = "resource.type=\"cloud_run_revision\" AND metric.type=\"logging.googleapis.com/user/${google_logging_metric.watchdog_failures.name}\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_SUM"
      }
    }
  }
}

resource "google_monitoring_alert_policy" "api_errors" {
  display_name          = "CareGrid staging API 5xx"
  combiner              = "OR"
  notification_channels = var.notification_channels
  user_labels           = local.labels
  documentation {
    content   = "Inspect API revision errors, SQL saturation and recent migrations. Reconcile uncertain mutations before retrying. This count alarm is a staging signal, not a measured availability SLO."
    mime_type = "text/markdown"
  }
  conditions {
    display_name = "API returned server errors"
    condition_threshold {
      filter          = "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"${var.prefix}-api\" AND metric.type=\"run.googleapis.com/request_count\" AND metric.labels.response_code_class=\"5xx\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_SUM"
      }
    }
  }
  depends_on = [google_project_service.api]
}
