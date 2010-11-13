//
//  CMPopTipView.h
//
//  Created by Chris Miles on 18/07/10.
//  Copyright 2010 Chris Miles. All rights reserved.
//

/** \brief	Display a speech bubble-like popup on screen, pointing at the
			designated view or button.
 
	A UIView subclass drawn using core graphics. Pops up (optionally animated)
	a speech bubble-like view on screen, a rounded rectangle with a gradiant
	fill containing a specified text message, drawn with a pointer dynamically
	positioned to point at the designated button.
 
 Example:
 
	- (void)showPopTipView {
		NSString *message = @"Start by adding a waterway to your favourites.";
		CMPopTipView *popTipView = [[CMPopTipView alloc] initWithMessage:message];
		popTipView.delegate = self;
		[popTipView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];	// "+" button
		
		self.myPopTipView = popTipView;
		[popTipView release];
	}

	- (void)dismissPopTipView {
		[self.myPopTipView dismissAnimated:NO];
		self.myPopTipView = nil;
	}

	#pragma mark CMPopTipViewDelegate methods
	- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
		self.myPopTipView = nil;
	}
 
 */

#import <UIKit/UIKit.h>

@protocol CMPopTipViewDelegate;


@interface CMPopTipView : UIView {
	UIColor					*backgroundColor;
	id<CMPopTipViewDelegate>	delegate;
	NSString				*message;
	UIFont					*textFont;

	@private
	CGSize					bubbleSize;
	CGFloat					cornerRadius;
	CGFloat					sidePadding;
	CGFloat					topMargin;
	CGFloat					pointerSize;
	CGPoint					targetPoint;
}

@property (nonatomic, retain)	UIColor					*backgroundColor;
@property (nonatomic, assign)	id<CMPopTipViewDelegate>	delegate;
@property (nonatomic, retain)	NSString				*message;
@property (nonatomic, retain)	UIFont					*textFont;

- (void)presentPointingAtRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;
- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;
- (id)initWithMessage:(NSString *)messageToShow;

@end


@protocol CMPopTipViewDelegate <NSObject>
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView;
@end
