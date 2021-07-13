import os
import pandas as pd

root = r"C:\Users\graha\Documents\dev\github\EngineRoom\Framework\PythonLib"
#root = r"C:\Users\g.stalker-wilde\Google Drive\Documents\dev\repos\EngineRoom\\"
os.chdir(root)

from send2framework import sender
from threadrunners import rlocker, run_in_thread
from gart import read_live_data, pageMetrics, get_section_counts
from generators import const_gen, keyed_gen

# a threadsafe senderpa
s = rlocker(sender('/implOsc', ip='127.0.0.1', port=57121))


def format_section_counts(section_counts):
    ret = [['setSections']]
    ret.extend([[section_name, int(section_counts[section_name])] for section_name in section_counts])
    return sum(ret, []) # wicked, inefficient and obscure way of flattening a list of lists

               

sections = [
    '/',
    '/about/',
    '/about/careers/',
    '/about/people/',
    '/about/people/darren-walker/',
    '/about/the-ford-foundation-center-for-social-justice/',
    '/campaigns/',
    '/just-matters/',
    '/our-work-around-the-world/',
    '/the-latest/',
    '/work/challenging-inequality/',
    '/work/our-grants/',
    '/work/',
    '/search'
    ]

    
#fs = format_section_counts(get_section_counts(sections))

def start():
    s('start')
    
    def next_val_():
        rtd = read_live_data()
        print(rtd)
        return ['setRate', int(rtd['activeUsers']), 60] # 60 is max rate - can reset dynamically if necessary
    def next_val():   
        return format_section_counts(get_section_counts(sections))
    
    stopper, _ = run_in_thread(s, keyed_gen(next_val), const_gen(15)) 
    return stopper

def stop():
    stopper.set()
    s('stop')


stopper = start()


