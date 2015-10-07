//
//  CMPopTipView.m
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

#import "CMPopTipView.h"
#import <QuartzCore/QuartzCore.h>

@interface CMPopTipView ()
{
	CGSize					_bubbleSize;
	CGFloat					_cornerRadius;
	BOOL					_highlight;
	PointDirection			_pointDirection;
	CGFloat					_pointerSize;
	CGPoint					_targetPoint;
	CGFloat					_bubblePaddingX;
	CGFloat					_bubblePaddingY;
}

@property (nonatomic, strong, readwrite)	id	targetObject;
@property (nonatomic, strong) NSTimer *autoDismissTimer;
@property (nonatomic, strong) UIButton *dismissTarget;
@end


@implementation CMPopTipView

- (CGRect)bubbleFrame {
	CGRect bubbleFrame;
	if (_pointDirection == PointDirectionUp) {
		bubbleFrame = CGRectMake(_sidePadding, _targetPoint.y+_pointerSize, _bubbleSize.width, _bubbleSize.height);
	}
	else {
		bubbleFrame = CGRectMake(_sidePadding, _targetPoint.y-_pointerSize-_bubbleSize.height, _bubbleSize.width, _bubbleSize.height);
	}
	return bubbleFrame;
}

- (CGRect)contentFrame {
	CGRect bubbleFrame = [self bubbleFrame];
	CGRect contentFrame = CGRectMake(bubbleFrame.origin.x + _cornerRadius + _bubblePaddingX,
									 bubbleFrame.origin.y + _cornerRadius + _bubblePaddingY,
									 bubbleFrame.size.width - (_bubblePaddingX*2) - (_cornerRadius*2),
									 bubbleFrame.size.height - (_bubblePaddingY*2) - (_cornerRadius*2));
	return contentFrame;
}

- (void)layoutSubviews {
    [super layoutSubviews];
	if (self.customView) {
		
		CGRect contentFrame = [self contentFrame];
        [self.customView setFrame:contentFrame];
    }
}

- (void)drawRect:(__unused CGRect)rect
{
	CGRect bubbleRect = [self bubbleFrame];
	
	CGContextRef c = UIGraphicsGetCurrentContext(); 
    
    CGContextSetRGBStrokeColor(c, 0.0, 0.0, 0.0, 1.0);	// black
	CGContextSetLineWidth(c, self.borderWidth);
    
	CGMutablePathRef bubblePath = CGPathCreateMutable();
	
	if (_pointDirection == PointDirectionUp) {
		CGPathMoveToPoint(bubblePath, NULL, _targetPoint.x+_sidePadding, _targetPoint.y);
		CGPathAddLineToPoint(bubblePath, NULL, _targetPoint.x+_sidePadding+_pointerSize, _targetPoint.y+_pointerSize);
		
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y,
							bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+_cornerRadius,
							_cornerRadius);
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+bubbleRect.size.height,
							bubbleRect.origin.x+bubbleRect.size.width-_cornerRadius, bubbleRect.origin.y+bubbleRect.size.height,
							_cornerRadius);
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height,
							bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height-_cornerRadius,
							_cornerRadius);
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x, bubbleRect.origin.y,
							bubbleRect.origin.x+_cornerRadius, bubbleRect.origin.y,
							_cornerRadius);
		CGPathAddLineToPoint(bubblePath, NULL, _targetPoint.x+_sidePadding-_pointerSize, _targetPoint.y+_pointerSize);
	}
	else {
		CGPathMoveToPoint(bubblePath, NULL, _targetPoint.x+_sidePadding, _targetPoint.y);
		CGPathAddLineToPoint(bubblePath, NULL, _targetPoint.x+_sidePadding-_pointerSize, _targetPoint.y-_pointerSize);
		
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height,
							bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height-_cornerRadius,
							_cornerRadius);
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x, bubbleRect.origin.y,
							bubbleRect.origin.x+_cornerRadius, bubbleRect.origin.y,
							_cornerRadius);
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y,
							bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+_cornerRadius,
							_cornerRadius);
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+bubbleRect.size.height,
							bubbleRect.origin.x+bubbleRect.size.width-_cornerRadius, bubbleRect.origin.y+bubbleRect.size.height,
							_cornerRadius);
		CGPathAddLineToPoint(bubblePath, NULL, _targetPoint.x+_sidePadding+_pointerSize, _targetPoint.y-_pointerSize);
	}
    
	CGPathCloseSubpath(bubblePath);
    
    CGContextSaveGState(c);
	CGContextAddPath(c, bubblePath);
	CGContextClip(c);

    if (self.hasGradientBackground == NO) {
        // Fill with solid color
        CGContextSetFillColorWithColor(c, [self.backgroundColor CGColor]);
        CGContextFillRect(c, self.bounds);
    }
    else {
        // Draw clipped background gradient
        CGFloat bubbleMiddle = (bubbleRect.origin.y+(bubbleRect.size.height/2)) / self.bounds.size.height;
        
        CGGradientRef myGradient;
        CGColorSpaceRef myColorSpace;
        size_t locationCount = 5;
        CGFloat locationList[] = {0.0, (CGFloat)(bubbleMiddle-0.03), bubbleMiddle, (CGFloat)(bubbleMiddle+0.03), 1.0};
        
        CGFloat colourHL = 0.0;
        if (_highlight) {
            colourHL = 0.25;
        }
        
        CGFloat red;
        CGFloat green;
        CGFloat blue;
        CGFloat alpha;
        size_t numComponents = CGColorGetNumberOfComponents([self.backgroundColor CGColor]);
        const CGFloat *components = CGColorGetComponents([self.backgroundColor CGColor]);
        if (numComponents == 2) {
            red = components[0];
            green = components[0];
            blue = components[0];
            alpha = components[1];
        }
        else {
            red = components[0];
            green = components[1];
            blue = components[2];
            alpha = components[3];
        }
        CGFloat colorList[] = {
            //red, green, blue, alpha 
            (CGFloat)(red*1.16+colourHL), (CGFloat)(green*1.16+colourHL),  (CGFloat)(blue*1.16+colourHL), alpha,
             (CGFloat)(red*1.16+colourHL),  (CGFloat)(green*1.16+colourHL),  (CGFloat)(blue*1.16+colourHL), alpha,
             (CGFloat)(red*1.08+colourHL),  (CGFloat)(green*1.08+colourHL),  (CGFloat)(blue*1.08+colourHL), alpha,
            red     +colourHL, green     +colourHL, blue     +colourHL, alpha,
            red     +colourHL, green     +colourHL, blue     +colourHL, alpha
        };
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
    }
	
    // Draw top highlight and bottom shadow
    if (self.has3DStyle) {
        CGContextSaveGState(c);
        CGMutablePathRef innerShadowPath = CGPathCreateMutable();
        
        // add a rect larger than the bounds of bubblePath
        CGPathAddRect(innerShadowPath, NULL, CGRectInset(CGPathGetPathBoundingBox(bubblePath), -30, -30));
        
        // add bubblePath to innershadow
        CGPathAddPath(innerShadowPath, NULL, bubblePath);
        CGPathCloseSubpath(innerShadowPath);
        
        // draw top highlight
        UIColor *highlightColor = [UIColor colorWithWhite:1.0 alpha:0.75];
        CGContextSetFillColorWithColor(c, highlightColor.CGColor);
        CGContextSetShadowWithColor(c, CGSizeMake(0.0, 4.0), 4.0, highlightColor.CGColor);
        CGContextAddPath(c, innerShadowPath);
        CGContextEOFillPath(c);
        
        // draw bottom shadow
        UIColor *shadowColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        CGContextSetFillColorWithColor(c, shadowColor.CGColor);
        CGContextSetShadowWithColor(c, CGSizeMake(0.0, -4.0), 4.0, shadowColor.CGColor);
        CGContextAddPath(c, innerShadowPath);
        CGContextEOFillPath(c);
        
        CGPathRelease(innerShadowPath);
        CGContextRestoreGState(c);
    }
	
	CGContextRestoreGState(c);

    //Draw Border
    if (self.borderWidth > 0) {
        size_t numBorderComponents = CGColorGetNumberOfComponents([self.borderColor CGColor]);
        const CGFloat *borderComponents = CGColorGetComponents(self.borderColor.CGColor);
        CGFloat r, g, b, a;
        if (numBorderComponents == 2) {
            r = borderComponents[0];
            g = borderComponents[0];
            b = borderComponents[0];
            a = borderComponents[1];
        }
        else {
            r = borderComponents[0];
            g = borderComponents[1];
            b = borderComponents[2];
            a = borderComponents[3];
        }
        
        CGContextSetRGBStrokeColor(c, r, g, b, a);
        CGContextAddPath(c, bubblePath);
        CGContextDrawPath(c, kCGPathStroke);
    }
    
	CGPathRelease(bubblePath);
	
	// Draw title and text
    if (self.title) {
        [self.titleColor set];
        CGRect titleFrame = CGRectIntegral([self contentFrame]);
        
        if ([self.title respondsToSelector:@selector(drawWithRect:options:attributes:context:)]) {
            NSMutableParagraphStyle *titleParagraphStyle = [[NSMutableParagraphStyle alloc] init];
            titleParagraphStyle.alignment = self.titleAlignment;
            titleParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            
            [self.title drawWithRect:titleFrame
                             options:NSStringDrawingUsesLineFragmentOrigin
                          attributes:@{
                                       NSFontAttributeName: self.titleFont,
                                       NSForegroundColorAttributeName: self.titleColor,
                                       NSParagraphStyleAttributeName: titleParagraphStyle
                                       }
                             context:nil];
            
        }
        else {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

            [self.title drawInRect:titleFrame
                          withFont:self.titleFont
                     lineBreakMode:NSLineBreakByWordWrapping
                         alignment:self.titleAlignment];

#pragma clang diagnostic pop

        }
    }
	
	if (self.message) {
		[self.textColor set];
		CGRect textFrame = CGRectIntegral([self contentFrame]);
        
        // Move down to make room for title
        if (self.title) {
            
            if ([self.title respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
                NSMutableParagraphStyle *titleParagraphStyle = [[NSMutableParagraphStyle alloc] init];
                titleParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

                textFrame.origin.y += [self.title boundingRectWithSize:CGSizeMake(textFrame.size.width, 99999.0)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{
                                                                         NSFontAttributeName: self.titleFont,
                                                                         NSParagraphStyleAttributeName: titleParagraphStyle
                                                                         }
                                                               context:nil].size.height;
            }
            else {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

                textFrame.origin.y += [self.title sizeWithFont:self.titleFont
                                             constrainedToSize:CGSizeMake(textFrame.size.width, 99999.0)
                                                 lineBreakMode:NSLineBreakByWordWrapping].height;

#pragma clang diagnostic pop

            }
        }
        
        NSMutableParagraphStyle *textParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        textParagraphStyle.alignment = self.textAlignment;
        textParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        if ([self.message respondsToSelector:@selector(drawWithRect:options:attributes:context:)]) {
            [self.message drawWithRect:textFrame
                               options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
                                                                                          NSFontAttributeName: self.textFont,
                                                                                          NSParagraphStyleAttributeName: textParagraphStyle,
                                                                                          NSForegroundColorAttributeName: self.textColor
                                                                                          }
                               context:nil];
        }
        else {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

            [self.message drawInRect:textFrame
                            withFont:self.textFont
                       lineBreakMode:NSLineBreakByWordWrapping
                           alignment:self.textAlignment];

#pragma clang diagnostic pop

        }
    }
}

- (void)presentPointingAtView:(UIView *)targetView inView:(UIView *)containerView animated:(BOOL)animated {
	if (!self.targetObject) {
		self.targetObject = targetView;
	}
    
    // If we want to dismiss the bubble when the user taps anywhere, we need to insert
    // an invisible button over the background.
    if ( self.dismissTapAnywhere ) {
        self.dismissTarget = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.dismissTarget addTarget:self action:@selector(dismissTapAnywhereFired:) forControlEvents:UIControlEventTouchUpInside];
        [self.dismissTarget setTitle:@"" forState:UIControlStateNormal];
        self.dismissTarget.frame = containerView.bounds;
        [containerView addSubview:self.dismissTarget];
    }
	
	[containerView addSubview:self];
    
	// Size of rounded rect
	CGFloat rectWidth;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // iPad
        if (self.maxWidth) {
            if (self.maxWidth < containerView.frame.size.width) {
                rectWidth = self.maxWidth;
            }
            else {
                rectWidth = containerView.frame.size.width - 20;
            }
        }
        else {
            rectWidth = (int)(containerView.frame.size.width/3);
        }
    }
    else {
        // iPhone
        if (self.maxWidth) {
            if (self.maxWidth < containerView.frame.size.width) {
                rectWidth = self.maxWidth;
            }
            else {
                rectWidth = containerView.frame.size.width - 10;
            }
        }
        else {
            rectWidth = (int)(containerView.frame.size.width*2/3);
        }
    }

	CGSize textSize = CGSizeZero;
    
    if (self.message!=nil) {
        if ([self.message respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
            NSMutableParagraphStyle *textParagraphStyle = [[NSMutableParagraphStyle alloc] init];
            textParagraphStyle.alignment = self.textAlignment;
            textParagraphStyle.lineBreakMode  =NSLineBreakByWordWrapping;

            textSize = [self.message boundingRectWithSize:CGSizeMake(rectWidth, 99999.0)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{
                                                            NSFontAttributeName: self.textFont,
                                                            NSParagraphStyleAttributeName: textParagraphStyle
                                                            }
                                                  context:nil].size;
        }
        else {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

            textSize = [self.message sizeWithFont:self.textFont
                                constrainedToSize:CGSizeMake(rectWidth, 99999.0)
                                    lineBreakMode:NSLineBreakByWordWrapping];

#pragma clang diagnostic pop
        
        }
    }
    if (self.customView != nil) {
        textSize = self.customView.frame.size;
    }
    if (self.title != nil) {
        CGSize titleSize;

        if ([self.title respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
            NSMutableParagraphStyle *titleParagraphStyle = [[NSMutableParagraphStyle alloc] init];
            titleParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

            titleSize = [self.title boundingRectWithSize:CGSizeMake(rectWidth, 99999.0)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{
                                                           NSFontAttributeName: self.titleFont,
                                                           NSParagraphStyleAttributeName: titleParagraphStyle
                                                           }
                                                 context:nil].size;
        }
        else {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

            titleSize = [self.title sizeWithFont:self.titleFont
                               constrainedToSize:CGSizeMake(rectWidth, 99999.0)
                                   lineBreakMode:NSLineBreakByWordWrapping];

#pragma clang diagnostic pop
        
        }

        if (titleSize.width > textSize.width) textSize.width = titleSize.width;
        textSize.height += titleSize.height;
    }
    
	_bubbleSize = CGSizeMake(textSize.width + (_bubblePaddingX*2) + (_cornerRadius*2), textSize.height + (_bubblePaddingY*2) + (_cornerRadius*2));
	
	UIView *superview = containerView.superview;
	if ([superview isKindOfClass:[UIWindow class]])
		superview = containerView;
	
	CGPoint targetRelativeOrigin    = [targetView.superview convertPoint:targetView.frame.origin toView:superview];
	CGPoint containerRelativeOrigin = [superview convertPoint:containerView.frame.origin toView:superview];
    
	CGFloat pointerY;	// Y coordinate of pointer target (within containerView)
	
    
    if (targetRelativeOrigin.y+targetView.bounds.size.height < containerRelativeOrigin.y) {
        pointerY = 0.0;
        _pointDirection = PointDirectionUp;
    }
    else if (targetRelativeOrigin.y > containerRelativeOrigin.y+containerView.bounds.size.height) {
        pointerY = containerView.bounds.size.height;
        _pointDirection = PointDirectionDown;
    }
    else {
        _pointDirection = _preferredPointDirection;
        CGPoint targetOriginInContainer = [targetView convertPoint:CGPointMake(0.0, 0.0) toView:containerView];
        CGFloat sizeBelow = containerView.bounds.size.height - targetOriginInContainer.y;
        if (_pointDirection == PointDirectionAny) {
            if (sizeBelow > targetOriginInContainer.y) {
                pointerY = targetOriginInContainer.y + targetView.bounds.size.height;
                _pointDirection = PointDirectionUp;
            }
            else {
                pointerY = targetOriginInContainer.y;
                _pointDirection = PointDirectionDown;
            }
        }
        else {
            if (_pointDirection == PointDirectionDown) {
                pointerY = targetOriginInContainer.y;
            }
            else {
                pointerY = targetOriginInContainer.y + targetView.bounds.size.height;
            }
        }
    }
    
	CGFloat W = containerView.bounds.size.width;
	
	CGPoint p = [targetView.superview convertPoint:targetView.center toView:containerView];
	CGFloat x_p = p.x;
	CGFloat x_b = x_p - roundf(_bubbleSize.width/2);
	if (x_b < _sidePadding) {
		x_b = _sidePadding;
	}
	if (x_b + _bubbleSize.width + _sidePadding > W) {
		x_b = W - _bubbleSize.width - _sidePadding;
	}
	if (x_p - _pointerSize < x_b + _cornerRadius) {
		x_p = x_b + _cornerRadius + _pointerSize;
	}
	if (x_p + _pointerSize > x_b + _bubbleSize.width - _cornerRadius) {
		x_p = x_b + _bubbleSize.width - _cornerRadius - _pointerSize;
	}
	
	CGFloat fullHeight = _bubbleSize.height + _pointerSize + 10.0;
	CGFloat y_b;
	if (_pointDirection == PointDirectionUp) {
		y_b = _topMargin + pointerY;
		_targetPoint = CGPointMake(x_p-x_b, 0);
	}
	else {
		y_b = pointerY - fullHeight;
		_targetPoint = CGPointMake(x_p-x_b, fullHeight-2.0);
	}
	
	CGRect finalFrame = CGRectMake(x_b-_sidePadding,
								   y_b,
								   _bubbleSize.width+_sidePadding*2,
								   fullHeight);
    finalFrame = CGRectIntegral(finalFrame);
    
   	
	if (animated) {
        if (self.animation == CMPopTipAnimationSlide) {
            self.alpha = 0.0;
            CGRect startFrame = finalFrame;
            startFrame.origin.y += 10;
            self.frame = startFrame;
        }
		else if (self.animation == CMPopTipAnimationPop) {
            self.frame = finalFrame;
            self.alpha = 0.5;
            
            // start a little smaller
            self.transform = CGAffineTransformMakeScale(0.75f, 0.75f);
            
            // animate to a bigger size
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(popAnimationDidStop:finished:context:)];
            [UIView setAnimationDuration:0.15f];
            self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
            self.alpha = 1.0;
            [UIView commitAnimations];
        }
		
		[self setNeedsDisplay];
		
		if (self.animation == CMPopTipAnimationSlide) {
			[UIView beginAnimations:nil context:nil];
			self.alpha = 1.0;
			self.frame = finalFrame;
			[UIView commitAnimations];
		}
	}
	else {
		// Not animated
		[self setNeedsDisplay];
		self.frame = finalFrame;
	}
}

- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated {
	UIView *targetView = (UIView *)[barButtonItem performSelector:@selector(view)];
	UIView *targetSuperview = [targetView superview];
	UIView *containerView = [targetSuperview superview];
	
	if (nil == containerView) {
		NSLog(@"Cannot determine container view from UIBarButtonItem: %@", barButtonItem);
		self.targetObject = nil;
		return;
	}
	
	self.targetObject = barButtonItem;
	
	[self presentPointingAtView:targetView inView:containerView animated:animated];
}

- (void)finaliseDismiss {
	[self.autoDismissTimer invalidate]; self.autoDismissTimer = nil;

    if (self.dismissTarget) {
        [self.dismissTarget removeFromSuperview];
		self.dismissTarget = nil;
    }
	
	[self removeFromSuperview];
    
	_highlight = NO;
	self.targetObject = nil;
}

- (void)dismissAnimationDidStop:(__unused NSString *)animationID finished:(__unused NSNumber *)finished context:(__unused void *)context
{
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

- (void)autoDismissAnimatedDidFire:(NSTimer *)theTimer {
    NSNumber *animated = [[theTimer userInfo] objectForKey:@"animated"];
    [self dismissAnimated:[animated boolValue]];
	[self notifyDelegatePopTipViewWasDismissedByUser];
}

- (void)autoDismissAnimated:(BOOL)animated atTimeInterval:(NSTimeInterval)timeInterval {
    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:animated] forKey:@"animated"];
    
    [self.autoDismissTimer invalidate]; 
    self.autoDismissTimer = nil;    
    self.autoDismissTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
															 target:self
														   selector:@selector(autoDismissAnimatedDidFire:)
														   userInfo:userInfo
															repeats:NO];
}

- (void)notifyDelegatePopTipViewWasDismissedByUser {
	__strong id<CMPopTipViewDelegate> delegate = self.delegate;
	[delegate popTipViewWasDismissedByUser:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (self.disableTapToDismiss) {
		[super touchesBegan:touches withEvent:event];
		return;
	}

	[self dismissByUser];
}

- (void)dismissTapAnywhereFired:(__unused UIButton *)button
{
	[self dismissByUser];
}

- (void)dismissByUser
{
	_highlight = YES;
	[self setNeedsDisplay];
	
	[self dismissAnimated:YES];
	
	[self notifyDelegatePopTipViewWasDismissedByUser];
}

- (void)popAnimationDidStop:(__unused NSString *)animationID finished:(__unused NSNumber *)finished context:(__unused void *)context
{
    // at the end set to normal size
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1f];
	self.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.opaque = NO;

		_topMargin = 2.0;
		_pointerSize = 12.0;
		_sidePadding = 2.0;
        _borderWidth = 1.0;
		
		self.textFont = [UIFont boldSystemFontOfSize:14.0];
		self.textColor = [UIColor whiteColor];
		self.textAlignment = NSTextAlignmentCenter;
		self.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:60.0/255.0 blue:154.0/255.0 alpha:1.0];
        self.has3DStyle = YES;
        self.borderColor = [UIColor blackColor];
        self.hasShadow = YES;
        self.animation = CMPopTipAnimationSlide;
        self.dismissTapAnywhere = NO;
        self.preferredPointDirection = PointDirectionAny;
        self.hasGradientBackground = YES;
        self.cornerRadius = 10.0;
    }
    return self;
}

- (void)setHasShadow:(BOOL)hasShadow
{
    if (hasShadow != _hasShadow) {
        _hasShadow = hasShadow;

        if (hasShadow) {
            self.layer.shadowOffset = CGSizeMake(0, 3);
            self.layer.shadowRadius = 2.0;
            self.layer.shadowColor = [[UIColor blackColor] CGColor];
            self.layer.shadowOpacity = 0.3;
        } else {
            self.layer.shadowOpacity = 0.0;
        }
    }
}

- (PointDirection) getPointDirection
{
  return _pointDirection;
}

- (id)initWithTitle:(NSString *)titleToShow message:(NSString *)messageToShow
{
	CGRect frame = CGRectZero;
	
	if ((self = [self initWithFrame:frame])) {
        self.title = titleToShow;
		self.message = messageToShow;
        
        self.titleFont = [UIFont boldSystemFontOfSize:16.0];
        self.titleColor = [UIColor whiteColor];
        self.titleAlignment = NSTextAlignmentCenter;
        self.textFont = [UIFont systemFontOfSize:14.0];
		self.textColor = [UIColor whiteColor];
	}
	return self;
}

- (id)initWithMessage:(NSString *)messageToShow
{
	CGRect frame = CGRectZero;
	
	if ((self = [self initWithFrame:frame])) {
		self.message = messageToShow;
        self.isAccessibilityElement = YES;
        self.accessibilityHint = messageToShow;
	}
	return self;
}

- (id)initWithCustomView:(UIView *)aView
{
	CGRect frame = CGRectZero;
	
	if ((self = [self initWithFrame:frame])) {
		self.customView = aView;
        [self addSubview:self.customView];
	}
	return self;
}

@end
