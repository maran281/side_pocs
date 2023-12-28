provider "google" {
    project = "plated-hash-405319"
    region = "us-east1"
}

terraform {
  backend "gcs" {
    bucket = "tf_statebucket_4_side_pocs"
    value = "bushing_data_bq"
  }
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