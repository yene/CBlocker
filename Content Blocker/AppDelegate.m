//
//  AppDelegate.m
//  Content Blocker
//
//  Created by Yannick Weiss on 15/08/15.
//  Copyright © 2015 Yannick Weiss. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // On first run copy the example data from bundle to the temporary location
  BOOL launchedBefore = [[NSUserDefaults standardUserDefaults] boolForKey:@"LaunchedBefore"];
  if (!launchedBefore) {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LaunchedBefore"];
    [self copyExample];
    [self generateBlockerListJSON];
  }
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)copyExample {
  NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/blockerList"];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  BOOL sourceExists = [fileManager fileExistsAtPath:sourcePath];
  NSAssert(sourceExists, @"Example Folder is not added to the project");
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:@"/blockerList"];
  BOOL targetExists = [fileManager fileExistsAtPath:targetPath];
  NSAssert(!targetExists, @"Example Folder already exists");
  if (!targetExists) {
    BOOL success = [fileManager copyItemAtPath:sourcePath toPath:targetPath error:nil];
    NSAssert(success, @"Could not copy Example Files over");
  }
}

- (void)generateBlockerListJSON {
  NSMutableArray *lists = [NSMutableArray array];
  
  // iterate over blockerlist folder content
  NSArray *arr = [[NSFileManager defaultManager] URLsForDirectory: NSDocumentDirectory inDomains: NSUserDomainMask];
  NSURL *directoryURL = [arr firstObject];
  directoryURL = [directoryURL URLByAppendingPathComponent:@"blockerList" isDirectory:YES];
  
  NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]
                                       enumeratorAtURL:directoryURL
                                       includingPropertiesForKeys:@[NSURLIsDirectoryKey]
                                       options:0
                                       errorHandler:^(NSURL *url, NSError *error) {
                                         // Return YES if the enumeration should continue after the error.
                                         return YES;
                                       }];
  
  for (NSURL *url in enumerator) {
    NSError *error;
    NSNumber *isDirectory = nil;
    if (![url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
      // handle error
    } else if (![isDirectory boolValue]) {
      // No error and it’s not a directory; do something with the file
      if([[url pathExtension] isEqualToString:@"json"]) {
        // load file
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError *jsonReadError;
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonReadError];
        if (jsonReadError != nil) {
          NSLog(@"Error: was not able to read %@.", url);
          continue;
        }
        
        // add rules
        [lists addObject:array];
      }
    }
  }
  
  
  // save json
  NSError *jsonWriteError;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:lists
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&jsonWriteError];
  if (!jsonData) {
    NSLog(@"Error writing generated JSON: %@", jsonWriteError.localizedDescription);
  } else {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:@"/blockerList.json"];
    [jsonData writeToFile:targetPath atomically:YES];
  }
  
}

@end
