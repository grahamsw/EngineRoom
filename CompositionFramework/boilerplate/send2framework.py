from pythonosc import udp_client


# save a sender and use it to send multiple messages to the same address
def sender(addr, ip='127.0.0.1', port=57120):
    client = udp_client.SimpleUDPClient(ip, port)
    def s(*args):
        client.send_message(addr, args)
    return s
    
# send a one-off message - msg must be an array
def send(addr, msg, ip='127.0.0.1', port=57120):
    sender(addr, ip, port)(*msg)
    
    