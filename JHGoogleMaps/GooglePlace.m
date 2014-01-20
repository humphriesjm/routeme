//
//  GooglePlace.m
//  JHGoogleMaps
//
//  Created by Jason Humphries on 1/19/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import "GooglePlace.h"

@implementation GooglePlace

-(CLLocation *)location
{
    return [[CLLocation alloc] initWithLatitude:self.placeLat longitude:self.placeLng];
}

@end
