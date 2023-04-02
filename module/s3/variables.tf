variable "bucket_name" {
  type        = string
  description = "name of the bucket"
}

variable "location" {
  type        = string
  description = "Location of the bucket"
}

variable "indexpage" {
  type        = string
  default     = "index.html"
  description = "Name of the Index HTML File with Extension Ex: Index.html Main.html"
}

variable "enable_static_website" {
  type    = bool
  default = false
}
