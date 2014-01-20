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

#define GOOGLE_MAPS_API_KEY @"AIzaSyBhF3Wx4zluGHMjNfcNHZKWZ6_QKP2OKwg"
#define GOOGLE_PLACES_API_KEY @"AIzaSyAo0uvnBOcWnCUWzwLYjz-U9wNTpstAXBg"

#define START_LAT @(35.9409076)
#define START_LNG @(-78.863088)
//#define END_LAT @(36.002767) // Popup HQ
//#define END_LNG @(-78.904096)
#define END_LAT @(35.816264) // Manor Six Forks
#define END_LNG @(-78.614673)

#define GOOGLE_PLACES_API_BASE_URL @"https://maps.googleapis.com/maps/api/place/nearbysearch/json"
#define GOOGLE_DIRECTIONS_API_BASE_URL @"http://maps.googleapis.com/maps/api/directions/json?"

#define MY_APP_DELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CLLocation *currentLocation;
@property (assign, nonatomic) float lat;
@property (assign, nonatomic) float lng;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDate *lastLocationUpdate;
@property (strong, nonatomic) NSMutableArray *mainPlacesArray;

@property (assign, nonatomic) int numberOfLocationUpdates;

-(BOOL)mainPlacesContainsPlaceWithID:(NSString*)placeID;

@end
