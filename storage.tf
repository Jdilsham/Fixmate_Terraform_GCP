resource "google_storage_bucket" "fixmate_files" {
  name                        = "fixmate-files-490017"
  location                    = "ASIA-SOUTH1"
  force_destroy               = false
  uniform_bucket_level_access = true

  public_access_prevention = "enforced"
}

resource "google_storage_bucket_iam_member" "fixmate_backend_bucket_access" {
  bucket = google_storage_bucket.fixmate_files.name
  role   = "roles/storage.objectAdmin"

  member = "serviceAccount:fixmate-gke-sa@fixmate-490017.iam.gserviceaccount.com"
}