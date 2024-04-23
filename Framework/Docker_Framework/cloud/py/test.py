import requests
import json
import os
import inspect



url_base = 'https://www.alphavantage.co/query?function={function}&symbol={symbol}&interval={interval}&apikey={apikey}'

function = 'TIME_SERIES_INTRADAY'
symbol = 'IBM'
interval = '5min'


def read_api():
    fn = 'secrets/alpha.json'
    script_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe()))) 
    with open(script_dir + '/' + fn) as f:
        return json.load(f)['api']

apikey = read_api()
print(apikey)

url = url_base.format(function = function, symbol = symbol, interval=interval, apikey = apikey)

r = requests.get(url)
data = r.json()

print(data)