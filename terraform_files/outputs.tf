output "static_website_bucket_name" {
  description = "Name of the static website bucket"
  value       = google_storage_bucket.static_website.name
}
