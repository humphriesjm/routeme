//
//  SearchPlacesViewController.m
//  JHGoogleMaps
//
//  Created by Jason Humphries on 1/17/14.
//  Copyright (c) 2014 Humphries Data Design. All rights reserved.
//

#import "SearchPlacesViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

@interface SearchPlacesViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) IBOutlet UITableView *placesTable;
@property (strong, nonatomic) NSArray *placesArray;
@end

@implementation SearchPlacesViewController

-(void)awakeFromNib
{
    //
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backAction)];
//    [imgButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = b;
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)startSearch:(NSString*)term
{
    // popup hq
//    float lat = 35.995602;
//    float lng = -78.902153;
    // colonial rtp apts
    float lat = MY_APP_DELEGATE.lat;
    float lng = MY_APP_DELEGATE.lng;
    float radius = 2000.f;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    NSString *locationString = [NSString stringWithFormat:@"%f,%f", lat, lng];
    NSString *paramsString = [NSString stringWithFormat:@"%@?location=%@&radius=%f&keyword=%@&sensor=false&key=%@", GOOGLE_PLACES_API_BASE_URL, locationString, radius, term, GOOGLE_PLACES_API_KEY];
    [manager GET:paramsString
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             NSLog(@"success:%@", responseObject);
             NSDictionary *placesResultsDict = (NSDictionary*)responseObject;
             NSString *status = placesResultsDict[@"status"];
             if ([status isEqualToString:@"ZERO_RESULTS"]) {
                 [[[UIAlertView alloc] initWithTitle:@"Google Places Search"
                                             message:@"No results..." delegate:nil cancelButtonTitle:@"Try again"
                                   otherButtonTitles:nil, nil] show];
             } else if ([placesResultsDict[@"results"] count] > 0) {
                 self.placesArray = placesResultsDict[@"results"];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.placesTable reloadData];
                 });
             } else {
                 NSLog(@"no results");
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"error:%@", error);
         }];
}

-(void)processGooglePlacesResults:(NSDictionary*)dict
{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0) {
        [self startSearch:textField.text];
    }
    [textField resignFirstResponder];
    return YES;
}

#pragma mark <UITableViewDataSource>

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.placesArray.count;
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
    cell.textLabel.text = self.placesArray[indexPath.row][@"name"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"you selected %@", self.placesArray[indexPath.row]);
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
