//
//  AppDelegate.m
//  JHGoogleMaps
//
//  Created by Jason Humphries on 1/17/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

-(CLLocation *)currentLocation
{
    return [[CLLocation alloc] initWithLatitude:self.lat longitude:self.lng];
}

-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations
{
    NSLog(@"location update");
    self.numberOfLocationUpdates += 1;
    self.lastLocationUpdate = [NSDate date];
    CLLocation *lastLocation = [locations firstObject];
    NSDate *now = [NSDate date];
    float timeDiff = [now timeIntervalSinceDate:self.lastLocationUpdate];
    NSLog(@"time diff:%f", timeDiff*60.f);
//    if ([self.lastLocationUpdate timeIntervalSinceNow])
    self.lat = lastLocation.coordinate.latitude;
    self.lng = lastLocation.coordinate.longitude;
    if (self.numberOfLocationUpdates >= 5) {
        [self.locationManager stopUpdatingLocation];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.mainPlacesArray = [NSMutableArray array];
    self.numberOfLocationUpdates = 0;
    
    self.lat = [START_LAT floatValue];
    self.lng = [START_LNG floatValue];
    
    [GMSServices provideAPIKey:GOOGLE_MAPS_API_KEY];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    return YES;
}

-(BOOL)mainPlacesContainsPlaceWithID:(NSString*)placeID
{
    NSArray *mainPlacesArrayCopy = [self.mainPlacesArray copy];
    for (NSDictionary *currentPlaceDict in mainPlacesArrayCopy) {
        if ([currentPlaceDict[@"id"] isEqualToString:placeID]) {
            return YES;
        }
    }
    return NO;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
