variable "project_id" {
  type        = string
  description = "The ID of the Google Cloud project to deploy resources to."
}

variable "region" {
  type        = string
  description = "The region in which to deploy the GKE cluster."
}

variable "ambassador_config_path" {
  type        = string
  description = "The path to the custom Ambassador configuration file."
  default     = "./ambassador.yaml"
}
