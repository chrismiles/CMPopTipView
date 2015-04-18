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

@interface UIView (RenderToImage)
- (UIImage *)imageByRenderingView;
@end

@implementation UIView (RenderViewToImage)
- (UIImage *)imageByRenderingView {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}
@end

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
    sampleTitle = nil;
    sampleMessage = nil;
    sampleView = nil;
    popTipView = nil;
    
    [super tearDown];
}

#pragma mark - Initializer tests

- (void)testPopTipViewInitializerShouldHaveTitleAndMessage {
    popTipView = [[CMPopTipView alloc] initWithTitle:sampleTitle message:sampleMessage];
    
    XCTAssertNotNil(popTipView, @"Pop tip view should not be nil");
    XCTAssertEqualObjects(sampleTitle, popTipView.title, @"Pop tip view should have correct title");
    XCTAssertEqualObjects(sampleMessage, popTipView.message, @"Pop tip view should have correct message");
}

- (void)testPopTipViewInitializerShouldHaveMessage {
    popTipView = [[CMPopTipView alloc] initWithMessage:sampleMessage];
    
    XCTAssertEqualObjects(sampleMessage, popTipView.message, @"Pop tip view should have correct message");
}

- (void)testPopTipViewInitilizerShouldHaveCustomView {
    popTipView = [[CMPopTipView alloc] initWithCustomView:sampleView];
    
    XCTAssertEqual(sampleView, popTipView.customView, @"Pop tip view should have correct custom view");
}

#pragma mark - Presenter tests

- (void)testPresentPopTipViewShouldAppearInsideContainerView {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIView *targetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [containerView addSubview:targetView];
    
    popTipView = [[CMPopTipView alloc] initWithTitle:sampleTitle message:sampleMessage];
    [popTipView presentPointingAtView:targetView inView:containerView animated:NO];
    
    XCTAssertTrue([containerView.subviews containsObject:popTipView], @"Pop tip should be a subview of container view");
    XCTAssertFalse(popTipView.hidden, @"Pop tip should be visible");
}

- (void)testPresentPopTipViewShouldAppearInsideContainerViewWithoutTargetView {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    popTipView = [[CMPopTipView alloc] initWithTitle:sampleTitle message:sampleMessage];
    [popTipView presentPointingAtView:nil inView:containerView animated:NO];
    
    XCTAssertTrue([containerView.subviews containsObject:popTipView], @"Pop tip should be a subview of container view");
    XCTAssertFalse(popTipView.hidden, @"Pop tip should be visible");
}

- (void)testPresentPopTipViewShouldAppearPointingToBarButton {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:containerView.bounds];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:sampleTitle style:UIBarButtonItemStylePlain target:nil action:nil];
    
    toolbar.items = @[button];
    [containerView addSubview:toolbar];
    
    popTipView = [[CMPopTipView alloc] initWithTitle:sampleTitle message:sampleMessage];
    [popTipView presentPointingAtBarButtonItem:button animated:NO];
    
    XCTAssertTrue([containerView.subviews containsObject:popTipView], @"Pop tip should be a subview of container view");
    XCTAssertFalse(popTipView.hidden, @"Pop tip should be visible");
}

#pragma mark - Point direction tests 

- (void)testPopTipViewShouldPointUpIfPresentedFromAbove {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIView *targetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [containerView addSubview:targetView];
    
    popTipView = [[CMPopTipView alloc] initWithTitle:sampleTitle message:sampleMessage];
    [popTipView presentPointingAtView:targetView inView:containerView animated:NO];
    
    XCTAssertEqual(PointDirectionUp, [popTipView getPointDirection], @"Pop tip should point upwards");
}

- (void)testPopTipViewShouldPointDownIfPresentedFromBelow {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIView *targetView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, 10, 10)];
    [containerView addSubview:targetView];
    
    popTipView = [[CMPopTipView alloc] initWithTitle:sampleTitle message:sampleMessage];
    [popTipView presentPointingAtView:targetView inView:containerView animated:NO];
    
    XCTAssertEqual(PointDirectionDown, [popTipView getPointDirection], @"Pop tip should point downwards");
}

#pragma mark - Delegate tests




@end
