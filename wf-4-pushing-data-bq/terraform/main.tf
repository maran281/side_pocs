provider "google" {
    project = "plated-hash-405319"
    region = "us-east1"
}

terraform {
  backend "gcs" {
    bucket = "tf_statebucket_4_side_pocs"
    prefix = "bushing_data_bq"
  }
}

#Bucket which stores the souce code for the cloud function
resource "google_storage_bucket" "cf_sc_4_wf_4_pushing_data_bq" {
  name = "bucket_sourcecode_4_pushing_data_bq"
  location = "us-east1"
}

#resource which places the source code object for the cloud function from local to the bucket
resource "google_storage_bucket_object" "cf_sourcecodeobject_4_pushing_data_bq" {
  name = "main.zip"
  bucket = google_storage_bucket.cf_sc_4_wf_4_pushing_data_bq.name
  source = "../code/main.zip"

  depends_on = [ google_storage_bucket.cf_sc_4_wf_4_pushing_data_bq ]
}

#Bigquery dataset where CF will publish the data
resource "google_bigquery_dataset" "bq_dataset_4_wf_4_pushing_data_bq" {
    dataset_id = "bq_dataset_4_wf_4_pushing_data_bq"
    project = "plated-hash-405319"
    location = "us-east1"
    default_table_expiration_ms = 3600000

    labels = {
      environment="development_env"
    }
}

#Bigquery table where CF will publish the data
resource "google_bigquery_table" "bq_table_4_wf_4_pushing_data_bq" {
  dataset_id = google_bigquery_dataset.bq_dataset_4_wf_4_pushing_data_bq.dataset_id
  table_id = "bq_table_4_wf_4_pushing_data_bq"
  schema = jsonencode(jsondecode(file("schema/bq_table1_schema.jsonl")))

#Below example shows if you want to hardcode the schema in the file itself
#  schema = <<EOF
#  {"catalog": {"book": {"author": "string", "genre": "string", "price": "number", "publish_date": "string", "description": "string", "Age_Criteria": "string"}}}
#  EOF

  time_partitioning {
    type = "DAY"
  }
}

resource "google_cloudfunctions_function" "cf_4_wf_4_pushing_data_bq" {
  name = "cf_4_wf_4_pushing_data_bq"
  runtime = "python310"
  source_archive_bucket = google_storage_bucket.cf_sc_4_wf_4_pushing_data_bq.name
  source_archive_object = google_storage_bucket_object.cf_sourcecodeobject_4_pushing_data_bq.name

  entry_point = "process_xml"
  trigger_http = true
  timeout = 60

  service_account_email = "side-pocs-sa@plated-hash-405319.iam.gserviceaccount.com"

}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  cloud_function = google_cloudfunctions_function.cf_4_wf_4_pushing_data_bq.name
  role = "roles/cloudfunctions.invoker"
  member = "allUsers"
}