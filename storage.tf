resource "google_storage_bucket" "fixmate_files" {
  name                        = "fixmate-files-490017"
  location                    = "ASIA-SOUTH1"
  force_destroy               = false
  uniform_bucket_level_access = true

  public_access_prevention = "inherited"
}

resource "google_storage_bucket_iam_member" "public_read" {
  bucket = google_storage_bucket.fixmate_files.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}