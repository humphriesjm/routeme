//
//  RMRoute.h
//  RouteMe
//
//  Created by Jason Humphries on 1/31/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "GooglePlace.h"

@interface RMRoute : NSObject

@property (strong, nonatomic) GooglePlace *startingLocation;
@property (strong, nonatomic) GooglePlace *endingLocation;
@property (strong, nonatomic) NSArray *waypoints;

@property (strong, nonatomic) NSMutableArray *routePlacesArray;
@property (assign, nonatomic) float routeTotalDistance;
@property (assign, nonatomic) float routeTotalTime;

@end
