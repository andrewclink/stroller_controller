//
//  Pace.swift
//  StrollerController
//
//  Created by Andrew Clink on 7/21/17.
//  Copyright © 2017 Andrew Clink. All rights reserved.
//

import XCTest
@testable import StrollerController

class PaceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPaceIncrement() {
        var p =          Pace(minutes: 5, seconds: 15)
        let result = p + Pace(minutes: 0, seconds: 10)
        
        XCTAssert(result.minutes == 5 && result.seconds == 25, "5:15 + 0:10 should equal 5:25, instead got \(result)")
    }
    
    func testPaceIncrementNegative() {
        var p = Pace(minutes: 5, seconds: 10)
        let result = p + Pace(minutes:0, seconds: -20)
        
        XCTAssert(result.minutes == 4 && result.seconds == 50, "5:10 + 0:-20 should equal 4:50, instead got \(result)")
    }
    
    func testPaceDecrement() {
        var p =          Pace(minutes: 5, seconds: 15)
        let result = p - Pace(minutes: 0, seconds: 10)
        
        XCTAssert(result.minutes == 5 && result.seconds == 5, "5:15 - 0:10 should equal 5:05, instead got \(result)")
    }
    
    func testPaceDecrementNegative() {
        var p =          Pace(minutes: 5, seconds: 15)
        let result = p - Pace(minutes: 0, seconds: -10)
        
        XCTAssert(result.minutes == 5 && result.seconds == 25, "5:15 - 0:-10 should equal 5:25, instead got \(result)")
    }
    
}
