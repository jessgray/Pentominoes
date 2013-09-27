//
//  UIPieceImageView.m
//  Pentominoes
//
//  Created by Jessica Smith on 9/22/13.
//  Copyright (c) 2013 Jessica Smith. All rights reserved.
//

#import "UIPieceImageView.h"

@interface UIPieceImageView ()
@property (nonatomic)  NSInteger numRotations;
@property NSInteger numFlips;

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
}

- (NSInteger)NumFlips {
    return self.numFlips;
}

- (NSInteger)NumRotations {
    return self.numRotations;
}

- (void)IncreaseFlips {
    self.numFlips++;
    if(self.numFlips == 2) {
        self.numFlips = 0;
    }
}

- (void)IncreaseRotations {
    self.numRotations++;
    if(self.numRotations == 4) {
        self.numRotations = 0;
    }
}

- (void)AddNumRotations:(NSInteger)numRotations {
    
    _numRotations += numRotations;
    if(self.numRotations >= 4) {
        self.numRotations -= 4;
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
