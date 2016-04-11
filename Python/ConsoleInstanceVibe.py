# -*- coding: utf-8 -*-
"""
Created on Thu Mar 10 00:25:15 2016

@author: grahamsw
"""
from DVEditor import DynamicValue, DynamicValueConsole

   
# generates the signals listened for in simpleOscReceiverScore.ck      
dvs = [DynamicValue('/vib1/f/lpf/Q', 0.0, 1.0, 0.4), 
       DynamicValue('/vib1/f/vibratoFreq', 0.0, 10.0, 8.0),
       DynamicValue('/vib1/f/vibratoGain', 0.0, 100.0, 90.0),
       DynamicValue('/vib1/f/lpf/Q', 0.0, 2.0, 1.0), 
       DynamicValue('/vib1/f/freq', 100.0, 1000.0, 200.0),
       DynamicValue('/vib1/f/msOn', 0.0, 1000.0, 20.0),
       DynamicValue('/vib1/f/gain', 0.0, 1.0, 0.7),
       DynamicValue('/vib1/f/msOff', 0.0, 1000.0, 20.0)
       ]
       
       
      
#dvs1.Init(["f/gain",  "f/freq", "f/msOn", "f/msOff", "f/pfreq"], 
#         [0.7 ,      400.0  ,  100.0,    200, 2000 ]);
ed = DynamicValueConsole(dvs, '127.0.0.1', 6449)   
