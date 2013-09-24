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
#import "UIPieceImageView.h"
#import <math.h>

static const NSInteger kSpaceBelowMainBoard = 50;
static const NSInteger kEdgeMargin = 100;
static const NSInteger kColumnSpaceBetweenPieces = 20;
static const NSInteger kRowSpaceBetweenPieces = 50;
static const NSInteger kSideOfSquare = 30;
static const CGFloat kAnimationTransition = 1.5;
static const CGFloat kSnapTransition = 0.3;
static const CGFloat kPieceScale = 0.8;


@interface JGSViewController () <InfoDelegate>

- (IBAction)newBoardSelected:(id)sender;
- (IBAction)solveGame:(id)sender;
- (IBAction)resetPieces:(id)sender;

@property (retain, nonatomic) IBOutlet UIImageView *mainBoard;
@property (retain, nonatomic) IBOutlet UIButton *board1;
@property (retain, nonatomic) IBOutlet UIButton *board2;
@property (retain, nonatomic) IBOutlet UIButton *board3;
@property (retain, nonatomic) IBOutlet UIButton *board4;
@property (retain, nonatomic) IBOutlet UIButton *board5;
@property (retain, nonatomic) IBOutlet UIButton *board6;
@property (retain, nonatomic) IBOutlet UIButton *solveButton;


@property NSUInteger currentBoard;
@property (nonatomic, strong) NSArray *boardButtons;
@property (nonatomic, strong) NSMutableArray *boardPieces;
@property (nonatomic, strong) UIView *piecesContainer;

-(IBAction)unwindSegue:(UIStoryboardSegue*)segue;

@property (nonatomic, retain) JGSModel *model;
@end

@implementation JGSViewController


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self) {
        _model = [[JGSModel alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [_model release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.boardPieces = [[NSMutableArray alloc] init];
    
    NSArray *pieceImages = [_model getPieceImages];
    
    // Create mutable array of board pieces that are each UIPieceImageViews half the size of their corresponding UIImage
    for(NSUInteger i = 0; i < [[_model getBoardPieceLetters] count]; i++) {
        
        UIPieceImageView *boardPiece = [[UIPieceImageView alloc] initWithImage:pieceImages[i]];
        
        CGSize pieceImageSize = [pieceImages[i] size];
        boardPiece.frame = CGRectMake(0.0, 0.0, pieceImageSize.width/2, pieceImageSize.height/2);
        
        boardPiece.userInteractionEnabled = YES;
        [self.boardPieces addObject:boardPiece];
    }
    
    [self defineAndAddGestures];
    
    // Put all board buttons into an array for user interaction enabled toggling
    self.boardButtons = [NSArray arrayWithObjects:self.board1, self.board2, self.board3, self.board4, self.board5, self.board6, self.solveButton, nil];
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

// Handle rotations of the UI
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [self toggleBoardButtons:YES];
    
    [UIView animateWithDuration:kAnimationTransition animations:^{
        [self movePiecesToDefaultPosition];
    }];
    
    
}

- (IBAction)newBoardSelected:(id)sender {
    
    self.currentBoard = [sender tag] -1;
    self.mainBoard.image = [_model getBoardImage:[sender tag] -1];
}

- (IBAction)solveGame:(id)sender {
    
    if(self.currentBoard != 0) {
        [self toggleBoardButtons:NO];
        
        NSUInteger boardPieceIndex = 0;
        
        // Move each piece onto the game board in the correct position
        for (NSString *key in [_model getBoardPieceLetters]) {
            
            NSDictionary *currentSolution = [_model getSolutionForPiece:key onBoard:self.currentBoard-1];
            NSInteger xCoord, yCoord, numRotations, numFlips;
            UIPieceImageView *currentPiece = [self.boardPieces objectAtIndex:boardPieceIndex];
            
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

// Reset all pieces back to their original places
- (IBAction)resetPieces:(id)sender {
    
    [self toggleBoardButtons:YES];
    
    [UIImageView animateWithDuration:kAnimationTransition animations:^{
        // Move pieces back to the original area
        [self movePiecesToDefaultPosition];
    }];
}

// Toggle board selectors on/off
-(void)toggleBoardButtons: (BOOL)enable {

    for (UIButton* button in self.boardButtons) {
        button.enabled = enable;
    }
}

// Move one piece back to its original position
- (void)returnPieceToOriginalSpot: (UIPieceImageView *)piece {
    
    [UIView animateWithDuration:kAnimationTransition animations:^{
        [piece setFrame:[piece getOriginalFrame]];
    }];
}

// Move all pieces back to the original playing positions
-(void)movePiecesToDefaultPosition {
    CGSize screenSize = self.view.bounds.size;
    CGFloat xCoord = 0.0;
    CGFloat yCoord = 0.0;
    CGFloat largestHeight = 0.0;
    
    // Undo any transforms applied to pieces
    for (UIPieceImageView *piece in self.boardPieces) {
        piece.transform = CGAffineTransformIdentity;
    }
    
    // Place each piece into the container, spacing them appropriately
    for (UIPieceImageView *piece in self.boardPieces) {
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
        
        [piece setOriginalFrame:piece.frame];
        
        xCoord += pieceFrame.size.width + kColumnSpaceBetweenPieces;
    }
}

#pragma mark - Define Gestures
- (void)defineAndAddGestures {
    
    // Define gestures for each piece and apply them to the pieces
    for (UIPieceImageView *boardPiece in self.boardPieces) {
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        
        [boardPiece addGestureRecognizer:singleTap];
        [boardPiece addGestureRecognizer:doubleTap];
        [boardPiece addGestureRecognizer:pan];
    }
}

#pragma mark - Touches
-(IBAction)handleSingleTap:(UITapGestureRecognizer *)sender {
    
    UIPieceImageView *piece = (UIPieceImageView *)sender.view;
    
    if(sender.state == UIGestureRecognizerStateEnded){
        
        [piece increaseRotations];
        
        // If piece has been flipped, need to make rotation direction -1 in order to keep clockwise rotation
        NSInteger rotationDirection = ([piece getNumFlips] == 1) ? -1 : 1;
        
        // Animate rotation 90 degrees clockwise
        [UIView animateWithDuration:kSnapTransition animations:^{
            [piece setTransform:CGAffineTransformRotate(piece.transform, rotationDirection*M_PI_2)];
        }];
        
        // Snap piece to the grid if it's on the main board
        if([piece isDescendantOfView:self.mainBoard]) {
            [self snapPiece:piece];
        }
    }
}

-(IBAction)handleDoubleTap:(UITapGestureRecognizer *)sender {
    
    UIPieceImageView *piece = (UIPieceImageView *)sender.view;
    
    if(sender.state == UIGestureRecognizerStateEnded){
        
        // If image has been rotated an odd number of times, flip needs to use 1 for x and -1 for y to keep
        // flips consistent
        
        CGFloat flipX = ([piece getNumRotations] %2 == 0) ? -1.0 : 1.0;
        CGFloat flipY = -1*flipX;
        
        [piece increaseFlips];
        
        // Animate flip
        [UIView animateWithDuration:kSnapTransition animations:^{
            [piece setTransform:CGAffineTransformScale(piece.transform, flipX, flipY)];
        }];
        
    }
}

#pragma mark - Pans
-(IBAction)handlePan:(UIPanGestureRecognizer *)sender {
    
    UIPieceImageView *piece = (UIPieceImageView *)sender.view;
    
    switch(sender.state) {
        case UIGestureRecognizerStateBegan:
            
            // Convert coordinates of piece to belong the the game board so the piece doesn't jump around while
            // moving
            piece.center = [sender locationInView:self.mainBoard];
            
            CGPoint origin = [[piece superview] convertPoint:piece.frame.origin toView:self.mainBoard];
            [piece setFrame: CGRectMake(origin.x, origin.y, piece.frame.size.width, piece.frame.size.height)];
            
            [self.mainBoard addSubview:piece];
            
            // Shrink piece when it begins to move
            [self applyTransformWithAnimation:piece withScale:kPieceScale];
            
            break;
        case UIGestureRecognizerStateChanged:
            
            // Keep moving the piece in relation to the game board
            piece.center = [sender locationInView:self.mainBoard];
            
            break;
        case UIGestureRecognizerStateEnded:
            // Unshrink piece once it stops moving
            [self applyTransformWithAnimation:piece withScale:1/kPieceScale];
            
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
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        default:
            
            [self returnPieceToOriginalSpot:piece];
            break;
    }
}

// Snap a piece to the main game board
-(void)snapPiece:(UIPieceImageView *)piece {
    
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

- (void)applyTransformWithAnimation: (UIPieceImageView *)piece withScale: (CGFloat)scaleRatio {
    
    [piece setNewFrame:piece.frame];
    
    [UIView animateWithDuration:kSnapTransition animations:^{
        [piece setTransform:CGAffineTransformScale(piece.transform, scaleRatio, scaleRatio)];
    }];
    
    piece.frame = [piece getFrame];
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

@end
