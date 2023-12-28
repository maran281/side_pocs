from google.cloud import bigquery
import json

def upload_to_bigquery(jsonl_data, project_id, dataset_id, table_id):

    print("############# Inside xml_to_jsonl function #############")

    # Create a BigQuery client
    client = bigquery.Client(project=project_id)

    # Convert the JSON Lines string to a list of dictionaries
    data = [json.loads(line) for line in jsonl_data]

    print(f"Data after the json line converted to list dictionary: {data}")

    # Create a BigQuery table reference
    table_ref = client.dataset(dataset_id).table(table_id)

    # Configuring job for loading data into BigQuery
    job_config = bigquery.LoadJobConfig(write_disposition=bigquery.WriteDisposition.WRITE_APPEND,)

    # Load data into BigQuery table
    load_job = client.load_table_from_json(data, table_ref, job_config=job_config)
    load_job.result()

    print(f"Data loaded to {project_id}.{dataset_id}.{table_id}")

    print("############# Inside xml_to_jsonl function #############")