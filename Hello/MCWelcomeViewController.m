//
//  MCWelcomeViewController.m
//  Hello
//
//  Created by Jeff Lopes on 10/7/13.
//  Copyright (c) 2013 MonkeyCity. All rights reserved.
//

#import "MCWelcomeViewController.h"
#import <AdSupport/AdSupport.h>
#import <Parse/Parse.h>

@implementation MCWelcomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.initialName)
        self.myNameIsView.nameTextField.text = self.initialName;
    
    self.myNameIsView.nameTextField.delegate = self;
    self.myNameIsView.nameTextField.returnKeyType = UIReturnKeyDone;
    [self.myNameIsView.nameTextField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self save])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        return YES;
    }
    else
        return NO;
}

- (BOOL)save
{
    NSString *name = self.myNameIsView.nameTextField.text;
    
    if (!name || [name isEqualToString:@""])
        return NO;
    
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    PFQuery *query = [PFQuery queryWithClassName:PARSE_OBJECT_NAME];
    [query whereKey:PARSE_IDFA_KEY equalTo:idfa];
    PFObject *user = [query getFirstObject];
    
    if (!user)
    {
        user = [PFObject objectWithClassName:PARSE_OBJECT_NAME];
        [user setObject:[[NSUUID UUID] UUIDString] forKey:PARSE_UUID_KEY];
        [user setObject:idfa forKey:PARSE_IDFA_KEY];
    }
    
    [user setObject:name forKey:PARSE_NAME_KEY];
    
    if (![user save])
        return NO;

    return YES;
}

@end
