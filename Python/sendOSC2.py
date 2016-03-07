from pythonosc import osc_message_builder
from pythonosc import udp_client


def makeOscSender(ip, port):
    c = udp_client.UDPClient(ip, port)
    def send(addr, val):
        oscmsg = osc_message_builder.OscMessageBuilder(addr)
        oscmsg.add_arg(val)
        c.send(oscmsg.build())
    return send

