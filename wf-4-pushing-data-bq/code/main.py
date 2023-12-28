import logging
from xml_to_jsonl import xml_to_jsonl
from upload_to_bigquery import upload_to_bigquery
from google.cloud import storage, bigquery
import functions_framework

@functions_framework.http
def process_xml(request):
    xml_content= """<book><id>bk101</id><author>None</author><title>XML Developer's Guide</title><genre>Computer</genre><price>44.95</price><publish_date>2000-10-01</publish_date><description>An in-depth look at creating applications with XML.</description></book>"""

    #Convert xml into a json format

    jsonl_data = xml_to_jsonl(xml_content)

    # Specify your BigQuery project, dataset, and table
    project_id = "plated-hash-405319"
    dataset_id = "bq_dataset_4_wf_4_pushing_data_bq"
    table_id = "bq_table_4_wf_4_pushing_data_bq"

    # Upload JSONL data to BigQuery
    upload_to_bigquery(jsonl_data, project_id, dataset_id, table_id)

    return "task is completed"

