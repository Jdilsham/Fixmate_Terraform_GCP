terraform {
  backend "gcs" {
    bucket = "fixmate-terraform-state"
    prefix = "terraform/state"
  }
}