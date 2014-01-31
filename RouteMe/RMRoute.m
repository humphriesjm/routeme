//
//  RMRoute.m
//  RouteMe
//
//  Created by Jason Humphries on 1/31/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import "RMRoute.h"

@implementation RMRoute

-(GooglePlace *)startingLocation
{
    if (!_startingLocation) {
        _startingLocation = [[GooglePlace alloc] init];
    }
    return _startingLocation;
}

-(GooglePlace *)endingLocation
{
    if (!_endingLocation) {
        _endingLocation = [[GooglePlace alloc] init];
    }
    return _endingLocation;
}

@end
