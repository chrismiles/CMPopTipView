//
//  CMPopTipView.h
//
//  Created by Chris Miles on 18/07/10.
//  Copyright (c) Chris Miles 2010-2014.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

/*
	Version: 2.2
 */


/** \brief	Display a speech bubble-like popup on screen, pointing at the
			designated view or button.

	A UIView subclass drawn using core graphics. Pops up (optionally animated)
	a speech bubble-like view on screen, a rounded rectangle with a gradient
	fill containing a specified text message, drawn with a pointer dynamically
	positioned to point at the center of the designated button or view.

 Example 1 - point at a UIBarButtonItem in a nav bar:

	- (void)showPopTipView {
		NSString *message = @"Start by adding a waterway to your favourites.";
		CMPopTipView *popTipView = [[CMPopTipView alloc] initWithMessage:message];
		popTipView.delegate = self;
		[popTipView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];

		self.myPopTipView = popTipView;
		[popTipView release];
	}

	- (void)dismissPopTipView {
		[self.myPopTipView dismissAnimated:NO];
		self.myPopTipView = nil;
	}


	#pragma mark CMPopTipViewDelegate methods
	- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
		// User can tap CMPopTipView to dismiss it
		self.myPopTipView = nil;
	}

 Example 2 - pointing at a UIButton:

	- (IBAction)buttonAction:(id)sender {
		// Toggle popTipView when a standard UIButton is pressed
		if (nil == self.roundRectButtonPopTipView) {
			self.roundRectButtonPopTipView = [[[CMPopTipView alloc] initWithMessage:@"My message"] autorelease];
			self.roundRectButtonPopTipView.delegate = self;

			UIButton *button = (UIButton *)sender;
			[self.roundRectButtonPopTipView presentPointingAtView:button inView:self.view animated:YES];
		}
		else {
			// Dismiss
			[self.roundRectButtonPopTipView dismissAnimated:YES];
			self.roundRectButtonPopTipView = nil;
		}
	}

	#pragma mark CMPopTipViewDelegate methods
	- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
		// User can tap CMPopTipView to dismiss it
		self.roundRectButtonPopTipView = nil;
	}

 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PointDirection) {
    PointDirectionAny = 0,
    PointDirectionUp,
    PointDirectionDown,
};

typedef NS_ENUM(NSInteger, CMPopTipAnimation) {
    CMPopTipAnimationSlide = 0,
    CMPopTipAnimationPop,
    CMPopTipAnimationFade
};

@protocol CMPopTipViewDelegate;

@interface CMPopTipView : UIView

@property (nonatomic, strong)			UIColor					*backgroundColor;
@property (nonatomic, weak)				id<CMPopTipViewDelegate>	delegate;
@property (nonatomic, assign)			BOOL					disableTapToDismiss;
@property (nonatomic, assign)			BOOL					dismissTapAnywhere;
@property (nonatomic, strong)			NSString				*title;
@property (nonatomic, strong)			NSString				*message;
@property (nonatomic, strong)           UIView	                *customView;
@property (nonatomic, strong, readonly)	id						targetObject;
@property (nonatomic, strong)			UIColor					*titleColor;
@property (nonatomic, strong)			UIFont					*titleFont;
@property (nonatomic, strong)			UIColor					*textColor;
@property (nonatomic, strong)			UIFont					*textFont;
@property (nonatomic, assign)			NSTextAlignment			titleAlignment;
@property (nonatomic, assign)			NSTextAlignment			textAlignment;
@property (nonatomic, assign)           BOOL                    has3DStyle;
@property (nonatomic, strong)			UIColor					*borderColor;
@property (nonatomic, assign)           CGFloat                 cornerRadius;
@property (nonatomic, assign)			CGFloat					borderWidth;
@property (nonatomic, assign)           BOOL                    hasShadow;
@property (nonatomic, assign)           CMPopTipAnimation       animation;
@property (nonatomic, assign)           CGFloat                 maxWidth;
@property (nonatomic, assign)           PointDirection          preferredPointDirection;
@property (nonatomic, assign)           BOOL                    hasGradientBackground;
@property (nonatomic, assign)           CGFloat                 sidePadding;
@property (nonatomic, assign)           CGFloat                 topMargin;
@property (nonatomic, assign)           CGFloat                 pointerSize;
@property (nonatomic, assign)           CGFloat                 bubblePaddingX;
@property (nonatomic, assign)           CGFloat                 bubblePaddingY;

/**
 Dismiss along with user interaction if YES. For example, users can scroll down a table view when a tip view is shown. The tip view dismiss when he or she touches down and user interaction continues. Default is NO.
 @note Make sure `dismissTapAnywhere` is NO.
 */
@property (nonatomic, assign)           BOOL                    dismissAlongWithUserInteraction;
@property (nonatomic, assign)           BOOL                    shouldEnforceCustomViewPadding;
@property (nonatomic, assign)           BOOL                    shouldMaskCustomView;

/* Contents can be either a message or a UIView */
- (BOOL)isBeingShown;
- (id)initWithTitle:(NSString *)titleToShow message:(NSString *)messageToShow;
- (id)initWithMessage:(NSString *)messageToShow;
- (id)initWithCustomView:(UIView *)aView;

- (void)presentPointingAtView:(UIView *)targetView inView:(UIView *)containerView animated:(BOOL)animated;
- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;
- (void)autoDismissAnimated:(BOOL)animated atTimeInterval:(NSTimeInterval)timeInterval;
- (PointDirection) getPointDirection;

@end


@protocol CMPopTipViewDelegate <NSObject>
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView;
@end
