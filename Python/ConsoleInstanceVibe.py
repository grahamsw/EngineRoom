# -*- coding: utf-8 -*-
"""
Created on Thu Mar 10 00:25:15 2016

@author: grahamsw
"""
from DVEditor import DynamicValue, DynamicValueConsole

   
# generates the signals listened for in simpleOscReceiverScore.ck      
dvs = [DynamicValue('f/lpf/Q', 0.0, 1.0, 0.4), 
       DynamicValue('f/vibratoFreq', 0.0, 10.0, 8.0),
       DynamicValue('f/vibratoGain', 0.0, 100.0, 90.0),
       DynamicValue('f/lpf/Q', 0.0, 2.0, 1.0), 
       DynamicValue('f/freq', 100.0, 1000.0, 200.0),
       DynamicValue('f/msOn', 0.0, 1000.0, 20.0),
       DynamicValue('f/gain', 0.0, 1.0, 0.7),
       DynamicValue('f/msOff', 0.0, 1000.0, 20.0)
       ]       
instanceName = 'vib1'
ip = '127.0.0.1'
port = 6449
      
      
ed = DynamicValueConsole(instanceName, dvs, ip, port)   
