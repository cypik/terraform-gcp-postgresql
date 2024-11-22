variable "pg_ha_name" {
  type        = string
  default     = "tftest"
  description = "The name for Cloud SQL instance"
}

variable "pg_ha_external_ip_range" {
  type        = string
  default     = "192.10.10.10/32"
  description = "The ip range to allow connecting from/to Cloud SQL"
}