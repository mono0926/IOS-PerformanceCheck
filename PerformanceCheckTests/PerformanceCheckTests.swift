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
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCountMany() {
        self.measureBlock() {
            let toNum = 100000
            var list = [Int]()
            for i in 0..<toNum {
                list.append(i)
            }
        }
    }
    
    func testCoreData() {
        MagicalRecord.setupCoreDataStack()
        let memberCount = 100000
        let moc = NSManagedObjectContext.MR_contextForCurrentThread()
        
        Member.MR_deleteAllMatchingPredicate(nil)
        for i in 0..<memberCount {
            Member.MR_createEntity()
            moc.MR_saveToPersistentStoreAndWait()
        }
        
        self.measureBlock() {
            self.makeAllAsIceLoverBatch()
        }
    }
    private func makeAllAsIceLover() {
        let moc = NSManagedObjectContext.MR_contextForCurrentThread()
        let members = Member.MR_findAll() as [Member]
        for m in members {
            m.loveIce = true
        }
        moc.MR_saveToPersistentStoreAndWait()
    }
    
    private func makeAllAsIceLoverBatch() {
        let moc = NSManagedObjectContext.MR_contextForCurrentThread()
        let entityDescription = NSEntityDescription.entityForName("Member", inManagedObjectContext: moc)!
        let batchUpdateRequest = NSBatchUpdateRequest(entity: entityDescription)
        batchUpdateRequest.resultType = NSBatchUpdateRequestResultType.UpdatedObjectIDsResultType
        batchUpdateRequest.propertiesToUpdate = ["loveIce": true]
        // Execute Batch Request
        var batchUpdateRequestError: NSError?
        moc.executeRequest(batchUpdateRequest, error:&batchUpdateRequestError)
        if let e = batchUpdateRequestError {
            NSLog("Unable to execute batch update request. (%@)", e);
        }
    }
}
