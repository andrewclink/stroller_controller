//
//  Pace.swift
//  StrollerController
//
//  Created by Andrew Clink on 7/20/17.
//  Copyright © 2017 Andrew Clink. All rights reserved.
//

import Foundation

struct Pace
{
    var minutes:Int
    var seconds:Int
    
    init(minutes: Int, seconds: Int)
    {
        self.minutes = minutes + (seconds / 60)
        self.seconds = seconds % 60
    }
    
    func isStopped() -> Bool
    {
        return (minutes + seconds == 0)
    }
    

    // Add two paces
    static func +(lhs: Pace, addend:Pace) -> Pace
    {
        let seconds = ((lhs.minutes + addend.minutes) * 60) + lhs.seconds + addend.seconds
        return Pace(minutes: seconds / 60, seconds: seconds % 60)
    }

    static func +=(lhs: inout Pace, addend:Pace)
    {
        let seconds = ((lhs.minutes + addend.minutes) * 60) + lhs.seconds + addend.seconds
        lhs.minutes = seconds / 60
        lhs.seconds = seconds % 60
//        return lhs
    }
    
    // Add a certain number of seconds
    static func +(lhs: Pace, addend:Int) -> Pace
    {
        let seconds = (lhs.minutes * 60) + lhs.seconds + addend
        return Pace(minutes: seconds / 60, seconds: seconds % 60)
    }

    static func +=(lhs: inout Pace, addend:Int)
    {
        let seconds = (lhs.minutes * 60) + lhs.seconds + addend
        lhs.minutes = seconds / 60
        lhs.seconds = seconds % 60
    }

    
    static func -(lhs:  Pace, addend:Pace) -> Pace
    {
        let seconds = ((lhs.minutes - addend.minutes) * 60) + lhs.seconds - addend.seconds
        return Pace(minutes: seconds / 60, seconds: seconds % 60)
    }
    static func -=(lhs: inout Pace, addend:Pace)
    {
        let seconds = ((lhs.minutes - addend.minutes) * 60) + lhs.seconds - addend.seconds
        lhs.minutes = seconds / 60
        lhs.seconds = seconds % 60
    }

    
    static func -(lhs: Pace, addend:Int) -> Pace
    {
        let seconds = (lhs.minutes * 60) + lhs.seconds - addend
        return Pace(minutes: seconds / 60, seconds: seconds % 60)
    }
    
    static func -=(lhs:inout Pace, addend:Int)
    {
        let seconds = (lhs.minutes * 60) + lhs.seconds - addend
        lhs.minutes = seconds / 60
        lhs.seconds = seconds % 60
    }

//    static func -(subtrahend:Pace) -> Pace
//    {
//        return Pace(minutes: minutes - subtrahend.minutes, seconds: seconds - subtrahend.seconds)
//    }

    func asFloat() -> Float
    {
        return Float(minutes) + Float(seconds / 60)
    }
    
}
