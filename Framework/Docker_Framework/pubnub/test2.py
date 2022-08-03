import urllib.request
import json



def getData(url):
    req = urllib.request.Request(url)
    r = urllib.request.urlopen(req).read()
    return json.loads(r.decode('utf-8'))

def getCurrencies():
    url = 'https://api.coingecko.com/api/v3/coins/list'
    return [currency['symbol'] for currency in getData(url)]

def getCurrencyPrice(symbol):
    url = f'https://api.coingecko.com/api/v3/coins/{symbol}?sparkline=true'
    data = getData(url)
    return {'symbol':symbol,
            'price':data['market_data']['current_price']['usd'], 
            'supply':data['market_data']['circulating_supply'],
            'sentiment_up':data['sentiment_votes_up_percentage'],
            'sentiment_down':data['sentiment_votes_down_percentage'],
            'sparkline':data['market_data']['sparkline_7d']}

    
for symbol in  ['bitcoin', 'dogecoin', 'ethereum']: # currencies[0]
    print(f'{getCurrencyPrice(symbol)}')