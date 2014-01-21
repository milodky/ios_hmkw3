//
//  Place.h
//  MapDemo
//
//  Created by Mason Silber on 2/28/13.
//  Copyright (c) 2013 Mason Silber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Place : NSObject

@property (nonatomic, strong) NSString *tweet, *username, *tweetid, *imgurl;
@property (nonatomic, strong) NSString *created;

@property CLLocationCoordinate2D location;

@end
