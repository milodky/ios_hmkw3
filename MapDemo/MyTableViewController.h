//
//  MyTableViewController.h
//  MapDemo
//
//  Created by Xiaoting Ye on 3/18/13.
//  Copyright (c) 2013 Mason Silber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface MyTableViewController : UITableViewController
-(void)setName:(NSString *)str;
-(void)setTweet:(NSString *)str;
-(void)setImg:(NSString *)str;
-(void)setTweetID:(NSString *)str;
//-(void)setTweetAccount:(ACAccountStore *)str;
@end
