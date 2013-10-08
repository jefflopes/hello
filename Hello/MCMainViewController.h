//
//  MCMainViewController.h
//  Hello
//
//  Created by Jeff Lopes on 10/7/13.
//  Copyright (c) 2013 MonkeyCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface MCMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, CBPeripheralManagerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nameButtonItem;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)changeName:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)segControlChanged:(id)sender;

@end
