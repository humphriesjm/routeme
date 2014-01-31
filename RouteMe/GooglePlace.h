//
//  GooglePlace.h
//  JHGoogleMaps
//
//  Created by Jason Humphries on 1/19/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface GooglePlace : NSObject
@property (assign, nonatomic) float placeLat;
@property (assign, nonatomic) float placeLng;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *rating;
@property (strong, nonatomic) NSArray *types;
@property (strong, nonatomic) NSString *iconURL;
@property (strong, nonatomic) NSString *placeID;
@property (strong, nonatomic) NSString *placeReference;
@property (strong, nonatomic) NSString *placeTitle;
@property (strong, nonatomic) NSString *placeSubtitle;
@property (strong, nonatomic) NSString *placeAddress;
@property (strong, nonatomic) NSString *placePhoneNumber;
@property (strong, nonatomic) NSString *placeURL;
@property (strong, nonatomic) NSString *placeWebsite;
@property (assign, nonatomic) float placeOpacity;
@property (strong, nonatomic) GMSMarker *placeMarker;

+(GooglePlace*)buildPlaceWithPlaceDetailResult:(NSDictionary*)placeDict;

@end
