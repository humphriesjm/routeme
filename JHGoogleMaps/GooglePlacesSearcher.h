//
//  GooglePlacesSearcher.h
//  JHGoogleMaps
//
//  Created by Jason Humphries on 1/19/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "AFNetworking.h"
#import "AppDelegate.h"

@interface GooglePlacesSearcher : NSObject

@property (strong, nonatomic) NSArray *placesArray;

+(void)searchKeyword:(NSString*)term
               atLat:(float)lat
                 lng:(float)lng
             success:(void(^)(NSArray *))success
             failure:(void(^)(NSError *))failure;

@end
