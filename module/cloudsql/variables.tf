variable "project_id" {
  type        = string
  description = "The ID of the Google Cloud project."
}

variable "region" {
  type        = string
  description = "The region in which to create the Cloud SQL MySQL instance."
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

variable "availability_zone" {
  type        = string
  description = "The availability zone in which to create the instance."
}

variable "root_password" {
  type        = string
  description = "The root password for the instance."
}

variable "instance_name" {
  type        = string
  description = "The name of the Cloud SQL MySQL instance."
}

variable "subnet_name" {
  type        = string
  description = "The CIDR range for authorized network access."
}
