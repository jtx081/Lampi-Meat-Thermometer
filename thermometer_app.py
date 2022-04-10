from kivy.app import App
from paho.mqtt.client import Client
from kivy.properties import NumericProperty, StringProperty
from kivy.clock import Clock


class ThermometerApp(App):

    _temp = NumericProperty()
    display_text = StringProperty()

    def _get_temp(self):
        return self._temp

    def _set_temp(self, value):
        self._temp = value

    def make_temp_string(self):
        if self._temp == None:
            display_text = "no temp reading yet"
        else:
            self.display_text = "{}".format(self._temp)

    def on_start(self):
        #self._publish_clock = None
        #self.mqtt_broker_bridged = False
        #self._associated = True
        #self.association_code = None
        self.mqtt = Client(client_id="thermometer")
        self.mqtt.enable_logger()
        #self.mqtt.will_set(client_state_topic(MQTT_CLIENT_ID), "0", qos=2, retain=True)
        self.mqtt.on_connect = self.on_connect
        self.mqtt.connect("localhost", port=1883,
                          keepalive=60)
        self.mqtt.loop_start()

        #self.associated_status_popup = self._build_associated_status_popup()
        #self.associated_status_popup.bind(on_open=self.update_popup_associated)
        #Clock.schedule_interval(self._poll_associated, 0.1)

    def on_connect(self, client, userdata, flags, rc):
        #self.mqtt.publish(client_state_topic(MQTT_CLIENT_ID), b"1", qos=2, retain=True)
        #self.mqtt.message_callback_add(TOPIC_LAMP_CHANGE_NOTIFICATION,self.receive_new_lamp_state)
        #self.mqtt.message_callback_add(broker_bridge_connection_topic(),self.receive_bridge_connection_status)
        #self.mqtt.message_callback_add(TOPIC_LAMP_ASSOCIATED,self.receive_associated)
       # self.mqtt.subscribe(broker_bridge_connection_topic(), qos=1)
       # self.mqtt.subscribe(TOPIC_LAMP_CHANGE_NOTIFICATION, qos=1)
      #  self.mqtt.subscribe(TOPIC_LAMP_ASSOCIATED, qos=2)
        self.mqtt.subscribe("test/temperature")

    def receive_new_lamp_state(self, client, userdata, message):
        new_temp = json.loads(message.payload.decode('utf-8'))
        print('new message detected' + new_temp)

        self.temp = new_temp
