//
//  PerformanceCheckTests.swift
//  PerformanceCheckTests
//
//  Created by mono on 11/30/14.
//  Copyright (c) 2014 mono. All rights reserved.
//

import UIKit
import XCTest

class PerformanceCheckTests: XCTestCase {    
    func testCountMany() {
        self.measureBlock() {
            let toNum = 100000
            var list = [Int]()
            for i in 0..<toNum {
                list.append(i)
            }
        }
    }
}
