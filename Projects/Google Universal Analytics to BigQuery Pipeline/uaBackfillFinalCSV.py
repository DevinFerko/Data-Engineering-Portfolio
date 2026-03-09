import json
import pandas as pd
from google.oauth2 import service_account
from googleapiclient.discovery import build

# Path to your service account key file
KEY_FILE = 'C:/Users/Devin Ferko/Desktop/Codes/ua-backfill-424912-bf3ad1cba776.json'
# Google Analytics view ID
VIEW_ID = '129721902'
# Path to save the output CSV file
OUTPUT_FILE = 'C:/Users/Devin Ferko/Desktop/analytics_data2.csv'

# Authenticate with Google Analytics API
credentials = service_account.Credentials.from_service_account_file(
    KEY_FILE,
    scopes=['https://www.googleapis.com/auth/analytics.readonly']
)
analytics = build('analyticsreporting', 'v4', credentials=credentials)

def get_analytics_report():
    request_body = {
        'reportRequests': [
            {
                'viewId': VIEW_ID,
                'dateRanges': [{'startDate': '2018-01-01', 'endDate': '2023-06-30'}],
                'metrics': [
                    {'expression': 'ga:users'},
                    {'expression': 'ga:newUsers'},
                    {'expression': 'ga:percentNewSessions'},
                    {'expression': 'ga:sessionsPerUser'},
                ],
                'dimensions': [
                    {'name': 'ga:userType'},
                    {'name': 'ga:sessionCount'},
                    {'name': 'ga:daysSinceLastSession'},
                    {'name': 'ga:userDefinedValue'},
                    {'name': 'ga:userBucket'},
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

def save_data_to_csv(df, file_path):
    # Print DataFrame info for debugging
    print("DataFrame head:\n", df.head())
    print("DataFrame info:\n", df.info())
    
    # Save the DataFrame to a CSV file
    df.to_csv(file_path, index=False)
    print(f"Data successfully saved to {file_path}")

def main():
    rows, headers = get_analytics_report()
    print("Number of rows fetched:", len(rows))  # Debug print statement
    df = parse_response(rows, headers)
    if not df.empty:
        save_data_to_csv(df, OUTPUT_FILE)
    else:
        print("No data to save to CSV")

if __name__ == '__main__':
    main()
