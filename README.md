# Terraform-gcp-postgresql
# Terraform Google Cloud Postgresql Module
## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Examples](#examples)
- [License](#license)
- [Author](#author)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Introduction
This project deploys a Google Cloud infrastructure using Terraform to create Postgresql .
## Usage
To use this module, you should have Terraform installed and configured for GCP. This module provides the necessary Terraform configuration for creating GCP resources, and you can customize the inputs as needed. Below is an example of how to use this module:

# Examples:

## Example: postgresql-public

```hcl
module "postgresql-db" {
  source               = "cypik/postgresql/google"
  version              = "1.0.2"
  name                 = "testdb"
  environment          = "test"
  db_name              = "postgresql"
  root_password        = "G5PX1SDW0R"
  user_password        = "Y2512FCNU85HEE9"
  database_version     = "POSTGRES_14"
  zone                 = "us-central1-c"
  region               = "us-central1"
  edition              = "ENTERPRISE_PLUS"
  tier                 = "db-perf-optimized-N-2"
  data_cache_enabled   = true
  random_instance_name = true
  deletion_protection  = false

  ip_configuration = {
    ipv4_enabled       = true
    private_network    = null
    ssl_mode           = "ENCRYPTED_ONLY"
    allocated_ip_range = null
    authorized_networks = [{
      name  = "sample-gcp-health-checkers-range"
      value = "130.211.0.0/28"
    }]
  }
}
```

## Example: postgresql-psc
```hcl
module "postgresql-db" {
  source                          = "cypik/postgresql/google"
  version                         = "1.0.2"
  name                            = local.name
  environment                     = "test"
  user_name                       = "tftest"
  user_password                   = "foobar"
  db_name                         = local.name
  db_charset                      = "UTF8"
  db_collation                    = "en_US.UTF8"
  database_version                = "POSTGRES_15"
  region                          = "asia-northeast1"
  tier                            = "db-custom-2-7680"
  zone                            = "asia-northeast1-a"
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"
  random_instance_name            = true
  deletion_protection             = false
  database_flags                  = [{ name = "autovacuum", value = "off" }]

  user_labels = {
    foo = "bar"
  }

  insights_config = {
    query_plans_per_minute = 5
  }

  ip_configuration = {
    ipv4_enabled = false
    psc_enabled  = true
    ssl_mode     = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
  }

  backup_configuration = {
    enabled                        = true
    start_time                     = "20:55"
    location                       = null
    point_in_time_recovery_enabled = false
    transaction_log_retention_days = null
    retained_backups               = 365
    retention_unit                 = "COUNT"
  }

  additional_databases = [
    {
      name      = "${local.name}-additional"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    },
  ]

  additional_users = [
    {
      name            = "tftest2"
      password        = "abcdefg"
      host            = "localhost"
      random_password = false
    },
    {
      name            = "tftest3"
      password        = "abcdefg"
      host            = "localhost"
      random_password = false
    },
  ]
}
```

## Example: postgresql-public-iam

```hcl
module "postgresql-db" {
  source                         = "cypik/postgresql/google"
  version                        = "1.0.2"
  name                           = "example-iam"
  environment                    = "test"
  db_name                        = "postgresql"
  database_version               = "POSTGRES_9_6"
  zone                           = "asia-northeast1-a"
  region                         = "asia-northeast1"
  tier                           = "db-custom-1-3840"
  deletion_protection            = false
  random_instance_name           = true
  enable_random_password_special = true

  ip_configuration = {
    ipv4_enabled       = true
    private_network    = null
    ssl_mode           = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    allocated_ip_range = null
    authorized_networks = [{
      name  = "sample-gcp-health-checkers-range"
      value = "130.211.0.0/28"
    }]
  }

  password_validation_policy_config = {
    complexity                  = "COMPLEXITY_DEFAULT"
    disallow_username_substring = true
    min_length                  = 8
    password_change_interval    = "3600s"
    reuse_interval              = 1
  }

  database_flags = [
    {
      name  = "cloudsql.iam_authentication"
      value = "on"
    },
  ]

  additional_users = [
    {
      name            = "tftest2"
      password        = "Ex@mp!e1"
      host            = "localhost"
      random_password = false
    },
    {
      name            = "tftest3"
      password        = "Ex@mp!e2"
      host            = "localhost"
      random_password = false
    },
  ]

  iam_users = [
    {
      id    = "cloudsql_pg_sa",
      email = "example@gmail.com"
    },
    {
      id    = "dbadmin",
      email = "dbadmin@develop.blueprints.joonix.net"
    },
    {
      id    = "subtest",
      email = "subtest@develop.blueprints.joonix.net"
      type  = "CLOUD_IAM_GROUP"
    }
  ]
}
```
## Example: postgresql-ha

```hcl
module "postgresql-db" {
  source                          = "cypik/postgresql/google"
  version                         = "1.0.2"
  name                            = local.name
  user_name                       = "tftest"
  environment                     = "test"
  user_password                   = "foobar"
  db_name                         = local.name
  db_charset                      = "UTF8"
  db_collation                    = "en_US.UTF8"
  database_version                = "POSTGRES_9_6"
  region                          = "asia-northeast1"
  tier                            = "db-custom-1-3840"
  zone                            = "asia-northeast1-a"
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"
  deletion_protection             = false
  random_instance_name            = true
  database_flags                  = [{ name = "autovacuum", value = "off" }]

  user_labels = {
    foo = "bar"
  }

  ip_configuration = {
    ipv4_enabled       = true
    ssl_mode           = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    private_network    = null
    allocated_ip_range = null
    authorized_networks = [
      {
        name  = "cidr"
        value = "192.10.10.10/32"
      },
    ]
  }

  backup_configuration = {
    enabled                        = true
    start_time                     = "20:55"
    location                       = null
    point_in_time_recovery_enabled = false
    transaction_log_retention_days = null
    retained_backups               = 365
    retention_unit                 = "COUNT"
  }

  additional_databases = [
    {
      name      = "${local.name}-additional"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    },
  ]

  additional_users = [
    {
      name            = "tftest2"
      password        = "abcdefg"
      host            = "localhost"
      random_password = false
    },
    {
      name            = "tftest3"
      password        = "abcdefg"
      host            = "localhost"
      random_password = false
    },
  ]
}
```

This example demonstrates how to create various GCP resources using the provided modules. Adjust the input values to suit your specific requirements.

## Examples
For detailed examples on how to use this module, please refer to the [Examples](https://github.com/cypik/terraform-google-postgresql/tree/master/examples) directory within this repository.

## Author
Your Name Replace **MIT** and **Cypik** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the **MIT** License - see the [LICENSE](https://github.com/cypik/terraform-google-postgresql/blob/master/LICENSE) file for details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.9.5 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >=6.1.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.3 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >=6.1.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.3 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.6.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | cypik/labels/google | 1.0.2 |

## Resources

| Name | Type |
|------|------|
| [google_project_iam_member.database_integration](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_sql_database.additional_databases](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database) | resource |
| [google_sql_database.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database) | resource |
| [google_sql_database_instance.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance) | resource |
| [google_sql_user.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user) | resource |
| [google_sql_user.iam_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user) | resource |
| [null_resource.module_depends_on](https://registry.terraform.io/providers/hashicorp/null/3.2.3/docs/resources/resource) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_password.additional_passwords](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_activation_policy"></a> [activation\_policy](#input\_activation\_policy) | The activation policy for the master instance.Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`. | `string` | `"ALWAYS"` | no |
| <a name="input_additional_databases"></a> [additional\_databases](#input\_additional\_databases) | A list of additional databases to be created in the cluster, where each database is defined by its name, charset, and collation settings. | <pre>list(object({<br>    name      = string<br>    charset   = string<br>    collation = string<br>  }))</pre> | `[]` | no |
| <a name="input_additional_users"></a> [additional\_users](#input\_additional\_users) | A list of users to be created in your cluster. A random password would be set for the user if the `random_password` variable is set. | <pre>list(object({<br>    name            = string<br>    password        = string<br>    random_password = bool<br>  }))</pre> | `[]` | no |
| <a name="input_availability_type"></a> [availability\_type](#input\_availability\_type) | The availability type for the master instance.This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`. | `string` | `"ZONAL"` | no |
| <a name="input_backup_configuration"></a> [backup\_configuration](#input\_backup\_configuration) | The database backup configuration. | <pre>object({<br>    enabled                        = optional(bool, false)<br>    start_time                     = optional(string)<br>    location                       = optional(string)<br>    point_in_time_recovery_enabled = optional(bool, false)<br>    transaction_log_retention_days = optional(string)<br>    retained_backups               = optional(number)<br>    retention_unit                 = optional(string)<br>  })</pre> | <pre>{<br>  "binary_log_enabled": null,<br>  "enabled": true,<br>  "point_in_time_recovery_enabled": null,<br>  "retained_backups": 1,<br>  "retention_unit": null,<br>  "start_time": null,<br>  "transaction_log_retention_days": 1<br>}</pre> | no |
| <a name="input_connector_enforcement"></a> [connector\_enforcement](#input\_connector\_enforcement) | Enforce that clients use the connector library | `bool` | `false` | no |
| <a name="input_create_timeout"></a> [create\_timeout](#input\_create\_timeout) | The optional timeout that is applied to limit long database creates. | `string` | `"30m"` | no |
| <a name="input_data_cache_enabled"></a> [data\_cache\_enabled](#input\_data\_cache\_enabled) | Whether data cache is enabled for the instance. Defaults to false. Feature is only available for ENTERPRISE\_PLUS tier and supported database\_versions | `bool` | `false` | no |
| <a name="input_database_deletion_policy"></a> [database\_deletion\_policy](#input\_database\_deletion\_policy) | The deletion policy for the database. Setting ABANDON allows the resource to be abandoned rather than deleted. This is useful for Postgres, where databases cannot be deleted from the API if there are users other than cloudsqlsuperuser with access. Possible values are: "ABANDON". | `string` | `null` | no |
| <a name="input_database_flags"></a> [database\_flags](#input\_database\_flags) | The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/postgres/flags) | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_database_integration_roles"></a> [database\_integration\_roles](#input\_database\_integration\_roles) | The roles required by default database instance service account for integration with GCP services | `list(string)` | `[]` | no |
| <a name="input_database_version"></a> [database\_version](#input\_database\_version) | The database version to use | `string` | n/a | yes |
| <a name="input_db_charset"></a> [db\_charset](#input\_db\_charset) | The charset for the default database | `string` | `""` | no |
| <a name="input_db_collation"></a> [db\_collation](#input\_db\_collation) | The collation for the default database. Example: 'en\_US.UTF8' | `string` | `""` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The name of the database to be created. | `string` | `""` | no |
| <a name="input_delete_timeout"></a> [delete\_timeout](#input\_delete\_timeout) | The optional timeout that is applied to limit long database deletes. | `string` | `"30m"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Used to block Terraform from deleting a SQL Instance. | `bool` | `true` | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | Enables protection of an instance from accidental deletion across all surfaces (API, gcloud, Cloud Console and Terraform). | `bool` | `false` | no |
| <a name="input_deny_maintenance_period"></a> [deny\_maintenance\_period](#input\_deny\_maintenance\_period) | The Deny Maintenance Period fields to prevent automatic maintenance from occurring during a 90-day time period. See [more details](https://cloud.google.com/sql/docs/postgres/maintenance) | <pre>list(object({<br>    end_date   = string<br>    start_date = string<br>    time       = string<br>  }))</pre> | `[]` | no |
| <a name="input_disk_autoresize"></a> [disk\_autoresize](#input\_disk\_autoresize) | Configuration to increase storage size. | `bool` | `true` | no |
| <a name="input_disk_autoresize_limit"></a> [disk\_autoresize\_limit](#input\_disk\_autoresize\_limit) | The maximum size to which storage can be auto increased. | `number` | `0` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | The disk size for the master instance. | `number` | `10` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | The disk type for the master instance. | `string` | `"PD_SSD"` | no |
| <a name="input_edition"></a> [edition](#input\_edition) | The edition of the instance, can be ENTERPRISE or ENTERPRISE\_PLUS. | `string` | `null` | no |
| <a name="input_enable_default_db"></a> [enable\_default\_db](#input\_enable\_default\_db) | Enable or disable the creation of the default database | `bool` | `true` | no |
| <a name="input_enable_default_user"></a> [enable\_default\_user](#input\_enable\_default\_user) | Enable or disable the creation of the default user | `bool` | `true` | no |
| <a name="input_enable_google_ml_integration"></a> [enable\_google\_ml\_integration](#input\_enable\_google\_ml\_integration) | Enable database ML integration | `bool` | `false` | no |
| <a name="input_enable_random_password_special"></a> [enable\_random\_password\_special](#input\_enable\_random\_password\_special) | Enable special characters in generated random passwords. | `bool` | `false` | no |
| <a name="input_encryption_key_name"></a> [encryption\_key\_name](#input\_encryption\_key\_name) | The full path to the encryption key used for the CMEK disk encryption | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Additional tags for the resource. | `map(string)` | `{}` | no |
| <a name="input_follow_gae_application"></a> [follow\_gae\_application](#input\_follow\_gae\_application) | A Google App Engine application whose zone to remain in. Must be in the same region as this instance. | `string` | `null` | no |
| <a name="input_iam_users"></a> [iam\_users](#input\_iam\_users) | A list of IAM users to be created in your CloudSQL instance | <pre>list(object({<br>    id    = string,<br>    email = string<br>  }))</pre> | `[]` | no |
| <a name="input_insights_config"></a> [insights\_config](#input\_insights\_config) | The insights\_config settings for the database. | <pre>object({<br>    query_plans_per_minute  = optional(number, 5)<br>    query_string_length     = optional(number, 1024)<br>    record_application_tags = optional(bool, false)<br>    record_client_address   = optional(bool, false)<br>  })</pre> | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of the instance. The supported values are SQL\_INSTANCE\_TYPE\_UNSPECIFIED, CLOUD\_SQL\_INSTANCE, ON\_PREMISES\_INSTANCE and READ\_REPLICA\_INSTANCE. Set to READ\_REPLICA\_INSTANCE if master\_instance\_name value is provided | `string` | `"CLOUD_SQL_INSTANCE"` | no |
| <a name="input_ip_configuration"></a> [ip\_configuration](#input\_ip\_configuration) | The ip configuration for the Cloud SQL instances. | <pre>object({<br>    authorized_networks                           = optional(list(map(string)), [])<br>    ipv4_enabled                                  = optional(bool, true)<br>    private_network                               = optional(string)<br>    ssl_mode                                      = optional(string)<br>    allocated_ip_range                            = optional(string)<br>    enable_private_path_for_google_cloud_services = optional(bool, false)<br>    psc_enabled                                   = optional(bool, false)<br>    psc_allowed_consumer_projects                 = optional(list(string), [])<br>  })</pre> | `{}` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] . | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_maintenance_window_day"></a> [maintenance\_window\_day](#input\_maintenance\_window\_day) | The day of week (1-7) for the master instance maintenance. | `number` | `1` | no |
| <a name="input_maintenance_window_hour"></a> [maintenance\_window\_hour](#input\_maintenance\_window\_hour) | The hour of day (0-23) maintenance window for the master instance maintenance. | `number` | `23` | no |
| <a name="input_maintenance_window_update_track"></a> [maintenance\_window\_update\_track](#input\_maintenance\_window\_update\_track) | The update track of maintenance window for the master instance maintenance.Can be either `canary` or `stable`. | `string` | `"canary"` | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg 'info@cypik.com'. | `string` | `"info@cypik.com"` | no |
| <a name="input_master_instance_name"></a> [master\_instance\_name](#input\_master\_instance\_name) | Name of the master instance if this is a failover replica. Required for creating failover replica instance. Not needed for master instance. When removed, next terraform apply will promote this failover replica instance as master instance | `string` | `null` | no |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | List of modules or resources this module depends on. | `list(any)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource. Provided by the client when the resource is created. | `string` | `"test"` | no |
| <a name="input_password_validation_policy_config"></a> [password\_validation\_policy\_config](#input\_password\_validation\_policy\_config) | The password validation policy settings for the database instance. | <pre>object({<br>    min_length                  = number<br>    complexity                  = string<br>    reuse_interval              = number<br>    disallow_username_substring = bool<br>    password_change_interval    = string<br>  })</pre> | `null` | no |
| <a name="input_pricing_plan"></a> [pricing\_plan](#input\_pricing\_plan) | The pricing plan for the master instance. | `string` | `"PER_USE"` | no |
| <a name="input_random_instance_name"></a> [random\_instance\_name](#input\_random\_instance\_name) | Sets random suffix at the end of the Cloud SQL resource name | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | The region of the Cloud SQL resources | `string` | `"us-central1"` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Terraform current module repo | `string` | `"https://github.com/cypik/terraform-google-postgresql"` | no |
| <a name="input_root_password"></a> [root\_password](#input\_root\_password) | Initial root password during creation | `string` | `null` | no |
| <a name="input_secondary_zone"></a> [secondary\_zone](#input\_secondary\_zone) | The preferred zone for the secondary/failover instance, it should be something like: `us-central1-a`, `us-east1-c`. | `string` | `null` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | The tier for the master instance. | `string` | `"db-f1-micro"` | no |
| <a name="input_update_timeout"></a> [update\_timeout](#input\_update\_timeout) | The optional timeout that is applied to limit long database updates. | `string` | `"30m"` | no |
| <a name="input_user_deletion_policy"></a> [user\_deletion\_policy](#input\_user\_deletion\_policy) | The deletion policy for the user. Setting ABANDON allows the resource to be abandoned rather than deleted. This is useful for Postgres, where users cannot be deleted from the API if they have been granted SQL roles. Possible values are: "ABANDON". | `string` | `null` | no |
| <a name="input_user_labels"></a> [user\_labels](#input\_user\_labels) | The key/value labels for the master instances. | `map(string)` | `{}` | no |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | The name of the default user | `string` | `"postgresql"` | no |
| <a name="input_user_password"></a> [user\_password](#input\_user\_password) | The password for the default user. If not set, a random one will be generated and available in the generated\_user\_password output variable. | `string` | `""` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | The zone for the master instance, it should be something like: `us-central1-a`, `us-east1-c`. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_name"></a> [connection\_name](#output\_connection\_name) | The connection name of the master instance to be used in connection strings |
| <a name="output_first_ip_address"></a> [first\_ip\_address](#output\_first\_ip\_address) | The first IPv4 address of the addresses assigned. |
| <a name="output_generated_user_password"></a> [generated\_user\_password](#output\_generated\_user\_password) | The auto-generated default user password if no input password was provided |
| <a name="output_iam_users"></a> [iam\_users](#output\_iam\_users) | The list of the IAM users with access to the CloudSQL instance |
| <a name="output_instances"></a> [instances](#output\_instances) | A list of all `google_sql_database_instance` resources we've created |
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | The IPv4 address assigned for the master instance |
| <a name="output_name"></a> [name](#output\_name) | The instance name for the master instance |
| <a name="output_primary"></a> [primary](#output\_primary) | The `google_sql_database_instance` resource representing the primary instance |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | The first private (PRIVATE) IPv4 address assigned for the master instance |
| <a name="output_psc_service_attachment_link"></a> [psc\_service\_attachment\_link](#output\_psc\_service\_attachment\_link) | The psc\_service\_attachment\_link created for the master instance |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | The first public (PRIMARY) IPv4 address assigned for the master instance |
| <a name="output_replicas"></a> [replicas](#output\_replicas) | A list of `google_sql_database_instance` resources representing the replicas |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The URI of the master instance |
| <a name="output_server_ca_cert"></a> [server\_ca\_cert](#output\_server\_ca\_cert) | The CA certificate information used to connect to the SQL instance via SSL |
| <a name="output_service_account_email_address"></a> [service\_account\_email\_address](#output\_service\_account\_email\_address) | The service account email address assigned to the master instance |
<!-- END_TF_DOCS -->