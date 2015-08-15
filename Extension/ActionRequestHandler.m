//
//  ActionRequestHandler.m
//  Extension
//
//  Created by Yannick Weiss on 15/08/15.
//  Copyright © 2015 Yannick Weiss. All rights reserved.
//

#import "ActionRequestHandler.h"

@interface ActionRequestHandler ()

@end

@implementation ActionRequestHandler

- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context {
  // grab the json file from the shared group directory
  NSURL *groupURL = [[NSFileManager defaultManager]
                     containerURLForSecurityApplicationGroupIdentifier:
                     @"group.com.yannickweiss.Content-Blocker"];
  NSURL *blockerList = [groupURL URLByAppendingPathComponent:@"blockerList.json"];
  
  NSItemProvider *attachment = [[NSItemProvider alloc] initWithContentsOfURL:blockerList];
  
  NSExtensionItem *item = [[NSExtensionItem alloc] init];
  item.attachments = @[attachment];
  
  [context completeRequestReturningItems:@[item] completionHandler:nil];
}

@end
