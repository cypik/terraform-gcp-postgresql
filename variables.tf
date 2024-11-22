variable "name" {
  type        = string
  default     = "test"
  description = "Name of the resource. Provided by the client when the resource is created. "
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] ."
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for the resource."
}

variable "managedby" {
  type        = string
  default     = "info@cypik.com"
  description = "ManagedBy, eg 'info@cypik.com'."
}

variable "repository" {
  type        = string
  default     = "https://github.com/cypik/terraform-google-postgresql"
  description = "Terraform current module repo"
}

variable "random_instance_name" {
  type        = bool
  default     = false
  description = "Sets random suffix at the end of the Cloud SQL resource name"
}

variable "database_version" {
  type        = string
  description = "The database version to use"
  validation {
    condition     = (length(var.database_version) >= 9 && ((upper(substr(var.database_version, 0, 9)) == "POSTGRES_") && can(regex("^\\d+(?:_?\\d)*$", substr(var.database_version, 9, -1))))) || can(regex("^\\d+(?:_?\\d)*$", var.database_version))
    error_message = "The specified database version is not a valid representaion of database version. Valid database versions should be like the following patterns:- \"9_6\", \"postgres_9_6\" or \"POSTGRES_14\"."
  }
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "The region of the Cloud SQL resources"
}

variable "tier" {
  type        = string
  default     = "db-f1-micro"
  description = "The tier for the master instance."
}

variable "edition" {
  type        = string
  default     = null
  description = "The edition of the instance, can be ENTERPRISE or ENTERPRISE_PLUS."
}

variable "zone" {
  type        = string
  default     = null
  description = "The zone for the master instance, it should be something like: `us-central1-a`, `us-east1-c`."
}

variable "secondary_zone" {
  type        = string
  default     = null
  description = "The preferred zone for the secondary/failover instance, it should be something like: `us-central1-a`, `us-east1-c`."
}

variable "follow_gae_application" {
  type        = string
  default     = null
  description = "A Google App Engine application whose zone to remain in. Must be in the same region as this instance."
}

variable "activation_policy" {
  type        = string
  default     = "ALWAYS"
  description = "The activation policy for the master instance.Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
}

variable "availability_type" {
  type        = string
  default     = "ZONAL"
  description = "The availability type for the master instance.This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`."
}

variable "deletion_protection_enabled" {
  type        = bool
  default     = false
  description = "Enables protection of an instance from accidental deletion across all surfaces (API, gcloud, Cloud Console and Terraform)."
}

variable "disk_autoresize" {
  type        = bool
  default     = true
  description = "Configuration to increase storage size."
}

variable "disk_autoresize_limit" {
  type        = number
  default     = 0
  description = "The maximum size to which storage can be auto increased."
}

variable "disk_size" {
  type        = number
  default     = 10
  description = "The disk size for the master instance."
}

variable "disk_type" {
  type        = string
  default     = "PD_SSD"
  description = "The disk type for the master instance."
}

variable "pricing_plan" {
  type        = string
  default     = "PER_USE"
  description = "The pricing plan for the master instance."
}

variable "maintenance_window_day" {
  type        = number
  default     = 1
  description = "The day of week (1-7) for the master instance maintenance."
}

variable "maintenance_window_hour" {
  type        = number
  default     = 23
  description = "The hour of day (0-23) maintenance window for the master instance maintenance."
}

variable "maintenance_window_update_track" {
  type        = string
  default     = "canary"
  description = "The update track of maintenance window for the master instance maintenance.Can be either `canary` or `stable`."
}

variable "database_flags" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/postgres/flags)"
}

variable "user_labels" {
  type        = map(string)
  default     = {}
  description = "The key/value labels for the master instances."
}

variable "deny_maintenance_period" {
  type = list(object({
    end_date   = string
    start_date = string
    time       = string
  }))
  default     = []
  description = "The Deny Maintenance Period fields to prevent automatic maintenance from occurring during a 90-day time period. See [more details](https://cloud.google.com/sql/docs/postgres/maintenance)"
}

variable "backup_configuration" {
  type = object({
    enabled                        = optional(bool, false)
    start_time                     = optional(string)
    location                       = optional(string)
    point_in_time_recovery_enabled = optional(bool, false)
    transaction_log_retention_days = optional(string)
    retained_backups               = optional(number)
    retention_unit                 = optional(string)
  })
  default = {
    binary_log_enabled             = null
    enabled                        = true
    point_in_time_recovery_enabled = null
    start_time                     = null
    transaction_log_retention_days = 1
    retained_backups               = 1
    retention_unit                 = null
  }
  description = "The database backup configuration."
}

variable "insights_config" {
  type = object({
    query_plans_per_minute  = optional(number, 5)
    query_string_length     = optional(number, 1024)
    record_application_tags = optional(bool, false)
    record_client_address   = optional(bool, false)
  })
  default     = null
  description = "The insights_config settings for the database."
}

variable "password_validation_policy_config" {
  type = object({
    min_length                  = number
    complexity                  = string
    reuse_interval              = number
    disallow_username_substring = bool
    password_change_interval    = string
  })
  default     = null
  description = "The password validation policy settings for the database instance."
}

variable "ip_configuration" {
  type = object({
    authorized_networks                           = optional(list(map(string)), [])
    ipv4_enabled                                  = optional(bool, true)
    private_network                               = optional(string)
    ssl_mode                                      = optional(string)
    allocated_ip_range                            = optional(string)
    enable_private_path_for_google_cloud_services = optional(bool, false)
    psc_enabled                                   = optional(bool, false)
    psc_allowed_consumer_projects                 = optional(list(string), [])
  })
  default     = {}
  description = "The ip configuration for the Cloud SQL instances."
}


variable "db_charset" {
  type        = string
  default     = ""
  description = "The charset for the default database"
}

variable "db_collation" {
  type        = string
  default     = ""
  description = "The collation for the default database. Example: 'en_US.UTF8'"
}

variable "additional_databases" {
  type = list(object({
    name      = string
    charset   = string
    collation = string
  }))
  default     = []
  description = "A list of additional databases to be created in the cluster, where each database is defined by its name, charset, and collation settings."
}

variable "user_name" {
  type        = string
  default     = "postgresql"
  description = "The name of the default user"
}

variable "user_password" {
  type        = string
  default     = ""
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
}

variable "additional_users" {
  type = list(object({
    name            = string
    password        = string
    random_password = bool
  }))
  default = []
  validation {
    condition     = length([for user in var.additional_users : false if(user.random_password == false && (user.password == null || user.password == "")) || (user.random_password == true && (user.password != null && user.password != ""))]) == 0
    error_message = "Password is a required field for built-in Postgres users and you cannot set both password and random_password, choose one of them."
  }
  description = "A list of users to be created in your cluster. A random password would be set for the user if the `random_password` variable is set."
}

variable "iam_users" {
  type = list(object({
    id    = string,
    email = string
  }))
  default     = []
  description = "A list of IAM users to be created in your CloudSQL instance"
}

variable "create_timeout" {
  type        = string
  default     = "30m"
  description = "The optional timeout that is applied to limit long database creates."
}

variable "update_timeout" {
  type        = string
  default     = "30m"
  description = "The optional timeout that is applied to limit long database updates."
}

variable "delete_timeout" {
  type        = string
  default     = "30m"
  description = "The optional timeout that is applied to limit long database deletes."
}

variable "encryption_key_name" {
  type        = string
  default     = null
  description = "The full path to the encryption key used for the CMEK disk encryption"
}

variable "module_depends_on" {
  type        = list(any)
  default     = []
  description = "List of modules or resources this module depends on."
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Used to block Terraform from deleting a SQL Instance."
}

variable "enable_default_db" {
  type        = bool
  default     = true
  description = "Enable or disable the creation of the default database"
}

variable "enable_default_user" {
  type        = bool
  default     = true
  description = "Enable or disable the creation of the default user"
}

variable "database_deletion_policy" {
  type        = string
  default     = null
  description = "The deletion policy for the database. Setting ABANDON allows the resource to be abandoned rather than deleted. This is useful for Postgres, where databases cannot be deleted from the API if there are users other than cloudsqlsuperuser with access. Possible values are: \"ABANDON\"."
}

variable "user_deletion_policy" {
  type        = string
  default     = null
  description = "The deletion policy for the user. Setting ABANDON allows the resource to be abandoned rather than deleted. This is useful for Postgres, where users cannot be deleted from the API if they have been granted SQL roles. Possible values are: \"ABANDON\"."
}

variable "enable_random_password_special" {
  type        = bool
  default     = false
  description = "Enable special characters in generated random passwords."
}

variable "connector_enforcement" {
  type        = bool
  default     = false
  description = "Enforce that clients use the connector library"
}

variable "db_name" {
  type        = string
  default     = ""
  description = "The name of the database to be created."
}

variable "database_integration_roles" {
  type        = list(string)
  default     = []
  description = "The roles required by default database instance service account for integration with GCP services"
}

variable "data_cache_enabled" {
  type        = bool
  default     = false
  description = "Whether data cache is enabled for the instance. Defaults to false. Feature is only available for ENTERPRISE_PLUS tier and supported database_versions"
}

variable "enable_google_ml_integration" {
  type        = bool
  default     = false
  description = "Enable database ML integration"
}

variable "master_instance_name" {
  type        = string
  default     = null
  description = "Name of the master instance if this is a failover replica. Required for creating failover replica instance. Not needed for master instance. When removed, next terraform apply will promote this failover replica instance as master instance"
}

variable "instance_type" {
  type        = string
  default     = "CLOUD_SQL_INSTANCE"
  description = "The type of the instance. The supported values are SQL_INSTANCE_TYPE_UNSPECIFIED, CLOUD_SQL_INSTANCE, ON_PREMISES_INSTANCE and READ_REPLICA_INSTANCE. Set to READ_REPLICA_INSTANCE if master_instance_name value is provided"
}

variable "root_password" {
  type        = string
  default     = null
  description = "Initial root password during creation"
}