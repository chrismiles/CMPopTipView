//
//  Demo1ViewController.h
//  CMPopTipView
//
//  Created by Chris Miles on 13/11/10.
//  Copyright 2010 Chris Miles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPopTipView.h"

@interface Demo1ViewController : UIViewController <CMPopTipViewDelegate> {

}

- (IBAction)navBarLeftButtonAction:(id)sender;
- (IBAction)navBarRightButtonAction:(id)sender;
- (IBAction)toolbarLeftButtonAction:(id)sender;
- (IBAction)toolbarMiddleButtonAction:(id)sender;
- (IBAction)toolbarRightButtonAction:(id)sender;

@end
