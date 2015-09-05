//
//  ViewController.m
//  Content Blocker
//
//  Created by Yannick Weiss on 15/08/15.
//  Copyright © 2015 Yannick Weiss. All rights reserved.
//

#import "ViewController.h"
#import <SafariServices/SafariServices.h>
#import "SSZipArchive.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *sourceField;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateLabel;

@end

@implementation ViewController
- (IBAction)report:(id)sender {
  MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
  mc.mailComposeDelegate = self;
  [mc setSubject:@"Please look at this site."];
  [mc setMessageBody:@"Block the following:\n * " isHTML:NO];
  [mc setToRecipients:@[@"block@yannickweiss.com"]];
  [self presentViewController:mc animated:YES completion:NULL];
}

#pragma mark Mail Delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
  [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)update:(id)sender {
  [self.sourceField resignFirstResponder];
  NSString *source = self.sourceField.text;
  [[NSUserDefaults standardUserDefaults] setObject:source forKey:@"source"];
  
  if ([[source pathExtension] isEqualToString:@"json"]) {
    // save json directly to the shared group folder for the extension
    NSURL *url = [NSURL URLWithString:source];
    [self downloadJSON:url];
  } else if ([[source pathExtension] isEqualToString:@"zip"]) {
    NSURL  *url = [NSURL URLWithString:source];
    [self downloadZip:url];
  } else if ([source containsString:@"https://github.com/"]) {
    NSString *downloadZIP = [source stringByAppendingString:@"archive/master.zip"];
    NSURL  *url = [NSURL URLWithString:downloadZIP];
    [self downloadZip:url];
  } else {
    // TODO show error url not recoginsed
  }

}

- (void)downloadJSON:(NSURL *)jsonURL {
  dispatch_queue_t queue = dispatch_get_global_queue(0,0);
  dispatch_async(queue, ^{
    NSData *urlData = [NSData dataWithContentsOfURL:jsonURL];
    if (urlData) {
      NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier: @"group.com.yannickweiss.CBlocker"];
      NSURL *blockerList = [groupURL URLByAppendingPathComponent:@"blockerList.json"];
      [urlData writeToURL:blockerList atomically:YES];
      [[self class] reloadExtension];
    } else {
      UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                     message:@"Could not download JSON file."
                                                              preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                            handler:nil];
      
      [alert addAction:defaultAction];
      dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
      });
    }
  });
}

- (void)downloadZip:(NSURL *)zipURL {
  dispatch_queue_t queue = dispatch_get_global_queue(0,0);
  dispatch_async(queue, ^{
    // TODO: Better download code with more error reporting than this
    NSData *urlData = [NSData dataWithContentsOfURL:zipURL];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    NSString *zipPath = [path stringByAppendingPathComponent:@"blockerList.zip"];
    zipPath = [zipPath stringByStandardizingPath];
    [urlData writeToFile:zipPath atomically:YES];
    
    BOOL zipExists = [[NSFileManager defaultManager] fileExistsAtPath:zipPath];
    if (zipExists) {
      NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
      NSString *documentsDirectory = [paths objectAtIndex:0];
      NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:@"/blockerList"];
      
      // delete existing folder
      [[NSFileManager defaultManager] removeItemAtPath:targetPath error:nil];
      
      // unpack
      [SSZipArchive unzipFileAtPath:zipPath toDestination:targetPath];
      
      // generate blocklist json
      [AppDelegate generateBlockerListJSON];
      
      [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastUpdate"];
    } else {
      UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                     message:@"Could not download ZIP file."
                                                              preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                            handler:nil];
      
      [alert addAction:defaultAction];
      dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
      });
    }
    
    [[self class] reloadExtension];
    
  });

}

+ (void)reloadExtension {
  [SFContentBlockerManager reloadContentBlockerWithIdentifier:@"com.yannickweiss.CBlocker.Extension" completionHandler:^(NSError *error) {
    if (error != nil) {
      NSLog(@"Error: %@", error.localizedDescription);
    } else {
      NSLog(@"reloaded content blocker");
    }
  }];
}


- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  NSString *source = [[NSUserDefaults standardUserDefaults] objectForKey:@"source"];
  if (!source) {
    source = @"https://github.com/yene/blockerList";
  }
  
  self.sourceField.text = source;
  NSDate *lastUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastUpdate"];
  if (lastUpdate != nil) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *formattedDateString = [dateFormatter stringFromDate:lastUpdate];
    self.lastUpdateLabel.text = [@"Last Updated: " stringByAppendingString:formattedDateString];
  } else {
    self.lastUpdateLabel.text = @"";
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(IBAction)removeKeyboard {
  [self.sourceField resignFirstResponder];
}

@end
