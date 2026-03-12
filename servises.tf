resource "google_project_service" "services" {
  for_each = toset([                   #Converts the list into a set.
    "container.googleapis.com",        #Google Kubernetes Engine
    "compute.googleapis.com",          #Compute Engine
    "iam.googleapis.com",              #Identity and Access Management (IAM)
    "sqladmin.googleapis.com",         #Cloud SQL
    "artifactregistry.googleapis.com", #Artifact Registry
    "servicenetworking.googleapis.com" #Private Service Networking
  ])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}
