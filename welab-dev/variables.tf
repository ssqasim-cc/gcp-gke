
variable "project_id" {
  type        = string
  description = "The ID of the project to create resources in"
}

variable "cluster_name" {
  type        = string
  description = "This will be the clustername"
}

variable "machine_type" {
  type        = string
  default     = "e2-medium"
  description = "The zones where worker nodes are located"
}

variable "region" {
  type        = string
  description = "The region to use"
}

variable "main_zone" {
  type        = string
  description = "The zone to use as primary"
}

variable "cluster_node_zones" {
  type        = list(string)
  description = "The zones where Kubernetes cluster worker nodes should be located"
}

variable "credentials_file_path" {
  type        = string
  description = "The credentials JSON file used to authenticate with GCP"
}

variable "service_account" {
  type        = string
  description = "The GCP service account"
}

variable "enable_monitoring" {
  type    = bool
  default = false
}
variable "enable_logging" {
  type    = bool
  default = false
}

variable "database_name" {
  type        = string
  description = "The name of the database to create."
}

variable "db_tier" {
  type        = string
  description = "The machine type to use for the instance."
  default     = "db-custom-1-3840"
}

variable "multi_az" {
  type        = bool
  description = "Whether to create a multi-AZ instance."
  default     = false
}

variable "root_password" {
  type        = string
  description = "The root password for the instance."
}

variable "instance_name" {
  type        = string
  description = "The name of the Cloud SQL MySQL instance."
}

variable "bucket-name" {
  type = string
  description = "name of the bucket"
}

variable "location" {
  type = string
  description = "Location of the bucket"
}
variable "domain_name" {
  type = string
  description = "domain name for SSL cert"
}
