# -*- coding: utf-8 -*-
"""
Created on Mon Jun 15 16:49:32 2015

@author: g.stalker-wilde
"""

import tkinter as tk
import OSC

class DynamicValue:
    def __init__(self, address, fr, to):
        self.address = address
        self.fr = fr
        self.to = to
        
        
class DynamicValueEditor:
    def __init__(self, dvals, ip, port):    
        self.c = OSC.OSCClient()
        self.c.connect((ip,port))
        
        self.root = tk.Tk()
        self.root.title("Osc Console")
        for dv in dvals:
            self.addSetter(dv.address, dv.fr, dv.to)
        self.root.mainloop()
    
       
    
    
    def send(self, addr, val):  
        print (addr + ': ' + val)
        oscmsg = OSC.OSCMessage()
        oscmsg.setAddress(addr)
        oscmsg.append(float(val)/100.0)
        self.c.send(oscmsg)
    
    def update(self, slider, label, address, from_, to):
        print ('nob from: ' + from_ + ' to: ' + to)
        label["text"] = address
        slider["from_"] = from_ * 100
        slider["to"] = to * 100
        slider.set(from_ * 100)
    
    def addSetter(self, addr='/poop/freq', f = 0, t = 100):
                
        label1 = tk.Label(self.root, text=addr)
        address1 = tk.Entry(self.root)
        address1.insert(0,addr)
        from1 = tk.Entry(self.root)
        from1.insert(0,f)
        to1 = tk.Entry(self.root)
        to1.insert(0,t)
        
        button1 = tk.Button(self.root, text="Update", command=lambda: self.update(slider1,label1,address1.get(),from1.get(), to1.get()))
        slider1 = tk.Scale(self.root, from_=f * 100, to=t * 100, orient=tk.HORIZONTAL, command=lambda x: self.send(address1.get(), x))
        label1.pack()
        slider1.pack()
        address1.pack();
        from1.pack()
        to1.pack()
        button1.pack()  

      
      
dvs = [DynamicValue('/first/gain', 0, 100), DynamicValue('/first/freq', 1000, 2000)]
ed = DynamicValueEditor(dvs, '127.0.0.1', 6449)   