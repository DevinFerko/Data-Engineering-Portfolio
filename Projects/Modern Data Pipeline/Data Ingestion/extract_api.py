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
bq_project = 'Insert'
bq_dataset = 'Insert'

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