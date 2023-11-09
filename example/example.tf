provider "google" {
  project = "opz0-397319"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

#####==============================================================================
##### postgresql-db module call.
#####==============================================================================
module "postgresql-db" {
  source               = "../"
  name                 = "test"
  environment          = "postgresql-db"
  database_version     = "POSTGRES_9_6"
  zone                 = "us-central1-c"
  region               = "us-central1"
  tier                 = "db-custom-1-3840"
  deletion_protection  = false
  random_instance_name = true
  ip_configuration = {
    ipv4_enabled        = true
    private_network     = null
    require_ssl         = false
    allocated_ip_range  = null
    authorized_networks = var.authorized_networks
  }
}