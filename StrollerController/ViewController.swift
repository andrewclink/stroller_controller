//
//  ViewController.swift
//  StrollerController
//
//  Created by Andrew Clink on 7/20/17.
//  Copyright © 2017 Andrew Clink. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, StrollerDelegate {




    var speedIncrementSeconds = 5
    var btmanager: CBCentralManager?
    var connectingPeripheral: CBPeripheral? // Retain the currently connecting peripheral

    var stroller:Stroller?
    
    @IBOutlet var paceField:UILabel?
    @IBOutlet var angleSlider:UISlider?
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        paceField?.text = "Searching..."
        
        startScanning()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - UX
    
    @IBAction func slowDownAction()
    {
        if let stroller = self.stroller
        {
            switch(stroller.currentPace.asSeconds)
            {
                case 7*60...12*60:
                    // Moving slowly
                    stroller.decreaseSpeed(by: Pace(minutes:0, seconds:30))
                
                case 5*60+45...6*60+59:
                    // Moving moderately
                    stroller.decreaseSpeed(by: Pace(minutes:0, seconds:10))
                
                default:
                    // Moving quickly
                    stroller.decreaseSpeed(by: Pace(minutes:0, seconds:5))
            }
        }
    }
    
    @IBAction func speedUpAction()
    {
        if let stroller = self.stroller
        {
            switch(stroller.currentPace.asSeconds)
            {
                case 0:
                    // We're stopped, start moving at a walking pace
                    // 5 km/hr = 1hr/5km = 60min/5km = 12min/1km
                    stroller.currentPace = Pace(minutes: 12, seconds: 0)
                
                case 7*60...12*60:
                    // Moving slowly
                    stroller.increaseSpeed(by: Pace(minutes:0, seconds:30))

                case 5*60+45...6*60+59:
                    // Moving moderately
                    stroller.increaseSpeed(by: Pace(minutes:0, seconds:10))

                default:
                    // Moving quickly
                    stroller.increaseSpeed(by: Pace(minutes:0, seconds:5))
                

            }
        }
    }
    
    @IBAction func stopAction()
    {
        print("Stopping immediately");
        self.stroller?.currentPace = Pace(minutes: 0, seconds: 0)
    }


    
    @IBAction func setSteeringAngle(sender:UISlider)
    {
        self.stroller?.steeringAngle = sender.value
    }
    
    // MARK: - Responding to Events
    
    internal func stroller(_ s: Stroller, didChangePace pace: Pace)
    {
        DispatchQueue.main.async {
            self.paceField?.text? = String(format: "%d:%02d/km", pace.minutes, pace.seconds)
        }
    }
    
    
    internal func stroller(_ stroller: Stroller, didChangeSteeringAngle angle: Int)
    {
        print("VC: got angle: \(angle)")

        let pos = Float(angle) / Float(0xffff)
        DispatchQueue.main.async {
            self.angleSlider?.value = pos
        }
    }

    // MARK: - Bluetooth
    
    func startScanning()
    {
        guard let central = btmanager else {
            // We'll be back when the central manager turns on
            let centralQueue = DispatchQueue(label: "com.adc")
            self.btmanager = CBCentralManager(delegate: self, queue: centralQueue)
            return
        }

        let filter = [
            Stroller.serviceUUID
        ]

        central.scanForPeripherals(withServices: filter, options: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        print("BT: Central Manager update state \(central.state)")
        switch (central.state)
        {
        case .poweredOn:
            print("BT: Powered On; scanning")
            self.startScanning()
            
        case .unsupported:
            print("BT: Unsupported")
            
        case .unauthorized:
            print("BT: Unauthorized")
            
        default:
            print("BT: unhandled central state \(String(describing:central.state))");
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
        print("BT: found perepheral: \(peripheral)")
        
        
        if nil == stroller
        {
            DispatchQueue.main.async {
                self.paceField?.text = "Connecting..."
            }

            btmanager!.stopScan()

            connectingPeripheral = peripheral // retain the currently connecting peripheral
            btmanager!.connect(peripheral, options: nil)
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)
    {
        DispatchQueue.main.async {
            print("didconnect")
            self.paceField?.text = "Connected"
        
        }

        // Create the stroller controller
        self.stroller = Stroller(withPeripheral: peripheral, delegate:self)
        self.connectingPeripheral = nil

    }
    
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?)
    {
        DispatchQueue.main.async {
            print("didconnect - error")
        
            self.paceField?.text = "Error Connecting"
            print("Could not connect: Error: \(error)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?)
    {
        self.stroller = nil;
        self.startScanning()

        DispatchQueue.main.async {
            self.paceField?.text = "Disconnected"
        }

    }
    

}

