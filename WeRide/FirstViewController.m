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
                NSLog(@"going to get %@ email", userId);
                
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
                    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                    NSLog(@"%@ %lu", @"arr array length",(unsigned long)[_ids count]);

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
    NSLog(@"int num of rows: %lu", (unsigned long)[_ids count]);
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

@end
