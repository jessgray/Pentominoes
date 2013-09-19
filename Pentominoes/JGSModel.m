//
//  JGSModel.m
//  Pentominoes
//
//  Created by Jessica Smith on 9/18/13.
//  Copyright (c) 2013 Jessica Smith. All rights reserved.
//

#import "JGSModel.h"

@interface JGSModel ()
@property (nonatomic, strong) NSArray *pieceImages;
@end

@implementation JGSModel

-(id)init {
    self = [super init];
    if(self) {
        _pieceImages = [self getPieceImages];
    }
    
    return self;
}

-(NSArray*)getPieceImages {
    
    // Define all pieces represented by letters
    NSArray *boardPieceLetters = [NSArray arrayWithObjects:@"F", @"I", @"L", @"N", @"P", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    NSMutableArray *tempImages = [[NSMutableArray alloc] init];
    
    // Create mutable array of of UIImages that represent each game piece
    for(NSUInteger i = 0; i < [boardPieceLetters count]; i++) {
        
        UIImage *pieceImage = [UIImage imageNamed: [NSString stringWithFormat:@"tile%@.png", boardPieceLetters[i]]];
        
        [tempImages addObject:pieceImage];
    }
    
    // Make the mutable array immutable
    self.pieceImages = [NSArray arrayWithArray:tempImages];
    
    return self.pieceImages;
}

@end


