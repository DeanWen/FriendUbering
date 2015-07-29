//
//  FirstViewController.m
//  WeRide
//
//  Created by Dian Wen on 7/24/15.
//  Copyright (c) 2015 Dian Wen. All rights reserved.
//

#import "FirstViewController.h"
#import "LoginFBViewController.h"
#import "FriendItem.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {

        [[UberKit sharedInstance] setClientID:@"TRoQcMg6E3QrqVzNTt6-tjoGcIIJq7FU"];
        [[UberKit sharedInstance] setClientSecret:@"5gz7mKnnU9XxeuH-3yVYHGpestBWzhhdnhkaieOU"];
        [[UberKit sharedInstance] setRedirectURL:@"weride://response"];
        [[UberKit sharedInstance] setApplicationName:@"WERIDE"];
        _uberkit = [UberKit sharedInstance];
        _uberkit.delegate = self;
    
    [super viewDidLoad];
    _ids = [[NSMutableArray alloc] init];
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.top = 20;
    [self.tableView setContentInset:contentInset];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if ([FBSDKAccessToken currentAccessToken] == nil) {
        UIViewController *viewController =
        [[UIStoryboard storyboardWithName:@"Main"
                                   bundle:NULL] instantiateViewControllerWithIdentifier:@"LoginView"];
        [self presentViewController:viewController animated:YES completion:NULL];
    }
    
    [self.ids removeAllObjects];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends"
                                                                   parameters:nil];
//    NSArray *idArr;
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *data = (NSDictionary *)result;
            
            NSArray *arr = [data objectForKey:@"data"];

            NSDictionary *para = @{@"fields": @"email,name"};
            for (NSDictionary *item in arr) {

                NSString *userId = [item valueForKey:@"id"];
              
                
                FBSDKGraphRequest *request2 = [[FBSDKGraphRequest alloc] initWithGraphPath:userId
                                                                                parameters:para
                                                                               tokenString:@"1506471932977294|488069ddea7fd24610284677fcd3bea3" version:@"v2.4" HTTPMethod:@"GET"];
                [request2 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                    
                    if (!error) {
                        // result is a dictionary with the user's Facebook data
                        NSDictionary *data = (NSDictionary *)result;

                        FriendItem *item = [[FriendItem alloc] init];
                        item.name = [data valueForKey:@"name"];
                        
                        item.email = [data valueForKey:@"email"];

                        item.selected = NO;
                        [self.ids addObject:item];

                    }
                    NSLog(@"%lu", _ids.count);
                    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    

                }];
                
            }
            

          
        }
    }];
    
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
   
    return [self.ids count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    FriendItem *tappedItem = [self.ids objectAtIndex:indexPath.row];
    tappedItem.selected = !tappedItem.selected;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    }
    FriendItem *item = _ids[indexPath.row];
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.email;
    
    if (item.selected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (IBAction)uberButton:(id)sender {
    
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Data.plist"];
    NSLog(@"%@", plistPath);
    
    NSMutableDictionary *rootObj = [[NSMutableDictionary alloc] init];
    NSDictionary *innerDict;
    NSString *name;
    NSString *email;
    NSString *start_time = @"dummy";
    NSString *end_time = @"dummy";
    
    for (FriendItem *item in _ids) {
        if (item.selected) {
            item.selected = NO;
            name = item.name;
            email = item.email;
            
            innerDict = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name",
                         start_time, @"start_time",
                         end_time, @"end_time",
                          nil];
            [rootObj setObject:innerDict forKey:item.email];
        }
    }
    
    [rootObj writeToFile:plistPath atomically:TRUE];
    
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    [array addObject:@"aaa"];
//    [array addObject:@"aaa"];
//    [array addObject:@"aaa"];
//    [array addObject:@"aaa"];
//    [array addObject:@"aaa"];
//    
//    // get paths from root direcory
//    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
//    // get documents path
//    NSString *documentsPath = [paths objectAtIndex:0];
//    // get the path to our Data/plist file
//    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Data.plist"];
//    
//    // This writes the array to a plist file. If this file does not already exist, it creates a new one.
//    [array writeToFile:plistPath atomically: TRUE];
//    
//    NSLog(@"%@", plistPath);
    [_uberkit openUberApp];
    
    
    
    }

@end
