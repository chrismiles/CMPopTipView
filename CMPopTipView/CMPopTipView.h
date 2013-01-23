//
//  CMPopTipView.h
//
//  Created by Chris Miles on 18/07/10.
//  Copyright (c) Chris Miles 2010-2012.
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
	Version: 1.2.0
 */


/** \brief	Display a speech bubble-like popup on screen, pointing at the
			designated view or button.
 
	A UIView subclass drawn using core graphics. Pops up (optionally animated)
	a speech bubble-like view on screen, a rounded rectangle with a gradiant
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

typedef enum {
    PointDirectionAny = 0,
	PointDirectionUp,
	PointDirectionDown,
} PointDirection;

typedef enum {
    CMPopTipAnimationSlide = 0,
    CMPopTipAnimationPop
} CMPopTipAnimation;


@protocol CMPopTipViewDelegate;


@interface CMPopTipView : UIView {
	UIColor					*backgroundColor;
	id<CMPopTipViewDelegate>	delegate;
    NSString                *title;
	NSString				*message;
	id						targetObject;
    UIColor                 *titleColor;
    UIFont                  *titleFont;
	UIColor					*textColor;
	UIFont					*textFont;
    UIColor                 *borderColor;
    CGFloat                 borderWidth;
    CMPopTipAnimation       animation;

	@private
	CGSize					bubbleSize;
	CGFloat					cornerRadius;
	BOOL					highlight;
	CGFloat					sidePadding;
	CGFloat					topMargin;
	PointDirection			pointDirection;
	CGFloat					pointerSize;
	CGPoint					targetPoint;
}

@property (nonatomic, retain)			UIColor					*backgroundColor;
@property (nonatomic, assign)		id<CMPopTipViewDelegate>	delegate;
@property (nonatomic, assign)			BOOL					disableTapToDismiss;
@property (nonatomic, assign)			BOOL					dismissTapAnywhere;
@property (nonatomic, retain)			NSString				*title;
@property (nonatomic, retain)			NSString				*message;
@property (nonatomic, retain)           UIView	                *customView;
@property (nonatomic, retain, readonly)	id						targetObject;
@property (nonatomic, retain)			UIColor					*titleColor;
@property (nonatomic, retain)			UIFont					*titleFont;
@property (nonatomic, retain)			UIColor					*textColor;
@property (nonatomic, retain)			UIFont					*textFont;
@property (nonatomic, assign)			UITextAlignment			titleAlignment;
@property (nonatomic, assign)			UITextAlignment			textAlignment;
@property (nonatomic, retain)			UIColor					*borderColor;
@property (nonatomic, assign)			CGFloat					borderWidth;
@property (nonatomic, assign)           CMPopTipAnimation       animation;
@property (nonatomic, assign)           CGFloat                 maxWidth;
@property (nonatomic, assign)           PointDirection          preferredPointDirection;

/* Contents can be either a message or a UIView */
- (id)initWithTitle:(NSString *)titleToShow message:(NSString *)messageToShow;
- (id)initWithMessage:(NSString *)messageToShow;
- (id)initWithCustomView:(UIView *)aView;

- (void)presentPointingAtView:(UIView *)targetView inView:(UIView *)containerView animated:(BOOL)animated;
- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;
- (void)autoDismissAnimated:(BOOL)animated atTimeInterval:(NSTimeInterval)timeInvertal;
- (PointDirection) getPointDirection;

@end


@protocol CMPopTipViewDelegate <NSObject>
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView;
@end
