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

-(NSArray*)ImagesForPieces;
- (NSArray *)LettersForBoardPieces;
- (NSArray *)SolutionsForGame;
- (NSDictionary *)SolutionForPiece:(NSString*)piece onBoard:(NSUInteger)board;
-(UIImage*)BoardImageForBoardNumber:(NSUInteger)boardNumber;

@end
