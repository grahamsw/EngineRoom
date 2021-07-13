import pandas as pd
import json

def parseline(l):
    # {'numPageViews': 143, 'activeUsers': 12}
    l = l.replace("{'numPageViews': ", "")
    l =  l.replace(" 'activeUsers': ", "")
    l = l.replace("}", "")
    ps = l.split(',')
    return {'numPageViews': int(ps[0]), 'activeUsers': int(ps[1])}


f =  open('log.txt')
ls  = f.readlines()

lss = [parseline(l) for l in ls]

for l in lss[:20]:
    print(l)

df = pd.DataFrame(lss)

print(df.head())

df.to_csv('log.csv')
