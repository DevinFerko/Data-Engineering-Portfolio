import json
import pandas as pd
from google.oauth2 import service_account
from googleapiclient.discovery import build
from google.cloud import bigquery

# Timing Function
import time 
startTime = time.time()

# Path to your service account key file
KEY_FILE = 'Your JSON File Path'
# Google Analytics view ID
VIEW_ID = 'Your View_ID'
# BigQuery dataset and table
DATASET_ID = 'Your Dataset Name'
TABLE_ID = 'Your Table Name' 

# Authenticate with Google Analytics API
credentials = service_account.Credentials.from_service_account_file(
    KEY_FILE,
    scopes=['https://www.googleapis.com/auth/analytics.readonly']
)
analytics = build('analyticsreporting', 'v4', credentials=credentials)

# Authenticate with BigQuery
bq_client = bigquery.Client.from_service_account_json(KEY_FILE)

def get_analytics_report():
    request_body = {
        'reportRequests': [
            {
                'viewId': VIEW_ID,
                'dateRanges': [{'startDate': '2012-01-01', 'endDate': '2017-12-31'}],
                'metrics': [
                    {'expression': 'ga:CTR'},
                    {'expression': 'ga:costPerTransaction'},
                    {'expression': 'ga:costPerGoalConversion'},
                    {'expression': 'ga:costPerConversion'},
                    {'expression': 'ga:RPC'},
                    {'expression': 'ga:ROAS'},
                ],
                'dimensions': [
                    {'name': 'ga:adwordsCampaignID'},
                    {'name': 'ga:adwordsAdGroupID'},
                    {'name': 'ga:adwordsCreativeID'},
                    {'name': 'ga:adwordsCriteriaID'},
                    {'name': 'ga:adQueryWordCount'},
                    {'name': 'ga:isTrueViewVideoAd'}, 
                ],
                'pageSize': 1000  # Request up to 1000 rows at a time
            }
        ]
    }

    all_rows = []
    while True:
        response = analytics.reports().batchGet(body=request_body).execute()
        report = response['reports'][0]
        rows = report.get('data', {}).get('rows', [])
        all_rows.extend(rows)
        
        next_page_token = report.get('nextPageToken')
        if not next_page_token:
            break
        
        request_body['reportRequests'][0]['pageToken'] = next_page_token
    
    return all_rows, response['reports'][0]['columnHeader']

def parse_response(rows, headers):
    if not rows:
        return pd.DataFrame()  # Return an empty DataFrame if no rows are available

    dimension_headers = headers['dimensions']
    metric_headers = [metric['name'] for metric in headers['metricHeader']['metricHeaderEntries']]

    data = []
    for row in rows:
        dimensions = row['dimensions']
        metrics = row['metrics'][0]['values']
        data.append(dimensions + metrics)
    
    columns = dimension_headers + metric_headers
    
    df = pd.DataFrame(data, columns=columns)
    return df

def load_data_to_bigquery(df):
    # Print DataFrame info for debugging
    print("DataFrame head:\n", df.head())
    print("DataFrame info:\n", df.info())
    
    table_ref = bq_client.dataset(DATASET_ID).table(TABLE_ID)
    job = bq_client.load_table_from_dataframe(df, table_ref)
    job.result()  # Wait for the job to complete
    print(f"Data successfully loaded to BigQuery table {DATASET_ID}.{TABLE_ID}")

def main():
    rows, headers = get_analytics_report()
    print("Number of rows fetched:", len(rows))  # Debug print statement
    df = parse_response(rows, headers)
    if not df.empty:
        load_data_to_bigquery(df)
    else:
        print("No data to load to BigQuery")

if __name__ == '__main__':
    main()

print("Time took to run --- %s seconds ---" % (time.time() - startTime))