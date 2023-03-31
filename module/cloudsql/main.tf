locals {
  region            = var.region
  network_name      = var.project_id
  database_name     = var.database_name
  database_version  = "MYSQL_8_0"
  db_tier           = var.db_tier
  multi_az          = var.multi_az
  availability_zone = var.availability_zone
  root_password     = var.root_password
  instance_name     = var.instance_name
  private_network   = var.subnet_name
}

resource "google_sql_database_instance" "mysql_instance" {
  name             = local.instance_name
  database_version = local.database_version
  region           = local.region
  settings {
    tier              = local.db_tier
    availability_type = local.multi_az ? "REGIONAL" : "ZONAL"
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.subnet_name
    }
  }
}

data "template_file" "cloud_sql_instance" {
  template = file("${path.module}/templates/cloud_sql_instance.tf.tpl")
  vars = {
    instance_name   = local.instance_name
    private_network = local.private_network
    root_password   = local.root_password
  }
}
