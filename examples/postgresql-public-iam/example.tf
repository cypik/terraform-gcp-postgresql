provider "google" {
  project = "soy-smile-435017-c5"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

#####==============================================================================
##### postgresql-db module call.
#####==============================================================================
module "postgresql-db" {
  source                         = "./../../"
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
      email = "thesureshyadav76@gmail.com"
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