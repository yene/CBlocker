//
//  ViewController.h
//  Content Blocker
//
//  Created by Yannick Weiss on 15/08/15.
//  Copyright © 2015 Yannick Weiss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ViewController : UIViewController<MFMailComposeViewControllerDelegate>
+ (void)reloadExtension;

@end

