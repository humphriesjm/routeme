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

+(GooglePlace *)buildPlaceWithPlaceDetailResult:(NSDictionary *)placeDict
{
    GooglePlace *newPlace = [[GooglePlace alloc] init];
    newPlace.placeLat = [placeDict[@"geometry"][@"location"][@"lat"] floatValue];
    newPlace.placeLng = [placeDict[@"geometry"][@"location"][@"lng"] floatValue];
    newPlace.placeAddress = placeDict[@"formatted_address"];
    newPlace.placePhoneNumber = placeDict[@"formatted_phone_number"];
    newPlace.placeID = placeDict[@"id"];
    newPlace.placeTitle = placeDict[@"name"];
    newPlace.rating = placeDict[@"rating"];
    newPlace.placeReference = placeDict[@"reference"];
    newPlace.iconURL = placeDict[@"icon"];
    newPlace.placeURL = placeDict[@"url"];
    newPlace.placeWebsite = placeDict[@"website"];
    
    return newPlace;
}

@end
