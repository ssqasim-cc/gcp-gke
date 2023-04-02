resource "google_storage_bucket" "this" {
  name     = var.bucket_name
  location = var.location
  dynamic "website" {
    for_each = var.enable_static_website ? [1] : []
    content {
      main_page_suffix = var.indexpage
      not_found_page   = var.indexpage
    }
  }
}

# Make new objects public
resource "google_storage_default_object_access_control" "website_read" {
  bucket = google_storage_bucket.this.name
  role   = "READER"
  entity = "allUsers"
}
