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
- (IBAction)update:(id)sender {
  NSString *source = self.sourceField.text;
  source = [source stringByReplacingOccurrencesOfString:@"https://" withString:@""];
  // Example Format: https://github.com/yene/spyfall/archive/master.zip
  NSString *downloadZIP = [NSString stringWithFormat:@"https://%@/%@", source, @"archive/master.zip"]; // could have double // in name
  dispatch_queue_t queue = dispatch_get_global_queue(0,0);
  dispatch_async(queue, ^{
    // TODO: Better download code with more error reporting than this
    
    NSLog(@"Beginning download");
    NSURL  *url = [NSURL URLWithString:downloadZIP];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    //Find a cache directory. You could consider using documenets dir instead (depends on the data you are fetching)
    NSLog(@"Got the data!");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    //Save the data
    NSLog(@"Saving");
    NSString *zipPath = [path stringByAppendingPathComponent:@"blockerList.zip"];
    zipPath = [zipPath stringByStandardizingPath];
    [urlData writeToFile:zipPath atomically:YES];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL zipExists = [fileManager fileExistsAtPath:zipPath];
    if (zipExists) {
      
      NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
      NSString *documentsDirectory = [paths objectAtIndex:0];
      NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:@"/blockerList"];
      
      // delete exisiting folder
      [fileManager removeItemAtPath:targetPath error:nil];
      
      // unpack
      [SSZipArchive unzipFileAtPath:zipPath toDestination:targetPath];

      // generate blocklist json
      [AppDelegate generateBlockerListJSON];
      
      [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastUpdate"];
    } else {
      NSLog(@"could not download ZIP");
    }

    
    [SFContentBlockerManager reloadContentBlockerWithIdentifier:@"com.yannickweiss.Content-Blocker.Extension" completionHandler:^(NSError *error) {
      if (error != nil) {
        NSLog(@"Error: %@", error.localizedDescription);
      } else {
        NSLog(@"reloaded content blocker");
      }
    }];
    
  });
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.sourceField.text = @"https://github.com/yene/blockerList";
  NSDate *lastUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastUpdate"];
  if (lastUpdate != nil) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *formattedDateString = [dateFormatter stringFromDate:lastUpdate];
    self.lastUpdateLabel.text = [@"Last Updated: " stringByAppendingString:formattedDateString];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
