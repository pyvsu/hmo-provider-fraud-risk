from google.cloud import bigquery
import os

# These come from your CSV filenames — adjust if yours differ slightly
FILES = {
    "raw_provider_labels": "Train-1542865627584.csv",
    "raw_beneficiary": "Train_Beneficiarydata-1542865627584.csv",
    "raw_inpatient": "Train_Inpatientdata-1542865627584.csv",
    "raw_outpatient": "Train_Outpatientdata-1542865627584.csv",
}

DATA_DIR = os.path.expanduser("~/projects/hmo-provider-fraud-risk/data/raw")
PROJECT_ID = "hmo-provider-fraud-risk"
DATASET_ID = "raw"

client = bigquery.Client(project=PROJECT_ID)

# Create the dataset if it doesn't already exist
dataset_ref = f"{PROJECT_ID}.{DATASET_ID}"
dataset = bigquery.Dataset(dataset_ref)
dataset.location = "US"
client.create_dataset(dataset, exists_ok=True)
print(f"Dataset ready: {dataset_ref}")

# Load each CSV into its own table
job_config = bigquery.LoadJobConfig(
    source_format=bigquery.SourceFormat.CSV,
    skip_leading_rows=1,
    autodetect=True,
    write_disposition="WRITE_TRUNCATE",  # overwrite if rerun
)

for table_name, filename in FILES.items():
    filepath = os.path.join(DATA_DIR, filename)
    table_ref = f"{PROJECT_ID}.{DATASET_ID}.{table_name}"

    with open(filepath, "rb") as f:
        job = client.load_table_from_file(f, table_ref, job_config=job_config)
    job.result()  # wait for the job to finish

    table = client.get_table(table_ref)
    print(f"{table_name}: loaded {table.num_rows} rows")
