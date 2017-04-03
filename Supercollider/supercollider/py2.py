# -*- coding: utf-8 -*-
"""
Created on Mon Jan  2 15:11:32 2017

@author: grahamsw
"""

import OSC
import time, random
client = OSC.OSCClient()
client.connect( ( '127.0.0.1', 57120 ) )
msg = OSC.OSCMessage()
msg.setAddress("/print")
msg.append(100)
client.send(msg)