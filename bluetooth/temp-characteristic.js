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

  this.changed_brightness =  function(brightness) {
    console.log('lampiState changed TempCharacteristic');
    if( this._update !== null ) {
        console.log('updating new brightness uuid=', this.uuid);
        var data = new Buffer(1);
        data.writeUInt8(brightness);
        this._update(data);
    } 
  }

  this.lampiState = lampiState;

  this.lampiState.on('changed-brightness', this.changed_brightness.bind(this));

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
    data.writeUInt8(this.lampiState.brightness);
    console.log('onReadRequest returning ', data);
    callback(this.RESULT_SUCCESS, data);
  }
};

// TempCharacteristic.prototype.onWriteRequest = function(data, offset, withoutResponse, callback) {
//     if(offset) {
//         callback(this.RESULT_ATTR_NOT_LONG);
//     }
//     else if (data.length !== 1) {
//         callback(this.RESULT_INVALID_ATTRIBUTE_LENGTH);
//     }
//     else {
//         var brightness = data.readUInt8(0);
//         this.lampiState.set_brightness( brightness );
//         callback(this.RESULT_SUCCESS);
//     }
// };

TempCharacteristic.prototype.onSubscribe = function(maxValueSize, updateValueCallback) {
    console.log('subscribe on ', CHARACTERISTIC_NAME);
    this._update = updateValueCallback;
}

TempCharacteristic.prototype.onUnsubscribe = function() {
    console.log('unsubscribe on ', CHARACTERISTIC_NAME);
    this._update = null;
}


module.exports = TempCharacteristic;

