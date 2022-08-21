locals {
  static_website_bucket_name         = var.website_bucket_name != "" ? var.website_bucket_name : "${var.environment}-static-website-${random_pet.bucket.id}"
  cloud_function_archive_bucket_name = "${var.environment}-cf-archive-${random_pet.bucket.id}"
  archive_name                       = "cf-code.zip"
  labels = {
    subject     = "static-website"
    environment = var.environment
    tool        = "terraform"
  }
}

resource "random_pet" "bucket" {
  length = 1
}

# Static Website resources
resource "google_storage_bucket" "static_website" {
  name                        = local.static_website_bucket_name
  location                    = var.location
  storage_class               = "STANDARD"
  force_destroy               = true
  uniform_bucket_level_access = true
  labels                      = local.labels

  website {
    main_page_suffix = "index.html"
    not_found_page   = "error.html"
  }
}

resource "google_storage_bucket_iam_member" "static_website" {
  bucket = google_storage_bucket.static_website.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

# Cloud Function part
resource "google_storage_bucket" "cloud_function_archive" {
  name                        = local.cloud_function_archive_bucket_name
  location                    = var.location
  storage_class               = "STANDARD"
  force_destroy               = true
  uniform_bucket_level_access = true
  labels                      = local.labels
}

data "archive_file" "archive" {
  type        = "zip"
  source_dir  = "${path.module}/../cloud_function_code"
  output_path = "${path.module}/../files/${local.archive_name}"
}

resource "google_storage_bucket_object" "archive" {
  name   = local.archive_name
  bucket = google_storage_bucket.cloud_function_archive.name
  source = data.archive_file.archive.output_path
}

resource "google_cloudfunctions_function" "cache_control_metadata" {
  name        = "${var.environment}-cache-control-metadata-${random_pet.bucket.id}"
  description = "Function that updates object's Cache-Control metadata in ${google_storage_bucket.static_website.name} bucket"
  runtime     = "python310"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.cloud_function_archive.name
  source_archive_object = google_storage_bucket_object.archive.name
  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = google_storage_bucket.static_website.name
  }
  entry_point = "update_cache_control"

  labels = local.labels
}
