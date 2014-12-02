//
//  PerfomanceCheckTests.m
//  PerformanceCheck
//
//  Created by mono on 11/30/14.
//  Copyright (c) 2014 mono. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CoreData+MagicalRecord.h"
#import <CoreData/CoreData.h>
#import "PerformanceCheckTests-Swift.h"

@interface CoreDataTests2 : XCTestCase

@end

@implementation CoreDataTests2

- (void)setUp {
    [super setUp];
    [MagicalRecord setupCoreDataStack];
    NSUInteger memberCount = 100000;
    NSManagedObjectContext* moc = [NSManagedObjectContext MR_contextForCurrentThread];
    
    for (NSUInteger i = 0; i <memberCount; i++) {
        [Member MR_createEntity];
        [moc MR_saveToPersistentStoreAndWait];
    }
}

- (void)tearDown {
    [Member MR_deleteAllMatchingPredicate:nil];
    NSManagedObjectContext* moc = [NSManagedObjectContext MR_contextForCurrentThread];
    [moc MR_saveToPersistentStoreAndWait];
    [super tearDown];
}

- (void)testCoreData {
    [self measureBlock:^{
        NSManagedObjectContext* moc = [NSManagedObjectContext MR_contextForCurrentThread];
        NSArray* members = [Member MR_findAll];
        for (Member* m in members) {
            m.loveIce = YES;
        }
        [moc MR_saveToPersistentStoreAndWait];
    }];
}

- (void)testCoreDataBatch {
    [self measureBlock:^{
        NSManagedObjectContext* moc = [NSManagedObjectContext MR_contextForCurrentThread];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Member" inManagedObjectContext:moc];
        
        NSBatchUpdateRequest *batchUpdateRequest = [[NSBatchUpdateRequest alloc] initWithEntity:entityDescription];
        
        [batchUpdateRequest setResultType:NSUpdatedObjectIDsResultType];
        [batchUpdateRequest setPropertiesToUpdate:@{ @"loveIce" : @YES }];
        
        // Execute Batch Request
        NSError *batchUpdateRequestError = nil;
        [moc executeRequest:batchUpdateRequest error:&batchUpdateRequestError];
        if (batchUpdateRequestError) {
            XCTFail(@"%@", batchUpdateRequestError);
        }
    }];
}

@end
