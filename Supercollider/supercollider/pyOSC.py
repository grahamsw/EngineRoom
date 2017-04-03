# -*- coding: utf-8 -*-
"""
Created on Sun Jan  1 22:32:18 2017

@author: grahamsw
"""

import OSC

c = OSC.OSCClient()
c.connect(('localhost', 57121))   # localhost, port 57120
oscmsg = OSC.OSCMessage()
oscmsg.setAddress("/testMsg")
oscmsg.append(42)
c.send(oscmsg)

def handler(addr, tags, data, client_address):
    txt = "OSCMessage '%s' from %s: " % (addr, client_address)
    txt += str(data)
    print(txt)
    
s = OSC.OSCServer(('127.0.0.1', 57122))  # listen on localhost, port 57120
s.addMsgHandler('/testMsg', handler)     # call handler() for OSC messages received with the /startup address
s.serve_forever()    