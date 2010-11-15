//
//  CMPopTipView.m
//
//  Created by Chris Miles on 18/07/10.
//  Copyright 2010 Chris Miles. All rights reserved.
//

#import "CMPopTipView.h"


@implementation CMPopTipView

@synthesize backgroundColor;
@synthesize delegate;
@synthesize message;
@synthesize textFont;

- (void)drawRect:(CGRect)rect {
	
//	CGFloat directionSign;
//	if (pointDirection == PointDirectionUp) {
//		directionSign = 1.0;
//	}
//	else {
//		directionSign = -1.0;
//	}

	CGRect bubbleRect;
	if (pointDirection == PointDirectionUp) {
		bubbleRect = CGRectMake(2.0, targetPoint.y+pointerSize, bubbleSize.width, bubbleSize.height);
	}
	else {
		bubbleRect = CGRectMake(2.0, targetPoint.y-pointerSize-bubbleSize.height, bubbleSize.width, bubbleSize.height);
	}

	
	CGContextRef c = UIGraphicsGetCurrentContext(); 
	
	CGContextSetRGBStrokeColor(c, 0.0, 0.0, 0.0, 1.0);	// black
	CGContextSetLineWidth(c, 1.0);

	// DEBUG
	//CGContextSetRGBFillColor(c, 1.0, 0.0, 0.0, 0.5);
	//CGContextFillRect(c, CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height));


	CGMutablePathRef bubblePath = CGPathCreateMutable();
	
	if (pointDirection == PointDirectionUp) {
		CGPathMoveToPoint(bubblePath, NULL, targetPoint.x, targetPoint.y);
		CGPathAddLineToPoint(bubblePath, NULL, targetPoint.x+pointerSize, targetPoint.y+pointerSize);
		
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y,
							bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+cornerRadius,
							cornerRadius);
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+bubbleRect.size.height,
							bubbleRect.origin.x+bubbleRect.size.width-cornerRadius, bubbleRect.origin.y+bubbleRect.size.height,
							cornerRadius);
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height,
							bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height-cornerRadius,
							cornerRadius);
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x, bubbleRect.origin.y,
							bubbleRect.origin.x+cornerRadius, bubbleRect.origin.y,
							cornerRadius);
		CGPathAddLineToPoint(bubblePath, NULL, targetPoint.x-pointerSize, targetPoint.y+pointerSize);
	}
	else {
		CGPathMoveToPoint(bubblePath, NULL, targetPoint.x, targetPoint.y);
		CGPathAddLineToPoint(bubblePath, NULL, targetPoint.x-pointerSize, targetPoint.y-pointerSize);
		
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height,
							bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height-cornerRadius,
							cornerRadius);
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x, bubbleRect.origin.y,
							bubbleRect.origin.x+cornerRadius, bubbleRect.origin.y,
							cornerRadius);
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y,
							bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+cornerRadius,
							cornerRadius);
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+bubbleRect.size.height,
							bubbleRect.origin.x+bubbleRect.size.width-cornerRadius, bubbleRect.origin.y+bubbleRect.size.height,
							cornerRadius);
		CGPathAddLineToPoint(bubblePath, NULL, targetPoint.x+pointerSize, targetPoint.y-pointerSize);
	}

	CGPathCloseSubpath(bubblePath);

	
	// Draw shadow
	CGContextAddPath(c, bubblePath);
    CGContextSaveGState(c);
	CGContextSetShadow(c, CGSizeMake(0, 3), 5);
	CGContextSetRGBFillColor(c, 0.0, 0.0, 0.0, 0.9);
	CGContextFillPath(c);
    CGContextRestoreGState(c);

	
	// Draw clipped background gradient
	CGContextAddPath(c, bubblePath);
	CGContextClip(c);
	
	CGFloat bubbleMiddle = (bubbleRect.origin.y+(bubbleRect.size.height/2)) / self.bounds.size.height;
	
	CGGradientRef myGradient;
	CGColorSpaceRef myColorSpace;
	size_t locationCount = 5;
	CGFloat locationList[] = {0.0, bubbleMiddle-0.03, bubbleMiddle, bubbleMiddle+0.03, 1.0};

//	int numComponents = CGColorGetNumberOfComponents([backgroundColor CGColor]);
//	assert(numComponents == 4);
	const CGFloat *components = CGColorGetComponents([backgroundColor CGColor]);
	CGFloat red = components[0];
	CGFloat green = components[1];
	CGFloat blue = components[2];
	CGFloat alpha = components[3];
	CGFloat colorList[] = {
		//red, green, blue, alpha 
		red*1.16, green*1.16, blue*1.16, alpha,
		red*1.16, green*1.16, blue*1.16, alpha,
		red*1.08, green*1.08, blue*1.08, alpha,
		red,      green,      blue,      alpha,
		red,      green,      blue,      alpha
	};
	//	CGFloat colorList[] = {
//		//red, green, blue, alpha 
//		154.0/255.0, 94.0/255.0, 130.0/255.0, 1.0,
//		154.0/255.0, 94.0/255.0, 130.0/255.0, 1.0,
//		144.0/255.0, 84.0/255.0, 120.0/255.0, 1.0,
//		134.0/255.0, 74.0/255.0, 110.0/255.0, 1.0,
//		134.0/255.0, 74.0/255.0, 110.0/255.0, 1.0
//	};
	myColorSpace = CGColorSpaceCreateDeviceRGB();
	myGradient = CGGradientCreateWithColorComponents(myColorSpace, colorList, locationList, locationCount);
	CGPoint startPoint, endPoint;
	startPoint.x = 0;
	startPoint.y = 0;
	endPoint.x = 0;
	endPoint.y = CGRectGetMaxY(self.bounds);
	
	CGContextDrawLinearGradient(c, myGradient, startPoint, endPoint,0);
	CGGradientRelease(myGradient);
	CGColorSpaceRelease(myColorSpace);
	
	CGContextAddPath(c, bubblePath);
	CGContextDrawPath(c, kCGPathStroke);
	
	CGPathRelease(bubblePath);
	
	// Draw text
	[[UIColor whiteColor] set];
	CGRect textFrame = CGRectMake(bubbleRect.origin.x + cornerRadius,
								  bubbleRect.origin.y + cornerRadius,
								  bubbleRect.size.width - cornerRadius,
								  bubbleRect.size.height - cornerRadius);
	[self.message drawInRect:textFrame
					withFont:textFont
			   lineBreakMode:UILineBreakModeWordWrap
				   alignment:UITextAlignmentCenter];
}

- (void)presentPointingAtRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated {
	assert(0);
	NSLog(@"TODO");
}

- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated {
	UIView *targetView = (UIView *)[barButtonItem performSelector:@selector(view)];
	UIView *targetSuperview = [targetView superview];
	UIView *containerView = nil;
	if ([targetSuperview isKindOfClass:[UINavigationBar class]]) {
		UINavigationController *navController = [(UINavigationBar *)targetSuperview delegate];
		containerView = [[navController topViewController] view];
	}
	else if ([targetSuperview isKindOfClass:[UIToolbar class]]) {
		containerView = [targetSuperview superview];
	}
	
	if (nil == containerView) {
		NSLog(@"Cannot determine container view from UIBarButtonItem: %@", barButtonItem);
		return;
	}
	
	NSLog(@"containerView: %@", containerView);
	[containerView addSubview:self];
	
	CGPoint barButtonItemWindowCoord = [targetView convertPoint:CGPointMake(0.0, 0.0) toView:nil];
	CGPoint containerViewWindowCoord = [containerView convertPoint:CGPointMake(0.0, 0.0) toView:nil];
	CGFloat targetY;
	if (barButtonItemWindowCoord.y < containerViewWindowCoord.y) {
		// Bar button item is above the container view; point to top
		pointDirection = PointDirectionUp;
		targetY = 0.0;
	}
	else {
		// Bar button item is below the container view; point to bottom
		pointDirection = PointDirectionDown;
		targetY = containerView.bounds.size.height;
		
		if ([targetSuperview isDescendantOfView:containerView]) {
			targetY -= targetSuperview.bounds.size.height;
		}
	}

	CGSize textSize = [self.message sizeWithFont:textFont
							   constrainedToSize:CGSizeMake(containerView.frame.size.width*2/3, 99999.0)
								   lineBreakMode:UILineBreakModeWordWrap];
	bubbleSize = CGSizeMake(textSize.width + cornerRadius*2, textSize.height + cornerRadius*2);
	
	CGFloat W = containerView.frame.size.width;
	
	CGFloat x_p = targetView.center.x;
	CGFloat x_b = x_p - (bubbleSize.width/2);
	if (x_b < sidePadding) {
		x_b = sidePadding;
	}
	if (x_b + bubbleSize.width + sidePadding > W) {
		x_b = W - bubbleSize.width - sidePadding;
	}
	if (x_p - pointerSize < x_b + cornerRadius) {
		x_p = x_b + cornerRadius + pointerSize;
	}
	if (x_p + pointerSize > x_b + bubbleSize.width - cornerRadius) {
		x_p = x_b + bubbleSize.width - cornerRadius - pointerSize;
	}
	
	CGFloat fullHeight = bubbleSize.height + pointerSize + 10.0;
	CGFloat y_b;
	if (pointDirection == PointDirectionUp) {
		y_b = topMargin;
		targetPoint = CGPointMake(x_p-x_b, 0);
	}
	else {
		y_b = targetY - fullHeight;
		targetPoint = CGPointMake(x_p-x_b, fullHeight-2.0);
	}

	
//	targetPoint = CGPointMake(x_p-x_b, targetY);
	CGRect finalFrame = CGRectMake(x_b-sidePadding,
								   y_b,
								   bubbleSize.width+sidePadding*2,
								   fullHeight);

	if (animated) {
		self.alpha = 0.0;
		CGRect startFrame = finalFrame;
		startFrame.origin.y += 10;
		self.frame = startFrame;
	}
	
	[self setNeedsDisplay];

	if (animated) {
		[UIView beginAnimations:nil context:nil];
		self.alpha = 1.0;
	}
	
	self.frame = finalFrame;
	
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void)finaliseDismiss {
	[self removeFromSuperview];
}

- (void)dismissAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[self finaliseDismiss];
}

- (void)dismissAnimated:(BOOL)animated {
	
	if (animated) {
		CGRect frame = self.frame;
		frame.origin.y += 10.0;
		
		[UIView beginAnimations:nil context:nil];
		self.alpha = 0.0;
		self.frame = frame;
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dismissAnimationDidStop:finished:context:)];
		[UIView commitAnimations];
	}
	else {
		[self finaliseDismiss];
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { 
	[self dismissAnimated:YES];
	
	if (delegate && [delegate respondsToSelector:@selector(popTipViewWasDismissedByUser:)]) {
		[delegate popTipViewWasDismissedByUser:self];
	}
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.opaque = NO;
		
		cornerRadius = 8.0;
		topMargin = 2.0;
		pointerSize = 12.0;
		sidePadding = 2.0;
		
		self.textFont = [UIFont boldSystemFontOfSize:14.0];
//		self.backgroundColor = [UIColor colorWithRed:134.0/255.0 green:74.0/255.0 blue:110.0/255.0 alpha:1.0];
		self.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:60.0/255.0 blue:154.0/255.0 alpha:1.0];
    }
    return self;
}

- (id)initWithMessage:(NSString *)messageToShow {
	CGRect frame = CGRectZero;
	
	if ((self = [self initWithFrame:frame])) {
		self.message = messageToShow;
	}
	return self;
}

- (void)dealloc {
	[backgroundColor release];
	[message release];
	[textFont release];
	
    [super dealloc];
}


@end
