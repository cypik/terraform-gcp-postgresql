provider "google" {
  project = "soy-smile-435017-c5"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

#####==============================================================================
##### postgresql-db module call.
#####==============================================================================
module "postgresql-db" {
  source               = "./../../"
  name                 = var.pg_ha_name
  random_instance_name = true
  database_version     = "POSTGRES_9_6"
  region               = "asia-northeast1"

  tier                            = "db-custom-1-3840"
  zone                            = "asia-northeast1-a"
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"

  deletion_protection = false

  database_flags = [{ name = "autovacuum", value = "off" }]

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
        value = var.pg_ha_external_ip_range
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

  db_name      = var.pg_ha_name
  db_charset   = "UTF8"
  db_collation = "en_US.UTF8"

  additional_databases = [
    {
      name      = "${var.pg_ha_name}-additional"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    },
  ]

  user_name     = "tftest"
  user_password = "foobar"

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