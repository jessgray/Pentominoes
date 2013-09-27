//
//  UIPieceImageView.h
//  Pentominoes
//
//  Created by Jessica Smith on 9/22/13.
//  Copyright (c) 2013 Jessica Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPieceImageView : UIImageView
- (void)reset;

- (NSInteger)NumFlips;
- (NSInteger)NumRotations;

- (void)IncreaseFlips;
- (void)IncreaseRotations;
- (void)AddNumRotations:(NSInteger)numRotations;
@end
