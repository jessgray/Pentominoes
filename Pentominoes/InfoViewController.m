//
//  InfoViewController.m
//  Pentominoes
//
//  Created by Jessica Smith on 9/21/13.
//  Copyright (c) 2013 Jessica Smith. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@property (retain, nonatomic) IBOutlet UILabel *infoLabel;
- (IBAction)dismissPressed:(id)sender;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.infoLabel.text = @"This version of Pentominoes was made by Jessie Smith. Enjoy!";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)dismissPressed:(id)sender {
    [self.delegate dismissMe];
    
}

@end
