//
//  JGSViewController.m
//  Pentominoes
//
//  Created by Jessica Smith on 9/8/13.
//  Copyright (c) 2013 Jessica Smith. All rights reserved.
//

#import "JGSViewController.h"
#define spaceBelowMainBoard 50
#define edgeMargin 100
#define columnSpaceBetweenPieces 20
#define rowSpaceBetweenPieces 50


@interface JGSViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mainBoard;
- (IBAction)newBoardSelected:(id)sender;
- (IBAction)solveGame:(id)sender;

@property NSInteger currentBoard;
@property (nonatomic, strong) NSMutableArray *boardPieces;
@property (nonatomic, strong) NSArray *solutions;
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
        boardPiece.frame = CGRectMake(0.0, 0.0, pieceImageSize.width/2, pieceImageSize.height/2);
        
        [self.boardPieces addObject:boardPiece];
    }

    // Create solutions array for use when the user clicks the "solve" button
    NSString *solutionsPath = [[NSBundle mainBundle] pathForResource:@"Solutions" ofType:@"plist"];
    self.solutions = [NSArray arrayWithContentsOfFile:solutionsPath];

}

-(void)movePiecesToDefaultPosition {
    
}

-(void)viewDidAppear:(BOOL)animated {
    CGSize screenSize = self.view.bounds.size;
    CGSize boardSize = self.mainBoard.bounds.size;
    CGFloat xCoord = 0.0;
    CGFloat yCoord = 0.0;
    CGFloat largestHeight = 0.0;
    
    // Create a container to hold all of the pieces 
    CGRect frame = CGRectMake(edgeMargin, boardSize.height+spaceBelowMainBoard, screenSize.width-edgeMargin, screenSize.height-spaceBelowMainBoard-boardSize.height);
    UIView *piecesContainer = [[UIImageView alloc] initWithFrame:frame];
    
    // Place each piece into the container, spacing them appropriately
    for (UIImageView *piece in self.boardPieces) {
        CGSize pieceSize = piece.bounds.size;
        
        if(pieceSize.height > largestHeight) {
            largestHeight = pieceSize.height;
        }
        
        // Make sure the piece fits within the frame of the piece container. Wrap piece onto the next row
        // if it can't fit in the current row. 
        if(xCoord+pieceSize.width > screenSize.width-2*edgeMargin) {
            xCoord = 0.0;
            yCoord += largestHeight + rowSpaceBetweenPieces;
            largestHeight = 0.0;
            
        }
        
        // Create a frame for the piece and add the piece to the piece container
        CGRect pieceFrame = CGRectMake(xCoord, yCoord, pieceSize.width, pieceSize.height);
        [piecesContainer addSubview:piece];
        [piece setFrame:pieceFrame];
        
        xCoord += pieceFrame.size.width + columnSpaceBetweenPieces;
    }
    
    // Add pieces to the game board
    [self.view addSubview:piecesContainer];
    
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

- (IBAction)solveGame:(id)sender {
    
    
}
@end
