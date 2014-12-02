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

- (void)testPerformanceExample {
    [self measureBlock:^{
        NSUInteger toNum = 100000;
        NSMutableArray* list = [NSMutableArray new];
        for (NSUInteger i = 0; i < toNum; i++) {
            [list addObject:@(i)];
        }
    }];
}

@end
