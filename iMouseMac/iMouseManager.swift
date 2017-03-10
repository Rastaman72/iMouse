
//
//  iMouseManager.swift
//  iMouse
//
//  Created by Michal Niemiec on 03/03/2017.
//  Copyright © 2017 Hybris. All rights reserved.
//

import CoreBluetooth
import Quartz

class iMouseManager: NSObject {
    
    var manager : CBCentralManager?
    var customCharacteristic: CBMutableCharacteristic?
    var customService: CBMutableService?
    
    var kServiceUUID = "312700E2-E798-4D5C-8DCF-49908332DF9F"
    var kCharacteristicUUID = "FFA28CDE-6525-4489-801C-1C060CAC9767"
    
    
    var iMouse : CBPeripheral?
    
    var mouseLocation :NSPoint?
    
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
        //            downEvent.post(tap: CGEventTapLocation.cghidEventTap)
        //            upEvent.post(tap: CGEventTapLocation.cghidEventTap)
    }
    
    
}

extension iMouseManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        manager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name  {
            if name == "iMouse" && iMouse == nil {
                if peripheral.state.rawValue == 0 {
                    iMouse = peripheral
                    manager?.connect(iMouse!, options: nil)
                }
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let name = peripheral.name  {
            if name == "iMouse"{
                print("didDisconnectPeripheral")
                iMouse = nil
            }
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect")
        iMouse?.delegate = self
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
                if characteristic.uuid.isEqual(to: CBUUID(string: kCharacteristicUUID)) {
                    iMouse?.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
            let point = NSPointFromString(String(data: characteristic.value!, encoding: .utf8)!)
            
            self.mouseLocation = NSEvent.mouseLocation()
            
            let correctpoint = NSPoint(x: NSEvent.mouseLocation().x, y: (NSScreen.main()?.frame.size.height)! - NSEvent.mouseLocation().y)

            self.mouseLocation?.x += point.x
            self.mouseLocation?.y += point.y
            
            let newPoint = NSPointToCGPoint(self.mouseLocation!)
            
            self.mouseMoveAndClick(onPoint: newPoint)
            
   
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateNotificationStateFor")
    }
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        print("peripheralDidUpdateName")
    }
}

