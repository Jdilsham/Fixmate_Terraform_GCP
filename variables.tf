variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "asia-south1"
}

variable "zones" {
  description = "The GCP zone"
  type        = string
  default = [
    "asia-south1-a",
    "asia-south1-b",
    "asia-south1-c"
  ]
}

variable "db_password" {
  description = "Cloud SQL database password"
  sensitive   = true
}