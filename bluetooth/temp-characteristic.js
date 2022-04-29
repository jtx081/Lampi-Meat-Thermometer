var util = require('util');
var bleno = require('bleno');

var CHARACTERISTIC_NAME = 'Temp';

function TempCharacteristic(lampiState) {
  TempCharacteristic.super_.call(this, {
    uuid: '0003A7D3-D8A4-4FEA-8174-1736E808C066',
    properties: ['read', 'notify'],
    secure: [],
    descriptors: [
        new bleno.Descriptor({
            uuid: '2901',
            value: CHARACTERISTIC_NAME,
        }),
        new bleno.Descriptor({
           uuid: '2904',
           value: new Buffer([0x04, 0x00, 0x27, 0x00, 0x01, 0x00, 0x00])
        }),
    ],
  });

  this._update = null;

  this.changed_temperature =  function(temperature) {
    console.log('lampiState changed TempCharacteristic');
    if( this._update !== null ) {
        console.log('updating new temperature uuid=', this.uuid);
        var data = new Buffer(1);
        data.writeUInt8(temperature);
        this._update(data);
    } 
  }

  this.lampiState = lampiState;

  this.lampiState.on('changed-temperature', this.changed_temperature.bind(this));

}

util.inherits(TempCharacteristic, bleno.Characteristic);

TempCharacteristic.prototype.onReadRequest = function(offset, callback) {
  console.log('onReadRequest');
  if (offset) {
    console.log('onReadRequest offset');
    callback(this.RESULT_ATTR_NOT_LONG, null);
  }
  else {
    var data = new Buffer(1);
    data.writeUInt8(this.lampiState.temperature);
    console.log('onReadRequest returning ', data);
    callback(this.RESULT_SUCCESS, data);
  }
};


TempCharacteristic.prototype.onSubscribe = function(maxValueSize, updateValueCallback) {
    console.log('subscribe on ', CHARACTERISTIC_NAME);
    this._update = updateValueCallback;
}

TempCharacteristic.prototype.onUnsubscribe = function() {
    console.log('unsubscribe on ', CHARACTERISTIC_NAME);
    this._update = null;
}


module.exports = TempCharacteristic;

