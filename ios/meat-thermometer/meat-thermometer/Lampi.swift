//
//  Lampi.swift
//  Lampi
//
import Foundation
import CoreBluetooth
import Combine
import SwiftUI

class Lampi: NSObject, ObservableObject {
    let name: String
    @Published var state = State() {
        didSet {
            
            if oldValue.goal != state.goal {
                print(oldValue.goal)
                print(state.goal)
              
                updateDevice()
            }
        }
    }

    private func setupPeripheral() {
        if let lampiPeripheral = lampiPeripheral  {
            lampiPeripheral.delegate = self
        }
    }

    private var bluetoothManager: CBCentralManager?

    var lampiPeripheral: CBPeripheral? {
        didSet {
            setupPeripheral()
        }
    }
    private var DoneCharacteristic: CBCharacteristic?
    private var TemperatureCharacteristic: CBCharacteristic?
    private var GoalCharacteristic: CBCharacteristic?

    // MARK: State Tracking
    private var skipNextDeviceUpdate = false
    private var pendingBluetoothUpdate = false

    init(name: String) {
        self.name = name
        super.init()

        self.bluetoothManager = CBCentralManager(delegate: self, queue: nil)
    }

    init(lampiPeripheral: CBPeripheral) {
        guard let peripheralName = lampiPeripheral.name else {
            fatalError("Lampi must initialized with a peripheral with a name")
        }

        self.lampiPeripheral = lampiPeripheral
        self.name = peripheralName

        super.init()

        self.setupPeripheral() // properties set in init() do not trigger didSet
    }
}

extension Lampi {
    static let SERVICE_UUID = CBUUID(string: "0001A7D3-D8A4-4FEA-8174-1736E808C066")
    static let DONE_UUID = CBUUID(string: "0002A7D3-D8A4-4FEA-8174-1736E808C066")
    static let TEMPERATURE_UUID = CBUUID(string: "0003A7D3-D8A4-4FEA-8174-1736E808C066")
    static let GOAL_UUID = CBUUID(string: "0004A7D3-D8A4-4FEA-8174-1736E808C066")

    private var shouldSkipUpdateDevice: Bool {
        return skipNextDeviceUpdate || pendingBluetoothUpdate
    }

    private func updateDevice(force: Bool = false) {
        pendingBluetoothUpdate = false
        writeGoal()
        skipNextDeviceUpdate = false
    }

    private func writeGoal() {
        if let GoalCharacteristic = GoalCharacteristic {
            print("writing")
            var GoalChar = UInt8(state.goal)
            let data = Data(bytes: &GoalChar, count: 1)
            lampiPeripheral?.writeValue(data, for: GoalCharacteristic, type: .withResponse)
        }
    }

}

extension Lampi {
    struct State: Equatable {
        var isConnected = false
        
        var goal: Int = 0
        var isDone: Int = 0
        var temperature: Double = 1.00

    }
}

extension Lampi: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            bluetoothManager?.scanForPeripherals(withServices: [Lampi.SERVICE_UUID])
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == name {
            print("Found \(name)")

            lampiPeripheral = peripheral

            bluetoothManager?.stopScan()
            bluetoothManager?.connect(peripheral)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral \(peripheral)")
        peripheral.delegate = self
        peripheral.discoverServices([Lampi.SERVICE_UUID])
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from peripheral \(peripheral)")
        state.isConnected = false
        bluetoothManager?.connect(peripheral)
    }
}

extension Lampi: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
            print("Found: \(service)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            switch characteristic.uuid {
                
                case Lampi.TEMPERATURE_UUID:
                    self.TemperatureCharacteristic = characteristic
                    peripheral.readValue(for: characteristic)
                    peripheral.setNotifyValue(true, for: characteristic)
                    print("Found: \(characteristic)")

                case Lampi.GOAL_UUID:
                    self.GoalCharacteristic = characteristic
                    print("Found: \(characteristic)")

                case Lampi.DONE_UUID:
                    self.DoneCharacteristic = characteristic
                    peripheral.readValue(for: characteristic)
                    peripheral.setNotifyValue(true, for: characteristic)
                    print("Found: \(characteristic)")

            default:
                continue
            }
        }

    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        skipNextDeviceUpdate = true

        guard let updatedValue = characteristic.value,
              !updatedValue.isEmpty else { return }

        switch characteristic.uuid {

            case Lampi.TEMPERATURE_UUID:
                state.temperature = Double(updatedValue[0])
                print("temp: \(state.temperature)")
            
            case Lampi.DONE_UUID:
                state.isDone = Int(updatedValue[0])
                print("isDone: \(state.isDone)")

        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
}
