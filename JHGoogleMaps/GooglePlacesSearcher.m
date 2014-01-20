//
//  GooglePlacesSearcher.m
//  JHGoogleMaps
//
//  Created by Jason Humphries on 1/19/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import "GooglePlacesSearcher.h"

@implementation GooglePlacesSearcher

+(void)searchKeyword:(NSString *)term
               atLat:(float)lat
                 lng:(float)lng
             success:(void (^)(NSArray *))success
             failure:(void (^)(NSError *))failure
{
    float radius = 2000.f;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    NSString *locationString = [NSString stringWithFormat:@"%f,%f", lat, lng];
    NSString *paramsString = [NSString stringWithFormat:@"%@?location=%@&radius=%f&keyword=%@&sensor=false&key=%@", GOOGLE_PLACES_API_BASE_URL, locationString, radius, term, GOOGLE_PLACES_API_KEY];
    NSLog(@"-=-=GOOGLE PLACES API SEARCH TICK=-=-");
    [manager GET:paramsString
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"success:%@", responseObject);
             NSDictionary *placesResultsDict = (NSDictionary*)responseObject;
             NSString *status = placesResultsDict[@"status"];
             if ([status isEqualToString:@"ZERO_RESULTS"]) {
                 NSLog(@"ZERO RESULTS");
                 if (success) success(nil);
             } else if ([placesResultsDict[@"results"] count] > 0) {
//                 self.placesArray = placesResultsDict[@"results"];
                 if (success) success(placesResultsDict[@"results"]);
             } else {
                 NSLog(@"no results");
                 if (success) success(nil);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"error:%@", error);
             if (failure) failure(error);
         }];
}

@end
