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
    ipv4_enabled        = true
    private_network     = null
    ssl_mode            = "ENCRYPTED_ONLY"
    allocated_ip_range  = null
    authorized_networks = var.authorized_networks
  }
}