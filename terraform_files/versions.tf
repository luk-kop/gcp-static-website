terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.32.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.2"
    }
  }

  required_version = "~> 1.2.1"
}
