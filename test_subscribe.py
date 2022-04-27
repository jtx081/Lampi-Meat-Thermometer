import paho.mqtt.client as MQTT
import json

c = MQTT.Client()
c.enable_logger()
c.connect('localhost', port=1883, keepalive=60)

def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))

    client.subscribe('test/temperature')

def message_received(client, userdata, message):
  print("Topic: '{}' Payload: '{}'".format(message.topic, message.payload))
  new_temp = round(json.loads(message.payload.decode('utf-8')))
  print('new temp: ' + str(new_temp))

c.on_connect = on_connect
c.on_message = message_received

c.loop_forever()
