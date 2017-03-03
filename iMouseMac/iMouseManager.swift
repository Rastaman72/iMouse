
//
//  iMouseManager.swift
//  iMouse
//
//  Created by Michal Niemiec on 03/03/2017.
//  Copyright © 2017 Hybris. All rights reserved.
//

import CoreBluetooth

class iMouseManager: NSObject {
    
    var manager : CBCentralManager?
    var customCharacteristic: CBMutableCharacteristic?
    var customService: CBMutableService?
    
    var kServiceUUID = "312700E2-E798-4D5C-8DCF-49908332DF9F"
    var kCharacteristicUUID = "FFA28CDE-6525-4489-801C-1C060CAC9767"
    
    
    var iMouse : CBPeripheral?
    
    override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
        func mouseMoveAndClick(onPoint point: CGPoint) {
            guard let moveEvent = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: point, mouseButton: .left) else {
                return
            }
            guard let downEvent = CGEvent(mouseEventSource: nil, mouseType: .leftMouseDown, mouseCursorPosition: point, mouseButton: .left) else {
                return
            }
            guard let upEvent = CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp, mouseCursorPosition: point, mouseButton: .left) else {
                return
            }
            moveEvent.post(tap: CGEventTapLocation.cghidEventTap)
            downEvent.post(tap: CGEventTapLocation.cghidEventTap)
            upEvent.post(tap: CGEventTapLocation.cghidEventTap)
        }
    
    
}

extension iMouseManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        manager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name  {
            if name == "iMouse"{
                if peripheral.state.rawValue == 0 {
                    iMouse = peripheral
                    iMouse?.delegate = self
                    manager?.connect(iMouse!, options: nil)
                }
                
            }
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("will")
    }
    
    
    func centralManager(_ central: CBCentralManager, didRetrieveConnectedPeripherals peripherals: [CBPeripheral]) {
        print("didRetrieveConnectedPeripherals")
    }
    
    func centralManager(_ central: CBCentralManager, didRetrievePeripherals peripherals: [CBPeripheral]) {
        print("didRetrievePeripherals")
    }
    
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral")
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect")
        if (peripheral.name?.contains((iMouse?.name!)!))! {
            iMouse?.discoverServices([CBUUID(string: kServiceUUID)])
        }
    }
    
    
}

extension iMouseManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if (peripheral.name?.contains((iMouse?.name!)!))! {
            for service in (iMouse?.services!)! {
                iMouse?.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if (peripheral.name?.contains((iMouse?.name)!))! {
            for characteristic in service.characteristics! {
                
                if characteristic.uuid.isEqual(to: CBUUID(string: "FFA28CDE-6525-4489-801C-1C060CAC9767")) {
                    iMouse?.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let a = String(data: characteristic.value!, encoding: .utf8)
        mouseMoveAndClick(onPoint: CGPoint(x: 200, y: 200))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateNotificationStateFor")
    }
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        print("peripheralDidUpdateName")
    }
}

