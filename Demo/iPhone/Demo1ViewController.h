//
//  Demo1ViewController.h
//  CMPopTipView
//
//  Created by Chris Miles on 13/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPopTipView.h"

@interface Demo1ViewController : UIViewController <CMPopTipViewDelegate> {

}

@property (nonatomic, retain)	IBOutlet	UIBarButtonItem		*toolbarButtonItem1;

- (IBAction)aboutAction:(id)sender;

@end
