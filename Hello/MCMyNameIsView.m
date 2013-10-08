//
//  MCMyNameIsView.m
//  Hello
//
//  Created by Jeff Lopes on 10/7/13.
//  Copyright (c) 2013 MonkeyCity. All rights reserved.
//

#import "MCMyNameIsView.h"

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
}

@end
