# Modern Data Pipeline: API to BigQuery Ingestion

This repository contains a Python-based ETL pipeline that automates the ingestion of e-commerce data from a REST API into Google BigQuery. It is designed to handle nested JSON structures, manage database schemas dynamically, and provide resilient data fetching.

## Features
- **Resilient Extraction:** Implements a retry mechanism with exponential backoff for API calls.
- **Relational Mapping:** Automatically flattens nested JSON and handles one-to-many relationships (e.g., Carts to Products).
- **Auto-Schema Detection:** Dynamically generates BigQuery table schemas based on DataFrame dtypes.
- **Logging:** Comprehensive logging for monitoring pipeline health and troubleshooting.

## Architecture
1. **Source:** [Fake Store API](https://fakestoreapi.com/) (Products, Users, and Carts endpoints).
2. **Processing:** Python (Pandas) for data cleaning and normalization.
3. **Destination:** Google BigQuery (Data Warehouse).

## Setup & Configuration
1. **Prerequisites:**
   - Google Cloud Service Account with `BigQuery Admin` permissions.
   - Python 3.x installed.
2. **Dependencies:**
   ```bash
   pip install requests pandas google-cloud-bigquery pyarrow

# Breakdown of extract_api.py

## Configuration

This section of the script reads the project ID and dataset name from a local file. This is done out of a security practice and helps keep sensitive identifiers out of the main section of code.

## API Fetch Function with Retries

This function communicates with the API

- Retry Logic: This ```for``` loop retries the API call up to 3 times before exiting.
- Error Handling: ```response.raise_for_status()``` catches HTTP errors, example 404 or 500 errors.

## Transform layer

```normalize_json``` - This converts the JSON format into a Pandas DataFrame

```process_carts``` - This function splits "Cart" into ```carts``` and ```cart_products``` as a single cart can contain multiple products.

## Load Layer

```ensure_table``` - Instead of manually creating tables in BigQuery, this function gives the DataFrame data types and creates the table if it doesn't exist

```load_to_bq``` uses the ```load_table_from_dataframe``` method to send data from the script to BigQuery efficiently

## Extract

```extract_endpoint```

- The ```else``` path handles "flat" data like the products or users table. This is a straight line: Fetch -> Normalize -> Load

- The ```if``` path handles Relation Data which is present in "cart" as that data is an array of products. This creates a dataset which is easier to query in SQL.

## Main

Runs the script in order with logging