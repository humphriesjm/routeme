//
//  GooglePlacesAutocompletor.m
//  RouteMe
//
//  Created by Jason Humphries on 1/31/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import "GooglePlacesAutocompletor.h"
#import "AFNetworking.h"
#import "GooglePlace.h"

@implementation GooglePlacesAutocompletor

+(void)searchTerm:(NSString *)term
            atLat:(float)lat
              lng:(float)lng
          success:(void (^)(NSArray *))success
          failure:(void (^)(NSError *))failure
{
    float radius = 2000.f;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *locationString = [NSString stringWithFormat:@"%f,%f", lat, lng];
    NSString *paramsString = [NSString stringWithFormat:@"%@?location=%@&radius=%f&input=%@&sensor=false&key=%@", GOOGLE_PLACES_AUTOCOMPLETE_API_BASE_URL, locationString, radius, term, GOOGLE_PLACES_API_KEY];
    NSString *encodedParamsString = [paramsString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"-=-=GOOGLE PLACES AUTOCOMPLETE API SEARCH TICK=-=-");
    [manager GET:encodedParamsString
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"AC success:%@", responseObject[@"predictions"]);
             NSDictionary *acResultsDict = (NSDictionary*)responseObject;
             NSString *status = acResultsDict[@"status"];
             if ([status isEqualToString:@"ZERO_RESULTS"]) {
                 NSLog(@"ZERO RESULTS");
                 if (success) success(nil);
             } else if ([acResultsDict[@"predictions"] count] > 0) {
                 NSLog(@"%d RESULTS", [acResultsDict[@"predictions"] count]);
                 if (success) success(acResultsDict[@"predictions"]);
             } else {
                 NSLog(@"no ac results");
                 if (success) success(nil);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"error:%@", error);
             if (failure) failure(error);
         }];
}

@end
