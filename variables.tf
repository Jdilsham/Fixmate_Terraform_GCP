variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "asia-south1"
}

variable "zone" {
  description = "The GCP zone"
  type = string
  default = "asia-south1-a"
}

variable "db_password" {
  description = "Database password"
  sensitive = true
}