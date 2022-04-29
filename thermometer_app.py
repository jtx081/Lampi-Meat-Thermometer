#!/usr/bin/env python3

from kivy.app import App
from kivy.properties import StringProperty

from paho.mqtt.client import Client
import json
from kivy.uix.floatlayout import FloatLayout
from kivy.uix.popup import Popup
import pigpio
import math


class ThermometerApp(App):

    target_temp = 85
    display_target_temp = StringProperty(str(target_temp) + " F")
    display_target_temp_message = StringProperty(
        "Desired Temperature: " + str(target_temp) + " F")
    temp = 0

    pi = pigpio.pi()

    # turn off all pins
    pi.write(13, 0)  # blue
    pi.write(19, 0)  # red
    pi.write(26, 0)  # green

    display_temp = StringProperty('0 F')

    def build(self):
        self.popup = DonePopup()
        self.popupWindow = Popup(title="MESSAGE: Goal temp. reached!", content=self.popup, size_hint=(
            None, None), size=(240, 320), auto_dismiss=False)

    def on_start(self):
        self.mqtt = Client(client_id='temperature_probe')
        self.mqtt.enable_logger()
        self.mqtt.on_connect = self.on_connect
        self.mqtt.connect('localhost', port=1883, keepalive=60)
        self.mqtt.loop_start()

    def on_connect(self, client, userdata, flags, rc):
        self.mqtt.subscribe('meatthermometer/temperature')
        self.mqtt.subscribe('meatthermometer/goal')
        self.mqtt.message_callback_add(
            'meatthermometer/temperature', self.temp_received)
        self.mqtt.message_callback_add(
            'meatthermometer/goal', self.goal_temp_received)

    def temp_received(self, client, userdata, message):
        new_temp = math.floor(json.loads(message.payload.decode('utf-8')))
        self.display_temp = '{} F'.format(new_temp)
        self.temp = new_temp

        if (self.temp < self.target_temp):
            self.pi.write(13, 0)
            self.pi.set_PWM_dutycycle(
                19, (self.target_temp - self.temp)/self.target_temp * self.target_temp)
            self.pi.write(26, 0)

            App.get_running_app().popupWindow.dismiss()

            self.mqtt.publish('meatthermometer/done',
                              json.dumps(0).encode('utf-8'),
                              qos=1)

        else:
            self.pi.write(13, 0)
            self.pi.write(19, 0)
            self.pi.write(26, 1)

            App.get_running_app().popupWindow.open()

            self.mqtt.publish('meatthermometer/done',
                              json.dumps(1).encode('utf-8'),
                              qos=1)

    def goal_temp_received(self, client, userdata, message):
        new_goal_temp = round(json.loads(message.payload.decode('utf-8')))
        self.target_temp = new_goal_temp
        self.display_target_temp_message = 'Desired Temperature: {} F'.format(
            new_goal_temp)
        self.display_target_temp = '{} F'.format(new_goal_temp)

        # set PWM range
        self.pi.set_PWM_range(13, self.target_temp)
        self.pi.set_PWM_range(19, self.target_temp)
        self.pi.set_PWM_range(26, self.target_temp)


class DonePopup(FloatLayout):
    pass
