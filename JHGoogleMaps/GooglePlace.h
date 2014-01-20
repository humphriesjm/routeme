//
//  GooglePlace.h
//  JHGoogleMaps
//
//  Created by Jason Humphries on 1/19/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GooglePlace : NSObject
@property (assign, nonatomic) float placeLat;
@property (assign, nonatomic) float placeLng;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *rating;
@property (strong, nonatomic) NSArray *types;
@property (strong, nonatomic) NSString *iconURL;
@property (strong, nonatomic) NSString *placeID;
@property (strong, nonatomic) NSString *placeTitle;
@property (strong, nonatomic) NSString *placeSubtitle;
@property (assign, nonatomic) float placeOpacity;
@end
