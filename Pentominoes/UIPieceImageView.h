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

- (NSInteger)getNumFlips;
- (NSInteger)getNumRotations;
- (CGRect)getFrame;
- (CGRect)getOriginalFrame;

- (void)increaseFlips;
- (void)increaseRotations;
- (void)setNewFrame:(CGRect)frame;
- (void)setOriginalFrame:(CGRect)frame;
@end
