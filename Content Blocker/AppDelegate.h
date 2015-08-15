//
//  AppDelegate.h
//  Content Blocker
//
//  Created by Yannick Weiss on 15/08/15.
//  Copyright © 2015 Yannick Weiss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
+ (void)generateBlockerListJSON;

@end

