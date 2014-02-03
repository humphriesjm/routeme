//
//  PlaceDetailViewController.h
//  RouteMe
//
//  Created by Jason Humphries on 2/2/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GooglePlace;

@interface PlaceDetailViewController : UIViewController

@property (strong, nonatomic) GooglePlace *thisPlace;

@end
