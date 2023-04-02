resource "google_storage_bucket" "this" {
  provider = google
  name     = var.bucket-name
  location = var.location
}

# Make new objects public
resource "google_storage_default_object_access_control" "website_read" {
  bucket = google_storage_bucket.this.name
  role   = "READER"
  entity = "allUsers"
}