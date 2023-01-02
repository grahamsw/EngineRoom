# Python 3 server example
from http.server import BaseHTTPRequestHandler, HTTPServer, CGIHTTPRequestHandler
from io import BytesIO
import urllib.parse
from urllib.parse import unquote_plus
from html import escape

import time
import sys

sys.path.append('./lib')

from send2framework import sender
from threadrunners import rlocker
import time
import os


state = {'clocks':{}, 'instruments':{}}

print("hello from web server", flush=True)

def parsePath(path):
    description = f"path: {path} is invalid"
    def split_path(path):
        if path[0] == '/':
            path = path[1:]      
        return path.split('/')
    parts = split_path(path)
    if len(parts) == 3:
        if parts[0] == 'clock':
            if parts[2].isnumeric():
                rate = int(parts[2])
                set_clock(rate, parts[1])
                description = f"set clock {parts[1]} to {rate}"
        elif parts[0] == 'start':
            mm = urllib.parse.unquote(parts[2])

            start_instrument(parts[1], mm)
            description = f"start instrument {parts[1]} with melody {mm}"
        elif parts[0] == 'change':
            mm = urllib.parse.unquote(parts[2])
            change_instrument(parts[1], mm)
            description = f"change instrument {parts[1]} with melody {mm}"    
    elif len(parts) == 2:
        if parts[0] == 'stop':
            stop_instrument(parts[1])
            description = f"stop instrument {parts[1]}"
    
    return description



def make_sender():
    host =  os.getenv('SC_IP') or '172.70.0.2'
    port =  57120 if not os.getenv('SC_PORT') else int(os.getenv('SC_PORT'))
    osc_chan = os.getenv('SC_OSC_CHANNEL') or '/implOsc'
    print(host, port, osc_chan)
    s = rlocker(sender(osc_chan, ip=host, port=port))
    return s

def set_clock(rate, name):
    state['clocks']['name'] =  rate
    s = make_sender()
    s('set_clock', rate, name)

def start_instrument(name, melody):
    state['instruments'][name] =  melody
    s = make_sender()
    s('start', name, melody)

def change_instrument(name, melody): 
    if name in state['instruments']:   
        state['instruments'][name] =  melody

    s = make_sender()
    s('change', name, melody)

def stop_instrument(name):
    if name in state['instruments']:
        del state['instruments'][name]
    s = make_sender()
    s('stop', name)


hostName = "0.0.0.0"
serverPort = 8000

class MyServer(CGIHTTPRequestHandler):

    def parse_inputs(inputs):
        def clean(st):
            return unquote_plus(st).strip()
        ret = {}
        inputs = inputs.replace("b'", "").replace("'", "")
        ps = [p.split('=') for p in inputs.split('&')]
        for p in ps:
            ret[clean(p[0])] = clean(p[1])
        return ret
    

    def handle_inputs(input_dict):
        print('in handle_inputs', flush=True)
        if 'formType' not in input_dict:
            print("bad input")
            return
        form_type = input_dict['formType']
        if form_type == 'newInstrument' or form_type == 'changeInstrument':
            instrument = input_dict['iname']
            melody = input_dict['melody']
            if instrument in state['instruments']:
                change_instrument(instrument, melody)
            else:
                start_instrument(instrument, melody)
            #state['instruments'][instrument] = melody
        elif form_type == 'deleteInstrument':
            stop_instrument(instrument)




    def basic_item_formatter(key, item):
        return f'{escape(key)}: {escape(item)}'

    def make_list(title, dict, item_formatter=basic_item_formatter ):
        ret = [f'<div><span><em>{title}</em></span>', '<ul>']
        for k in dict:
            ret.append(f'<li>{item_formatter(k, dict[k])}</li>')
        ret.append('</ul>\n</div>')
        return '\n'.join(ret)

    def make_audio_embed():
        ret = [
            '<div>',
            '<audio controls autoplay name="media"><source src="https://audio.spiderhats.com/panola" type="audio/mpeg">',
            '</audio>',
            '</div>'
        ]
        return '\n'.join(ret)


    def make_instrument_form():
        ret = [
            '<form   method="POST">',
            '<input type="hidden" id="formType" name="formType" value="newInstrument">'
            '<label for="iname">Instrument name:</label><br>',
            '<input type="text" id="iname" name="iname"><br>',
            '<label for="melody">Melody:</label><br>',
            '<input type="text" id="melody" size="100" name="melody"><br>',
            '<input type="submit" value="Submit">'
        ]
        return '\n'.join(ret)



    def create_page(self):
         response = BytesIO()
         response.write(bytes('<html><head><title>Panola</title></head>\n<body>', 'utf-8'))
         response.write(bytes(MyServer.make_list('Clocks', state['clocks']), 'utf-8'))
         response.write(bytes(MyServer.make_list('Instruments', state['instruments']), 'utf-8'))

         response.write(bytes(MyServer.make_instrument_form(), 'utf-8'))
    #    # response.write(bytes(MyServer.make_clock_form(), 'utf-8'))

         response.write(bytes(MyServer.make_audio_embed(), 'utf-8'))
         response.write(bytes('</body></html>', 'utf-8'))

         return response.getvalue()




    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(self.create_page())
        # self.wfile.write(bytes("<html><head><title>Panola</title></head>", "utf-8"))
        # self.wfile.write(bytes("<body>", "utf-8"))
        # call_type = parsePath(self.path)
        # self.wfile.write(bytes(f"<p>Request: {call_type}<p>", "utf-8"))
        # self.wfile.write(bytes("<form   method=\"POST\"> \
        #                        <label for=\"fname\">First name:</label><br> \
        #                        <input type=\"text\" id=\"fname\" name=\"fname\"><br> \
        #                        <label for=\"lname\">Last name:</label><br> \
        #                        <input type=\"text\" id=\"lname\" name=\"lname\"> \
        #                        <input type=\"submit\" value=\"Submit\">", "utf-8"))

        # self.wfile.write(bytes('<div><audio controls autoplay name="media"><source src="https://audio.spiderhats.com/panola" type="audio/mpeg"></audio></div>', "utf-8"))
        # self.wfile.write(bytes("</body></html>", "utf-8"))

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        body = self.rfile.read(content_length)
        print(str(body), flush=True)
        inputs = MyServer.parse_inputs(str(body))
        print('inputs:', end=' ')
        print(inputs, flush=True)
        MyServer.handle_inputs(inputs)
        print('inputs handled', flush=True)
        self.send_response(200)
        self.end_headers()
        self.wfile.write(self.create_page())
        # response = BytesIO()
        # response.write(b'This is POST request. ')
        # response.write(b'Received: <br>')
        # for k in inputs:
        #     response.write(bytes(k, 'utf-8'))
        #     response.write(b': ')
        #     response.write(bytes(inputs[k], 'utf-8'))
        #     response.write(b'<br>')
        # self.wfile.write(response.getvalue())

print("starting web server", flush=True)
webServer = HTTPServer((hostName, serverPort), MyServer)
print("Server started http://%s:%s" % (hostName, serverPort), flush=True)

webServer.serve_forever()


    

 #   webServer.server_close()
 #   print("Server stopped.")