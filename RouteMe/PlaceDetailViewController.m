//
//  PlaceDetailViewController.m
//  RouteMe
//
//  Created by Jason Humphries on 2/2/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import "PlaceDetailViewController.h"
#import "GooglePlace.h"

@interface PlaceDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;

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
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
