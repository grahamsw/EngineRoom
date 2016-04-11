# -*- coding: utf-8 -*-
"""
Created on Mon Jun 15 16:49:32 2015

@author: g.stalker-wilde
"""

import Tkinter as tk
import OSC

class DynamicValue:
    def __init__(self, address, fr, to):
        self.address = address
        self.fr = fr
        self.to = to
        
        
class DynamicValuesEditor:
    def __init__(self, dvals, ip, port):    
        self.c = OSC.OSCClient()
        self.c.connect((ip,port))
        
        self.root = tk.Tk()
        self.root.title("Osc Console")
        for dv in dvals:
            self.addSetter(dv.address, dv.fr, dv.to)
        self.root.mainloop()
    
       
    
    
    def send(self, addr, val, v):  
        print ('%s: %f' % (addr, (float(val) /100.0)))
        v["text"] = float(val) / 100.0
        oscmsg = OSC.OSCMessage()
        oscmsg.setAddress(addr)
        oscmsg.append(float(val)/100.0)
        self.c.send(oscmsg)
    
    def update(self, slider, label, address, from_, to):
        print "spunk update: from: %s, to: %s" % (from_, to)
        label["text"] = address
        slider["from_"] = int(from_) * 100
        slider["to"] = int(to) * 100
        slider.set(int(from_) * 100 )
    
    def addSetter(self, addr, f, t):
        label1 = tk.Label(self.root, text=addr)
        address1 = tk.Entry(self.root)
        address1.insert(0,addr)
        from1 = tk.Entry(self.root)
        from1.insert(0,f)
        to1 = tk.Entry(self.root)
        to1.insert(0,t)
        
        button1 = tk.Button(self.root, text="Update", command=lambda: self.update(slider1,label1,address1.get(),from1.get(), to1.get()))
        slider1 = tk.Scale(self.root, from_=f * 100 , to=t*100, showvalue = 0,  orient=tk.HORIZONTAL, command=lambda x: self.send(address1.get(), x, val))
        val = tk.Label(self.root, text = f)        
        label1.pack()
        val.pack()
        slider1.pack()
        address1.pack();
        from1.pack()
        to1.pack()
        button1.pack()  
      
      
  