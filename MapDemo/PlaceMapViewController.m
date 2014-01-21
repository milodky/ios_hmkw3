//
//  PlaceMapViewController.m
//  MapDemo
//
//  Created by Mason Silber on 2/28/13.
//  Copyright (c) 2013 Mason Silber. All rights reserved.
//

#import "PlaceMapViewController.h"
#import "Place.h"
#import "MapPin.h"
#import <UIKit/UIKit.h>
#import"MyTableViewController.h"


#define startLat @"40.809881"
#define startLong @"-73.959746"

#define token @"913876524-RkVVBckdzrofVe5syvSdFNR9DL6unAHyEW7IM7qZ"
#define secret @"swaSVSSKDUYtcIzYeG1A6ZQjX0wVtNaTRXWbhHiUTk"
@interface PlaceMapViewController ()

@property (nonatomic, strong) MKMapView *map;
@property (nonatomic, strong) NSMutableArray *placeArray;
@property (nonatomic) ACAccountStore *accountStore;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) Place *myplace;


@end

@implementation PlaceMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _placeArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _map = [[MKMapView alloc] initWithFrame:[[self view] frame]];
    [_map setDelegate:self];
    
    CLLocationCoordinate2D startLocation;
    startLocation.latitude = [startLat floatValue];
    startLocation.longitude = [startLong floatValue];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
    MKCoordinateRegion region = MKCoordinateRegionMake(startLocation, span);
    [_map setRegion:region];
    
    [[self view] addSubview:_map];
	// Do any additional setup after loading the view.
}

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}


-(void)getPlacesForLocation//:(CLLocationCoordinate2D)location
{
    NSURL *placesURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1.1/search/tweets.json"]];
    NSString *geocode = @"40.809881,-73.959746,5mi";
   // NSData *placeData;
    ACAccountCredential *credential =
    [[ACAccountCredential alloc] initWithOAuthToken:token tokenSecret:secret];
    
    _accountStore = [[ACAccountStore alloc] init];
    
    
    if ([self userHasAccessToTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType = [self.accountStore
                                             accountTypeWithAccountTypeIdentifier:
                                             ACAccountTypeIdentifierTwitter];
        
        
        ACAccount *newAccount = [[ACAccount alloc] initWithAccountType:twitterAccountType];
        newAccount.credential = credential;

        [_accountStore saveAccount:newAccount withCompletionHandler:^(BOOL success, NSError *error) {
           if (success)
               NSLog(@"success!");
           else {
               if ([[error domain] isEqualToString:ACErrorDomain]) {
                   
                   // The following error codes and descriptions are found in ACError.h
                   switch ([error code]) {
                       case ACErrorAccountMissingRequiredProperty:
                           NSLog(@"Account wasn't saved because "
                                 "it is missing a required property.");
                           break;
                       case ACErrorAccountAuthenticationFailed:
                           NSLog(@"Account wasn't saved because "
                                 "authentication of the supplied "
                                 "credential failed.");
                           break;
                       case ACErrorAccountTypeInvalid:
                           NSLog(@"Account wasn't saved because "
                                 "the account type is invalid.");
                           break;
                       case ACErrorAccountAlreadyExists:
                           NSLog(@"Account wasn't added because "
                                 "it already exists.");
                           break;
                       case ACErrorAccountNotFound:
                           NSLog(@"Account wasn't deleted because"
                                 "it could not be found.");
                           break;
                       case ACErrorPermissionDenied:
                           NSLog(@"Permission Denied");
                           break;
                       case ACErrorUnknown:
                       default: // fall through for any unknown errors...
                           NSLog(@"An unknown error occurred.");
                           break;
                    
                   }
               } else {
                   // handle other error domains and their associated response codes...
                   NSLog(@"%@", [error localizedDescription]);
               }
           }
        }];
        
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 NSArray *twitterAccounts =
                 [self.accountStore accountsWithAccountType:twitterAccountType];
                 
                 
                 NSDictionary *params = @{
                                          @"geocode" : geocode,
                                          @"count" : @"100"
                                          };
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodGET
                                              URL:placesURL
                                       parameters:params];
                 
                 [request setAccount:[twitterAccounts lastObject]];
                 [request performRequestWithHandler:^(NSData *responseData,
                                                      NSHTTPURLResponse *urlResponse,
                                                      NSError *error) {
                     if (responseData) {
                         //NSString *abc = [[NSString alloc] initWithData:responseData   encoding:NSASCIIStringEncoding];
                         
                         //NSLog(@"response data is: %@", abc);
                         
                         NSDictionary *placesDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
                         if(error)
                         {
                             NSLog(@"Error parsing data: %@", [error description]);
                             return;
                         }
                         NSArray *placesArray = [placesDict objectForKey:@"statuses"];
                         int i = 0;

                         
                         for(NSDictionary *placeDict in placesArray)
                         {
                             /*
                              * if the geo equals to null, just skip it.
                              */
                             NSDictionary *geo_info = [placeDict objectForKey:@"geo"];
                             
                             if ((NSNull *)geo_info == [NSNull null])
                                 continue;
                             /*
                              * if the ids of two or more tweets are the same, skip them
                              */
                             for (Place *myplace in _placeArray) {
                                 if ([[myplace tweetid] isEqualToString:[placeDict objectForKey:@"id_str"]])
                                     continue;
                            }
                             
                             i++;
                             Place *newPlace = [[Place alloc] init];
                             
                             
                             
                             
                             [newPlace setTweet:[placeDict objectForKey:@"text"]];
                             
                             [newPlace setUsername:[[placeDict objectForKey:@"user"] objectForKey:@"name"]];
                             
                             [newPlace setTweetid:[placeDict objectForKey:@"id_str"]];
                             
                             [newPlace setImgurl:[[placeDict objectForKey:@"user"] objectForKey:@"profile_image_url"]];
                             [newPlace setCreated:[placeDict objectForKey:@"created_at"]];
                             
                             CLLocationCoordinate2D placeLocation;
                             NSArray *coordinate = [geo_info objectForKey:@"coordinates"];
                             
                             placeLocation.latitude = [coordinate[0] floatValue];
                             placeLocation.longitude = [coordinate[1] floatValue];
                             [newPlace setLocation:placeLocation];
                             
                             [_placeArray addObject:newPlace];
                         }
                         
                         dispatch_async(dispatch_get_main_queue(), ^
                                        {
                                            //NSLog(@"%@", [NSString stringWithFormat:@"%d",i]);
                                            [self putPinsOnMap : i];
                                            //NSLog(@"f");
                                        });
                     }
                     else {
                         NSLog(@"responseData is false");
                     }
                 }];
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"there is no ersponse from the server");
             }
         }];
    }
}

-(void)putPinsOnMap:(int) i
{
    //NSLog((@"I'm in pinmap"));
    NSLog(@"%@", [NSString stringWithFormat:@"i in putPinOnMap %d",i]);
    //NSLog(@"%@", [NSString stringWithFormat:@"count putPinOnMap %d",[_placeArray count]]);
    
    int j = [_placeArray count] - i;
    Place *place;
    if (![_placeArray count])
        return;
    for (; j < [_placeArray count]; j++)
        
    //for(Place *place in _placeArray)
    {
        //NSLog(@"%@", [NSString stringWithFormat:@"j in putPinOnMap %d",j]);

        place = [_placeArray objectAtIndex:j];
        MapPin *pin = [[MapPin alloc] init];
        [pin setTitle:[place username]];
        [pin setSubtitle:[place created]];
        
        [pin setCoordinate:[place location]];
        [_map addAnnotation:pin];

    }
    if ([_placeArray count] > 100)
    {
        for (int k = 10; k >= 0; k--) {
            place = [_placeArray objectAtIndex:k];
            MapPin *pin = [[MapPin alloc] init];
            [pin setTitle:[place username]];
            [pin setSubtitle:[place created]];
            
            [pin setCoordinate:[place location]];
            [_map removeAnnotation:pin];
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate methods

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    /*
    
    if([_placeArray count] == 0)
    {
        [self getPlacesForLocation:[_map centerCoordinate]];
    }
    */
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getPlacesForLocation) userInfo:nil repeats:YES];
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"MapPin";
    if([annotation isKindOfClass:[MapPin class]]){
        MKPinAnnotationView *newPin = (MKPinAnnotationView *)[_map dequeueReusableAnnotationViewWithIdentifier:identifier];
        if(newPin == nil) {
            newPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        else {
            [newPin setAnnotation:annotation];
        }

        [newPin setEnabled:YES];
        [newPin setPinColor:MKPinAnnotationColorRed];
        [newPin setCanShowCallout:YES];
        [newPin setAnimatesDrop:YES];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
        newPin.rightCalloutAccessoryView = rightButton;
        
        return newPin;
    }
    return nil;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MKPointAnnotation *currentAnnotation = (MKPointAnnotation *)view.annotation;
    
//    MKPointAnnotation *currentAnnotation = (MKPointAnnotation *) annotation;
    
    //[self ]
    
    //NSDictionary *tweet = [[NSDictionary alloc] init];
    NSString *name = currentAnnotation.title;
    for (Place *tmp in _placeArray)
    {
        if ([[tmp username] isEqualToString:name]) {
            NSLog(@"the username is %@", [tmp username]);
            _myplace = tmp;
            /*
             __tweet = @{
             @"tweet" : [tmp tweet],
             @"img_url":[tmp imgurl],
             @"tweed_id":[tmp tweetid],
             @"name" : [tmp username]
             };
             */
            break;
        }
        
    }
}


- (void)showDetails:(UIButton*)sender
{
    MyTableViewController *detailcontroller = [[MyTableViewController alloc] init];
    detailcontroller.title = @"detailed content";
    [detailcontroller setName:[_myplace username]];
    [detailcontroller setTweet:[_myplace tweet]];
    [detailcontroller setImg:[_myplace imgurl]];
    [detailcontroller setTweetID:[_myplace tweetid]];
    /*
    [detailcontroller setName:[__tweet objectForKey:@"name"]];
    [detailcontroller setTweet:[__tweet objectForKey:@"tweet"]];
    [detailcontroller setImg:[__tweet objectForKey:@"img_url"]];
    [detailcontroller setTweetID:[__tweet objectForKey:@"tweet_id"]];
    */
   // [detailcontroller setTweetAccount:_accountStore];
    
    
    [self.navigationController pushViewController:detailcontroller animated:YES];
}


@end
