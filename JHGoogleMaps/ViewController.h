//
//  ViewController.h
//  JHGoogleMaps
//
//  Created by Jason Humphries on 1/17/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *googlePlacesArray;
//@property (strong, nonatomic) NSMutableArray *placesArray;

@end
