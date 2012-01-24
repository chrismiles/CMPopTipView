//
//  Demo1ViewController.m
//  CMPopTipView
//
//  Created by Chris Miles on 13/11/10.
//  Copyright (c) Chris Miles 2010.
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

#import "Demo1ViewController.h"

#define foo4random() (1.0 * (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX)

#pragma mark -
#pragma mark Private interface

@interface Demo1ViewController ()
@property (nonatomic, retain)	NSArray			*colorSchemes;
@property (nonatomic, retain)	NSDictionary	*contents;
@property (nonatomic, retain)	id				currentPopTipViewTarget;
@property (nonatomic, retain)	NSMutableArray	*visiblePopTipViews;
@end


#pragma mark -
#pragma mark Implementation

@implementation Demo1ViewController

@synthesize colorSchemes;
@synthesize contents=_contents;
@synthesize currentPopTipViewTarget;
@synthesize visiblePopTipViews;

- (void)dismissAllPopTipViews {
	while ([visiblePopTipViews count] > 0) {
		CMPopTipView *popTipView = [visiblePopTipViews objectAtIndex:0];
		[visiblePopTipViews removeObjectAtIndex:0];
		[popTipView dismissAnimated:YES];
	}
}

- (IBAction)buttonAction:(id)sender {
	[self dismissAllPopTipViews];
	
	if (sender == currentPopTipViewTarget) {
		// Dismiss the popTipView and that is all
		self.currentPopTipViewTarget = nil;
	}
	else {
		NSString *contentMessage = nil;
		UIView *contentView = nil;
		id content = [self.contents objectForKey:[NSNumber numberWithInt:[(UIView *)sender tag]]];
		if ([content isKindOfClass:[UIView class]]) {
			contentView = content;
		}
		else if ([content isKindOfClass:[NSString class]]) {
			contentMessage = content;
		}
		else {
			contentMessage = @"A CMPopTipView can automatically point to any view or bar button item.";
		}
		NSArray *colorScheme = [colorSchemes objectAtIndex:foo4random()*[colorSchemes count]];
		UIColor *backgroundColor = [colorScheme objectAtIndex:0];
		UIColor *textColor = [colorScheme objectAtIndex:1];
		
		CMPopTipView *popTipView;
		if (contentView) {
			popTipView = [[[CMPopTipView alloc] initWithCustomView:contentView] autorelease];
		}
		else {
			popTipView = [[[CMPopTipView alloc] initWithMessage:contentMessage] autorelease];
		}
		popTipView.delegate = self;
		//popTipView.disableTapToDismiss = YES;
		if (backgroundColor && ![backgroundColor isEqual:[NSNull null]]) {
			popTipView.backgroundColor = backgroundColor;
		}
		if (textColor && ![textColor isEqual:[NSNull null]]) {
			popTipView.textColor = textColor;
		}
        
        popTipView.animation = arc4random() % 2;
		
		if ([sender isKindOfClass:[UIButton class]]) {
			UIButton *button = (UIButton *)sender;
			[popTipView presentPointingAtView:button inView:self.view animated:YES];
		}
		else {
			UIBarButtonItem *barButtonItem = (UIBarButtonItem *)sender;
			[popTipView presentPointingAtBarButtonItem:barButtonItem animated:YES];
		}
		
		[visiblePopTipViews addObject:popTipView];
		self.currentPopTipViewTarget = sender;
	}
}


#pragma mark -
#pragma mark CMPopTipViewDelegate methods

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
	[visiblePopTipViews removeObject:popTipView];
	self.currentPopTipViewTarget = nil;
}


#pragma mark -
#pragma mark UIViewController methods

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	for (CMPopTipView *popTipView in visiblePopTipViews) {
		id targetObject = popTipView.targetObject;
		[popTipView dismissAnimated:NO];
		
		if ([targetObject isKindOfClass:[UIButton class]]) {
			UIButton *button = (UIButton *)targetObject;
			[popTipView presentPointingAtView:button inView:self.view animated:NO];
		}
		else {
			UIBarButtonItem *barButtonItem = (UIBarButtonItem *)targetObject;
			[popTipView presentPointingAtBarButtonItem:barButtonItem animated:NO];
		}
	}
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.visiblePopTipViews = [NSMutableArray array];
	
	self.contents = [NSDictionary dictionaryWithObjectsAndKeys:
					 // Rounded rect buttons
					 @"A CMPopTipView will automatically position itself within the container view.", [NSNumber numberWithInt:11],
					 @"A CMPopTipView will automatically orient itself above or below the target view based on the available space.", [NSNumber numberWithInt:12],
					 @"A CMPopTipView always tries to point at the center of the target view.", [NSNumber numberWithInt:13],
					 @"A CMPopTipView can point to any UIView subclass.", [NSNumber numberWithInt:14],
					 @"A CMPopTipView will automatically size itself to fit the text message.", [NSNumber numberWithInt:15],
					 [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appicon57.png"]] autorelease], [NSNumber numberWithInt:16],	// content can be a UIView
					 // Nav bar buttons
					 @"This CMPopTipView is pointing at a leftBarButtonItem of a navigationItem.", [NSNumber numberWithInt:21],
					 @"Two popup animations are provided: slide and pop. Tap other buttons to see them both.", [NSNumber numberWithInt:22],
					 // Toolbar buttons
					 @"CMPopTipView will automatically point at buttons either above or below the containing view.", [NSNumber numberWithInt:31],
					 @"The arrow is automatically positioned to point to the center of the target button.", [NSNumber numberWithInt:32],
					 @"CMPopTipView knows how to point automatically to UIBarButtonItems in both nav bars and tool bars.", [NSNumber numberWithInt:33],
					 nil];
	
	// Array of (backgroundColor, textColor) pairs.
	// NSNull for either means leave as default.
	// A color scheme will be picked randomly per CMPopTipView.
	self.colorSchemes = [NSArray arrayWithObjects:
						 [NSArray arrayWithObjects:[NSNull null], [NSNull null], nil],
						 [NSArray arrayWithObjects:[UIColor colorWithRed:134.0/255.0 green:74.0/255.0 blue:110.0/255.0 alpha:1.0], [NSNull null], nil],
						 [NSArray arrayWithObjects:[UIColor darkGrayColor], [NSNull null], nil],
						 [NSArray arrayWithObjects:[UIColor lightGrayColor], [UIColor darkTextColor], nil],
						 [NSArray arrayWithObjects:[UIColor orangeColor], [UIColor blueColor], nil],
						 [NSArray arrayWithObjects:[UIColor colorWithRed:220.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0], [NSNull null], nil],
						 nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
	self.contents = nil;
	self.visiblePopTipViews = nil;
}

- (void)dealloc {
	[_contents release];
	[colorSchemes release];
	[currentPopTipViewTarget release];
	[visiblePopTipViews release];
	
    [super dealloc];
}


@end
