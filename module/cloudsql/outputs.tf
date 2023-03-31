output "cloud_sql_instance" {
  value = data.template_file.cloud_sql_instance.rendered
}
