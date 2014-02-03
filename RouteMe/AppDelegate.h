//
//  AppDelegate.h
//  JHGoogleMaps
//
//  Created by Jason Humphries on 1/17/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>

#define GOOGLE_MAPS_API_KEY @"AIzaSyCPz4xDP5opkeCiEm7qpiqdtLOXCanlyEU"
#define GOOGLE_PLACES_API_KEY @"AIzaSyAo0uvnBOcWnCUWzwLYjz-U9wNTpstAXBg"

#define START_LAT @(35.9409076) // Colonial Grand
#define START_LNG @(-78.863088)
//#define END_LAT @(36.002767) // Popup HQ
//#define END_LNG @(-78.904096)
#define END_LAT @(35.816264) // Manor Six Forks
#define END_LNG @(-78.614673)

#define GOOGLE_PLACES_API_BASE_URL @"https://maps.googleapis.com/maps/api/place/nearbysearch/json"
#define GOOGLE_PLACES_DETAILS_BASE_URL @"https://maps.googleapis.com/maps/api/place/details/json"
#define GOOGLE_DIRECTIONS_API_BASE_URL @"http://maps.googleapis.com/maps/api/directions/json?"
#define GOOGLE_PLACES_AUTOCOMPLETE_API_BASE_URL @"https://maps.googleapis.com/maps/api/place/autocomplete/json"

#define FLURRY_DEV_TOKEN @"WVM5S4ZTV3T8TVVTKPSF"

#define TEST_FLIGHT_TOKEN @"3db8aa69-86de-4235-b733-8926fd93ed33"

#define MY_APP_DELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define LOCATION_UPDATE_NOTIFICATION @"LocationUpdateNotification"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocation *startingLocation;
@property (strong, nonatomic) CLLocation *destinationLocation;
@property (strong, nonatomic) NSString *keywordSearchString;
@property (assign, nonatomic) float lat;
@property (assign, nonatomic) float lng;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDate *lastLocationUpdate;
@property (strong, nonatomic) NSMutableArray *mainPlacesArray;

@property (assign, nonatomic) int numberOfLocationUpdates;

-(BOOL)mainPlacesContainsPlaceWithID:(NSString*)placeID;

@end
