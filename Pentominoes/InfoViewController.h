//
//  InfoViewController.h
//  Pentominoes
//
//  Created by Jessica Smith on 9/20/13.
//  Copyright (c) 2013 Jessica Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InfoDelegate <NSObject>

- (void)dismissMe;

@end

@interface InfoViewController : UIViewController
@property (nonatomic,weak) id<InfoDelegate> delegate;
@end
