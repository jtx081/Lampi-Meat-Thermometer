var util = require('util');
var bleno = require('bleno');

var CHARACTERISTIC_NAME = 'Goal';

function GoalCharacteristic(lampiState) {
    GoalCharacteristic.super_.call(this, {
        uuid: '"0004A7D3-D8A4-4FEA-8174-1736E808C066"',
        properties: ['read', 'write', 'notify'],
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

    this.changed_onoff = function(onoff) {
        console.log('lampiState changed GoalCharacteristic');
        if (this._update !== null) {
            console.log('updating new onoff uuid=', this.uuid);
            var data = new Buffer(1);
            data.writeUInt8(onoff);
            this._update(data);
        }
    }

    this.lampiState = lampiState;

    this.lampiState.on('changed-onoff', this.changed_brightness.bind(this));

}

util.inherits(GoalCharacteristic, bleno.Characteristic);

// GoalCharacteristic.prototype.onReadRequest = function(offset, callback) {
//   console.log('onReadRequest');
//   if (offset) {
//     console.log('onReadRequest offset');
//     callback(this.RESULT_ATTR_NOT_LONG, null);
//   }
//   else {
//     var data = new Buffer(1);
//     data.writeUInt8(this.lampiState.brightness);
//     console.log('onReadRequest returning ', data);
//     callback(this.RESULT_SUCCESS, data);
//   }
// };

GoalCharacteristic.prototype.onWriteRequest = function(data, offset, withoutResponse, callback) {
    if (offset) {
        callback(this.RESULT_ATTR_NOT_LONG);
    } else if (data.length !== 1) {
        callback(this.RESULT_INVALID_ATTRIBUTE_LENGTH);
    } else {
        var onoff = data.readUInt8(0);
        this.lampiState.set_onoff(onoff);
        callback(this.RESULT_SUCCESS);
    }
};

GoalCharacteristic.prototype.onSubscribe = function(maxValueSize, updateValueCallback) {
    console.log('subscribe on ', CHARACTERISTIC_NAME);
    this._update = updateValueCallback;
}

GoalCharacteristic.prototype.onUnsubscribe = function() {
    console.log('unsubscribe on ', CHARACTERISTIC_NAME);
    this._update = null;
}


module.exports = GoalCharacteristic;