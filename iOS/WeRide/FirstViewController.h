//
//  FirstViewController.h
//  WeRide
//
//  Created by Dian Wen on 7/24/15.
//  Copyright (c) 2015 Dian Wen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UberKit.h"

@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UberKitDelegate>
//@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
//@property (nonatomic, strong) NSArray *arr;
//@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSMutableArray *ids;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UberKit *uberkit;
- (IBAction)uberButton:(id)sender;

@end

