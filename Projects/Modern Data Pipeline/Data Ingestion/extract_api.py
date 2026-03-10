# Import Libraries and Dependancies
import requests
import pandas as pd
from google.cloud import bigquery
import json
import logging
import time

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

def save_json(endpoint, data):
    with open(f"{endpoint}_raw.json", "w") as f:
        json.dump(data, f, indent=2)

# -------------
# Loads df to BigQuery
# -------------

def load_to_bq(df, table_id):
    job = client.load_table_from_dataframe(df, table_id)
    job.results()
    print(f"Loaded {len(df)} rows to {table_id}")

# -------------
# Fetch/load per table
# -------------


# -------------
# Main
# -------------

def main():


if __name__ == "__main__":
    main()