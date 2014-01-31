//
//  GooglePlacesAutocompletor.h
//  RouteMe
//
//  Created by Jason Humphries on 1/31/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
@import CoreLocation;

@interface GooglePlacesAutocompletor : NSObject

+(void)searchTerm:(NSString*)term
            atLat:(float)lat
              lng:(float)lng
          success:(void(^)(NSArray *))success
          failure:(void(^)(NSError *))failure;

@end
