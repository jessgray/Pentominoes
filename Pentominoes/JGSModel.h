//
//  JGSModel.h
//  Pentominoes
//
//  Created by Jessica Smith on 9/18/13.
//  Copyright (c) 2013 Jessica Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGSModel : NSObject
- (void)initPieces;
- (void)initSolutions;

-(NSArray*)getPieceImages;
- (NSArray *)getBoardPieceLetters;
- (NSArray *)getSolutions;
- (NSDictionary *)getSolutionForPiece:(NSString*)piece onBoard:(NSUInteger)board;
-(UIImage*)getBoardImage: (NSUInteger)boardNumber;

@end
