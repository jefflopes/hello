//
//  MCMyNameIsCell.m
//  Hello
//
//  Created by Jeff Lopes on 10/7/13.
//  Copyright (c) 2013 MonkeyCity. All rights reserved.
//

#import "MCMyNameIsCell.h"

@implementation MCMyNameIsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.myNameIsView = [[MCMyNameIsView alloc] initWithFrame:CGRectMake(10, 10, 300, 200)];
        [self.contentView addSubview:self.myNameIsView];
    }
    return self;
}

@end
