//
//  Member.swift
//  PerformanceCheck
//
//  Created by mono on 11/30/14.
//  Copyright (c) 2014 mono. All rights reserved.
//

import Foundation
import CoreData
class Member: NSManagedObject {
    @NSManaged var loveIce: Bool
    class func MR_entityName() -> String {
        return "Member"
    }
}