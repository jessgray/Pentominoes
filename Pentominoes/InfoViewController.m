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
- (IBAction)boardBackgroundChanged:(id)sender;

@property (retain, nonatomic) IBOutlet UISegmentedControl *boardBackgroundSelector;
@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.infoLabel.text = @"This version of Pentominoes was made by Jessie Smith. Enjoy!";
    self.boardBackgroundSelector.selectedSegmentIndex = self.selectedBoardBackground;
}

- (void)dealloc {
    [_delegate release];
    [_boardBackgroundSelector release];
    [super dealloc];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)dismissPressed:(id)sender {
    [self.delegate dismissMe];
    
}

- (IBAction)boardBackgroundChanged:(id)sender {
    
    UISegmentedControl *selector = sender;
    self.selectedBoardBackground = [selector selectedSegmentIndex];
    
    [self.delegate changeBoardBackground:self.selectedBoardBackground];
}

@end
