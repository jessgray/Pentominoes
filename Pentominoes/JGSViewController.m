//
//  JGSViewController.m
//  Pentominoes
//
//  Created by Jessica Smith on 9/8/13.
//  Copyright (c) 2013 Jessica Smith. All rights reserved.
//

#import "JGSViewController.h"

@interface JGSViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mainBoard;
- (IBAction)newBoardSelected:(id)sender;

@property NSInteger currentBoard;
@end

@implementation JGSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newBoardSelected:(id)sender {
    
    self.currentBoard = [sender tag];
    
    NSString *newBoardImage = [NSString stringWithFormat:@"Board%i.png", [sender tag]-1];
    self.mainBoard.image = [UIImage imageNamed:newBoardImage];
}
@end
