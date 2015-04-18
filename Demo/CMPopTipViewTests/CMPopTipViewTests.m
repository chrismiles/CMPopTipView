//
//  CMPopTipViewTests.m
//  CMPopTipViewTests
//
//  Created by Ikhsan Assaat on 4/18/15.
//  Copyright (c) 2015 Chris Miles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CMPopTipView.h"

@interface CMPopTipViewTests : XCTestCase {
    CMPopTipView *popTipView;
    
    NSString *sampleTitle;
    NSString *sampleMessage;
    UIView *sampleView;
}

@end


@implementation CMPopTipViewTests

- (void)setUp {
    [super setUp];
    
    sampleTitle = @"title";
    sampleMessage = @"message";
    sampleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
}

- (void)tearDown {
    popTipView = nil;
    [super tearDown];
}

- (void)testInitializerShouldHaveTitleAndMessage {
    popTipView = [[CMPopTipView alloc] initWithTitle:sampleTitle message:sampleMessage];
    
    XCTAssertNotNil(popTipView, @"Pop tip view should not be nil");
    XCTAssertEqualObjects(sampleTitle, popTipView.title, @"Pop tip view should have correct title");
    XCTAssertEqualObjects(sampleMessage, popTipView.message, @"Pop tip view should have correct message");
}

- (void)testInitializerShouldHaveMessage {
    popTipView = [[CMPopTipView alloc] initWithMessage:sampleMessage];
    
    XCTAssertEqualObjects(sampleMessage, popTipView.message, @"Pop tip view should have correct message");
}

- (void)testInitilizerShouldHaveCustomView {
    popTipView = [[CMPopTipView alloc] initWithCustomView:sampleView];
    
    XCTAssertEqual(sampleView, popTipView.customView, @"Pop tip view should have correct custom view");
}

@end
