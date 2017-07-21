//
//  ViewController.swift
//  StrollerController
//
//  Created by Andrew Clink on 7/20/17.
//  Copyright © 2017 Andrew Clink. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var speedIncrementSeconds = 5
    
    var stroller:Stroller? {
        didSet {
            print("got stroller: \(stroller)")
        }
    }
    
    @IBOutlet var paceField:UILabel?
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        paceField?.text = "Searching..."
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK - UX
    
    @IBAction func slowDownAction()
    {
        
//        if currentPace == 0
//        {
//            // We're stopped, start moving at a walking pace
//            // 5 km/hr = 1hr/5km = 60min/5km = 12min/1km
//            currentPace = 12
//        }
    }
    
    @IBAction func speedUpAction()
    {
        
    }

}

