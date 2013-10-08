//
//  MCMainViewController.m
//  Hello
//
//  Created by Jeff Lopes on 10/7/13.
//  Copyright (c) 2013 MonkeyCity. All rights reserved.
//

#import "MCMainViewController.h"
#import "MCMyNameIsCell.h"
#import "MCWelcomeViewController.h"
#import <Parse/Parse.h>
#import <AdSupport/AdSupport.h>

@interface MCMainViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) NSArray *beacons;
@property (strong, nonatomic) NSMutableDictionary *strangers;
@property (strong, nonatomic) PFObject *user;

@end

@implementation MCMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    self.beacons = @[];
    self.strangers = [NSMutableDictionary dictionary];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    PFQuery *query = [PFQuery queryWithClassName:PARSE_OBJECT_NAME];
    [query whereKey:PARSE_IDFA_KEY equalTo:idfa];
    self.user = [query getFirstObject];
    
    if (!self.user)
    {
        [self performSegueWithIdentifier:@"showWelcome" sender:self];
    }
    else
    {
        self.nameButtonItem.title = [self.user objectForKey:PARSE_NAME_KEY];
        [self startBroadcasting];
        [self refreshStrangers];
    }
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
        [self startBroadcasting];
}

- (void)startBroadcasting
{
    NSString *uuid = [self.user objectForKey:PARSE_UUID_KEY];
    if (uuid)
    {
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:uuid] identifier:uuid];
        NSDictionary *peripheralData = [region peripheralDataWithMeasuredPower:nil];
        [self.peripheralManager startAdvertising:peripheralData];
    }
}

- (IBAction)changeName:(id)sender
{
    [self performSegueWithIdentifier:@"showWelcome" sender:self];
}

- (IBAction)refresh:(id)sender
{
    [self refreshStrangers];
}

- (IBAction)segControlChanged:(id)sender
{
    [self.tableView reloadData];
}

- (void)refreshStrangers
{
    PFQuery *query = [PFQuery queryWithClassName:PARSE_OBJECT_NAME];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            for (CLBeaconRegion *region in self.locationManager.rangedRegions.copy)
            {
                [self.locationManager stopRangingBeaconsInRegion:region];
                [self.strangers removeAllObjects];
            }
            
            for (PFObject *stranger in objects)
            {
                NSString *uuid = [stranger objectForKey:PARSE_UUID_KEY];
                CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:uuid] identifier:uuid];
                [self.strangers setObject:stranger forKey:uuid];
                [self.locationManager startRangingBeaconsInRegion:region];
            }
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSMutableArray *allBeacons = [NSMutableArray arrayWithArray:self.beacons];
 
    for (CLBeacon *existingBeacon in allBeacons.copy)
    {
        if ([region.proximityUUID.UUIDString isEqualToString:existingBeacon.proximityUUID.UUIDString])
            [allBeacons removeObject:existingBeacon];
    }
    
    for (CLBeacon *newBeacon in beacons)
    {
        if (newBeacon.proximity != CLProximityUnknown)
            [allBeacons addObject:newBeacon];
    }
    
    NSSortDescriptor *primarySortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"proximity" ascending:YES];
    NSSortDescriptor *secondarySortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"accuracy" ascending:YES];
    NSArray *sortDescriptors = @[primarySortDescriptor, secondarySortDescriptor];
    NSArray *sortedBeacons = [allBeacons sortedArrayUsingDescriptors:sortDescriptors];
    self.beacons = sortedBeacons;
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
        return self.beacons.count;
    else
        return self.strangers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyNameIsCell";
    MCMyNameIsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyNameIsCell"];
    
    if (cell == nil)
    {
        cell = [[MCMyNameIsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.myNameIsView.nameTextField.enabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        CLBeacon *beacon = self.beacons[indexPath.row];
        
        switch (beacon.proximity) {
            case CLProximityUnknown:
                cell.myNameIsView.contentView.backgroundColor = [UIColor grayColor];
                break;
            case CLProximityImmediate:
                cell.myNameIsView.contentView.backgroundColor = [UIColor greenColor];
                break;
            case CLProximityNear:
                cell.myNameIsView.contentView.backgroundColor = [UIColor yellowColor];
                break;
            case CLProximityFar:
                cell.myNameIsView.contentView.backgroundColor = [UIColor redColor];
                break;
            default:
                break;
        }
        
        PFObject *stranger = [self.strangers objectForKey:beacon.proximityUUID.UUIDString];
        NSString *name = [stranger objectForKey:PARSE_NAME_KEY];

        if (name && ![name isEqualToString:@""])
            cell.myNameIsView.nameTextField.text = name;
        else
            cell.myNameIsView.nameTextField.text = beacon.proximityUUID.UUIDString;
    }
    else
    {
        NSArray *uuids = [self.strangers allKeys];
        NSString *uuid = [uuids objectAtIndex:indexPath.row];
        PFObject *stranger  = [self.strangers objectForKey:uuid];
        
        cell.myNameIsView.contentView.backgroundColor = [UIColor redColor];
        NSString *name = [stranger objectForKey:PARSE_NAME_KEY];
        cell.myNameIsView.nameTextField.text = name;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showWelcome"])
    {
        MCWelcomeViewController *welcomeViewController = [segue destinationViewController];
        if (self.user)
           welcomeViewController.initialName = [self.user objectForKey:PARSE_NAME_KEY];
    }
}

@end
