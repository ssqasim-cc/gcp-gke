output "external-ip" {
  value       = google_compute_global_address.website
  description = "The external IP for pointing DNS"
}
