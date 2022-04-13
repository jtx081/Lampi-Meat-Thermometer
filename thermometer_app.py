from kivy.app import App
from kivy.properties import NumericProperty, StringProperty
from kivy.clock import Clock

from paho.mqtt.client import Client
import json


class ThermometerApp(App):

    display_text = StringProperty(' ') # how to format this?

    def on_start(self):
        #self.mqtt = Client('lamp_temp')
        self.mqtt = Client(client_id='temperature_probe')
        self.mqtt.enable_logger()
        self.mqtt.on_connect = self.on_connect
        self.mqtt.on_message = self.message_received
        self.mqtt.connect('localhost', port=1883, keepalive=60)
        self.mqtt.loop_start()

    def on_connect(self, client, userdata, flags, rc):
        #print("Connected with result code "+str(rc))

        self.mqtt.subscribe('test/temperature')

    def message_received(self, client, userdata, message):
        new_temp = round(json.loads(message.payload.decode('utf-8')))
        self.display_text = '{} F'.format(new_temp)
