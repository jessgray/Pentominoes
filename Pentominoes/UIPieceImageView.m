//
//  UIPieceImageView.m
//  Pentominoes
//
//  Created by Jessica Smith on 9/22/13.
//  Copyright (c) 2013 Jessica Smith. All rights reserved.
//

#import "UIPieceImageView.h"

@interface UIPieceImageView ()
@property NSInteger numRotations;
@property NSInteger numFlips;
@property (nonatomic)  CGRect newFrame;
@property (nonatomic) CGRect originalFrame;

@end

@implementation UIPieceImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self reset];
    }
    return self;
}

- (void)reset {
    self.numFlips = 0;
    self.numRotations = 0;
    self.newFrame = CGRectMake(0, 0, 0, 0);
    self.originalFrame = CGRectMake(0, 0, 0, 0);
}

- (NSInteger)getNumFlips {
    return self.numFlips;
}

- (NSInteger)getNumRotations {
    return self.numRotations;
}

- (CGRect)getFrame {
    return self.frame;
}

- (CGRect)getOriginalFrame {
    return self.originalFrame;
}

- (void)setOriginalFrame:(CGRect)frame {
    frame = self.originalFrame;
}

- (void)setNewFrame:(CGRect)frame {
    frame = self.frame;
}

- (void)increaseFlips {
    self.numFlips++;
    if(self.numFlips == 2) {
        self.numFlips = 0;
    }
}

- (void)increaseRotations {
    self.numRotations++;
    if(self.numRotations == 4) {
        self.numRotations = 0;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
