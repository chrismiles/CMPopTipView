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


#pragma mark -
#pragma mark Private interface

@interface Demo1ViewController ()
@property (nonatomic, retain)	CMPopTipView	*navBarLeftButtonPopTipView;
@property (nonatomic, retain)	CMPopTipView	*navBarRightButtonPopTipView;
@property (nonatomic, retain)	CMPopTipView	*toolbarLeftButtonPopTipView;
@property (nonatomic, retain)	CMPopTipView	*toolbarMiddleButtonPopTipView;
@property (nonatomic, retain)	CMPopTipView	*toolbarRightButtonPopTipView;
@end


#pragma mark -
#pragma mark Implementation

@implementation Demo1ViewController

@synthesize navBarRightButtonPopTipView, navBarLeftButtonPopTipView, toolbarLeftButtonPopTipView, toolbarMiddleButtonPopTipView, toolbarRightButtonPopTipView;

- (void)dismissAllPopTipViews {
	NSArray *allPopTipViews = [NSArray arrayWithObjects:
							   @"navBarLeftButtonPopTipView",
							   @"navBarRightButtonPopTipView",
							   @"toolbarLeftButtonPopTipView",
							   @"toolbarMiddleButtonPopTipView",
							   @"toolbarRightButtonPopTipView",
							   nil];
	
	for (NSString *propertyName in allPopTipViews) {
		SEL getter = NSSelectorFromString(propertyName);
		CMPopTipView *popTipView = [self performSelector:getter];
		if (popTipView != nil) {
			[popTipView dismissAnimated:YES];
			SEL setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [[propertyName substringToIndex:1] uppercaseString], [propertyName substringFromIndex:1]]);
			[self performSelector:setter withObject:nil];
		}
	}
}

- (IBAction)navBarLeftButtonAction:(id)sender {
	if (nil == self.navBarLeftButtonPopTipView) {
		[self dismissAllPopTipViews];
		NSString *message = @"This CMPopTipView is pointing at a leftBarButtonItem of a navigationItem.";
		self.navBarLeftButtonPopTipView = [[[CMPopTipView alloc] initWithMessage:message] autorelease];
		self.navBarLeftButtonPopTipView.delegate = self;
		[self.navBarLeftButtonPopTipView presentPointingAtBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES];
	}
	else {
		// Dismiss
		[self.navBarLeftButtonPopTipView dismissAnimated:YES];
		self.navBarLeftButtonPopTipView = nil;
	}
}

- (IBAction)navBarRightButtonAction:(id)sender {
	if (nil == self.navBarRightButtonPopTipView) {
		[self dismissAllPopTipViews];
		NSString *message = @"A CMPopTipView can point to any navigationItem bar button items.";
		self.navBarRightButtonPopTipView = [[[CMPopTipView alloc] initWithMessage:message] autorelease];
		self.navBarRightButtonPopTipView.delegate = self;
		[self.navBarRightButtonPopTipView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
	}
	else {
		// Dismiss
		[self.navBarRightButtonPopTipView dismissAnimated:YES];
		self.navBarRightButtonPopTipView = nil;
	}
}

- (IBAction)toolbarLeftButtonAction:(id)sender {
	if (nil == self.toolbarLeftButtonPopTipView) {
		[self dismissAllPopTipViews];
		NSString *message = @"CMPopTipView will automatically point at buttons either above or below the containing view.";
		self.toolbarLeftButtonPopTipView = [[[CMPopTipView alloc] initWithMessage:message] autorelease];
		self.toolbarLeftButtonPopTipView.delegate = self;
		
		UIBarButtonItem *barButtonItem = (UIBarButtonItem *)sender;
		[self.toolbarLeftButtonPopTipView presentPointingAtBarButtonItem:barButtonItem animated:YES];
	}
	else {
		// Dismiss
		[self.toolbarLeftButtonPopTipView dismissAnimated:YES];
		self.toolbarLeftButtonPopTipView = nil;
	}
}

- (IBAction)toolbarMiddleButtonAction:(id)sender {
	if (nil == self.toolbarMiddleButtonPopTipView) {
		[self dismissAllPopTipViews];
		NSString *message = @"The arrow is automatically positioned to point to the center of the target button.";
		self.toolbarMiddleButtonPopTipView = [[[CMPopTipView alloc] initWithMessage:message] autorelease];
		self.toolbarMiddleButtonPopTipView.delegate = self;
		
		UIBarButtonItem *barButtonItem = (UIBarButtonItem *)sender;
		[self.toolbarMiddleButtonPopTipView presentPointingAtBarButtonItem:barButtonItem animated:YES];
	}
	else {
		// Dismiss
		[self.toolbarMiddleButtonPopTipView dismissAnimated:YES];
		self.toolbarMiddleButtonPopTipView = nil;
	}
}

- (IBAction)toolbarRightButtonAction:(id)sender {
	if (nil == self.toolbarRightButtonPopTipView) {
		[self dismissAllPopTipViews];
		NSString *message = @"CMPopTipView knows how to point automatically to UIBarButtonItems in both nav bars and tool bars.";
		self.toolbarRightButtonPopTipView = [[[CMPopTipView alloc] initWithMessage:message] autorelease];
		self.toolbarRightButtonPopTipView.delegate = self;
		
		UIBarButtonItem *barButtonItem = (UIBarButtonItem *)sender;
		[self.toolbarRightButtonPopTipView presentPointingAtBarButtonItem:barButtonItem animated:YES];
	}
	else {
		// Dismiss
		[self.toolbarRightButtonPopTipView dismissAnimated:YES];
		self.toolbarRightButtonPopTipView = nil;
	}
}


#pragma mark -
#pragma mark CMPopTipViewDelegate methods

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
	if (popTipView == self.navBarLeftButtonPopTipView) {
		self.navBarLeftButtonPopTipView = nil;
	}
	else if (popTipView == self.navBarRightButtonPopTipView) {
		self.navBarRightButtonPopTipView = nil;
	}
	else if (popTipView == self.toolbarLeftButtonPopTipView) {
		self.toolbarLeftButtonPopTipView = nil;
	}
	else if (popTipView == self.toolbarMiddleButtonPopTipView) {
		self.toolbarMiddleButtonPopTipView = nil;
	}
	else if (popTipView == self.toolbarRightButtonPopTipView) {
		self.toolbarRightButtonPopTipView = nil;
	}
}


#pragma mark -
#pragma mark UIViewController methods

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
    // Release any retained subviews of the main view.
}

- (void)dealloc {
	[navBarLeftButtonPopTipView release];
	[navBarRightButtonPopTipView release];
	[toolbarLeftButtonPopTipView release];
	[toolbarMiddleButtonPopTipView release];
	[toolbarRightButtonPopTipView release];
	
    [super dealloc];
}


@end
