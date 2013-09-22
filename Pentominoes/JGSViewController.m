//
//  JGSViewController.m
//  Pentominoes
//
//  Created by Jessica Smith on 9/8/13.
//  Copyright (c) 2013 Jessica Smith. All rights reserved.
//

#import "JGSViewController.h"
#import "InfoViewController.h"
#import "JGSModel.h"
#import <math.h>

#define kSpaceBelowMainBoard 50
#define kEdgeMargin 100
#define kColumnSpaceBetweenPieces 20
#define kRowSpaceBetweenPieces 50
#define kSideOfSquare 30
#define kAnimationTransition 1.5
#define kSnapTransition 0.3


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
@property NSInteger numPiecesOnBoard;
@property (nonatomic, strong) NSMutableArray *boardPieces;
@property (nonatomic, strong) NSArray *boardPieceLetters;
@property (nonatomic, strong) NSArray *solutions;
@property (nonatomic, strong) UIView *piecesContainer;

-(IBAction)unwindSegue:(UIStoryboardSegue*)segue;

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
    
    NSArray *pieceImages = [_model getPieceImages];
    
    // Create mutable array of board pieces that are each UIImageViews half the size of their corresponding UIImage
    for(NSUInteger i = 0; i < [self.boardPieceLetters count]; i++) {
        
        UIImageView *boardPiece = [[UIImageView alloc] initWithImage:pieceImages[i]];
        
        CGSize pieceImageSize = [pieceImages[i] size];
        boardPiece.frame = CGRectMake(0.0, 0.0, pieceImageSize.width/2, pieceImageSize.height/2);
        
        boardPiece.userInteractionEnabled = YES;
        [self.boardPieces addObject:boardPiece];
    }
    
    
    for (UIImageView *boardPiece in self.boardPieces) {
        // Define gestures for each piece and apply them to the pieces
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        
        [boardPiece addGestureRecognizer:singleTap];
        [boardPiece addGestureRecognizer:doubleTap];
        [boardPiece addGestureRecognizer:pan];
    }
    
    // Create solutions array for use when the user clicks the "solve" button
    NSString *solutionsPath = [[NSBundle mainBundle] pathForResource:@"Solutions" ofType:@"plist"];
    self.solutions = [NSArray arrayWithContentsOfFile:solutionsPath];

}

#pragma mark Touches
-(IBAction)handleSingleTap:(UITapGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateEnded){
        [sender.view setTransform:CGAffineTransformRotate(sender.view.transform, M_PI_2)];
        
        // Snap piece to the grid if it's on the main board
        if([sender.view isDescendantOfView:self.mainBoard]) {
            [self snapPiece:sender.view];
        }
    }
}

-(IBAction)handleDoubleTap:(UITapGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateEnded){
        [sender.view setTransform:CGAffineTransformScale(sender.view.transform, -1.0, 1.0)];
    }
}

// Snap a piece to the main game board
-(void)snapPiece:(UIView *)piece {

    // Round off coordinates of the piece to the nearest integer, then calculate where
    // to place the piece on the board
    CGFloat oldX = piece.frame.origin.x/kSideOfSquare;
    CGFloat oldY = piece.frame.origin.y/kSideOfSquare;
    
    CGFloat roundedX = roundf(oldX);
    CGFloat roundedY = roundf(oldY);
    
    CGPoint snap = CGPointMake(((NSInteger)roundedX)*kSideOfSquare, ((NSInteger)roundedY)*kSideOfSquare);
    
    // Snap piece to nearest grid on the board
    piece.frame = (CGRect){snap, piece.frame.size};
}

-(BOOL)isPieceOverGameBoard:(UIView *)piece {
    
    
    // Note: piece is in coordinate system of self.mainBoard, but mainBoard is in coordinate system of self.view. Simply
    // need to compare coordinates of piece to dimensions of the board. 
    if((piece.center.x > 0 && piece.center.x < self.mainBoard.frame.size.width) &&
       (piece.center.y > 0 && piece.center.y < self.mainBoard.frame.size.height)) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark Pans
-(IBAction)handlePan:(UIPanGestureRecognizer *)sender {
    
    UIView *piece = sender.view;
    
    switch(sender.state) {
        case UIGestureRecognizerStateBegan:
            
            // Convert coordinates of piece to belong the the game board so the piece doesn't jump around while
            // moving
            piece.center = [sender locationInView:self.mainBoard];
                
            CGPoint origin = [[piece superview] convertPoint:piece.frame.origin toView:self.mainBoard];
            [piece setFrame: CGRectMake(origin.x, origin.y, piece.frame.size.width, piece.frame.size.height)];
                
            [self.mainBoard addSubview:piece];
            
            break;
        case UIGestureRecognizerStateChanged:

            // Keep moving the piece in relation to the game board 
            piece.center = [sender locationInView:self.mainBoard];
            
            break;
        case UIGestureRecognizerStateEnded:
            
            // If the piece is no longer over the game board, move it to the main view so it can be picked back up.
            // Otherwise, snap the piece to the board. 
            if(![self isPieceOverGameBoard:piece]) {
                piece.center = [sender locationInView:self.view];
                [self.view addSubview:piece];
            } else {
                
                [UIView animateWithDuration:kSnapTransition animations:^{
                    [self snapPiece:piece];
                }];
                
            }
            break;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    CGSize screenSize = self.view.bounds.size;
    CGSize boardSize = self.mainBoard.bounds.size;
    
    // Create a container to hold all of the pieces
    CGRect frame = CGRectMake(kEdgeMargin, boardSize.height+kSpaceBelowMainBoard, screenSize.width-kEdgeMargin, screenSize.height-kSpaceBelowMainBoard-boardSize.height);
    self.piecesContainer = [[UIImageView alloc] initWithFrame:frame];
    
    
    self.piecesContainer.userInteractionEnabled = YES;
    
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
    
    self.currentBoard = [sender tag] -1;

    NSString *boardImageName = [NSString stringWithFormat:@"Board%i.png", self.currentBoard];
    UIImage *mainBoardImage = [UIImage imageNamed:boardImageName];
    
    self.mainBoard.image = mainBoardImage;

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

#pragma mark - Info Delegate
-(void)dismissMe {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"InfoSegue"]) {
        InfoViewController *infoViewController = segue.destinationViewController;
        infoViewController.delegate = self;
    }
}

-(IBAction)unwindSegue:(UIStoryboardSegue *)segue {
    
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
