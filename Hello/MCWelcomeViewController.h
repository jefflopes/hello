//
//  MCWelcomeViewController.h
//  Hello
//
//  Created by Jeff Lopes on 10/7/13.
//  Copyright (c) 2013 MonkeyCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCMyNameIsView.h"

@interface MCWelcomeViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet MCMyNameIsView *myNameIsView;

@property (strong, nonatomic) NSString *initialName;

@end
