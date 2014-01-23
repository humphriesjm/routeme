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

@interface HomeViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *driveWalkSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextField *myLocationField;
@property (strong, nonatomic) IBOutlet UITextField *myDestinationField;
@property (strong, nonatomic) IBOutlet UITextField *keywordField;
@property (strong, nonatomic) IBOutlet UIButton *goButton;
@property (strong, nonatomic) NSString *currentLocationString;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *locationAI;
@property (assign, nonatomic) BOOL isInDrivingMode;
@end

@implementation HomeViewController

-(void)awakeFromNib
{
    self.isInDrivingMode = YES;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.locationAI startAnimating];
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
             [[[UIAlertView alloc] initWithTitle:@"Destination Set" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
             [[[UIAlertView alloc] initWithTitle:@"Starting Location Set" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
         } else {
             [[[UIAlertView alloc] initWithTitle:@"Address not found" message:@"Sorry, I couldn't find that starting address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
         }
     }];
}

#pragma mark - CLGeocoder - reverseGeocodeLocation

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
                [self.locationAI stopAnimating];
            }
        }];
    }
}

#pragma mark - Properties

-(void)setCurrentLocationString:(NSString *)currentLocationString
{
    _currentLocationString = currentLocationString;
    self.myLocationField.text = currentLocationString;
    [self startBeginningSearch];
}


@end
