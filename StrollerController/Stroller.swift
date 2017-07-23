//
//  StrollerController.swift
//  StrollerController
//
//  Created by Andrew Clink on 7/20/17.
//  Copyright © 2017 Andrew Clink. All rights reserved.
//

import Foundation
import CoreBluetooth

// Model class representing a remote (bluetooth) stroller instance.
// The only time I can think of where you'd want to "control" more
// than one is in a provisioning situation where they're being
// e.g. named in a list, or checking charge, etc.
//

protocol StrollerDelegate {
    func stroller(_ stroller:Stroller, didChangePace pace:Pace) -> Void
    func stroller(_ stroller:Stroller, didChangeSteeringAngle angle:Int) -> Void
}


enum CharacteristicUUID:String {
    case Speed         = "1419"
    case SteeringAngle = "1428"
    case SteeringHome  = "1429"
}

class Stroller : NSObject, CBPeripheralDelegate {
    
    static let serviceUUID = CBUUID(string: "c8216907")
    
    // Should this be a singleton? I suppose it doesn't need to be.
    //static let sharedController = StrollerController()
    
    let peripheral: CBPeripheral
    var speedCha: CBCharacteristic?
    var steeringAngleCha: CBCharacteristic?
    var steeringHomeCha: CBCharacteristic?
    

    var delegate:StrollerDelegate?
    
    var _currentPace:Pace
    var currentPace: Pace {
        
        get {
            return _currentPace
        }
        
        set(newPace) {
            // Filter for appropriate values
            if newPace < Pace(minutes:3, seconds:30) || newPace > Pace(minutes: 12, seconds: 00)
            {
                _currentPace = Pace(minutes: 0, seconds: 0)
            }
            else
            {
                _currentPace = newPace
            }

            // Inform Delegate
//            delegate?.stroller(self, didChangePace: _currentPace)
            
            
            // Transform to data
            let data = Data.init(from: UInt16(_currentPace.asSeconds))
            
            // Send to BT peripheral
            print("SM: Sending new pace: \(_currentPace)")
            
            if let cha = self.speedCha {
                let p = self.peripheral
                p.writeValue(data, for: cha, type: .withResponse)
            }

        }
    }
    
    var _steeringAngle:Float
    var steeringAngle:Float {
        get { return _steeringAngle }
        set(newAngle)
        {
            // Bound the value
            var x = newAngle
            if x > 1 { x = 1 }
            if x < 0 { x = 0 }

            _steeringAngle = x
            
            // Transform into data
            let uintAngle = Int16(x * Float(Int16.max))
            let dataAngle = Data.init(from: uintAngle)
            
            // Send to peri
            if let cha = self.steeringAngleCha
            {
                self.peripheral.writeValue(dataAngle, for: cha, type: .withoutResponse)
            }

        }
    }
    

    init(withPeripheral p:CBPeripheral, delegate: StrollerDelegate?)
    {
        
        print("SM: Stroller init")
        
        self.peripheral = p
        self.delegate = delegate;
        self._currentPace = Pace(minutes: 0, seconds: 0)
        self._steeringAngle = 0.5

        super.init()
        
        peripheral.delegate = self;
        peripheral.discoverServices([Stroller.serviceUUID])

    }
    
    //MARK: BT
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?)
    {
        if let error = error
        {
            print("SM: didWriteValue for \(characteristic.uuid.uuidString) err: \(error)")
        }
        else
        {
            print("SM: didWriteValue for \(characteristic.uuid.uuidString)")
            
            
            
            switch characteristic
            {
            
                case self.speedCha!:
                    self.delegate?.stroller(self, didChangePace: _currentPace)

            default:
                break;
            }
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
    {
        print("BT: peripheral svc changed:")
        print("BT:   services: \(peripheral.services)")
        
        guard let svc = peripheral.services?.first else {
            print("SM: No matching services")
            return
        }
        
        peripheral.discoverCharacteristics(nil, for: svc)
    }

    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    {
        print("SM: found characteristics")
        if let chas = service.characteristics
        {
            for cha:CBCharacteristic in chas
            {
                print("SM:   Found \(cha.uuid.uuidString)")

                switch (cha.uuid.uuidString)
                {

                case CharacteristicUUID.SteeringHome.rawValue:
                    steeringHomeCha  = cha

                case CharacteristicUUID.SteeringAngle.rawValue:
                    print("SM:   setting steering angle char: \(cha)");
                    steeringAngleCha = cha

                case CharacteristicUUID.Speed.rawValue:          self.speedCha = cha
                default:
                    print("SM:   Ignoring found characteristic \(cha)")
                    return
                }
                
//                print("SM: Discovering descriptors")
//                peripheral.discoverDescriptors(for: cha)
                if (cha.properties.contains(.write))
                {
                    print("writable")
                }

                if (cha.properties.contains(.read))
                {
                    peripheral.readValue(for:cha)
                }

            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?)
    {
//        var canRead = false
        
        print("SM: Got descriptors for \(characteristic.uuid)")
        
        if let descriptors = characteristic.descriptors {
            for d in descriptors
            {
                print("SM:    \(d)")
                peripheral.readValue(for:d)
            }
        }
        
        
//            print("SM:   reading value for \(cha.uuid.uuidString)")
//            peripheral.readValue(for: cha)

    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?)
    {
        print("SM: Value for descriptor \(descriptor)")

    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    {
        if let data = characteristic.value
        {
        
            switch (characteristic.uuid.uuidString)
            {
                case CharacteristicUUID.SteeringAngle.rawValue:
                    // Update delegate
                    let val = Int(data.to(type: Int16.self))
                    self.delegate?.stroller(self, didChangeSteeringAngle: val)

                case CharacteristicUUID.Speed.rawValue:
                    // Update delegate
                    if let data = characteristic.value {
                        _currentPace = Pace(minutes: 0, seconds: Int(data.to(type: UInt16.self)))
                        self.delegate?.stroller(self, didChangePace: _currentPace)
                    }

                default:
                    print("SH: Read unknown characteristic \(characteristic)")
            }
        }
    }
    
    
    //MARK: API
    
    func isStopped() -> Bool
    {
        return currentPace.isStopped()
    }
    
    
    func increaseSpeed(by inc:Pace)
    {
        currentPace -= inc
    }

    func decreaseSpeed(by inc:Pace)
    {
        if !currentPace.isStopped()
        {
            currentPace += inc
        }
    }
    

}
