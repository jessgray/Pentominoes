//
//  JGSModel.m
//  Pentominoes
//
//  Created by Jessica Smith on 9/18/13.
//  Copyright (c) 2013 Jessica Smith. All rights reserved.
//

#import "JGSModel.h"

@interface JGSModel ()
@property (nonatomic, strong) NSArray *boardPieceLetters;
@property (nonatomic, strong) NSArray *pieceImages;
@property (nonatomic, strong) NSArray *solutions;

@end

@implementation JGSModel

-(id)init {
    self = [super init];
    if(self) {
        [self initPieces];
        [self initSolutions];
    }
    return self;
}

- (void)initPieces {
    // Define all pieces represented by letters
    self.boardPieceLetters = [NSArray arrayWithObjects:@"F", @"I", @"L", @"N", @"P", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    NSMutableArray *tempImages = [[NSMutableArray alloc] init];
    
    // Create mutable array of of UIImages that represent each game piece
    for(NSUInteger i = 0; i < [self.boardPieceLetters count]; i++) {
        
        UIImage *pieceImage = [UIImage imageNamed: [NSString stringWithFormat:@"tile%@.png", self.boardPieceLetters[i]]];
        
        [tempImages addObject:pieceImage];
    }
    
    // Make the mutable array immutable
    self.pieceImages = [NSArray arrayWithArray:tempImages];

    [tempImages release];
}

- (void)initSolutions {
    // Create solutions array for use when the user clicks the "solve" button
    NSString *solutionsPath = [[NSBundle mainBundle] pathForResource:@"Solutions" ofType:@"plist"];
    self.solutions = [NSArray arrayWithContentsOfFile:solutionsPath];
}

-(NSArray*)ImagesForPieces {
    
    return self.pieceImages;
}

- (NSArray *)LettersForBoardPieces {
    return self.boardPieceLetters;
}

- (NSArray *)SolutionsForGame {
    return self.solutions;
}

- (NSDictionary *)SolutionForPiece:(NSString*)piece onBoard:(NSUInteger)board {
    NSDictionary *solution  = [[self.solutions objectAtIndex:board] valueForKey:piece];
    return solution;
}

-(UIImage*)BoardImageForBoardNumber:(NSUInteger)boardNumber {
    NSString *boardImageName = [NSString stringWithFormat:@"Board%i.png", boardNumber];
    UIImage *mainBoardImage = [UIImage imageNamed:boardImageName];
    
    return mainBoardImage;
}



@end


