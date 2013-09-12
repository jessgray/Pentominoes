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
@property NSMutableArray *boardPieces;
@end

@implementation JGSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.boardPieces = [[NSMutableArray alloc] init];
    NSArray *boardPieceLetters = [NSArray arrayWithObjects:@"F", @"I", @"L", @"N", @"P", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    // Create mutable array of board pieces that are each UIImageViews half the size of their corresponding UIImage
    for(NSUInteger i = 0; i < [boardPieceLetters count]; i++) {
        
        UIImage *pieceImage = [UIImage imageNamed: [NSString stringWithFormat:@"tile%@.png", boardPieceLetters[i]]];
        UIImageView *boardPiece = [[UIImageView alloc] initWithImage:pieceImage];
        
        CGSize pieceImageSize = pieceImage.size;
        boardPiece.frame = CGRectMake(0, 0, pieceImageSize.width/2, pieceImageSize.height/2);
        
        [self.boardPieces addObject:boardPiece];
    }
    
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
