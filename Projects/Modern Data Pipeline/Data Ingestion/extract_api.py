# Import Libraries and Dependancies
import requests
import pandas as pd
from google.cloud import bigquery
import json

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
tables = {
    "products": f"{bq_project}.{bq_dataset}.products",
    "carts": f"{bq_project}.{bq_dataset}.carts",
    "users": f"{bq_project}.{bq_dataset}.userss"
}

client = bigquery.Client()

# -------------
# API Fetch Function
# -------------

def fetch_api(endpoint):
    url = f"{api_base}/{endpoint}"
    response = requests.get(url, headers=headers)
    response.raise_for_status() #fails if api is down
    return response.json()

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


# -------------
# Fetch/load per table
# -------------


# -------------
# Main
# -------------

def main():


if __name__ == "__main__":
    main()