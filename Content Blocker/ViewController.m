//
//  ViewController.m
//  Content Blocker
//
//  Created by Yannick Weiss on 15/08/15.
//  Copyright © 2015 Yannick Weiss. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *sourceField;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateLabel;

@end

@implementation ViewController
- (IBAction)update:(id)sender {
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.sourceField.text = @"https://github.com/yene/blockerList";
  self.lastUpdateLabel.text = @"Last Updated: 14. August 2015";
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
