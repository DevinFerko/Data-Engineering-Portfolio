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