//
//  PlaceMapViewController.h
//  MapDemo
//
//  Created by Mason Silber on 2/28/13.
//  Copyright (c) 2013 Mason Silber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
@interface PlaceMapViewController : UIViewController<MKMapViewDelegate>
@property (strong, nonatomic) NSDictionary *_tweet;

@end
