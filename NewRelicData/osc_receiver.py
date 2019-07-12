from pythonosc import dispatcher
from pythonosc import osc_server
import threading
from threadrunners import rlocker

oscChannel = '/fromSC'
ip = '127.0.0.1'
port = 5771


_vals = {}

@rlocker
def readSupercolliderVal(key):
    return _vals[key]

@rlocker
def _setSupercolliderVal(key, val):
    _vals[key] = val

def handleMsg(unused_addr, key, val ):
  _setSupercolliderVal(key, val)



def makeDispatcher(addHandlerDict):
    disp = dispatcher.Dispatcher()
    for addr in addHandlerDict:
        disp.map(addr, addHandlerDict[addr])
    return disp




def initServer(ip, port, dispatcher):
  server = osc_server.ThreadingOSCUDPServer((ip, port), dispatcher)
  print("Serving on {}".format(server.server_address))
  server.serve_forever()    
  
  
disp = makeDispatcher({oscChannel: handleMsg})


t  = threading.Thread(target = initServer, args=(ip, port, disp) )   
t.start()