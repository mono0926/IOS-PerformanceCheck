//
//  PerformanceCheckTests.swift
//  PerformanceCheckTests
//
//  Created by mono on 11/30/14.
//  Copyright (c) 2014 mono. All rights reserved.
//

import UIKit
import XCTest

class CoreDataTests: XCTestCase {
    
    override func setUp() {
        MagicalRecord.setupCoreDataStack()
        let memberCount = 100000
        let moc = NSManagedObjectContext.MR_contextForCurrentThread()
        
        for i in 0..<memberCount {
            Member.MR_createEntity()
            moc.MR_saveToPersistentStoreAndWait()
        }
        super.setUp()
    }
    
    override func tearDown() {
        Member.MR_deleteAllMatchingPredicate(nil)
        super.tearDown()
    }
    
    func testCoreData() {
        self.measureBlock() {
            let moc = NSManagedObjectContext.MR_contextForCurrentThread()
            let members = Member.MR_findAll() as [Member]
            for m in members {
                m.loveIce = true
            }
            moc.MR_saveToPersistentStoreAndWait()
        }
    }
    
    func testCoreDataBatch() {
        self.measureBlock() {
            let moc = NSManagedObjectContext.MR_contextForCurrentThread()
            let entityDescription = NSEntityDescription.entityForName("Member", inManagedObjectContext: moc)!
            let batchUpdateRequest = NSBatchUpdateRequest(entity: entityDescription)
            batchUpdateRequest.resultType = NSBatchUpdateRequestResultType.UpdatedObjectIDsResultType
            batchUpdateRequest.propertiesToUpdate = ["loveIce": true]
            // Execute Batch Request
            var batchUpdateRequestError: NSError?
            moc.executeRequest(batchUpdateRequest, error:&batchUpdateRequestError)
            if let e = batchUpdateRequestError {
                XCTFail(e.description)
            }
        }
    }
}
