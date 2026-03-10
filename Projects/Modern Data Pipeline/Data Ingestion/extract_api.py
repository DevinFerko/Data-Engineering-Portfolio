# Import Libraries and Dependancies
import requests
import pandas as pd
from google.cloud import bigquery
import json
import logging
import time
from pathlib import Path

# -------------
# Configuration
# -------------

# API URL
api_base = "https://fakestoreapi.com"
headers = {"Content-Type": "application/json"}

# BigQuery
config = {}

with open(r"C:\Users\Devin Ferko\Desktop\Codes\Data Engineering Portfolio\Projects\Modern Data Pipeline\Data Ingestion\local_config.txt") as f:
    for line in f:
        key, value = line.strip().split("=")
        config[key] = value

bq_project = config["bq_project"]
bq_dataset = config["bq_dataset"]

print(bq_project)
print(bq_dataset)

# Map endpoints to Table Names
endpoints = {
    "products": "products",
    "carts": "carts",
    "users": "users"
}

# BigQuery Client
client = bigquery.Client(project=bq_project)

retry_limit = 3

# -------------
# Logging
# -------------

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

# -------------
# API Fetch Function with retries
# -------------

def fetch_api(endpoint):
    url = f"{api_base}/{endpoint}"
    for attempt in range(retry_limit):
        try:
            response = requests.get(url, headers=headers)
            response.raise_for_status() #fails if api is down
            logging.info(f"Fetched {endpoint}")
            return response.json()
    expect Exception as e:
        logging.warning(f"Attempt {attempt+1} failed: {e}")
        time.sleep(2)
    raise Exception(f"Failed to fetch {endpoint}")    

# -------------
# Normalize json
# -------------

def normalize_json(data):
    df = pd.json_normalize(data)
    df.columns = df.columns.str.replace(".", "_") #flattens columns names
    return df

# -------------
# Saves Raw json
# -------------

raw_dir = "raw_api"
Path(raw_dir).mkdir(exist_ok=True)

def save_json(endpoint, data):
    file_path = f"{raw_dir}/{endpoint}_raw.json"
    with open(file_path, "w") as f:
        json.dump(data, f, indent=2)
    logging.info(f"Saved raw JSON: {file_path}")

# -------------
# creates table if doesn't exist
# -------------

def ensure_table(table_id, df):
    try:
        client.get_table(table_id)
        logging.info(f"Table exists: {table_id}")
    except:
        schema = []
        for col in df.columns:
            dtype = "STRING"

            if pd.api.type.is_integer_dtype(df[col]):
                dtype = "INT64" 
            elif pd.api.type.is_float_dtype(df[col]):
                dtype = "FLOAT64" 
            schema.append(bigquery.SchemaField(col, dtype))

        table = bigquery.Table(table_id, schema=schema)
        client.create_table(table)
        logging.info(f"Created table: {table_id}")

# -------------
# Loads df to BigQuery
# -------------

def load_to_bq(df, table_id):
    job = client.load_table_from_dataframe(df, table_id)
    job.results()
    logging.info(f"Loaded {len(df)} rows into {table_id}")

# -------------
# Fetch/load per table
# -------------


# -------------
# Main
# -------------

def main():


if __name__ == "__main__":
    main()