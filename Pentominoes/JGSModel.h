//
//  JGSModel.h
//  Pentominoes
//
//  Created by Jessica Smith on 9/18/13.
//  Copyright (c) 2013 Jessica Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGSModel : NSObject
-(NSArray*)getPieceImages;
-(UIImage*)getBoardImage: (NSUInteger)boardNumber;
-(NSUInteger)getCurrentBoard;

-(void)setCurrentBoard: (NSUInteger)currentBoard;
@end
