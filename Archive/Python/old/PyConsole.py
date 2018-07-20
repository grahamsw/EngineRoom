# -*- coding: utf-8 -*-
"""
Created on Mon Jun 15 16:49:32 2015

@author: g.stalker-wilde
"""

import tkinter as tk
import uuid 
from collections import namedtuple
from sendOSC2 import makeOscSender

DynamicValue = namedtuple("DynamicValue", "address fr to start")
DynamicValueEditor = namedtuple("DynamicValueEditor", "address_editor from_editor to_editor slider button")
        
class DynamicValueConsole:
    def __init__(self, dvals, ip, port): 
        self.sender = makeOscSender(ip, port)
        
        self.root = tk.Tk()
        self.root.title("Osc Console")
        self.dves = {}
        for dv in dvals:
            self.addSetter(dv)
        self.root.mainloop()
      
           
    def send(self, addr, val):  
        print (addr + ': ' + str( float(val) ))
        self.sender(addr, float(val) )

    
    def update(self, key):
        dve = self.dves[key]
        print (dve.address_editor.get() + ' from: ' + dve.from_editor.get() + ' to: ' + dve.to_editor.get())
        dve.slider["from_"] = float(dve.from_editor.get()) 
        dve.slider["to"] = float(dve.to_editor.get()) 
        dve.slider.set(float(dve.from_editor.get()))
        
    def addSetter(self, dval): 
        key = uuid.uuid4()   
        separator1 = tk.Frame(height=2, bd=1, relief=tk.SUNKEN)
        address1 = tk.Entry(self.root)
        address1.insert(0,dval.address)
        from1 = tk.Entry(self.root)
        from1.insert(0,dval.fr)
        to1 = tk.Entry(self.root)
        to1.insert(0,dval.to)
        
        button1 = tk.Button(self.root, text="Update", command=lambda: self.update(key))
        slider1 = tk.Scale(self.root, from_=dval.fr, to=dval.to , orient=tk.HORIZONTAL, command=lambda x: self.send(address1.get(), x), resolution=0.1, relief=tk.SOLID)
        separator1.pack(fill=tk.X, padx=5, pady=10)     
        address1.pack()
        slider1.pack()
        from1.pack()
        to1.pack()
        button1.pack(pady=5)  
        slider1.set(dval.start)
        self.dves[key] = DynamicValueEditor(address1, from1, to1, slider1, button1)
        self.send(dval.address, dval.start)
   