//
//  StrollerController.swift
//  StrollerController
//
//  Created by Andrew Clink on 7/20/17.
//  Copyright © 2017 Andrew Clink. All rights reserved.
//

import Foundation

// Model class representing a remote (bluetooth) stroller instance.
// The only time I can think of where you'd want to "control" more
// than one is in a provisioning situation where they're being
// e.g. named in a list, or checking charge, etc.
//

class Stroller : NSObject {
    
    // Should this be a singleton? I suppose it doesn't need to be.
    //static let sharedController = StrollerController()
    

    var currentPace: Pace
    
    override init()
    {
        self.currentPace = Pace(minutes: 0, seconds: 0)
    }
    
    func increaseSpeed(by inc:Pace) {
        currentPace += inc
    }

    func decreaseSpeed(by inc:Pace) {
        currentPace -= inc
    }

}
