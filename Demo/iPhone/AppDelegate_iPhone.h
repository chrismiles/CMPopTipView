//
//  AppDelegate_iPhone.h
//  CMPopTipView
//
//  Created by Chris Miles on 26/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate> {
	UINavigationController *mainNavigationController;
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UINavigationController *mainNavigationController;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

