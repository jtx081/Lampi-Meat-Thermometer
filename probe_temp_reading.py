import time
from w1thermsensor import W1ThermSensor
import paho.mqtt.publish as publish

MQTT_BROKER_HOST = "localhost"
MQTT_BROKER_PORT = 1883
MQTT_BROKER_KEEP_ALIVE_SECS = 60
MQTT_CLIENT_ID = 'sensor'

pub_topic = 'meatthermometer/temperature'

sensor = W1ThermSensor()

while True:
    temperature_C = sensor.get_temperature()
    temp_F = round((temperature_C * (9/5)) + 32)
    print("The temperature is %s F" % temp_F)

    if temp_F is not None:
        publish.single(pub_topic, str(temp_F),
                    hostname=MQTT_BROKER_HOST, port=MQTT_BROKER_PORT, client_id=MQTT_CLIENT_ID)
    time.sleep(0.5)
