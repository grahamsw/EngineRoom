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





def make_sender():
    host =  os.getenv('SC_IP') or '172.70.0.2'
    port =  57120 if not os.getenv('SC_PORT') else int(os.getenv('SC_PORT'))
    osc_chan = os.getenv('SC_OSC_CHANNEL') or '/implOsc'
    print(host, port, osc_chan)
    s = rlocker(sender(osc_chan, ip=host, port=port))
    return s

def set_clock(rate, name):
    print(f'in set_clocks with rate: {rate} and name: {name}')
    print(state['clocks'], flush=True)
    state['clocks'][name] =  rate
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
        if form_type == 'newInstrument':
            instrument = input_dict['iname']
            if instrument == '': 
                return
            melody = input_dict['melody']
            if instrument in state['instruments']:
                change_instrument(instrument, melody)
            else:
                start_instrument(instrument, melody)
        elif form_type == 'editInstrument':
            instrument = input_dict['iname']
            if instrument == '': 
                return
            melody = input_dict['melody']

            if 'delete' in input_dict:
               stop_instrument(instrument)
               return
            else:
                change_instrument(instrument, melody)
                return
        elif form_type == 'newClock':
            print(f'handling newClock', flush=True)
            clockName = input_dict['clockName']
            clockBeats = input_dict['clockBeats']
            print(f'Name: {clockName}, Beats: {clockBeats}', flush=True)
            set_clock(clockBeats, clockName)
            return

    def basic_item_formatter(key, item):
        return f'{escape(key)}: {escape(item)}'

    def instrument_edit_formatter(key, item):
        ret = [
            '<form   method="POST">',
            '<input type="hidden" id="formType" name="formType" value="editInstrument">',
            f'<input type="hidden" id="iname" name="iname" value="{escape(key)}">'
            f'{escape(key)}',
            f'<input type="text" id="melody" size="100" name="melody" value="{escape(item)}">',
            '<input name="delete" type="checkbox">',
            '<input type="submit" value="Change/Delete">',
            '</form>'

        ]
        return '\n'.join(ret)

    def make_samples():
        ret = [
            '<div>',
            '<em>Sample melodies</em>',

            '<h3>Ex 7: The Rhine</h3>',
            '<ul>'
            f'<li><strong>{escape("e-4_32@vol[0.2] b-3@vol[0.1] g b- e-4 f g@vol[0.2] e-@vol[0.1] b-3 e-4 g a- b-4@vol[0.2] g@vol[0.1] e- g b- e-5 g@vol[0.2] e-@vol[0.1] b-4 g e- b-3")}</strong></li>',
            f'<li><strong>{escape("<e-4_4@vol[0.05] g3> <g4_4@vol[0.05] e- > <b-_4@vol[0.05] g> <g5_4@vol[0.05] e- >")}</strong></li>',
            '</ul>',

            '<h3>Ex 4. Siegfried\'s Anger</h3>',
            '<ul>',
            f'<li><strong>{escape("g4_8@vol[0.3] d@vol[0.1] e- b-3 c4_8@vol[0.3] g3@vol[0.1] a d g4_8@vol[0.3] d@vol[0.1] e- b-3 e-4_8@vol[0.3] b-3@vol[0.1] c4 g3")}</li>',
            '</ul>',
            '</div>'
        ]
        return '\n'.join(ret)
        
    def make_panola_link():
        ret = [
         '<div> <a target="_blank" href="https://sccode.org/1-5aq">A brief explanation of the Panola notation</a></div><br>'
        ]
        return '\n'.join(ret)

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
            '<input type="hidden" id="formType" name="formType" value="newInstrument">',
            '<label for="iname">Instrument name:</label><br>',
            '<input type="text" id="iname" name="iname"><br>',
            '<label for="melody">Melody:</label><br>',
            '<input type="text" id="melody" size="100" name="melody"><br>',
            '<label for="clock">Clock</label><br>',
            '<select id="clock" name="clock">',
        ]

        for clock in state['clocks']:
            ret.append(f'<option value="{clock}">{clock}</option>')

        ret.extend([
               '</select><br>',
               '<label for="quant">Quant</label><br>',
               '<input type="text" id="quant" name="quant"><br><br>',
               '<input type="submit" value="New Instrument">',
               '</form>'])

        return '\n'.join(ret)

    def make_clock_form():
        ret = [
            '<form method="POST">',
            '<input type="hidden" id="formType" name="formType" value="newClock">',
            '<label for="clockName">Clock name</label><br>',
            '<input type="text" id="clockName" name="clockName"><br>',
            '<label for="clockBeats">Beats per minute</clock><br>',
            '<input type="text" id="clockBeats" name="clockBeats"><br><br>',
            '<input type="submit" value="New Clock">',
            '</form>'
        ]
        return '\n'.join(ret)

    def write_response(self, response, txt):
        response.write(bytes(txt, 'utf-8'))

    def create_page(self):
         response = BytesIO()
         self.write_response(response, '<html><head><title>Panola</title></head>\n<body>')
         self.write_response(response, MyServer.make_list('Clocks', state['clocks'], MyServer.basic_item_formatter))
         self.write_response(response, MyServer.make_list('Instruments', state['instruments'], MyServer.instrument_edit_formatter))
         self.write_response(response, MyServer.make_panola_link())        
         self.write_response(response, '<hr>')
         self.write_response(response, MyServer.make_instrument_form())     
         self.write_response(response, '<hr>')
         self.write_response(response, MyServer.make_clock_form())     
         self.write_response(response, '<hr>')
         self.write_response(response, MyServer.make_audio_embed())     
         self.write_response(response, '<hr>')
         self.write_response(response, MyServer.make_samples())
         self.write_response(response, '</body></html>')
         return response.getvalue()

    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(self.create_page())

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


#set_clock(60, 'default')

print("starting web server", flush=True)
webServer = HTTPServer((hostName, serverPort), MyServer)
print("Server started http://%s:%s" % (hostName, serverPort), flush=True)

webServer.serve_forever()


    

 #   webServer.server_close()
 #   print("Server stopped.")