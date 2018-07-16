

from pythonosc import osc_message_builder
from pythonosc import udp_client

# can send an array 
def sendSC(addr, val):
    sendMsg('127.0.0.1', 57120, addr, val)
    
def sendMsg(ip, port, addr, val):
  client = udp_client.SimpleUDPClient(ip, port)
  client.send_message(addr, val)


sendSC('/testImplOsc', ['makeS'])
#sendSC('/testImplOsc', ['killS'])
sendSC('/testImplOsc', ['setFreq', 300])
sendSC('/testImplOsc', ['setAmp', 0.8])

