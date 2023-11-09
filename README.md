# terraform-gcp-postgresql-db
# Google Cloud Infrastructure Provisioning with Terraform
## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Module Inputs](#module-inputs)
- [Module Outputs](#module-outputs)
- [License](#license)

## Introduction
This project deploys a Google Cloud infrastructure using Terraform to create postgresql-db .
## Usage
To use this module, you should have Terraform installed and configured for GCP. This module provides the necessary Terraform configuration for creating GCP resources, and you can customize the inputs as needed. Below is an example of how to use this module:

# Example: postgresql-db

```hcl
module "postgresql-db" {
  source               = "git::https://github.com/opz0/terraform-gcp-postgresql.git?ref=v1.0.0"
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
```
This example demonstrates how to create various GCP resources using the provided modules. Adjust the input values to suit your specific requirements.

## Module Inputs

- 'name'  : The name of the postgresql-db.
- 'environment': The environment type.
- 'project_id' : The GCP project ID.
- 'region': The region the instance will sit in.
- 'database_version': The  postgresql Server version to use.
- 'user_password' : The password for the user.
- 'tier' :  The machine type to use.

## Module Outputs
Each module may have specific outputs. You can retrieve these outputs by referencing the module in your Terraform configuration.

- 'name' : The name for Cloud postgresql instance.
- 'first_ip_address' : The first IPv4 address of any type assigned.
- 'connection_name': The connection name of the instance to be used in connection strings.
- 'ip_address' : The first public (PRIMARY) IPv4 address assigned for the master instance.
- 'private_ip_address': The first private (PRIVATE) IPv4 address assigned for the master instance.
- 'self_link' : The URI of the master instance
- 'server_ca_cert' : The CA Certificate used to connect to the postgresql Instance via SSL.
- 'service_account_email_address' : The service account email address assigned to the instance.

## Examples
For detailed examples on how to use this module, please refer to the 'examples' directory within this repository.

## Author
Your Name Replace '[License Name]' and '[Your Name]' with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/opz0/terraform-gcp-postgresql/blob/readme/LICENSE) file for details.
