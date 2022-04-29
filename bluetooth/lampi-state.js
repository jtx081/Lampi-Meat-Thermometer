var events = require('events');
var util = require('util');
var mqtt = require('mqtt');

function LampiState() {
    events.EventEmitter.call(this);

    this.goal = 0x00;
    this.temperature = 0x00;
    this.done = 0x00;

    this.value = 0xFF;
    this.clientId = 'lamp_bt_peripheral';
    this.has_received_first_update = false;

    var that = this;
    var client_connection_topic = 'lamp/connection/' + this.clientId + '/state';
    
    var mqtt_options = {
    clientId: this.clientId,
    'will' : {
        topic: client_connection_topic,
        payload: '0',
        qos: 2,
        retain: true,
        },
    }

    var mqtt_client = mqtt.connect('mqtt://localhost', mqtt_options);
    mqtt_client.on('connect', function() {
        console.log('connected!');
        mqtt_client.publish(client_connection_topic,
            '1', {qos:2, retain:true})
        mqtt_client.subscribe('meatthermometer/temperature');
        mqtt_client.subscribe('meatthermometer/done')
    });

    mqtt_client.on('message', function(topic, message) {
        if (topic === 'meatthermometer/temperature'){
            new_state = JSON.parse(message);
            console.log('NEW STATE: ', new_state);
  
            if( new_state['client'] == that.clientId
                    && that.has_received_first_update) {
                console.log("...ignoring lamp changed update that we initiated");
                return;
            }
    
            var new_temperature = new_state;
   
            if (that.temperature !== new_temperature ) { 
                console.log('MQTT - NEW TEMPERATURE %d', new_temperature);
                that.temperature = new_temperature;
                that.emit('changed-temperature', that.temperature);
            }

            that.has_received_first_update = true;
        }
        if (topic === 'meatthermometer/done'){
            new_state = JSON.parse(message);
            console.log('NEW STATE: ', new_state);
 
            if( new_state['client'] == that.clientId
                    && that.has_received_first_update) {
                console.log("...ignoring lamp changed update that we initiated");
                return;
            }
    
            var new_done = new_state;
   
            if (that.done !== new_done ) { 
                console.log('MQTT - NEW DONE %d', new_done);
                that.done = new_done;
                that.emit('changed-done', that.done);
            }

            that.has_received_first_update = true;
        }
    });


    this.mqtt_client = mqtt_client;
    
}

util.inherits(LampiState, events.EventEmitter);

LampiState.prototype.set_goal = function(goal) {
    this.goal = goal;
    this.mqtt_client.publish('meatthermometer/goal', String(this.goal));
};


module.exports = LampiState;
