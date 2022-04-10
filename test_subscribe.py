from paho.mqtt.client import Client

c = MQTT.Client()
c.enable_logger()
c.connect('localhost', port=1883, keepalive=60)
c.loop_start()

def message_received(client, userdata, message):
  print("Topic: '{}' Payload: '{}'".format(message.topic, message.payload))
