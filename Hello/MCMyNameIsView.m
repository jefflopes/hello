//
//  MCMyNameIsView.m
//  Hello
//
//  Created by Jeff Lopes on 10/7/13.
//  Copyright (c) 2013 MonkeyCity. All rights reserved.
//

#import "MCMyNameIsView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MCMyNameIsView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addMainView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self addMainView];
}

- (void)addMainView
{
    self.contentView = [[[NSBundle mainBundle] loadNibNamed:@"MCMyNameIsView" owner:self options:nil] objectAtIndex:0];
    [self addSubview:self.contentView];
    
    self.contentView.layer.cornerRadius = 15;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

@end
