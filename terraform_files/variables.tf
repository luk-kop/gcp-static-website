variable "project_id" {
  description = "The GCP project id."
  type        = string
}

variable "environment" {
  description = "The resources environment."
  type        = string
  default     = "test"
}

variable "region" {
  description = "The GCP region in which resources will be deployed."
  type        = string
  default     = "europe-central2"
}

variable "location" {
  description = "The GCP location where the buckets will be deployed."
  type        = string
  default     = "EUROPE-CENTRAL2"
}

variable "website_bucket_name" {
  description = "The custom name for GCP bucket hosting static website."
  type        = string
  default     = ""
}