//
//  PlaceDetailViewController.m
//  RouteMe
//
//  Created by Jason Humphries on 2/2/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import "PlaceDetailViewController.h"
#import "GooglePlace.h"
#import "AppDelegate.h"

@interface PlaceDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceDeltaLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDeltaLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainRouteDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainRouteTimeLabel;

@end

@implementation PlaceDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.placeNameLabel.text = self.thisPlace.placeTitle;
    
    self.mainRouteDistanceLabel.text = [NSString stringWithFormat:@"%f meters", MY_APP_DELEGATE.totalDistanceForMainRoute];
    self.mainRouteTimeLabel.text = [NSString stringWithFormat:@"%f seconds", MY_APP_DELEGATE.totalTimeForMainRoute];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
