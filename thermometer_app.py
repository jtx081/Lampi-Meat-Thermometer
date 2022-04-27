from kivy.app import App
from kivy.properties import NumericProperty, StringProperty
from kivy.clock import Clock

from paho.mqtt.client import Client
import json
from kivy.uix.widget import Widget
from kivy.properties import ObjectProperty
from kivy.uix.label import Label
from kivy.uix.floatlayout import FloatLayout
from kivy.uix.popup import Popup
from kivy.uix.boxlayout import BoxLayout
#from kivy.uix.modalview import Dismiss

import pigpio
import time

class ThermometerApp(App):

    target_temp = 85
    display_target_temp = StringProperty("Desired Temperature: " + str(target_temp) + " F")
    temp = 0

    pi = pigpio.pi()

    # turn off all pins
    pi.write(13, 0) #blue
    pi.write(19, 0) #red
    pi.write(26, 0) #green

    # set PWM range
    pi.set_PWM_range(13, target_temp)
    pi.set_PWM_range(19, target_temp)
    pi.set_PWM_range(26, target_temp)

    display_text = StringProperty('0 F')

    #while True:
        #pi.write(19, 1) #red
        #pi.set_PWM_dutycycle(19, (target_temp - temp)/target_temp * target_temp)


    # make a popup for done
    # make an alerting system for temp
    # need to recieve set temperature from the app
    # need to send whether the process is done MeatThermometer/Done
    # figure out how to add sliding bar for the status

    # probe live??

    def on_start(self):
        #self.mqtt = Client('lamp_temp')
        self.mqtt = Client(client_id='temperature_probe')
        self.mqtt.enable_logger()
        self.mqtt.on_connect = self.on_connect
        #self.mqtt.on_message = self.message_received
        self.mqtt.connect('localhost', port=1883, keepalive=60)
        self.mqtt.loop_start()

    def on_connect(self, client, userdata, flags, rc):
        self.mqtt.subscribe('test/temperature') #we should change this topic MeatThermometer/Temperature
        self.mqtt.subscribe('test/goal')
        self.mqtt.message_callback_add('test/temperature', self.temp_received)
        self.mqtt.message_callback_add('test/goal', self.goal_temp_received)

    def temp_received(self, client, userdata, message):
        new_temp = round(json.loads(message.payload.decode('utf-8')))
        self.display_text = '{} F'.format(new_temp)
        self.temp = new_temp

        popup = DonePopup()

        popupWindow = Popup(title="Popup Window", content=popup, size_hint=(None, None), size=(200,200), auto_dismiss=True)


        if (self.temp < self.target_temp):
            self.pi.write(13, 0)
            self.pi.set_PWM_dutycycle(19, (self.target_temp - self.temp)/self.target_temp * self.target_temp)
            self.pi.write(26, 0)

            popupWindow.dismiss()

        else:
            self.pi.write(13, 0)
            self.pi.write(19, 0)
            self.pi.write(26, 1)

            popupWindow.open()

    def goal_temp_received(self, client, userdata, message):
        new_goal_temp = round(json.loads(message.payload.decode('utf-8')))
        self.goal_temp = '{}'.format(new_goal_temp)

    pi.write(13, 0)
    pi.write(19, 0)
    pi.write(26, 0)

    # how to go back to the cycle when it temerature goes down.
    # how to turn lights off?
    # current temp on popup? Discription to touch outside the popup?


class DonePopup(FloatLayout):
    pass


def showPopup():
    show = MyPopup()

    popupWindow = Popup(title="Popup Window", content=show)

    popupWindow.open()
