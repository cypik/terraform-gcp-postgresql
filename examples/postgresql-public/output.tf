output "name" {
  value       = module.postgresql-db.name
  sensitive   = true
  description = "The name for Cloud SQL instance"
}

output "self_link" {
  value       = module.postgresql-db.self_link
  description = "The connection name of the master instance to be used in connection strings"
}

output "psql_user_pass" {
  value       = module.postgresql-db.generated_user_password
  sensitive   = true
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
}

output "public_ip_address" {
  value       = module.postgresql-db.public_ip_address
  sensitive   = false
  description = "The first public (PRIMARY) IPv4 address assigned for the master instance"
}

output "private_ip_address" {
  value       = module.postgresql-db.private_ip_address
  description = "The first private (PRIVATE) IPv4 address assigned for the master instance"
}

output "ip_address" {
  value       = module.postgresql-db.ip_address
  description = "The IPv4 address assigned for the master instance"
}

output "first_ip_address" {
  value       = module.postgresql-db.first_ip_address
  description = "The first IPv4 address of the addresses assigned."
}

output "connection_name" {
  value       = module.postgresql-db.connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "server_ca_cert" {
  value       = module.postgresql-db.server_ca_cert
  sensitive   = true
  description = "The CA certificate information used to connect to the SQL instance via SSL"
}

output "service_account_email_address" {
  value       = module.postgresql-db.service_account_email_address
  description = "The service account email address assigned to the master instance"
}

output "psc_service_attachment_link" {
  value       = module.postgresql-db.psc_service_attachment_link
  description = "The psc_service_attachment_link created for the master instance"
}

output "generated_user_password" {
  value       = module.postgresql-db.generated_user_password
  sensitive   = true
  description = "The auto generated default user password if not input password was provided"
}

output "primary" {
  value       = module.postgresql-db.primary
  sensitive   = true
  description = "The `google_sql_database_instance` resource representing the primary instance"
}

output "replicas" {
  value       = module.postgresql-db.replicas
  sensitive   = true
  description = "A list of `google_sql_database_instance` resources representing the replicas"
}

output "instances" {
  value       = module.postgresql-db.instances
  sensitive   = true
  description = "A list of all `google_sql_database_instance` resources we've created"
}