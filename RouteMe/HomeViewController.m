//
//  HomeViewController.m
//  JHGoogleMaps
//
//  Created by Jason Humphries on 1/21/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import <AddressBook/AddressBook.h>
#import "MapViewController.h"
#import "GooglePlacesAutocompletor.h"
#import "GooglePlace.h"
#import "GooglePlacesSearcher.h"

@interface HomeViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *driveWalkSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextField *myLocationField;
@property (strong, nonatomic) IBOutlet UITextField *myDestinationField;
@property (strong, nonatomic) IBOutlet UITextField *keywordField;
@property (strong, nonatomic) IBOutlet UIButton *goButton;
@property (strong, nonatomic) NSString *currentLocationString;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *locationAI;
@property (assign, nonatomic) BOOL isInDrivingMode;
@property (strong, nonatomic) NSMutableArray *destinationsArray;
@property (strong, nonatomic) IBOutlet UITableView *destinationsTable;
@property (weak, nonatomic) IBOutlet UILabel *endLocationCheckImage;
@property (weak, nonatomic) IBOutlet UILabel *startLocationCheckImage;
@end

@implementation HomeViewController

-(void)awakeFromNib
{
    self.isInDrivingMode = YES;
    self.destinationsArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidUpdate:) name:LOCATION_UPDATE_NOTIFICATION object:nil];
}

-(void)locationDidUpdate:(NSNotification*)notif
{
//    NSLog(@"notif: %@", notif);
    if ([notif.object isKindOfClass:[CLLocation class]]) {
        CLLocation *newLocation = (CLLocation*)notif.object;
        [self.locationAI stopAnimating];
        [self reverseGeocodeLocationForString:MY_APP_DELEGATE.currentLocation];
        MY_APP_DELEGATE.startingLocation = newLocation;
        self.startLocationCheckImage.hidden = NO;
    }
}

-(void)keyboardDidHide
{
    NSLog(@"kb hide");
}

-(void)keyboardDidShow
{
    NSLog(@"kb show");
}

- (IBAction)driveWalkSegmentedControlChanged:(id)sender
{
    if (self.driveWalkSegmentedControl.selectedSegmentIndex == 0) {
        self.isInDrivingMode = YES;
    } else {
        self.isInDrivingMode = NO;
    }
}

- (IBAction)goAction:(id)sender
{
    [self performSegueWithIdentifier:@"homeToMapSegue" sender:nil];
}

#pragma mark - prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"homeToMapSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
            MapViewController *mvc = (MapViewController*)segue.destinationViewController;
//            mvc.
        }
    }
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField isEqual:self.myLocationField]) {
        [self startBeginningSearch];
    } else if ([textField isEqual:self.myDestinationField]) {
        [self startDestinationSearch];
    } else if ([textField isEqual:self.keywordField]) {
        if ([textField.text length] > 0) {
            MY_APP_DELEGATE.keywordSearchString = textField.text;
            [self goAction:nil];
        }
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *currentInputString = [textField.text stringByAppendingString:string];
    if (currentInputString.length < 1) {
        // nothing entered
        self.destinationsTable.hidden = YES;
    } else if (currentInputString.length < 2) {
        // not enough entered to search yet
        self.destinationsTable.hidden = YES;
    } else if (currentInputString.length > 2 && [textField isEqual:self.myDestinationField] && MY_APP_DELEGATE.lat != 0) {
        // now do an autocomplete search
        [GooglePlacesAutocompletor searchTerm:currentInputString
                                        atLat:MY_APP_DELEGATE.lat
                                          lng:MY_APP_DELEGATE.lng
                                      success:
         ^(NSArray *results) {
//             NSLog(@"autocompletor success:\n%@", results);
             if (results.count > 0) {
                 [self.destinationsArray removeAllObjects];
                 for (NSDictionary *result in results) {
                     GooglePlace *place = [[GooglePlace alloc] init];
                     place.placeID = result[@"id"];
                     place.placeTitle = result[@"description"];
                     place.placeReference = result[@"reference"];
//                     NSLog(@"terms:%@", result[@"terms"][0][@"value"]);
                     // add place to local array of places unless it exists
                     if (self.destinationsArray.count > 0) {
                         NSArray *localplacescopy = [self.destinationsArray copy];
                         for (GooglePlace *p in localplacescopy) {
                             if ([p.placeID isEqualToString:place.placeID]) {
                                 // don't add to array
                             } else {
                                 [self.destinationsArray addObject:place];
                                 break;
                             }
                         }
                     } else {
                         [self.destinationsArray addObject:place];
                     }
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.destinationsTable reloadData];
                         self.destinationsTable.hidden = NO;
                     });
                 }
             } else {
                 self.destinationsTable.hidden = YES;
             }
         } failure:^(NSError *error) {
             NSLog(@"autocompletor error: %@", error.localizedDescription);
         }];
    }
    return YES;
}

- (void)startDestinationSearch
{
    if ([self.myDestinationField.text length] > 0) {
        [self geocodeDestination:self.myDestinationField.text];
    }
}

- (void)startBeginningSearch
{
    if ([self.myLocationField.text length] > 0) {
        [self geocodeStart:self.myLocationField.text];
    }
}

#pragma mark - View Controller Lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.destinationsTable.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.locationAI startAnimating];
    self.startLocationCheckImage.hidden = YES;
    self.endLocationCheckImage.hidden = YES;
    // if there's a valid currentLocation, set it to starting location via reverse geocode
    if (MY_APP_DELEGATE.currentLocation.coordinate.latitude != 0) {
        [self reverseGeocodeLocation:MY_APP_DELEGATE.currentLocation];
    }
}

#pragma mark - geocode:

- (void)geocodeDestination:(NSString *)address
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address
                 completionHandler:
     ^(NSArray *placemarks, NSError *error)
     {
         if ([placemarks count] >= 1) {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             MY_APP_DELEGATE.destinationLocation = placemark.location;
             self.endLocationCheckImage.hidden = NO;
//             [[[UIAlertView alloc] initWithTitle:@"Destination Set" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
         } else {
             [[[UIAlertView alloc] initWithTitle:@"Address not found" message:@"Sorry, I couldn't find that destination address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
         }
     }];
}

- (void)geocodeStart:(NSString *)address
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address
                 completionHandler:
     ^(NSArray *placemarks, NSError *error)
     {
         if ([placemarks count] >= 1) {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             MY_APP_DELEGATE.startingLocation = placemark.location;
             self.startLocationCheckImage.hidden = NO;
         } else {
             [[[UIAlertView alloc] initWithTitle:@"Address not found" message:@"Sorry, I couldn't find that starting address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
         }
     }];
}

#pragma mark - CLGeocoder - reverseGeocodeLocation

- (void)reverseGeocodeLocationForString:(CLLocation *)location
{
    CLGeocoder* reverseGeocoderTwo = [[CLGeocoder alloc] init];
    if (reverseGeocoderTwo) {
        [reverseGeocoderTwo reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark* placemark = [placemarks objectAtIndex:0];
            if (placemark) {
                NSString *addr = [placemark.addressDictionary objectForKey:(NSString*)kABPersonAddressStreetKey];
                NSString *city = [placemark.addressDictionary objectForKey:(NSString*)kABPersonAddressCityKey];
                self.currentLocationString = [NSString stringWithFormat:@"%@ %@", addr, city];
                self.myLocationField.text = self.currentLocationString;
            }
        }];
    }
}

- (void)reverseGeocodeLocation:(CLLocation *)location
{
    CLGeocoder* reverseGeocoderTwo = [[CLGeocoder alloc] init];
    if (reverseGeocoderTwo) {
        [reverseGeocoderTwo reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark* placemark = [placemarks objectAtIndex:0];
            if (placemark) {
                NSString *addr = [placemark.addressDictionary objectForKey:(NSString*)kABPersonAddressStreetKey];
                NSString *city = [placemark.addressDictionary objectForKey:(NSString*)kABPersonAddressCityKey];
                self.currentLocationString = [NSString stringWithFormat:@"%@ %@", addr, city];
                self.myLocationField.text = self.currentLocationString;
                [self startBeginningSearch];
                [self.locationAI stopAnimating];
            }
        }];
    }
}

#pragma mark <UITableViewDataSource>

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.destinationsArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"destinationAC"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"destinationAC"];
    }
    cell.textLabel.text = [self.destinationsArray[indexPath.row] placeTitle];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GooglePlace *selectedPlace = (GooglePlace*)self.destinationsArray[indexPath.row];
    NSLog(@"you selected %@", selectedPlace.placeTitle);
    [GooglePlacesSearcher getGooglePlaceByReference:selectedPlace.placeReference
                                            success:
     ^(GooglePlace *gPlace) {
         NSLog(@"here it is:\n%@", gPlace);
         dispatch_async(dispatch_get_main_queue(), ^{
             self.destinationsTable.hidden = YES;
             self.myDestinationField.text = gPlace.placeAddress;
             MY_APP_DELEGATE.destinationLocation = [[CLLocation alloc] initWithLatitude:gPlace.placeLat longitude:gPlace.placeLng];
             self.endLocationCheckImage.hidden = NO;
             [self.myDestinationField resignFirstResponder];
             [self.myLocationField resignFirstResponder];
         });
     } failure:^(NSError *error) {
         NSLog(@"error:%@", error);
     }];
}

#pragma mark - Properties

//-(void)setCurrentLocationString:(NSString *)currentLocationString
//{
//    _currentLocationString = currentLocationString;
//    self.myLocationField.text = currentLocationString;
//    [self startBeginningSearch];
//}


@end
