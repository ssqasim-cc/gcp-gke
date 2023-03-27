
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
