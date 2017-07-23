//
//  Extensions.swift
//  StrollerController
//
//  Created by Andrew Clink on 7/21/17.
//  Copyright © 2017 Andrew Clink. All rights reserved.
//

import Foundation

extension Data {
    
    init<T>(from value: T)
    {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    func to<T:Integer>(type: T.Type) -> T
    {
        if (self.count < 1)
        {
            return 0 as T;
        }
        return self.withUnsafeBytes { $0.pointee }
    }
}
