//
//  StrollerControllerTests.swift
//  StrollerControllerTests
//
//  Created by Andrew Clink on 7/20/17.
//  Copyright © 2017 Andrew Clink. All rights reserved.
//

import XCTest
@testable import StrollerController

class StrollerControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPaceIncrement() {
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var p =          Pace(minutes: 5, seconds: 15)
        let result = p + Pace(minutes: 0, seconds: 10)
        
        XCTAssert(result.minutes == 5 && result.seconds == 25, "5:15 + 0:10 should equal 5:25, instead got \(result)")
    }
    

    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
