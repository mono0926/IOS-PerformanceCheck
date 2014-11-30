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

@interface PerfomanceCheckTests : XCTestCase

@end

@implementation PerfomanceCheckTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPerformanceExample {
    [self measureBlock:^{
        NSUInteger toNum = 100000;
        NSMutableArray* list = [NSMutableArray new];
        for (NSUInteger i = 0; i < toNum; i++) {
            [list addObject:@(i)];
        }
    }];
}

- (void)testCoreData {
    [MagicalRecord setupCoreDataStack];
    NSUInteger memberCount = 100000;
    NSManagedObjectContext* moc = [NSManagedObjectContext MR_contextForCurrentThread];
    
    [Member MR_deleteAllMatchingPredicate:nil];
    for (NSUInteger i = 0; i <memberCount; i++) {
        [Member MR_createEntity];
        [moc MR_saveToPersistentStoreAndWait];
    }
    [self measureBlock:^{
        [self makeAllIceLoveBatch];
    }];
}

- (void)makeAllIceLove
{
    NSManagedObjectContext* moc = [NSManagedObjectContext MR_contextForCurrentThread];
    NSArray* members = [Member MR_findAll];
    for (Member* m in members) {
        m.loveIce = YES;
    }
    [moc MR_saveToPersistentStoreAndWait];
}


- (void)makeAllIceLoveBatch
{
    NSManagedObjectContext* moc = [NSManagedObjectContext MR_contextForCurrentThread];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Member" inManagedObjectContext:moc];
    
    NSBatchUpdateRequest *batchUpdateRequest = [[NSBatchUpdateRequest alloc] initWithEntity:entityDescription];
    
    [batchUpdateRequest setResultType:NSUpdatedObjectIDsResultType];
    [batchUpdateRequest setPropertiesToUpdate:@{ @"loveIce" : @YES }];
    
    // Execute Batch Request
    NSError *batchUpdateRequestError = nil;
    [moc executeRequest:batchUpdateRequest error:&batchUpdateRequestError];
    if (batchUpdateRequestError) {
        NSLog(@"Unable to execute batch update request. (%@)", batchUpdateRequestError);
    }
}

@end
