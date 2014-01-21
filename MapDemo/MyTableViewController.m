//
//  MyTableViewController.m
//  MapDemo
//
//  Created by Xiaoting Ye on 3/18/13.
//  Copyright (c) 2013 Mason Silber. All rights reserved.
//

#import "MyTableViewController.h"

#define token @"913876524-RkVVBckdzrofVe5syvSdFNR9DL6unAHyEW7IM7qZ"
#define secret @"swaSVSSKDUYtcIzYeG1A6ZQjX0wVtNaTRXWbhHiUTk"



@interface MyTableViewController ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tweet;
@property (nonatomic, strong) NSString *img_url;

@property (nonatomic, strong) NSString *tweetid;

@property (nonatomic, strong) NSArray *param;
@property (nonatomic, strong) NSURL *favor;
@property (nonatomic, strong) NSURL *retweet;



@property (nonatomic) ACAccountStore *accountStore;



@end

@implementation MyTableViewController

//- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(5_0);
//- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(6_0);


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _param = [NSArray arrayWithObjects:@"Favorite", @"Retweet", nil];
        _favor = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/favorites/create.json"]];
        _retweet = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/:id.json"]];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    //tableView.sectionHeaderHeight = 2.0;
    //tableView.sectionFooterHeight = 2.0;
    // Return the number of sections.
    return 3;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Profile";
        case 1:
            return @"Tweet";
        case 2:
            return @"Option";
        default:
            return nil;
    }}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 40;
        case 1:
            return 40;
        case 2:
            return 40;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 50;
        case 1:
            return 100;
        case 2:
            return 50;
        default:
            return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return [_param count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_img_url]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *myimage = [[UIImage alloc] initWithData:data];
                    //NSLog(@"creating the image");
                    cell.imageView.image = myimage;});
            });
            [[cell textLabel] setText:_name];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:24];
            break;
        }
        case 1:
        {
            cell.textLabel.font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:23.0];
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            
            
            [[cell textLabel] setText:_tweet];
            break;
        }
        case 2:
        {
            [[cell textLabel] setText:[_param objectAtIndex:[indexPath row]]];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:24];
            
            break;
        }
        default:
            break;
    }
    // Configure the cell...
    
    return cell;
}


-(void)setName:(NSString *)str{
    _name = str;
}
-(void)setTweet:(NSString *)str{
    _tweet = str;
}
-(void)setImg:(NSString *)str{
    _img_url = str;
}
-(void)setTweetID:(NSString *)str{
    _tweetid = str;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 2:
        {
            
            ACAccountCredential *credential =
            [[ACAccountCredential alloc] initWithOAuthToken:token tokenSecret:secret];
            
            _accountStore = [[ACAccountStore alloc] init];
            
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
                    } else {
                        // handle other error domains and their associated response codes...
                        NSLog(@"%@", [error localizedDescription]);
                    }
                }
            }];
            
            
            
            switch (indexPath.row) {
                case 0:
                {
                    NSDictionary *param = @{
                                          @"id" : _tweetid,
                                          };
                    [self.accountStore
                     requestAccessToAccountsWithType:twitterAccountType
                     options:NULL
                     completion:^(BOOL granted, NSError *error) {
                         if (granted) {
                             //  Step 2:  Create a request
                             NSArray *twitterAccounts =
                             [self.accountStore accountsWithAccountType:twitterAccountType];
                             SLRequest *request =
                             [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodPOST
                                                          URL:_favor
                                                   parameters:param];
                             
                             [request setAccount:[twitterAccounts lastObject]];
                             [request performRequestWithHandler:^(NSData *responseData,
                                                                  NSHTTPURLResponse *urlResponse,
                                                                  NSError *error) {
                                 if (responseData) {
                                     NSString *abc = [[NSString alloc] initWithData:responseData   encoding:NSASCIIStringEncoding];
                                     
                                     NSLog(@"favor return data is: %@", abc);
                                 }
                             }];
                         }
                     }];
                    break;
                }
                case 1:
                {
                    _retweet = [NSURL URLWithString:
                                [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/%@.json",_tweetid]];
                    [self.accountStore
                     requestAccessToAccountsWithType:twitterAccountType
                     options:NULL
                     completion:^(BOOL granted, NSError *error) {
                         if (granted) {
                             //  Step 2:  Create a request
                             NSArray *twitterAccounts =
                             [self.accountStore accountsWithAccountType:twitterAccountType];
                             SLRequest *request =
                             [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodPOST
                                                          URL:_retweet
                                                   parameters:NULL];
                             
                             [request setAccount:[twitterAccounts lastObject]];
                             [request performRequestWithHandler:^(NSData *responseData,
                                                                  NSHTTPURLResponse *urlResponse,
                                                                  NSError *error) {
                                 if (responseData) {
                                     NSString *abc = [[NSString alloc] initWithData:responseData   encoding:NSASCIIStringEncoding];
                                     
                                     NSLog(@"retweet data is: %@", abc);
                                 }
                             }];
                         }
                     }];
                     break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
    // Navigation logic may go here. Create and push another view controller.
    
    //DetailViewController *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    /*
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end



