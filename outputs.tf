output "name" {
  value       = google_sql_database_instance.default.name
  description = "The instance name for the master instance"
}

output "public_ip_address" {
  description = "The first public (PRIMARY) IPv4 address assigned for the master instance"
  value       = google_sql_database_instance.default.public_ip_address
}

output "private_ip_address" {
  description = "The first private (PRIVATE) IPv4 address assigned for the master instance"
  value       = google_sql_database_instance.default.private_ip_address
}

output "ip_address" {
  value       = google_sql_database_instance.default.ip_address
  description = "The IPv4 address assigned for the master instance"
}

output "first_ip_address" {
  value       = google_sql_database_instance.default.first_ip_address
  description = "The first IPv4 address of the addresses assigned."
}

output "connection_name" {
  value       = google_sql_database_instance.default.connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "self_link" {
  value       = google_sql_database_instance.default.self_link
  description = "The URI of the master instance"
}

output "server_ca_cert" {
  value       = google_sql_database_instance.default.server_ca_cert
  description = "The CA certificate information used to connect to the SQL instance via SSL"
}

output "service_account_email_address" {
  value       = google_sql_database_instance.default.service_account_email_address
  description = "The service account email address assigned to the master instance"
}

output "psc_service_attachment_link" {
  value       = google_sql_database_instance.default.psc_service_attachment_link
  description = "The psc_service_attachment_link created for the master instance"
}

output "generated_user_password" {
  description = "The auto generated default user password if not input password was provided"
  value       = random_password.user-password.result
  sensitive   = true
}

output "additional_users" {
  description = "List of maps of additional users and passwords"
  value = [for r in google_sql_user.additional_users :
    {
      name     = r.name
      password = r.password
    }
  ]
  sensitive = true
}

output "iam_users" {
  description = "The list of the IAM users with access to the CloudSQL instance"
  value       = var.iam_users
}

output "primary" {
  value       = google_sql_database_instance.default
  description = "The `google_sql_database_instance` resource representing the primary instance"
  sensitive   = true
}

output "replicas" {
  value       = values(google_sql_database_instance.default)
  description = "A list of `google_sql_database_instance` resources representing the replicas"
  sensitive   = true
}

output "instances" {
  value       = concat([google_sql_database_instance.default], values(google_sql_database_instance.default))
  description = "A list of all `google_sql_database_instance` resources we've created"
  sensitive   = true
}