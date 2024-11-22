output "name" {
  value       = module.postgresql-db.name
  sensitive   = false
  description = "The name for Cloud SQL instance"
}

output "psql_conn" {
  value       = module.postgresql-db.instances
  sensitive   = true
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