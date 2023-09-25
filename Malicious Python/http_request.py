#!/usr/bin/python3

import requests
from requests.packages.urllib3.exceptions import InsecureRequestWarning

# Disable the InsecureRequestWarning
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

url = 'https://www.google.com'  # Replace with your URL

params = {
    'param1': 'value1',
    'param2': 'value2',
}

acceptable_responses = [200,201,202,203,204,301,302]
# Make the GET request with SSL verification disabled
try:
    response = requests.get(url, params=params, verify=False)

    # Check if the request was successful (status code 200)
    if response.status_code in acceptable_responses:
        print('Request was successful')
        print(f'Status code: {response.status_code}')
        print('Response content:')
        print(response.text)
    else:
        print(f'Request failed with status code: {response.status_code}')
        print('Response content:')
        print(response.text)

except requests.exceptions.RequestException as e:
    print(f'An error occurred: {e}')
