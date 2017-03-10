//
//  iMouseManager.swift
//  iMouse
//
//  Created by Michal Niemiec on 03/03/2017.
//  Copyright © 2017 Hybris. All rights reserved.
//

import UIKit
import CoreBluetooth

class iMouseManager: NSObject {
    
    var manager : CBPeripheralManager?
    var customCharacteristic: CBMutableCharacteristic?
    var customService: CBMutableService?
    
    var central :CBCentral?
    
    var kServiceUUID = "312700E2-E798-4D5C-8DCF-49908332DF9F"
    var kCharacteristicUUID = "FFA28CDE-6525-4489-801C-1C060CAC9767"
    
    
    override init() {
        super.init()
        manager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func setupService() {
        
        let UUID = CBUUID(string: kCharacteristicUUID)
        customCharacteristic = CBMutableCharacteristic(type: UUID, properties: [.read, .indicate, .write, .notify], value: nil, permissions: [.readable, .writeable])
        let serviceUUID = CBUUID(string: kServiceUUID)
        customService = CBMutableService(type: serviceUUID, primary: true)
        customService?.characteristics = [customCharacteristic!]
        manager?.add(customService!)
        
    }
    
    func sentNewPoint(point: CGPoint)
    {
        if central != nil {
            let pointStr = NSStringFromCGPoint(point)
            manager?.updateValue(pointStr.data(using: .utf8)!, for: customCharacteristic!, onSubscribedCentrals: [central!])
        }
    }
}

extension iMouseManager: CBPeripheralManagerDelegate {
    
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            setupService()
        default:
            break
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if error != nil {
        } else {
            manager?.startAdvertising([CBAdvertisementDataLocalNameKey : "iMouse"])
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        if self.central == nil {
            self.central = central
        }
    }
}
