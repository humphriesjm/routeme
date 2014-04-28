//
//  MapViewController.m
//  JHGoogleMaps
//
//  Created by Jason Humphries on 1/17/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import "MapViewController.h"
#import "MDDirectionService.h"
#import "AppDelegate.h"
#import "GooglePlacesSearcher.h"
#import "GooglePlace.h"
#import "PlaceDetailViewController.h"

@interface MapViewController () <GMSMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *waypoints;
@property (strong, nonatomic) NSMutableArray *waypointStrings;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftBBI;
@property (strong, nonatomic) GMSPath *mainPath;
@property (strong, nonatomic) GMSPath *staticPath;
@end

@implementation MapViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.placesArray = [NSMutableArray array];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.waypoints = [NSMutableArray array];
    self.waypointStrings = [NSMutableArray array];
    
    // Create a GMSCameraPosition that tells the map to display the coordinate at zoom level 6
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:MY_APP_DELEGATE.currentLocation.coordinate.latitude
                                                            longitude:MY_APP_DELEGATE.currentLocation.coordinate.longitude
                                                                 zoom:10];
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
                                     camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.mapType = kGMSTypeNormal;
//    self.mapView.mapType = kGMSTypeHybrid;
//    self.mapView.mapType = kGMSTypeSatellite;
//    self.mapView.mapType = kGMSTypeTerrain;
//    self.mapView.mapType = kGMSTypeNone;
    self.mapView.indoorEnabled = YES;
    self.mapView.accessibilityElementsHidden = NO;
    self.mapView.settings.scrollGestures = YES;
    self.mapView.settings.zoomGestures = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;
    self.mapView.hidden = NO;
    [self.view addSubview:self.mapView];
    
//    [self placePopupMarker];
    [self placeWaypoints];
    [self plotDirectionsForStaticRoute];
    
    // table
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
}

-(void)placeWaypoints
{
    float startLat = MY_APP_DELEGATE.startingLocation.coordinate.latitude;
    float startLng = MY_APP_DELEGATE.startingLocation.coordinate.longitude;
    float endLat = MY_APP_DELEGATE.destinationLocation.coordinate.latitude;
    float endLng = MY_APP_DELEGATE.destinationLocation.coordinate.longitude;
    CLLocationCoordinate2D startPosition = CLLocationCoordinate2DMake(startLat, startLng);
    CLLocationCoordinate2D endPosition = CLLocationCoordinate2DMake(endLat, endLng);
    
    GMSMarker *startMarker = [GMSMarker markerWithPosition:startPosition];
    GMSMarker *endMarker = [GMSMarker markerWithPosition:endPosition];
    startMarker.map = self.mapView;
    endMarker.map = self.mapView;
    [self.waypoints addObject:startMarker];
    [self.waypoints addObject:endMarker];
    
    NSString *startPositionString = [NSString stringWithFormat:@"%f,%f", startLat, startLng];
    NSString *endPositionString = [NSString stringWithFormat:@"%f,%f", endLat, endLng];
    [self.waypointStrings addObject:startPositionString];
    [self.waypointStrings addObject:endPositionString];
    
    if (self.waypoints.count > 1) {
        NSDictionary *query = @{ @"sensor" : @"false",
                                 @"waypoints" : self.waypointStrings };
        MDDirectionService *mds = [[MDDirectionService alloc] init];
        SEL selector = @selector(addDirections:);
        [mds setDirectionsQuery:query
                   withSelector:selector
                   withDelegate:self];
    }
}

-(void)placePopupMarker
{
    // Creates a marker in the center of the map
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(35.995602, -78.902153);
    marker.title = @"PopUp HQ";
    marker.snippet = @"Durham, NC";
    marker.icon = [GMSMarker markerImageWithColor:[UIColor grayColor]];
//    marker.icon = [UIImage imageNamed:@"someicon.png"];
    marker.opacity = 0.9;
//    marker.flat = YES;
    marker.map = self.mapView;
}

- (IBAction)listBBIAction:(id)sender
{
    self.mapView.hidden = !self.mapView.hidden;
    self.tableView.hidden = !self.tableView.hidden;
}

#pragma mark - GMSMapViewDelegate

-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"you tapped at %f, %f", coordinate.longitude, coordinate.latitude);

//    CLLocationCoordinate2D tapPosition = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
//    GMSMarker *tapMarker = [GMSMarker markerWithPosition:tapPosition];
}

-(void)plotDirectionsForStaticRoute
{
    float startLat = [START_LAT floatValue];
    float startLng = [START_LNG floatValue];
    float endLat = [END_LAT floatValue];
    float endLng = [END_LNG floatValue];
    CLLocationCoordinate2D startPosition = CLLocationCoordinate2DMake(startLat, startLng);
    CLLocationCoordinate2D endPosition = CLLocationCoordinate2DMake(endLat, endLng);
    
    GMSMarker *startMarker = [GMSMarker markerWithPosition:startPosition];
    GMSMarker *endMarker = [GMSMarker markerWithPosition:endPosition];
    startMarker.map = self.mapView;
    endMarker.map = self.mapView;
    [self.waypoints addObject:startMarker];
    [self.waypoints addObject:endMarker];
    
    NSString *startPositionString = [NSString stringWithFormat:@"%f,%f", startLat, startLng];
    NSString *endPositionString = [NSString stringWithFormat:@"%f,%f", endLat, endLng];
    [self.waypointStrings addObject:startPositionString];
    [self.waypointStrings addObject:endPositionString];
    NSDictionary *query = @{ @"sensor" : @"false",
                             @"waypoints" : self.waypointStrings };
    MDDirectionService *mds = [[MDDirectionService alloc] init];
    SEL selector = @selector(addStaticRouteDirections:);
    [mds setDirectionsQuery:query
               withSelector:selector
               withDelegate:self];
}

#define NUMBER_OF_SEARCHES_DIVISOR 10.0

-(void)addDirections:(NSDictionary *)json
{
    if ([json[@"routes"] count] > 0) {
        [MY_APP_DELEGATE.mainPlacesArray removeAllObjects];
        NSDictionary *firstRoute = json[@"routes"][0];
        NSArray *firstRouteLegs = firstRoute[@"legs"];
        // distance on path in meters
        float totalDistanceValue = [firstRouteLegs[0][@"distance"][@"value"] floatValue];
        float totalTimeValue = [firstRouteLegs[0][@"duration"][@"value"] floatValue];
        NSDictionary *routeOverviewPolyline = firstRoute[@"overview_polyline"];
        NSString *overview_route = routeOverviewPolyline[@"points"];
        self.mainPath = [GMSPath pathFromEncodedPath:overview_route];
        // total number of points along path = self.mainPath.count
        int numberOfPoints = self.mainPath.count;
        // number of searhes to perform along the path
        int numberOfSearches = (int)floor((numberOfPoints/NUMBER_OF_SEARCHES_DIVISOR));
        NSLog(@"totalDistance: %f meters", totalDistanceValue);
        NSLog(@"totalTimeValue: %f seconds", totalTimeValue);
        MY_APP_DELEGATE.totalDistanceForMainRoute = totalDistanceValue;
        MY_APP_DELEGATE.totalTimeForMainRoute = totalTimeValue;
        NSLog(@"numberOfPoints: %d", numberOfPoints);
        NSLog(@"numberOfSearches: %d", numberOfSearches);
        for (int j=0; j < numberOfSearches; j++) {
            CLLocationCoordinate2D currentCoord = [self.mainPath coordinateAtIndex:(j*numberOfSearches)];
            CLLocation *currentLoc = [[CLLocation alloc] initWithLatitude:currentCoord.latitude longitude:currentCoord.longitude];
            CLLocationCoordinate2D lastCoord;
            CLLocation *lastLoc;
            CGFloat distanceFromLastLocation = 0;
            if (j != 0) {
                lastCoord = [self.mainPath coordinateAtIndex:((j-1)*numberOfSearches)];
                lastLoc = [[CLLocation alloc] initWithLatitude:lastCoord.latitude longitude:lastCoord.longitude];
                // linear distance from last location
                distanceFromLastLocation = [lastLoc distanceFromLocation:currentLoc];
                NSLog(@"distanceFromLastLocation: %f", distanceFromLastLocation);
            }
            NSString *searchTerm = MY_APP_DELEGATE.keywordSearchString.length > 0 ? MY_APP_DELEGATE.keywordSearchString : @"coffee";
            NSLog(@"%f,%f", currentCoord.latitude, currentCoord.longitude);
            [GooglePlacesSearcher searchKeyword:searchTerm
                                          atLat:currentCoord.latitude
                                            lng:currentCoord.longitude
                                        success:
             ^(NSArray *results) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self reloadPlacesArrayLocations:results];
                 });
             } failure:^(NSError *error) {
                 NSLog(@"error0: %@", error.localizedDescription);
             }];
        }
        
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:self.mainPath];
        polyline.strokeWidth = 8.f;
        polyline.strokeColor = [UIColor blueColor];
        polyline.map = self.mapView;
    }
}

-(void)addStaticRouteDirections:(NSDictionary *)json
{
    if ([json[@"routes"] count] > 0) {
        NSDictionary *firstRoute = json[@"routes"][0];
        NSArray *firstRouteLegs = firstRoute[@"legs"];
        
        // distance on path in meters
        float totalDistanceValue = [firstRouteLegs[0][@"distance"][@"value"] floatValue];
        // distance on path in miles
        NSString *totalDistanceMiles = firstRouteLegs[0][@"distance"][@"text"];
        // time on path in seconds
        float totalTimeValue = [firstRouteLegs[0][@"duration"][@"value"] floatValue];
        // time on path in string format
        NSString *totalTimeMinutes = firstRouteLegs[0][@"duration"][@"text"];
        
        NSDictionary *routeOverviewPolyline = firstRoute[@"overview_polyline"];
        NSString *overview_route = routeOverviewPolyline[@"points"];
        self.staticPath = [GMSPath pathFromEncodedPath:overview_route];
        NSLog(@"totalDistance in meters(STATIC): %f", totalDistanceValue);
        NSLog(@"totalDistance in string(STATIC): %@", totalDistanceMiles);
        NSLog(@"totalTime in seconds(STATIC): %f", totalTimeValue);
        NSLog(@"totalTime in string(STATIC): %@", totalTimeMinutes);
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:self.staticPath];
        polyline.strokeWidth = 8.f;
        polyline.strokeColor = [UIColor redColor];
        polyline.map = self.mapView;
    }
}

-(void)reloadPlacesArrayLocations:(NSArray*)places
{
    NSLog(@"adding %d places", places.count);
    NSArray *newPlacesArrayCopy = [places copy];
    NSLog(@"placesArray count: (%d)", MY_APP_DELEGATE.mainPlacesArray.count);
    // add new place pins to map
    for (NSDictionary *place in newPlacesArrayCopy) {
        if ([MY_APP_DELEGATE mainPlacesContainsPlaceWithID:place[@"id"]]) {
            NSLog(@"don't add %@", place[@"name"]);
        } else {
            NSLog(@"do add %@", place[@"name"]);
            
            // map pin
            GMSMarker *marker = [[GMSMarker alloc] init];
            float markerLat = [place[@"geometry"][@"location"][@"lat"] floatValue];
            float markerLng = [place[@"geometry"][@"location"][@"lng"] floatValue];
            marker.position = CLLocationCoordinate2DMake(markerLat, markerLng);
            marker.title = place[@"name"];
            marker.snippet = place[@"vicinity"];
            marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
            marker.opacity = 0.9;
            
            // google place
            GooglePlace *gPlace = [[GooglePlace alloc] init];
            gPlace.placeMarker = marker;
            gPlace.placeLat = markerLat;
            gPlace.placeLng = markerLng;
            gPlace.rating = place[@"rating"];
            gPlace.types = place[@"types"];
            gPlace.iconURL = place[@"icon"];
            gPlace.placeID = place[@"id"];
            gPlace.placeOpacity = marker.opacity;
            gPlace.placeTitle = marker.title;
            gPlace.placeSubtitle = marker.snippet;
            gPlace.placeMarker.map = self.mapView;
            [self.googlePlacesArray addObject:gPlace];
            
            [MY_APP_DELEGATE.mainPlacesArray addObject:gPlace];
            //[MY_APP_DELEGATE.mainPlacesArray addObjectsFromArray:places];
        }
    }
    
    [self.tableView reloadData];
}


-(void)mapView:(GMSMapView *)mapView
      willMove:(BOOL)gesture
{
//    [mapView clear];
}

-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    NSLog(@"map became idle");
//    [self placePopupMarker];
}

#pragma mark <UITableViewDataSource>

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"MY_APP_DELEGATE.mainPlacesArray.count:(%d)", MY_APP_DELEGATE.mainPlacesArray.count);
    return MY_APP_DELEGATE.mainPlacesArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"placeCell"];
    }
    GooglePlace *gPlace = MY_APP_DELEGATE.mainPlacesArray[indexPath.row];
    cell.textLabel.text = gPlace.placeTitle;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id item = MY_APP_DELEGATE.mainPlacesArray[indexPath.row];
    if ([item isKindOfClass:[GooglePlace class]]) {
        GooglePlace *place = (GooglePlace*)item;
        [self performSegueWithIdentifier:@"placeDetailSegue" sender:place];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"placeDetailSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[PlaceDetailViewController class]]) {
            PlaceDetailViewController *pvc = (PlaceDetailViewController*)segue.destinationViewController;
            if ([sender isKindOfClass:[GooglePlace class]]) {
                pvc.thisPlace = (GooglePlace*)sender;
            }
        }
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
