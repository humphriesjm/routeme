//
//  ViewController.m
//  JHGoogleMaps
//
//  Created by Jason Humphries on 1/17/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import "ViewController.h"
#import "MDDirectionService.h"
#import "AppDelegate.h"
#import "GooglePlacesSearcher.h"
#import "GooglePlace.h"

@interface ViewController () <GMSMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *waypoints;
@property (strong, nonatomic) NSMutableArray *waypointStrings;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftBBI;
@end

@implementation ViewController

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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:MY_APP_DELEGATE.lat
                                                            longitude:MY_APP_DELEGATE.lng
                                                                 zoom:13];
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
//    self.view = self.mapView;
    self.mapView.hidden = NO;
    [self.view addSubview:self.mapView];
    
    [self placePopupMarker];
    [self placeWaypoints];
    
    // table
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.f, self.view.bounds.size.width, self.view.bounds.size.height - 64.f) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    
    // padding
    // Insets are specified in this order: top, left, bottom, right
//    UIEdgeInsets mapInsets = UIEdgeInsetsMake(100.0, 0.0, 0.0, 300.0);
//    self.mapView.padding = mapInsets;
}

-(void)placeWaypoints
{
    CLLocationCoordinate2D startPosition = CLLocationCoordinate2DMake([START_LAT floatValue], [START_LNG floatValue]);
    CLLocationCoordinate2D endPosition = CLLocationCoordinate2DMake([END_LAT floatValue], [END_LNG floatValue]);
    
    GMSMarker *startMarker = [GMSMarker markerWithPosition:startPosition];
    GMSMarker *endMarker = [GMSMarker markerWithPosition:endPosition];
    startMarker.map = self.mapView;
    endMarker.map = self.mapView;
    [self.waypoints addObject:startMarker];
    [self.waypoints addObject:endMarker];
    
    NSString *startPositionString = [NSString stringWithFormat:@"%f,%f", [START_LAT floatValue], [START_LNG floatValue]];
    NSString *endPositionString = [NSString stringWithFormat:@"%f,%f", [END_LAT floatValue], [END_LNG floatValue]];
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
    marker.icon = [GMSMarker markerImageWithColor:[UIColor yellowColor]];
//    marker.icon = [UIImage imageNamed:@"someicon.png"];
    marker.opacity = 0.9;
//    marker.flat = YES;
    marker.map = self.mapView;
}

- (IBAction)leftBBIAction:(id)sender
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

-(void)addDirections:(NSDictionary *)json
{
    NSDictionary *firstRoute = json[@"routes"][0];
    NSArray *firstRouteLegs = firstRoute[@"legs"];
//    NSLog(@"firstRouteLegs(%d): %@", firstRouteLegs.count, firstRouteLegs);
    float routeStartLat = [firstRoute[@"legs"][0][@"start_location"][@"lat"] floatValue];
    float routeStartLng = [firstRoute[@"legs"][0][@"start_location"][@"lng"] floatValue];
    float routeEndLat = [firstRoute[@"legs"][0][@"end_location"][@"lat"] floatValue];
    float routeEndLng = [firstRoute[@"legs"][0][@"end_location"][@"lng"] floatValue];
    
    float x1 = routeStartLat;
    float y1 = routeStartLng;
    float x2 = routeEndLat;
    float y2 = routeEndLng;
    
    NSArray *steps = firstRouteLegs[0][@"steps"];
    float totalDistanceValue = [firstRouteLegs[0][@"distance"][@"value"] floatValue]; // meters
//    float totalDistanceTime = [firstRouteLegs[0][@"duration"][@"value"] floatValue]; // seconds
    
    float searchRadius = 2000.f;
    float searchCircleNumber = ceilf(totalDistanceValue/(2.0*searchRadius));
    for (float j=0; j<searchCircleNumber; j++) {
//        GooglePlace *place = [[GooglePlace alloc] init];
        float currentLaty = x1 + ((x2 - x1)/(j+1))*j;
        float currentLngy = y1 + ((y2 - y1)/(j+1))*j;
//        place.placeLat = currentLaty;
//        place.placeLng = currentLngy;
//        [self.googlePlacesArray addObject:place];
        CLLocationCoordinate2D currentCoord = CLLocationCoordinate2DMake(currentLaty, currentLngy);
        NSString *searchTerm = @"coffee";
        NSLog(@"about to search (%@) lat(%f) lng(%f)", searchTerm, currentCoord.latitude, currentCoord.longitude);
        [GooglePlacesSearcher searchKeyword:searchTerm
                                      atLat:currentCoord.latitude
                                        lng:currentCoord.longitude
                                    success:^(NSArray *results) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self reloadPlacesArrayLocations:results];
                                        });
                                    } failure:^(NSError *error) {
                                        NSLog(@"error0: %@", error.localizedDescription);
                                    }];

    }
    
    float totalDistance = 0.f;
    float totalTime = 0.f;
    int i = 0;
    for (NSDictionary *leg in steps) {
        NSLog(@"distance:%@", leg[@"distance"][@"text"]);
        float distanceValue = [leg[@"distance"][@"value"] floatValue]; // meters
        float distanceTime = [leg[@"duration"][@"value"] floatValue]; // seconds
        totalDistance += distanceValue;
        totalTime += distanceTime;
        NSLog(@"time:%@", leg[@"duration"][@"text"]);
        NSLog(@"instructions:%@", leg[@"html_instructions"]);
        NSLog(@"-------step %d--------", i+1);
    }
    
    NSLog(@"firstRoute Leg Steps(%d)", steps.count);
    NSLog(@"totalDistance: %f", totalDistance);
    NSLog(@"easy total distance: %@", firstRouteLegs[0][@"distance"][@"value"]);
    NSLog(@"totalTime: %f", totalTime);
    NSLog(@"easy total time: %@", firstRouteLegs[0][@"duration"][@"value"]);

    // req
    NSDictionary *routeOverviewPolyline = firstRoute[@"overview_polyline"];
    NSString *overview_route = routeOverviewPolyline[@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = self.mapView;
}

-(void)reloadPlacesArrayLocations:(NSArray*)places
{
    NSLog(@"adding %d places", places.count);
    NSArray *newPlacesArrayCopy = [places copy];
    NSLog(@"placesArray count: (%d)", MY_APP_DELEGATE.mainPlacesArray.count);
    // add new place pins to map
    for (NSDictionary *place in newPlacesArrayCopy) {
//        NSLog(@"place:%@", place);
        if ([MY_APP_DELEGATE mainPlacesContainsPlaceWithID:place[@"id"]]) {
            // don't add
            NSLog(@"don't add %@", place[@"name"]);
        } else {
            NSLog(@"do add %@", place[@"name"]);
            [MY_APP_DELEGATE.mainPlacesArray addObjectsFromArray:places];
        }
        GMSMarker *marker = [[GMSMarker alloc] init];
        float markerLat = [place[@"geometry"][@"location"][@"lat"] floatValue];
        float markerLng = [place[@"geometry"][@"location"][@"lng"] floatValue];
        marker.position = CLLocationCoordinate2DMake(markerLat, markerLng);
        marker.title = place[@"name"];
        marker.snippet = place[@"vicinity"];
        marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
        marker.opacity = 0.9;
        NSString *rating = place[@"rating"];
        NSArray *types = place[@"types"];
        NSString *iconURL = place[@"icon"];
        NSString *placeID = place[@"id"];
        
        GooglePlace *gPlace = [[GooglePlace alloc] init];
        gPlace.placeLat = markerLat;
        gPlace.placeLng = markerLng;
        gPlace.rating = rating;
        gPlace.types = types;
        gPlace.iconURL = iconURL;
        gPlace.placeID = placeID;
        gPlace.placeOpacity = marker.opacity;
        gPlace.placeTitle = marker.title;
        gPlace.placeSubtitle = marker.snippet;
        [self.googlePlacesArray addObject:gPlace];
        
        marker.map = self.mapView;
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
    id item = MY_APP_DELEGATE.mainPlacesArray[indexPath.row];
    cell.textLabel.text = item[@"name"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
