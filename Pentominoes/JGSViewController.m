//
//  JGSViewController.m
//  Pentominoes
//
//  Created by Jessica Smith on 9/8/13.
//  Copyright (c) 2013 Jessica Smith. All rights reserved.
//

#import "JGSViewController.h"
#import "JGSModel.h"

#define kSpaceBelowMainBoard 50
#define kEdgeMargin 100
#define kColumnSpaceBetweenPieces 20
#define kRowSpaceBetweenPieces 50
#define kSideOfSquare 30
#define kAnimationTransition 1.5


@interface JGSViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mainBoard;
- (IBAction)newBoardSelected:(id)sender;
- (IBAction)solveGame:(id)sender;
- (IBAction)resetPieces:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *board1;
@property (weak, nonatomic) IBOutlet UIButton *board2;
@property (weak, nonatomic) IBOutlet UIButton *board3;
@property (weak, nonatomic) IBOutlet UIButton *board4;
@property (weak, nonatomic) IBOutlet UIButton *board5;
@property (weak, nonatomic) IBOutlet UIButton *board6;
@property (weak, nonatomic) IBOutlet UIButton *solveButton;


@property NSUInteger currentBoard;
@property (nonatomic, strong) NSMutableArray *boardPieces;
@property (nonatomic, strong) NSArray *boardPieceLetters;
@property (nonatomic, strong) NSArray *solutions;
@property (nonatomic, strong) UIView *piecesContainer;

@property (nonatomic, strong) JGSModel *model;
@end

@implementation JGSViewController


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self) {
        _model = [[JGSModel alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.boardPieces = [[NSMutableArray alloc] init];
    self.boardPieceLetters = [NSArray arrayWithObjects:@"F", @"I", @"L", @"N", @"P", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    // Create mutable array of board pieces that are each UIImageViews half the size of their corresponding UIImage
    for(NSUInteger i = 0; i < [self.boardPieceLetters count]; i++) {
        
        UIImage *pieceImage = [UIImage imageNamed: [NSString stringWithFormat:@"tile%@.png", self.boardPieceLetters[i]]];
        UIImageView *boardPiece = [[UIImageView alloc] initWithImage:pieceImage];
        
        CGSize pieceImageSize = pieceImage.size;
        boardPiece.frame = CGRectMake(0.0, 0.0, pieceImageSize.width/2, pieceImageSize.height/2);
        
        [self.boardPieces addObject:boardPiece];
    }

    // Create solutions array for use when the user clicks the "solve" button
    NSString *solutionsPath = [[NSBundle mainBundle] pathForResource:@"Solutions" ofType:@"plist"];
    self.solutions = [NSArray arrayWithContentsOfFile:solutionsPath];

}

-(void)viewDidAppear:(BOOL)animated {
    CGSize screenSize = self.view.bounds.size;
    CGSize boardSize = self.mainBoard.bounds.size;
    
    // Create a container to hold all of the pieces
    CGRect frame = CGRectMake(kEdgeMargin, boardSize.height+kSpaceBelowMainBoard, screenSize.width-kEdgeMargin, screenSize.height-kSpaceBelowMainBoard-boardSize.height);
    self.piecesContainer = [[UIImageView alloc] initWithFrame:frame];
    
    // Add pieces to the game board
    [self.view addSubview:self.piecesContainer];
    
    [self movePiecesToDefaultPosition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newBoardSelected:(id)sender {
    
    self.currentBoard = [sender tag] - 1;
    
    NSString *newBoardImage = [NSString stringWithFormat:@"Board%i.png", self.currentBoard];
    self.mainBoard.image = [UIImage imageNamed:newBoardImage];

}

- (IBAction)solveGame:(id)sender {
    
    if(self.currentBoard != 0) {
        [self toggleBoardButtons:NO];
        
        NSUInteger boardPieceIndex = 0;
        NSDictionary *thisSolution = [self.solutions objectAtIndex:self.currentBoard-1];
        
        // Move each piece onto the game board in the correct position
        for (NSString *key in self.boardPieceLetters) {
            
            NSDictionary *currentSolution = [thisSolution valueForKey:key];
            NSInteger xCoord, yCoord, numRotations, numFlips;
            UIImageView *currentPiece = [self.boardPieces objectAtIndex:boardPieceIndex];
            
            // Get values from the solution
            xCoord = [[currentSolution valueForKey:@"x"] integerValue]*kSideOfSquare;
            yCoord = [[currentSolution valueForKey:@"y"] integerValue]*kSideOfSquare;
            numRotations = [[currentSolution valueForKey:@"rotations"] integerValue];
            numFlips = [[currentSolution valueForKey:@"flips"] integerValue];
            
            CGPoint origin = [[currentPiece superview] convertPoint:currentPiece.frame.origin toView:self.mainBoard];
            [currentPiece setFrame: CGRectMake(origin.x, origin.y, currentPiece.frame.size.width, currentPiece.frame.size.height)];
            
            [UIView animateWithDuration:kAnimationTransition animations:^{
                // Apply rotations and flips
                if(numRotations > 0) {
                    currentPiece.transform = CGAffineTransformMakeRotation(numRotations*M_PI_2);
                }
                if(numFlips > 0) {
                    currentPiece.transform = CGAffineTransformScale(currentPiece.transform, -1.0, 1.0);
                }
                
                // Put piece onto the game board
                [currentPiece setFrame:CGRectMake(xCoord, yCoord, currentPiece.frame.size.width, currentPiece.frame.size.height)];
                [self.mainBoard addSubview:currentPiece];
            }];
            
            boardPieceIndex++;
        }
    }
}

-(void)toggleBoardButtons: (BOOL)enable {

        self.board1.enabled = enable;
        self.board2.enabled = enable;
        self.board3.enabled = enable;
        self.board4.enabled = enable;
        self.board5.enabled = enable;
        self.board6.enabled = enable;
        self.solveButton.enabled = enable;
}

// Handle rotations of the UI
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [self movePiecesToDefaultPosition];
    
}

-(void)movePiecesToDefaultPosition {
    CGSize screenSize = self.view.bounds.size;
    CGFloat xCoord = 0.0;
    CGFloat yCoord = 0.0;
    CGFloat largestHeight = 0.0;
    
    // Place each piece into the container, spacing them appropriately
    for (UIImageView *piece in self.boardPieces) {
        CGSize pieceSize = piece.bounds.size;
        
        if(pieceSize.height > largestHeight) {
            largestHeight = pieceSize.height;
        }
        
        // Make sure the piece fits within the frame of the piece container. Wrap piece onto the next row
        // if it can't fit in the current row.
        if(xCoord+pieceSize.width > screenSize.width-2*kEdgeMargin) {
            xCoord = 0.0;
            yCoord += largestHeight + kRowSpaceBetweenPieces;
            largestHeight = 0.0;
            
        }
        
        CGPoint origin = [[piece superview] convertPoint:piece.frame.origin toView:self.piecesContainer];
        [piece setFrame: CGRectMake(origin.x, origin.y, piece.frame.size.width, piece.frame.size.height)];
        
        // Create a frame for the piece and add the piece to the piece container
        CGRect pieceFrame = CGRectMake(xCoord, yCoord, pieceSize.width, pieceSize.height);
        [self.piecesContainer addSubview:piece];
        [piece setFrame:pieceFrame];
        
        xCoord += pieceFrame.size.width + kColumnSpaceBetweenPieces;
    }
}

- (IBAction)resetPieces:(id)sender {
    
    [self toggleBoardButtons:YES];
    
    [UIImageView animateWithDuration:kAnimationTransition animations:^{
        
        // Undo any transforms applied to pieces
        for (UIImageView *piece in self.boardPieces) {
            piece.transform = CGAffineTransformIdentity;
        }
        
        // Move pieces back to the original area
        [self movePiecesToDefaultPosition];
        
    }];
    
}
@end
