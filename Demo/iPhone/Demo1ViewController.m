//
//  Demo1ViewController.m
//  CMPopTipView
//
//  Created by Chris Miles on 13/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Demo1ViewController.h"


#pragma mark -
#pragma mark Private interface

@interface Demo1ViewController ()
@property (nonatomic, retain)	CMPopTipView	*aboutPopTipView;
@end


#pragma mark -
#pragma mark Implementation

@implementation Demo1ViewController

@synthesize aboutPopTipView;

- (void)showAboutPopTipView {
	NSString *message = @"Tap here to view information about the app.";
	CMPopTipView *popTipView = [[CMPopTipView alloc] initWithMessage:message];
	popTipView.delegate = self;
	[popTipView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];	// "+" button
	
	self.aboutPopTipView = popTipView;
	[popTipView release];
}

- (void)dismissAboutPopTipView {
	[self.aboutPopTipView dismissAnimated:YES];
	self.aboutPopTipView = nil;
}

- (IBAction)aboutAction:(id)sender {
	[self dismissAboutPopTipView];
}


#pragma mark -
#pragma mark CMPopTipViewDelegate methods

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
	self.aboutPopTipView = nil;
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
	
	[self performSelector:@selector(showAboutPopTipView) withObject:nil afterDelay:1.5];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[aboutPopTipView release];
	
    [super dealloc];
}


@end
