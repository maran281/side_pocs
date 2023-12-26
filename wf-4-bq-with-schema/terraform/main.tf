provider "google" {
  project = "plated-hash-405319"
  region = "us-east1"
}

#resource which stores the TF state file in the bucket
terraform {
  backend "gcs" {
    bucket = "tf_statebucket_4_side_pocs"
    prefix = "value"
  }
}

#Bigquery dataset where CF will publish the data
resource "google_bigquery_dataset" "bq_dataset_4_wf_4_bq_with_schema" {
    dataset_id = "bq_dataset_4_wf_4_bq_with_schema_id"
    project = "plated-hash-405319"
    location = "us-east1"
    default_table_expiration_ms = 3600000

    labels = {
      environment="development_env"
    }
}

#Bigquery table where CF will publish the data
resource "google_bigquery_table" "bq_table_4_wf_4_bq_with_schema" {
  dataset_id = google_bigquery_dataset.bq_dataset_4_wf_4_bq_with_schema.dataset_id
  table_id = "bq_table_4_wf_4_bq_with_schema"
  schema = jsonencode(jsondecode(file("bq_table1_schema.json")))

#Below example shows if you want to hardcode the schema in the file itself
#  schema = <<EOF
#  {"catalog": {"book": {"author": "string", "genre": "string", "price": "number", "publish_date": "string", "description": "string", "Age_Criteria": "string"}}}
#  EOF

  time_partitioning {
    type = "DAY"
  }
}

