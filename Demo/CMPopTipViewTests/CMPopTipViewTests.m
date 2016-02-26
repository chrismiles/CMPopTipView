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

@interface CMPopTipView (Testing)
- (void)dismissByUser;
@end

@interface CMPopTipViewTests : XCTestCase {
    CMPopTipView *_popTipView;
    
    NSString *_sampleTitle;
    NSString *_sampleMessage;
    UIView *_sampleView;
    
    BOOL _isDelegateCalled;
}

@end


@implementation CMPopTipViewTests

- (void)setUp {
    [super setUp];
    
    _sampleTitle = @"title";
    _sampleMessage = @"message";
    _sampleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _isDelegateCalled = NO;
}

- (void)tearDown {
    _sampleTitle = nil;
    _sampleMessage = nil;
    _sampleView = nil;
    _popTipView = nil;
    
    [super tearDown];
}

#pragma mark - Initializer tests

- (void)testPopTipViewInitializerShouldHaveTitleAndMessage {
    _popTipView = [[CMPopTipView alloc] initWithTitle:_sampleTitle message:_sampleMessage];
    
    XCTAssertNotNil(_popTipView, @"Pop tip view should not be nil");
    XCTAssertEqualObjects(_sampleTitle, _popTipView.title, @"Pop tip view should have correct title");
    XCTAssertEqualObjects(_sampleMessage, _popTipView.message, @"Pop tip view should have correct message");
}

- (void)testPopTipViewInitializerShouldHaveMessage {
    _popTipView = [[CMPopTipView alloc] initWithMessage:_sampleMessage];
    
    XCTAssertEqualObjects(_sampleMessage, _popTipView.message, @"Pop tip view should have correct message");
}

- (void)testPopTipViewInitilizerShouldHaveCustomView {
    _popTipView = [[CMPopTipView alloc] initWithCustomView:_sampleView];
    
    XCTAssertEqual(_sampleView, _popTipView.customView, @"Pop tip view should have correct custom view");
}

#pragma mark - Presenter tests

- (void)testPresentPopTipViewShouldAppearInsideContainerView {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIView *targetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [containerView addSubview:targetView];
    
    _popTipView = [[CMPopTipView alloc] initWithTitle:_sampleTitle message:_sampleMessage];
    [_popTipView presentPointingAtView:targetView inView:containerView animated:NO];
    
    XCTAssertTrue([containerView.subviews containsObject:_popTipView], @"Pop tip should be a subview of container view");
    XCTAssertFalse(_popTipView.hidden, @"Pop tip should be visible");
}

- (void)testPresentPopTipViewShouldAppearInsideContainerViewWithoutTargetView {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    _popTipView = [[CMPopTipView alloc] initWithTitle:_sampleTitle message:_sampleMessage];
    [_popTipView presentPointingAtView:nil inView:containerView animated:NO];
    
    XCTAssertTrue([containerView.subviews containsObject:_popTipView], @"Pop tip should be a subview of container view");
    XCTAssertFalse(_popTipView.hidden, @"Pop tip should be visible");
}

- (void)testPresentPopTipViewShouldAppearPointingToBarButton {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:containerView.bounds];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:_sampleTitle style:UIBarButtonItemStylePlain target:nil action:nil];
    
    toolbar.items = @[button];
    [containerView addSubview:toolbar];
    
    _popTipView = [[CMPopTipView alloc] initWithTitle:_sampleTitle message:_sampleMessage];
    [_popTipView presentPointingAtBarButtonItem:button animated:NO];
    
    XCTAssertTrue([containerView.subviews containsObject:_popTipView], @"Pop tip should be a subview of container view");
    XCTAssertFalse(_popTipView.hidden, @"Pop tip should be visible");
}

- (void)testPresentPopTipViewShouldRemovedFromContainerView {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIView *targetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [containerView addSubview:targetView];
    
    _popTipView = [[CMPopTipView alloc] initWithTitle:_sampleTitle message:_sampleMessage];
    [_popTipView presentPointingAtView:targetView inView:containerView animated:NO];
    [_popTipView dismissAnimated:NO];
    
    XCTAssertFalse([containerView.subviews containsObject:_popTipView], @"Pop tip should be removed from container view");
}

#pragma mark - Point direction tests 

- (void)testPopTipViewShouldPointUpIfPresentedFromAbove {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIView *targetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [containerView addSubview:targetView];
    
    _popTipView = [[CMPopTipView alloc] initWithTitle:_sampleTitle message:_sampleMessage];
    [_popTipView presentPointingAtView:targetView inView:containerView animated:NO];
    
    XCTAssertEqual(PointDirectionUp, [_popTipView getPointDirection], @"Pop tip should point upwards");
}

- (void)testPopTipViewShouldPointDownIfPresentedFromBelow {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIView *targetView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, 10, 10)];
    [containerView addSubview:targetView];
    
    _popTipView = [[CMPopTipView alloc] initWithTitle:_sampleTitle message:_sampleMessage];
    [_popTipView presentPointingAtView:targetView inView:containerView animated:NO];
    
    XCTAssertEqual(PointDirectionDown, [_popTipView getPointDirection], @"Pop tip should point downwards");
}

#pragma mark - Delegate tests

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    NSLog(@"%@", popTipView);
    _isDelegateCalled = YES;
}

- (void)testPopTipViewDelegateIsCalled {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIView *targetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [containerView addSubview:targetView];
    
    _popTipView = [[CMPopTipView alloc] initWithTitle:_sampleTitle message:_sampleMessage];
    _popTipView.delegate = (id<CMPopTipViewDelegate>)self;
    [_popTipView presentPointingAtView:targetView inView:containerView animated:NO];
    [_popTipView dismissByUser];
    
    XCTAssertTrue(_isDelegateCalled, @"Pop tip's delegate should get called");
}

@end
