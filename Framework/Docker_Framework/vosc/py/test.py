import requests


url_base = 'https://www.alphavantage.co/query?function={function}&symbol={symbol}&interval={interval}&apikey={apikey}'

function = 'TIME_SERIES_INTRADAY'
symbol = 'IBM'
interval = '5min'
apikey = 'JSQ40HHAZWBDHK0R'

url = url_base.format(function = function, symbol = symbol, interval=interval, apikey = apikey)


# replace the "demo" apikey below with your own key from https://www.alphavantage.co/support/#api-key
r = requests.get(url)
data = r.json()

print(data)