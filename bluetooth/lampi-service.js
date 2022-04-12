var util = require('util');
var bleno = require('bleno');

var TempCharacteristic = require('./temp-characteristic');

function LampiService(lampiState) {
    bleno.PrimaryService.call(this, {
        uuid: '0001A7D3-D8A4-4FEA-8174-1736E808C066',
        characteristics: [
            new TempCharacteristic(lampiState),
        ]
    });
}

util.inherits(LampiService, bleno.PrimaryService);

module.exports = LampiService;
